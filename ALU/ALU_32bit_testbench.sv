`timescale 1ns/1ps

module tb_alu32;

    reg  [31:0] A, B;
    reg  [2:0]  sel;

    wire [31:0] Result;
    wire Z, C, V;

    integer passed, failed;

    alu32 dut (
        .A(A), .B(B), .sel(sel),
        .Result(Result), .Z(Z), .C(C), .V(V)
    );

    task check_result;
        input [2:0]  op;
        input [31:0] test_A, test_B, expected_result;
        input        expected_Z, expected_C, expected_V;
        begin
            sel = op;
            A = test_A;
            B = test_B;

            #10;

            if (Result === expected_result &&
                Z === expected_Z &&
                C === expected_C &&
                V === expected_V) begin
                $display("PASS: sel=%b A=%h B=%h Result=%h Z=%b C=%b V=%b",
                         sel, A, B, Result, Z, C, V);
                passed = passed + 1;
            end
            else begin
                $display("FAIL: sel=%b A=%h B=%h Result=%h Expected=%h Z=%b C=%b V=%b",
                         sel, A, B, Result, expected_result, Z, C, V);
                $display("Expected flags: Z=%b C=%b V=%b",
                         expected_Z, expected_C, expected_V);
                failed = failed + 1;
            end
        end
    endtask

    initial begin
        passed = 0;
        failed = 0;

        $dumpfile("dump.vcd");
        $dumpvars(0, tb_alu32);

        $display("Starting 32-bit ALU tests...");

        // ADD
        check_result(3'b000, 32'd5, 32'd3,
                     32'd8, 0, 0, 0);

        // SUB
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

        // ADD overflow: largest positive signed number + 1
        check_result(3'b000, 32'h7FFFFFFF, 32'd1,
                     32'h80000000, 0, 0, 1);

        // SUB borrow: 3 - 5 wraps around in unsigned arithmetic
        check_result(3'b001, 32'd3, 32'd5,
                     32'hFFFFFFFE, 0, 1, 0);

        // INC wraparound
        check_result(3'b110, 32'hFFFFFFFF, 32'd0,
                     32'h00000000, 1, 1, 0);

        // DEC zero
        check_result(3'b111, 32'h00000000, 32'd0,
                     32'hFFFFFFFF, 0, 1, 0);

        // Zero result from subtraction
        check_result(3'b001, 32'd7, 32'd7,
                     32'h00000000, 1, 0, 0);

        $display("------------------------------");
        $display("Tests passed: %0d", passed);
        $display("Tests failed: %0d", failed);
        $display("------------------------------");

        $finish;
    end

endmodule
