`timescale 1ns/1ps

module tb_carry_lookahead_adder_16bit;

    reg  [15:0] A, B;
    reg         Cin;

    wire [15:0] Sum;
    wire        Cout;

    reg [16:0] expected;
    integer tests_passed, tests_failed;

    carry_lookahead_adder_16bit dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sum(Sum),
        .Cout(Cout)
    );

    task check_result;
        input [15:0] test_A, test_B;
        input        test_Cin;
        input [16:0] expected_result;
        begin
            A = test_A;
            B = test_B;
            Cin = test_Cin;
            expected = expected_result;

            #10;

            if ({Cout, Sum} === expected) begin
                $display("PASS: A=%h B=%h Cin=%b Result=%h",
                         A, B, Cin, {Cout, Sum});
                tests_passed = tests_passed + 1;
            end
            else begin
                $display("FAIL: A=%h B=%h Cin=%b Result=%h Expected=%h",
                         A, B, Cin, {Cout, Sum}, expected);
                tests_failed = tests_failed + 1;
            end
        end
    endtask

    initial begin
        tests_passed = 0;
        tests_failed = 0;

        $dumpfile("dump.vcd");
        $dumpvars(0, tb_carry_lookahead_adder_16bit);

        $display("Starting 16-bit CLA tests...");

        check_result(16'h0000, 16'h0000, 1'b0, 17'h00000);
        check_result(16'h0005, 16'h0003, 1'b0, 17'h00008);
        check_result(16'h00FF, 16'h0001, 1'b0, 17'h00100);
        check_result(16'h7FFF, 16'h0001, 1'b0, 17'h08000);
        check_result(16'hFFFF, 16'h0001, 1'b0, 17'h10000);
        check_result(16'hFFFF, 16'hFFFF, 1'b0, 17'h1FFFE);
        check_result(16'hFFFF, 16'hFFFF, 1'b1, 17'h1FFFF);
        check_result(16'h1234, 16'h4321, 1'b1, 17'h05556);
        check_result(16'h8000, 16'h8000, 1'b0, 17'h10000);
        check_result(16'h5555, 16'hAAAA, 1'b0, 17'h0FFFF);

        $display("------------------------------");
        $display("Tests passed: %0d", tests_passed);
        $display("Tests failed: %0d", tests_failed);
        $display("------------------------------");

        $finish;
    end

endmodule

