`timescale 1ns / 1ns

module matrix_mul_tb();

localparam  BITS_OF_matrix_SIZE = 32;

integer fp_r_a, fp_r_b, fp_w, rd_i, rd_j, rd_k, rd_l, wr_i, wr_j, wr_k;

reg  clk;
reg  rst_n;

reg [31 : 0]    rd_data_a[63 : 0];
reg [31 : 0]    rd_data_b[63 : 0];

reg [31 : 0]    mul_a;
reg [31 : 0]    mul_b;

reg             i_valid;





initial begin
    clk = 0;
    rst_n = 0;
    #2
    rst_n = 1;
end

always #1 begin
    clk <= ~clk;
end


reg [BITS_OF_matrix_SIZE - 1 : 0]    matrix_f_width;
reg [BITS_OF_matrix_SIZE - 1 : 0]    matrix_s_width;


wire                                     storage_valid;
wire    [31 : 0]                         mul_result;
wire    [BITS_OF_matrix_SIZE - 1 : 0]    matrix_width_out;


ram_data_make#(
    .matrix_width(BITS_OF_matrix_SIZE)         //bits of L         matrix multiply: M*L L*N,
)ram_data_make
(
    .clk            (clk),
    .rst_n          (rst_n),

    .o_valid        (),//each matrix enter will bring a high pulse
    .mul_f          (),//first
    .mul_s          (),//second

    .matrix_f_width (),//L         matrix multiply: M*L L*N,
    .matrix_s_width ()//N         matrix multiply: M*L L*N,
);

matrix_mul_top #(
    .matrix_width        (BITS_OF_matrix_SIZE)         //bits of L         matrix multiply: M*L L*N,
)u_matrix_mul_top
(
    .clk                (clk),
    .rst_n              (rst_n),

    .i_valid            (i_valid),//each matrix enter will bring a high pulse
    .mul_f              (mul_a),//first
    .mul_s              (mul_b),//second

    .matrix_f_width     (matrix_f_width),//L         matrix multiply: M*L L*N,
    .matrix_s_width     (matrix_s_width),//N         matrix multiply: M*L L*N,

    .matrix_width_out   (matrix_width_out),
    .o_valid            (storage_valid),
    .mul_result         (mul_result)
);

result_storage #(
    .size_height    (BITS_OF_matrix_SIZE),         //bits of M         matrix size: M*N,
    .size_width     (BITS_OF_matrix_SIZE)          //bits of N         matrix size: M*N,
)result_storage
(
    .clk            (clk),
    .rst_n          (rst_n),
    .matrix_width   (matrix_width_out),
    .i_valid        (storage_valid),
    .mul_result     (mul_result)
);

initial begin
    i_valid = 0;
    matrix_f_width = 0;
    mul_a = 0;
    mul_b = 0;
    #4

    //4*4 4*4 same
    fp_r_a = $fopen("../../../../../result/origin_data/origin_data_4x4_a.txt", "r");
    for (rd_i = 0; rd_i < 1; rd_i = rd_i + 1) begin
        $fscanf(fp_r_a, "%h %h %h %h %h %h %h %h", rd_data_a[0 ], rd_data_a[1 ], rd_data_a[2 ], rd_data_a[3 ]);
        $fscanf(fp_r_a, "%h %h %h %h %h %h %h %h", rd_data_a[4 ], rd_data_a[5 ], rd_data_a[6 ], rd_data_a[7 ]);
        $fscanf(fp_r_a, "%h %h %h %h %h %h %h %h", rd_data_a[8 ], rd_data_a[9 ], rd_data_a[10], rd_data_a[11]);
        $fscanf(fp_r_a, "%h %h %h %h %h %h %h %h", rd_data_a[12], rd_data_a[13], rd_data_a[14], rd_data_a[15]);
    end
    $fclose(fp_r_a);

    fp_r_b = $fopen("../../../../../result/origin_data/origin_data_4x4_b.txt", "r");
        for (rd_i = 0; rd_i < 1; rd_i = rd_i + 1) begin
        $fscanf(fp_r_b, "%h %h %h %h %h %h %h %h", rd_data_b[0 ], rd_data_b[1 ], rd_data_b[2 ], rd_data_b[3 ]);
        $fscanf(fp_r_b, "%h %h %h %h %h %h %h %h", rd_data_b[4 ], rd_data_b[5 ], rd_data_b[6 ], rd_data_b[7 ]);
        $fscanf(fp_r_b, "%h %h %h %h %h %h %h %h", rd_data_b[8 ], rd_data_b[9 ], rd_data_b[10], rd_data_b[11]);
        $fscanf(fp_r_b, "%h %h %h %h %h %h %h %h", rd_data_b[12], rd_data_b[13], rd_data_b[14], rd_data_b[15]);
    end
    $fclose(fp_r_b);

    i_valid = 1;
    matrix_f_width = 4;
    matrix_s_width = 4;
    for (rd_l = 0; rd_l < 4; rd_l = rd_l + 1) begin
        for (rd_j = 0; rd_j < 4; rd_j = rd_j + 1) begin
            for (rd_k = 0; rd_k < 4; rd_k = rd_k + 1) begin
                mul_a = rd_data_a[rd_l * 4 + rd_k];
                mul_b = rd_data_b[rd_j * 4 + rd_k];
                #2;
            end
        end
    end
    i_valid = 0;

    //4*4 4*4 same
    fp_r_a = $fopen("../../../../../result/origin_data/origin_data_4x4_a.txt", "r");
    for (rd_i = 0; rd_i < 1; rd_i = rd_i + 1) begin
        $fscanf(fp_r_a, "%h %h %h %h %h %h %h %h", rd_data_a[0 ], rd_data_a[1 ], rd_data_a[2 ], rd_data_a[3 ]);
        $fscanf(fp_r_a, "%h %h %h %h %h %h %h %h", rd_data_a[4 ], rd_data_a[5 ], rd_data_a[6 ], rd_data_a[7 ]);
        $fscanf(fp_r_a, "%h %h %h %h %h %h %h %h", rd_data_a[8 ], rd_data_a[9 ], rd_data_a[10], rd_data_a[11]);
        $fscanf(fp_r_a, "%h %h %h %h %h %h %h %h", rd_data_a[12], rd_data_a[13], rd_data_a[14], rd_data_a[15]);
    end
    $fclose(fp_r_a);

    fp_r_b = $fopen("../../../../../result/origin_data/origin_data_4x4_b.txt", "r");
        for (rd_i = 0; rd_i < 1; rd_i = rd_i + 1) begin
        $fscanf(fp_r_b, "%h %h %h %h %h %h %h %h", rd_data_b[0 ], rd_data_b[1 ], rd_data_b[2 ], rd_data_b[3 ]);
        $fscanf(fp_r_b, "%h %h %h %h %h %h %h %h", rd_data_b[4 ], rd_data_b[5 ], rd_data_b[6 ], rd_data_b[7 ]);
        $fscanf(fp_r_b, "%h %h %h %h %h %h %h %h", rd_data_b[8 ], rd_data_b[9 ], rd_data_b[10], rd_data_b[11]);
        $fscanf(fp_r_b, "%h %h %h %h %h %h %h %h", rd_data_b[12], rd_data_b[13], rd_data_b[14], rd_data_b[15]);
    end
    $fclose(fp_r_b);

    i_valid = 1;
    matrix_f_width = 4;
    matrix_s_width = 4;
    for (rd_l = 0; rd_l < 4; rd_l = rd_l + 1) begin
        for (rd_j = 0; rd_j < 4; rd_j = rd_j + 1) begin
            for (rd_k = 0; rd_k < 4; rd_k = rd_k + 1) begin
                mul_a = rd_data_a[rd_l * 4 + rd_k];
                mul_b = rd_data_b[rd_j * 4 + rd_k];
                #2;
            end
        end
    end
    i_valid = 0;


    //8*4 4*16 
    fp_r_a = $fopen("../../../../../result/origin_data/origin_data_8x4_a.txt", "r");
    for (rd_i = 0; rd_i < 1; rd_i = rd_i + 1) begin
        $fscanf(fp_r_a, "%h %h %h %h %h %h %h %h", rd_data_a[0 ], rd_data_a[1 ], rd_data_a[2 ], rd_data_a[3 ], rd_data_a[4 ], rd_data_a[5 ], rd_data_a[6 ], rd_data_a[7 ]);
        $fscanf(fp_r_a, "%h %h %h %h %h %h %h %h", rd_data_a[8 ], rd_data_a[9 ], rd_data_a[10], rd_data_a[11], rd_data_a[12], rd_data_a[13], rd_data_a[14], rd_data_a[15]);
        $fscanf(fp_r_a, "%h %h %h %h %h %h %h %h", rd_data_a[16], rd_data_a[17], rd_data_a[18], rd_data_a[19], rd_data_a[20], rd_data_a[21], rd_data_a[22], rd_data_a[23]);
        $fscanf(fp_r_a, "%h %h %h %h %h %h %h %h", rd_data_a[24], rd_data_a[25], rd_data_a[26], rd_data_a[27], rd_data_a[28], rd_data_a[29], rd_data_a[30], rd_data_a[31]);
    end
    $fclose(fp_r_a);

    fp_r_b = $fopen("../../../../../result/origin_data/origin_data_4x16_b.txt", "r");
        for (rd_i = 0; rd_i < 1; rd_i = rd_i + 1) begin
        $fscanf(fp_r_b, "%h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h", 
            rd_data_b[0 ], rd_data_b[1 ], rd_data_b[2 ], rd_data_b[3 ], rd_data_b[4 ], rd_data_b[5 ], rd_data_b[6 ], rd_data_b[7 ], rd_data_b[8 ], rd_data_b[9 ], rd_data_b[10], rd_data_b[11], rd_data_b[12], rd_data_b[13], rd_data_b[14], rd_data_b[15]);
        $fscanf(fp_r_b, "%h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h", 
            rd_data_b[16], rd_data_b[17], rd_data_b[18], rd_data_b[19], rd_data_b[20], rd_data_b[21], rd_data_b[22], rd_data_b[23], rd_data_b[24], rd_data_b[25], rd_data_b[26], rd_data_b[27], rd_data_b[28], rd_data_b[29], rd_data_b[30], rd_data_b[31]);
        $fscanf(fp_r_b, "%h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h", 
            rd_data_b[32], rd_data_b[33], rd_data_b[34], rd_data_b[35], rd_data_b[36], rd_data_b[37], rd_data_b[38], rd_data_b[39], rd_data_b[40], rd_data_b[41], rd_data_b[42], rd_data_b[43], rd_data_b[44], rd_data_b[45], rd_data_b[46], rd_data_b[47]);
        $fscanf(fp_r_b, "%h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h", 
            rd_data_b[48], rd_data_b[49], rd_data_b[50], rd_data_b[51], rd_data_b[52], rd_data_b[53], rd_data_b[54], rd_data_b[55], rd_data_b[56], rd_data_b[57], rd_data_b[58], rd_data_b[59], rd_data_b[60], rd_data_b[61], rd_data_b[62], rd_data_b[63]);
    end
    $fclose(fp_r_b);

    i_valid = 1;
    matrix_f_width = 4;
    matrix_s_width = 16;
    for (rd_l = 0; rd_l < 8; rd_l = rd_l + 1) begin
        for (rd_j = 0; rd_j < 16; rd_j = rd_j + 1) begin
            for (rd_k = 0; rd_k < 4; rd_k = rd_k + 1) begin
                mul_a = rd_data_a[rd_l * 4  + rd_k];
                mul_b = rd_data_b[rd_k * 16 + rd_j];
                #2;
            end
        end
    end
    i_valid = 0;

end
    
    
endmodule
