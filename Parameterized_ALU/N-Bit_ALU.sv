module parameterized_cla #(
    parameter WIDTH = 32
)(
    input  [WIDTH-1:0] A,
    input  [WIDTH-1:0] B,
    input              Cin,
    output [WIDTH-1:0] Sum,
    output             Cout
);

    // Parallel-prefix carry look-ahead network
    localparam STAGES = (WIDTH > 1) ? $clog2(WIDTH) : 1;

    wire [WIDTH-1:0] P [0:STAGES];
    wire [WIDTH-1:0] G [0:STAGES];
    wire [WIDTH:0] C;

    assign P[0] = A ^ B;
    assign G[0] = A & B;
    assign C[0] = Cin;

    genvar s, i;
    generate
        for (s = 0; s < STAGES; s = s + 1) begin : PREFIX_STAGE
            for (i = 0; i < WIDTH; i = i + 1) begin : PREFIX_BIT
                if (i >= (2**s)) begin : COMBINE
                    assign P[s+1][i] =
                        P[s][i] & P[s][i-(2**s)];

                    assign G[s+1][i] =
                        G[s][i] |
                        (P[s][i] & G[s][i-(2**s)]);
                end
                else begin : PASS_THROUGH
                    assign P[s+1][i] = P[s][i];
                    assign G[s+1][i] = G[s][i];
                end
            end
        end
    endgenerate

    genvar j;
    generate
        for (j = 0; j < WIDTH; j = j + 1) begin : CARRY_OUT
            assign C[j+1] =
                G[STAGES][j] |
                (P[STAGES][j] & Cin);
        end
    endgenerate

    assign Sum = P[0] ^ C[WIDTH-1:0];
    assign Cout = C[WIDTH];

endmodule


module parameterized_alu #(
    parameter WIDTH = 32
)(
    input  [WIDTH-1:0] A,
    input  [WIDTH-1:0] B,
    input  [2:0]       sel,
    output reg [WIDTH-1:0] Result,
    output reg             Z,
    output reg             C,
    output reg             V
);

    reg [WIDTH-1:0] arithmetic_B;
    reg arithmetic_Cin;

    wire [WIDTH-1:0] arithmetic_Sum;
    wire arithmetic_Cout;

    // Configure the shared adder for ADD, SUB, INC, or DEC
    always @(*) begin
        arithmetic_B = B;
        arithmetic_Cin = 1'b0;

        case (sel)
            3'b000: begin
                arithmetic_B = B;
                arithmetic_Cin = 1'b0;
            end

            3'b001: begin
                arithmetic_B = ~B;
                arithmetic_Cin = 1'b1;
            end

            3'b110: begin
                arithmetic_B = {WIDTH{1'b0}};
                arithmetic_Cin = 1'b1;
            end

            3'b111: begin
                arithmetic_B = {WIDTH{1'b1}};
                arithmetic_Cin = 1'b0;
            end

            default: begin
                arithmetic_B = B;
                arithmetic_Cin = 1'b0;
            end
        endcase
    end

    parameterized_cla #(.WIDTH(WIDTH)) adder (
        .A(A),
        .B(arithmetic_B),
        .Cin(arithmetic_Cin),
        .Sum(arithmetic_Sum),
        .Cout(arithmetic_Cout)
    );

    always @(*) begin
        Result = {WIDTH{1'b0}};
        Z = 1'b0;
        C = 1'b0;
        V = 1'b0;

        case (sel)
            3'b000: begin // ADD
                Result = arithmetic_Sum;
                C = arithmetic_Cout;
                V = (~(A[WIDTH-1] ^ B[WIDTH-1])) &
                    (A[WIDTH-1] ^ Result[WIDTH-1]);
            end

            3'b001: begin // SUB
                Result = arithmetic_Sum;
                C = ~arithmetic_Cout; // Borrow flag
                V = (A[WIDTH-1] ^ B[WIDTH-1]) &
                    (A[WIDTH-1] ^ Result[WIDTH-1]);
            end

            3'b010: Result = A & B;
            3'b011: Result = A | B;
            3'b100: Result = A ^ B;
            3'b101: Result = ~A;

            3'b110: begin // INC
                Result = arithmetic_Sum;
                C = arithmetic_Cout;
                V = (~A[WIDTH-1]) & Result[WIDTH-1];
            end

            3'b111: begin // DEC
                Result = arithmetic_Sum;
                C = (A == {WIDTH{1'b0}});
                V = A[WIDTH-1] & (~Result[WIDTH-1]);
            end
        endcase

        Z = (Result == {WIDTH{1'b0}});
    end

endmodule
