`timescale 1ns/1ps
module aes128_core (
    input  logic         clk,
    input  logic         rst,
    input  logic         start,

    input  logic [127:0] plaintext,
    input  logic [127:0] key,

    output logic [127:0] ciphertext,
    output logic         done,
    output logic         busy
);

    logic [127:0] state_reg;
    logic [127:0] key_reg;

    logic [127:0] next_key;
    logic [127:0] next_state;

    logic [3:0] round;

    logic final_round;

    aes_key_expand key_expand (
        .key_in(key_reg),
        .round(round),
        .key_out(next_key)
    );

    aes_round round_function (
        .state_in(state_reg),
        .round_key(next_key),
        .final_round(final_round),
        .state_out(next_state)
    );

    always_comb begin
        final_round = (round == 4'd10);
    end

    always_ff @(posedge clk) begin

        if (rst) begin
            state_reg  <= 128'b0;
            key_reg    <= 128'b0;
            ciphertext <= 128'b0;
            round      <= 4'd0;
            done       <= 1'b0;
            busy       <= 1'b0;
        end

        else begin

            done <= 1'b0;

            if (start && !busy) begin

                // Initial AddRoundKey
                state_reg <= plaintext ^ key;
                key_reg   <= key;

                round <= 4'd1;
                busy  <= 1'b1;

            end

            else if (busy) begin

                state_reg <= next_state;
                key_reg   <= next_key;

                if (round == 4'd10) begin

                    ciphertext <= next_state;

                    done <= 1'b1;
                    busy <= 1'b0;

                end

                else begin
                    round <= round + 1'b1;
                end

            end

        end

    end

endmodule