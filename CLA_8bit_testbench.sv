`timescale 1ns/1ps

module tb_carry_lookahead_adder_8bit;

    reg  [7:0] A;
    reg  [7:0] B;
    reg        Cin;

    wire [7:0] Sum;
    wire       Cout;

    reg [8:0] expected;
    integer tests_passed;
    integer tests_failed;

    carry_lookahead_adder_8bit dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sum(Sum),
        .Cout(Cout)
    );

    task check_result;
        input [7:0] test_A;
        input [7:0] test_B;
        input       test_Cin;
        input [8:0] expected_result;
        begin
            A = test_A;
            B = test_B;
            Cin = test_Cin;
            expected = expected_result;

            #10;

            if ({Cout, Sum} === expected) begin
                $display(
                    "PASS: A=%h B=%h Cin=%b | Result=%h Expected=%h",
                    A, B, Cin, {Cout, Sum}, expected
                );
                tests_passed = tests_passed + 1;
            end
            else begin
                $display(
                    "FAIL: A=%h B=%h Cin=%b | Result=%h Expected=%h",
                    A, B, Cin, {Cout, Sum}, expected
                );
                tests_failed = tests_failed + 1;
            end
        end
    endtask

    initial begin
        tests_passed = 0;
        tests_failed = 0;

        $dumpfile("dump.vcd");
        $dumpvars(0, tb_carry_lookahead_adder_8bit);

        $display("Starting 8-bit CLA tests...");

        check_result(8'h00, 8'h00, 1'b0, 9'h000);
        check_result(8'h05, 8'h03, 1'b0, 9'h008);
        check_result(8'h0F, 8'h01, 1'b0, 9'h010);
        check_result(8'h7F, 8'h01, 1'b0, 9'h080);
        check_result(8'hFF, 8'h01, 1'b0, 9'h100);
        check_result(8'hFF, 8'hFF, 1'b0, 9'h1FE);
        check_result(8'hFF, 8'hFF, 1'b1, 9'h1FF);
        check_result(8'h12, 8'h34, 1'b1, 9'h047);
        check_result(8'h80, 8'h80, 1'b0, 9'h100);
        check_result(8'h55, 8'hAA, 1'b0, 9'h0FF);

        $display("------------------------------");
        $display("Tests passed: %0d", tests_passed);
        $display("Tests failed: %0d", tests_failed);
        $display("------------------------------");

        $finish;
    end

endmodule

