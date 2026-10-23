module cla8 (
    input  [7:0] A, B,
    input        Cin,
    output [7:0] Sum,
    output       Cout
);
    wire [7:0] P, G;
    wire [8:0] C;

    assign P = A ^ B;
    assign G = A & B;
    assign C[0] = Cin;

    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) |
                  (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) |
                  (P[2] & P[1] & G[0]) |
                  (P[2] & P[1] & P[0] & C[0]);
    assign C[4] = G[3] | (P[3] & G[2]) |
                  (P[3] & P[2] & G[1]) |
                  (P[3] & P[2] & P[1] & G[0]) |
                  (P[3] & P[2] & P[1] & P[0] & C[0]);
    assign C[5] = G[4] | (P[4] & G[3]) |
                  (P[4] & P[3] & G[2]) |
                  (P[4] & P[3] & P[2] & G[1]) |
                  (P[4] & P[3] & P[2] & P[1] & G[0]) |
                  (P[4] & P[3] & P[2] & P[1] & P[0] & C[0]);
    assign C[6] = G[5] | (P[5] & G[4]) |
                  (P[5] & P[4] & G[3]) |
                  (P[5] & P[4] & P[3] & G[2]) |
                  (P[5] & P[4] & P[3] & P[2] & G[1]) |
                  (P[5] & P[4] & P[3] & P[2] & P[1] & G[0]) |
                  (P[5] & P[4] & P[3] & P[2] & P[1] & P[0] & C[0]);
    assign C[7] = G[6] | (P[6] & G[5]) |
                  (P[6] & P[5] & G[4]) |
                  (P[6] & P[5] & P[4] & G[3]) |
                  (P[6] & P[5] & P[4] & P[3] & G[2]) |
                  (P[6] & P[5] & P[4] & P[3] & P[2] & G[1]) |
                  (P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & G[0]) |
                  (P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & P[0] & C[0]);
    assign C[8] = G[7] | (P[7] & G[6]) |
                  (P[7] & P[6] & G[5]) |
                  (P[7] & P[6] & P[5] & G[4]) |
                  (P[7] & P[6] & P[5] & P[4] & G[3]) |
                  (P[7] & P[6] & P[5] & P[4] & P[3] & G[2]) |
                  (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & G[1]) |
                  (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & G[0]) |
                  (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & P[0] & C[0]);

    assign Sum = P ^ C[7:0];
    assign Cout = C[8];
endmodule


module cla32 (
    input  [31:0] A, B,
    input         Cin,
    output [31:0] Sum,
    output        Cout
);
    wire C8, C16, C24;

    cla8 block0(A[7:0],   B[7:0],   Cin, Sum[7:0],   C8);
    cla8 block1(A[15:8],  B[15:8], C8,  Sum[15:8],  C16);
    cla8 block2(A[23:16], B[23:16],C16, Sum[23:16], C24);
    cla8 block3(A[31:24], B[31:24],C24, Sum[31:24], Cout);
endmodule


module alu32 (
    input  [31:0] A, B,
    input  [2:0]  sel,
    output reg [31:0] Result,
    output reg        Z, C, V
);
    reg [31:0] add_B;
    reg        add_Cin;
    wire [31:0] add_Sum;
    wire        add_Cout;

    // Select operands for the shared CLA arithmetic unit
    always @(*) begin
        add_B   = B;
        add_Cin = 1'b0;

        case (sel)
            3'b000: begin       // ADD: A + B
                add_B = B;
                add_Cin = 1'b0;
            end
            3'b001: begin       // SUB: A - B = A + ~B + 1
                add_B = ~B;
                add_Cin = 1'b1;
            end
            3'b110: begin       // INC: A + 1
                add_B = 32'b0;
                add_Cin = 1'b1;
            end
            3'b111: begin       // DEC: A - 1
                add_B = 32'hFFFFFFFF;
                add_Cin = 1'b0;
            end
            default: begin
                add_B = B;
                add_Cin = 1'b0;
            end
        endcase
    end

    cla32 arithmetic_unit (
        .A(A), .B(add_B), .Cin(add_Cin),
        .Sum(add_Sum), .Cout(add_Cout)
    );

    always @(*) begin
        Result = 32'b0;
        Z = 1'b0;
        C = 1'b0;
        V = 1'b0;

        case (sel)
            3'b000: begin
                Result = add_Sum;
                C = add_Cout;
                V = (~(A[31] ^ B[31])) & (A[31] ^ Result[31]);
            end
            3'b001: begin
                Result = add_Sum;
                C = ~add_Cout; // Borrow flag
                V = (A[31] ^ B[31]) & (A[31] ^ Result[31]);
            end
            3'b010: Result = A & B;
            3'b011: Result = A | B;
            3'b100: Result = A ^ B;
            3'b101: Result = ~A;
            3'b110: begin
                Result = add_Sum;
                C = add_Cout;
                V = (~A[31]) & Result[31];
            end
            3'b111: begin
                Result = add_Sum;
              C = (A == 0); // Borrow when decrementing zero
                V = A[31] & (~Result[31]);
            end
        endcase

        Z = (Result == 32'b0);
    end
endmodule
