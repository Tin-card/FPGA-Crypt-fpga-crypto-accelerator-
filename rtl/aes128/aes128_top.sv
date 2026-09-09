`timescale 1ns/1ps
module aes128_top (
    input  logic         clk,
    input  logic         rst,
    input  logic         start,

    input  logic [127:0] plaintext,
    input  logic [127:0] key,

    output logic [127:0] ciphertext,
    output logic         done,
    output logic         busy
);

    aes128_core core (
        .clk        (clk),
        .rst        (rst),
        .start      (start),
        .plaintext  (plaintext),
        .key        (key),
        .ciphertext (ciphertext),
        .done       (done),
        .busy       (busy)
    );

endmodule