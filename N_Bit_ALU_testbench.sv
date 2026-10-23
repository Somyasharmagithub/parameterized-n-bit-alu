
`timescale 1ns/1ps

module tb_parameterized_alu;

    parameter WIDTH = 32;

    reg  [WIDTH-1:0] A, B;
    reg  [2:0] sel;

    wire [WIDTH-1:0] Result;
    wire Z, C, V;

    integer passed, failed;

    parameterized_alu #(.WIDTH(WIDTH)) dut (
        .A(A),
        .B(B),
        .sel(sel),
        .Result(Result),
        .Z(Z),
        .C(C),
        .V(V)
    );

    task check_result;
        input [2:0] sel_in;
        input [WIDTH-1:0] a_in, b_in, expected_result;
        input expected_Z, expected_C, expected_V;
        begin
            sel = sel_in;
            A = a_in;
            B = b_in;

            #10;

            if ((Result === expected_result) &&
                (Z === expected_Z) &&
                (C === expected_C) &&
                (V === expected_V)) begin

                $display(
                    "PASS: sel=%b A=%h B=%h Result=%h Z=%b C=%b V=%b",
                    sel, A, B, Result, Z, C, V
                );

                passed = passed + 1;
            end
            else begin
                $display(
                    "FAIL: sel=%b A=%h B=%h Result=%h Expected=%h",
                    sel, A, B, Result, expected_result
                );

                $display(
                    "Flags: Z=%b C=%b V=%b | Expected: Z=%b C=%b V=%b",
                    Z, C, V, expected_Z, expected_C, expected_V
                );

                failed = failed + 1;
            end
        end
    endtask

    initial begin
        passed = 0;
        failed = 0;

        $dumpfile("dump.vcd");
        $dumpvars(0, tb_parameterized_alu);

        $display("Starting parameterized ALU tests...");
        $display("WIDTH = %0d", WIDTH);

        // ADD: 5 + 3 = 8
        check_result(3'b000, 32'd5, 32'd3,
                     32'd8, 0, 0, 0);

        // SUB: 5 - 3 = 2
        check_result(3'b001, 32'd5, 32'd3,
                     32'd2, 0, 0, 0);

        // AND
        check_result(3'b010, 32'hF0F0, 32'h0FF0,
                     32'h00F0, 0, 0, 0);

        // OR
        check_result(3'b011, 32'hF000, 32'h00F0,
                     32'hF0F0, 0, 0, 0);

        // XOR
        check_result(3'b100, 32'hAAAA, 32'hFFFF,
                     32'h5555, 0, 0, 0);

        // NOT
        check_result(3'b101, 32'h00000000, 32'd0,
                     32'hFFFFFFFF, 0, 0, 0);

        // INC: 10 + 1 = 11
        check_result(3'b110, 32'd10, 32'd0,
                     32'd11, 0, 0, 0);

        // DEC: 10 - 1 = 9
        check_result(3'b111, 32'd10, 32'd0,
                     32'd9, 0, 0, 0);

        // Signed addition overflow
        check_result(3'b000, 32'h7FFFFFFF, 32'd1,
                     32'h80000000, 0, 0, 1);

        // Subtraction borrow: 3 - 5
        check_result(3'b001, 32'd3, 32'd5,
                     32'hFFFFFFFE, 0, 1, 0);

        // Increment wraparound
        check_result(3'b110, 32'hFFFFFFFF, 32'd0,
                     32'h00000000, 1, 1, 0);

        // Decrement zero
        check_result(3'b111, 32'h00000000, 32'd0,
                     32'hFFFFFFFF, 0, 1, 0);

        // Zero result
        check_result(3'b001, 32'd7, 32'd7,
                     32'h00000000, 1, 0, 0);

        $display("--------------------------------");
        $display("Tests passed: %0d", passed);
        $display("Tests failed: %0d", failed);
        $display("--------------------------------");

        $finish;
    end

endmodule
