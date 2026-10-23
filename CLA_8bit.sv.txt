module carry_lookahead_adder_8bit (
    input  [7:0] A,
    input  [7:0] B,
    input        Cin,
    output [7:0] Sum,
    output       Cout
);

    wire [7:0] P;
    wire [7:0] G;
    wire [8:0] C;

    // Propagate and Generate
    assign P = A ^ B;
    assign G = A & B;

    assign C[0] = Cin;

    // Carry Look-Ahead equations
    assign C[1] = G[0] |
                  (P[0] & Cin);

    assign C[2] = G[1] |
                  (P[1] & G[0]) |
                  (P[1] & P[0] & Cin);

    assign C[3] = G[2] |
                  (P[2] & G[1]) |
                  (P[2] & P[1] & G[0]) |
                  (P[2] & P[1] & P[0] & Cin);

    assign C[4] = G[3] |
                  (P[3] & G[2]) |
                  (P[3] & P[2] & G[1]) |
                  (P[3] & P[2] & P[1] & G[0]) |
                  (P[3] & P[2] & P[1] & P[0] & Cin);

    assign C[5] = G[4] |
                  (P[4] & G[3]) |
                  (P[4] & P[3] & G[2]) |
                  (P[4] & P[3] & P[2] & G[1]) |
                  (P[4] & P[3] & P[2] & P[1] & G[0]) |
                  (P[4] & P[3] & P[2] & P[1] & P[0] & Cin);

    assign C[6] = G[5] |
                  (P[5] & G[4]) |
                  (P[5] & P[4] & G[3]) |
                  (P[5] & P[4] & P[3] & G[2]) |
                  (P[5] & P[4] & P[3] & P[2] & G[1]) |
                  (P[5] & P[4] & P[3] & P[2] & P[1] & G[0]) |
                  (P[5] & P[4] & P[3] & P[2] & P[1] & P[0] & Cin);

    assign C[7] = G[6] |
                  (P[6] & G[5]) |
                  (P[6] & P[5] & G[4]) |
                  (P[6] & P[5] & P[4] & G[3]) |
                  (P[6] & P[5] & P[4] & P[3] & G[2]) |
                  (P[6] & P[5] & P[4] & P[3] & P[2] & G[1]) |
                  (P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & G[0]) |
                  (P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & P[0] & Cin);

    assign C[8] = G[7] |
                  (P[7] & G[6]) |
                  (P[7] & P[6] & G[5]) |
                  (P[7] & P[6] & P[5] & G[4]) |
                  (P[7] & P[6] & P[5] & P[4] & G[3]) |
                  (P[7] & P[6] & P[5] & P[4] & P[3] & G[2]) |
                  (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & G[1]) |
                  (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & G[0]) |
                  (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & P[0] & Cin);

    // Sum and final carry
    assign Sum = P ^ C[7:0];
    assign Cout = C[8];

endmodule
