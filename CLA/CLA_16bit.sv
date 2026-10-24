module cla8 (
    input  [7:0] A,
    input  [7:0] B,
    input        Cin,
    output [7:0] Sum,
    output       Cout
);

    wire [7:0] P, G;
    wire [8:0] C;

    assign P = A ^ B;
    assign G = A & B;
    assign C[0] = Cin;

    assign C[1] = G[0] |
                  (P[0] & C[0]);

    assign C[2] = G[1] |
                  (P[1] & G[0]) |
                  (P[1] & P[0] & C[0]);

    assign C[3] = G[2] |
                  (P[2] & G[1]) |
                  (P[2] & P[1] & G[0]) |
                  (P[2] & P[1] & P[0] & C[0]);

    assign C[4] = G[3] |
                  (P[3] & G[2]) |
                  (P[3] & P[2] & G[1]) |
                  (P[3] & P[2] & P[1] & G[0]) |
                  (P[3] & P[2] & P[1] & P[0] & C[0]);

    assign C[5] = G[4] |
                  (P[4] & G[3]) |
                  (P[4] & P[3] & G[2]) |
                  (P[4] & P[3] & P[2] & G[1]) |
                  (P[4] & P[3] & P[2] & P[1] & G[0]) |
                  (P[4] & P[3] & P[2] & P[1] & P[0] & C[0]);

    assign C[6] = G[5] |
                  (P[5] & G[4]) |
                  (P[5] & P[4] & G[3]) |
                  (P[5] & P[4] & P[3] & G[2]) |
                  (P[5] & P[4] & P[3] & P[2] & G[1]) |
                  (P[5] & P[4] & P[3] & P[2] & P[1] & G[0]) |
                  (P[5] & P[4] & P[3] & P[2] & P[1] & P[0] & C[0]);

    assign C[7] = G[6] |
                  (P[6] & G[5]) |
                  (P[6] & P[5] & G[4]) |
                  (P[6] & P[5] & P[4] & G[3]) |
                  (P[6] & P[5] & P[4] & P[3] & G[2]) |
                  (P[6] & P[5] & P[4] & P[3] & P[2] & G[1]) |
                  (P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & G[0]) |
                  (P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & P[0] & C[0]);

    assign C[8] = G[7] |
                  (P[7] & G[6]) |
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


module carry_lookahead_adder_16bit (
    input  [15:0] A,
    input  [15:0] B,
    input         Cin,
    output [15:0] Sum,
    output        Cout
);

    wire C8;

    // Lower 8 bits
    cla8 lower_block (
        .A(A[7:0]),
        .B(B[7:0]),
        .Cin(Cin),
        .Sum(Sum[7:0]),
        .Cout(C8)
    );

    // Upper 8 bits use the carry from the lower block
    cla8 upper_block (
        .A(A[15:8]),
        .B(B[15:8]),
        .Cin(C8),
        .Sum(Sum[15:8]),
        .Cout(Cout)
    );

endmodule
