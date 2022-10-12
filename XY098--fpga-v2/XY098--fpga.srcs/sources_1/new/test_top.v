module test_top(
        input   clk,
        input   rst_n
    );
  
localparam  BITS_OF_matrix_SIZE = 32;

wire                i_valid;
wire    [31 : 0]    mul_a;
wire    [31 : 0]    mul_b;
wire    [BITS_OF_matrix_SIZE - 1 : 0]    matrix_f_width;
wire    [BITS_OF_matrix_SIZE - 1 : 0]    matrix_s_width;

wire    [BITS_OF_matrix_SIZE - 1 : 0]    matrix_width_out;
wire                                     storage_valid;
wire    [31 : 0]                         mul_result;


ram_data_make#(
    .matrix_width(BITS_OF_matrix_SIZE)         //bits of L         matrix multiply: M*L L*N,
)ram_data_make
(
    .clk            (clk),
    .rst_n          (rst_n),

    .o_valid        (i_valid),//each matrix enter will bring a high pulse
    .mul_f          (mul_a),//first
    .mul_s          (mul_b),//second

    .matrix_f_width (matrix_f_width),//L         matrix multiply: M*L L*N,
    .matrix_s_width (matrix_s_width)//N         matrix multiply: M*L L*N,
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


    
endmodule
