`timescale 1ns/1ps
module aes_round (
    input  logic [127:0] state_in,
    input  logic [127:0] round_key,
    input  logic         final_round,
    output logic [127:0] state_out
);

    logic [127:0] sub_bytes;
    logic [127:0] shift_rows;
    logic [127:0] mix_columns;

    logic [7:0] sb [0:15];

    genvar i;

    generate
        for (i = 0; i < 16; i++) begin : SBOXES
            aes_sbox sbox_inst (
                .a(state_in[127 - i*8 -: 8]),
                .y(sb[i])
            );
        end
    endgenerate

    always_comb begin

        // SubBytes
        for (int j = 0; j < 16; j++) begin
            sub_bytes[127 - j*8 -: 8] = sb[j];
        end

        // AES state is treated as:
        //
        // [ 0  4  8 12 ]
        // [ 1  5  9 13 ]
        // [ 2  6 10 14 ]
        // [ 3  7 11 15 ]
        //
        // ShiftRows rotates each row left.

        shift_rows[127 - 0*8  -: 8] = sub_bytes[127 - 0*8  -: 8];
        shift_rows[127 - 1*8  -: 8] = sub_bytes[127 - 5*8  -: 8];
        shift_rows[127 - 2*8  -: 8] = sub_bytes[127 - 10*8 -: 8];
        shift_rows[127 - 3*8  -: 8] = sub_bytes[127 - 15*8 -: 8];

        shift_rows[127 - 4*8  -: 8] = sub_bytes[127 - 4*8  -: 8];
        shift_rows[127 - 5*8  -: 8] = sub_bytes[127 - 9*8  -: 8];
        shift_rows[127 - 6*8  -: 8] = sub_bytes[127 - 14*8 -: 8];
        shift_rows[127 - 7*8  -: 8] = sub_bytes[127 - 3*8  -: 8];

        shift_rows[127 - 8*8  -: 8] = sub_bytes[127 - 8*8  -: 8];
        shift_rows[127 - 9*8  -: 8] = sub_bytes[127 - 13*8 -: 8];
        shift_rows[127 - 10*8 -: 8] = sub_bytes[127 - 2*8  -: 8];
        shift_rows[127 - 11*8 -: 8] = sub_bytes[127 - 7*8  -: 8];

        shift_rows[127 - 12*8 -: 8] = sub_bytes[127 - 12*8 -: 8];
        shift_rows[127 - 13*8 -: 8] = sub_bytes[127 - 1*8  -: 8];
        shift_rows[127 - 14*8 -: 8] = sub_bytes[127 - 6*8  -: 8];
        shift_rows[127 - 15*8 -: 8] = sub_bytes[127 - 11*8 -: 8];

        if (final_round) begin
            mix_columns = shift_rows;
        end
        else begin
            for (int c = 0; c < 4; c++) begin
                automatic int b = c * 4;

                mix_columns[127 - (b+0)*8 -: 8] =
                    gm2(shift_rows[127 - (b+0)*8 -: 8]) ^
                    gm3(shift_rows[127 - (b+1)*8 -: 8]) ^
                    shift_rows[127 - (b+2)*8 -: 8] ^
                    shift_rows[127 - (b+3)*8 -: 8];

                mix_columns[127 - (b+1)*8 -: 8] =
                    shift_rows[127 - (b+0)*8 -: 8] ^
                    gm2(shift_rows[127 - (b+1)*8 -: 8]) ^
                    gm3(shift_rows[127 - (b+2)*8 -: 8]) ^
                    shift_rows[127 - (b+3)*8 -: 8];

                mix_columns[127 - (b+2)*8 -: 8] =
                    shift_rows[127 - (b+0)*8 -: 8] ^
                    shift_rows[127 - (b+1)*8 -: 8] ^
                    gm2(shift_rows[127 - (b+2)*8 -: 8]) ^
                    gm3(shift_rows[127 - (b+3)*8 -: 8]);

                mix_columns[127 - (b+3)*8 -: 8] =
                    gm3(shift_rows[127 - (b+0)*8 -: 8]) ^
                    shift_rows[127 - (b+1)*8 -: 8] ^
                    shift_rows[127 - (b+2)*8 -: 8] ^
                    gm2(shift_rows[127 - (b+3)*8 -: 8]);
            end
        end

        state_out = mix_columns ^ round_key;

    end

    function automatic [7:0] gm2(input [7:0] x);
        gm2 = {x[6:0],1'b0} ^ (8'h1b & {8{x[7]}});
    endfunction

    function automatic [7:0] gm3(input [7:0] x);
        gm3 = gm2(x) ^ x;
    endfunction

endmodule