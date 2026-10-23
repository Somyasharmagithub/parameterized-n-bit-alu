module ripple_carry_adder_16bit (
    input  [15:0] A,
    input  [15:0] B,
    input         Cin,
    output [15:0] Sum,
    output        Cout
);

    wire [16:0] C;

    // Initial carry input
    assign C[0] = Cin;

    // Generate sum and carry for each bit
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : RCA
            assign Sum[i] = A[i] ^ B[i] ^ C[i];

            assign C[i+1] = (A[i] & B[i]) |
                            (A[i] & C[i]) |
                            (B[i] & C[i]);
        end
    endgenerate

    // Final carry output
    assign Cout = C[16];

endmodule
