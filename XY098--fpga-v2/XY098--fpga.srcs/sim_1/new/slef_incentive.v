`timescale 1ns / 1ns


module slef_incentive();

localparam  BITS_OF_matrix_SIZE = 32;

reg  clk;
reg  rst_n;


initial begin
    clk = 0;
    rst_n = 0;
    #2
    rst_n = 1;
end

always #1 begin
    clk <= ~clk;
end

test_top test_top(
    .clk            (clk),
    .rst_n          (rst_n)
);

// ram_data_make#(
//     .matrix_width(BITS_OF_matrix_SIZE)         //bits of L         matrix multiply: M*L L*N,
// )ram_data_make
// (
//     .clk            (clk),
//     .rst_n          (rst_n),

//     .o_valid        (),//each matrix enter will bring a high pulse
//     .mul_f          (),//first
//     .mul_s          (),//second

//     .matrix_f_width (),//L         matrix multiply: M*L L*N,
//     .matrix_s_width ()//N         matrix multiply: M*L L*N,
// );


endmodule
