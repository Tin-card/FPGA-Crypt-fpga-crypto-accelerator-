`timescale 1ns/1ps

module aes128_tb;

    logic clk;
    logic rst;
    logic start;

    logic [127:0] key;
    logic [127:0] plaintext;

    logic [127:0] ciphertext;
    logic done;
    logic busy;

    integer fd;
    integer scan_result;
    integer test_count;
    integer pass_count;

    reg [8*64-1:0] test_name;
    reg [127:0] vector_key;
    reg [127:0] vector_plaintext;
    reg [127:0] expected_ciphertext;

    aes128_top dut (
        .clk        (clk),
        .rst        (rst),
        .start      (start),
        .key        (key),
        .plaintext  (plaintext),
        .ciphertext (ciphertext),
        .done       (done),
        .busy       (busy)
    );

    // 100 MHz clock
    always #5 clk = ~clk;

    task automatic run_test(
        input [8*64-1:0] name,
        input [127:0] test_key,
        input [127:0] test_plaintext,
        input [127:0] expected
    );
        begin
            test_count = test_count + 1;

            key       = test_key;
            plaintext = test_plaintext;

            @(posedge clk);
            start = 1'b1;

            @(posedge clk);
            start = 1'b0;

            wait(done);

            #1;

            $display("");
            $display("Test %0d: %s", test_count, name);
            $display("  Plaintext : %032h", test_plaintext);
            $display("  Key       : %032h", test_key);
            $display("  Ciphertext: %032h", ciphertext);
            $display("  Expected  : %032h", expected);

            if (ciphertext === expected) begin
                $display("  RESULT    : PASS");
                pass_count = pass_count + 1;
            end
            else begin
                $display("  RESULT    : FAIL");
                $display("  ERROR: AES RTL output does not match reference!");
            end

            @(posedge clk);
        end
    endtask

    initial begin
        clk = 1'b0;
        rst = 1'b1;
        start = 1'b0;

        key = '0;
        plaintext = '0;

        test_count = 0;
        pass_count = 0;

        $display("========================================");
        $display("     AES-128 MULTI-VECTOR VERIFICATION");
        $display("========================================");

        // Reset
        repeat (2) @(posedge clk);
        rst = 1'b0;

        // Open generated vector file
        fd = $fopen("tb/aes_vectors.txt", "r");

        if (fd == 0) begin
            $display("");
            $display("ERROR: Could not open tb/aes_vectors.txt");
            $fatal(1);
        end

        // Read vectors until EOF
        while (!$feof(fd)) begin

            scan_result = $fscanf(
                fd,
                "%s %h %h %h\n",
                test_name,
                vector_key,
                vector_plaintext,
                expected_ciphertext
            );

            if (scan_result == 4) begin
                run_test(
                    test_name,
                    vector_key,
                    vector_plaintext,
                    expected_ciphertext
                );
            end
        end

        $fclose(fd);

        $display("");
        $display("========================================");
        $display("          VERIFICATION SUMMARY");
        $display("========================================");
        $display("Tests : %0d", test_count);
        $display("Passed: %0d", pass_count);
        $display("Failed: %0d", test_count - pass_count);

        if (pass_count == test_count) begin
            $display("");
            $display("ALL TESTS PASSED");
            $display("");
            $finish;
        end
        else begin
            $display("");
            $display("VERIFICATION FAILED");
            $display("");
            $fatal(1);
        end
    end

endmodule
