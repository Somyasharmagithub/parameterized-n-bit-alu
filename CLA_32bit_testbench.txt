`timescale 1ns/1ps

module tb_carry_lookahead_adder_32bit;

    reg  [31:0] A, B;
    reg         Cin;

    wire [31:0] Sum;
    wire        Cout;

    reg [32:0] expected;
    integer tests_passed, tests_failed;

    carry_lookahead_adder_32bit dut (
        .A(A), .B(B), .Cin(Cin),
        .Sum(Sum), .Cout(Cout)
    );

    task check_result;
        input [31:0] test_A, test_B;
        input        test_Cin;
        input [32:0] expected_result;
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
        $dumpvars(0, tb_carry_lookahead_adder_32bit);

        $display("Starting 32-bit CLA tests...");

        check_result(32'h00000000, 32'h00000000, 1'b0,
                     33'h000000000);

        check_result(32'h00000005, 32'h00000003, 1'b0,
                     33'h000000008);

        check_result(32'h000000FF, 32'h00000001, 1'b0,
                     33'h000000100);

        check_result(32'h7FFFFFFF, 32'h00000001, 1'b0,
                     33'h080000000);

        check_result(32'hFFFFFFFF, 32'h00000001, 1'b0,
                     33'h100000000);

        check_result(32'hFFFFFFFF, 32'hFFFFFFFF, 1'b0,
                     33'h1FFFFFFFE);

        check_result(32'hFFFFFFFF, 32'hFFFFFFFF, 1'b1,
                     33'h1FFFFFFFF);

        check_result(32'h12345678, 32'h43214321, 1'b1,
                     33'h05555999A);

        check_result(32'h80000000, 32'h80000000, 1'b0,
                     33'h100000000);

        check_result(32'h55555555, 32'hAAAAAAAA, 1'b0,
                     33'h0FFFFFFFF);

        $display("------------------------------");
        $display("Tests passed: %0d", tests_passed);
        $display("Tests failed: %0d", tests_failed);
        $display("------------------------------");

        $finish;
    end

endmodule
