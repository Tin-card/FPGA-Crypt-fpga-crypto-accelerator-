`timescale 1ns/1ps

module aes_key_expand (
    input  logic [127:0] key_in,
    input  logic [3:0]   round,
    output logic [127:0] key_out
);

    logic [31:0] w0, w1, w2, w3;
    logic [31:0] rot_word;
    logic [31:0] sub_word;
    logic [31:0] temp;

    logic [31:0] n0, n1, n2, n3;

    logic [7:0] rcon;

    logic [7:0] s0, s1, s2, s3;

    // Split 128-bit key into four 32-bit words
    always_comb begin
        w0 = key_in[127:96];
        w1 = key_in[95:64];
        w2 = key_in[63:32];
        w3 = key_in[31:0];
    end

    // RotWord
    always_comb begin
        rot_word = {
            w3[23:0],
            w3[31:24]
        };
    end

    // SubWord using AES S-box
    aes_sbox sb0 (
        .a(rot_word[31:24]),
        .y(s0)
    );

    aes_sbox sb1 (
        .a(rot_word[23:16]),
        .y(s1)
    );

    aes_sbox sb2 (
        .a(rot_word[15:8]),
        .y(s2)
    );

    aes_sbox sb3 (
        .a(rot_word[7:0]),
        .y(s3)
    );

    always_comb begin
        sub_word = {
            s0,
            s1,
            s2,
            s3
        };
    end

    // AES-128 round constants
    always_comb begin
        case (round)
            4'd1:  rcon = 8'h01;
            4'd2:  rcon = 8'h02;
            4'd3:  rcon = 8'h04;
            4'd4:  rcon = 8'h08;
            4'd5:  rcon = 8'h10;
            4'd6:  rcon = 8'h20;
            4'd7:  rcon = 8'h40;
            4'd8:  rcon = 8'h80;
            4'd9:  rcon = 8'h1b;
            4'd10: rcon = 8'h36;
            default: rcon = 8'h00;
        endcase
    end

    // AES-128 key schedule
    always_comb begin
        temp = sub_word;

        // XOR Rcon into the most significant byte
        temp[31:24] = temp[31:24] ^ rcon;

        n0 = w0 ^ temp;
        n1 = w1 ^ n0;
        n2 = w2 ^ n1;
        n3 = w3 ^ n2;

        key_out = {
            n0,
            n1,
            n2,
            n3
        };
    end

endmodule
