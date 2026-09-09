`timescale 1ns/1ps

module aes128_tb;

    logic         clk;
    logic         rst;
    logic         start;

    logic [127:0] plaintext;
    logic [127:0] key;

    logic [127:0] ciphertext;
    logic         done;
    logic         busy;

    // ------------------------------------------------------------
    // Device Under Test
    // ------------------------------------------------------------

    aes128_top dut (
        .clk        (clk),
        .rst        (rst),
        .start      (start),
        .plaintext  (plaintext),
        .key        (key),
        .ciphertext (ciphertext),
        .done       (done),
        .busy       (busy)
    );

    // ------------------------------------------------------------
    // Clock
    // 100 MHz equivalent clock
    // Period = 10 ns
    // ------------------------------------------------------------

    initial begin
        clk = 1'b0;

        forever #5 clk = ~clk;
    end

    // ------------------------------------------------------------
    // Test
    // ------------------------------------------------------------

    initial begin

        // Initial values
        rst       = 1'b1;
        start     = 1'b0;
        plaintext = 128'b0;
        key       = 128'b0;

        // Hold reset for two clock cycles
        #20;

        rst = 1'b0;

        // AES-128 NIST known-answer test vector
        plaintext = 128'h00112233445566778899aabbccddeeff;
        key       = 128'h000102030405060708090a0b0c0d0e0f;

        // Start encryption
        @(posedge clk);
        start = 1'b1;

        @(posedge clk);
        start = 1'b0;

        // Wait for encryption to complete
        wait(done == 1'b1);

        #1;

        $display("");
        $display("========================================");
        $display("        AES-128 VERIFICATION");
        $display("========================================");
        $display("Plaintext : %032h", plaintext);
        $display("Key       : %032h", key);
        $display("Ciphertext: %032h", ciphertext);
        $display("Expected  : 69c4e0d86a7b0430d8cdb78070b4c55a");

        if (ciphertext == 128'h69c4e0d86a7b0430d8cdb78070b4c55a) begin

            $display("");
            $display("TEST PASSED");
            $display("");

        end
        else begin

            $display("");
            $display("TEST FAILED");
            $display("");

            $fatal(1);

        end

        $finish;

    end

endmodule