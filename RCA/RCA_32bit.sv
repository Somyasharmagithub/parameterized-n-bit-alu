module ripple_carry_adder_32bit (
    input  [31:0] A,
    input  [31:0] B,
    input         Cin,
    output [31:0] Sum,
    output        Cout
);

    wire [32:0] C;

    assign C[0] = Cin;

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : RCA
            assign Sum[i] = A[i] ^ B[i] ^ C[i];

            assign C[i+1] = (A[i] & B[i]) |
                            (A[i] & C[i]) |
                            (B[i] & C[i]);
        end
    endgenerate

    assign Cout = C[32];

endmodule
