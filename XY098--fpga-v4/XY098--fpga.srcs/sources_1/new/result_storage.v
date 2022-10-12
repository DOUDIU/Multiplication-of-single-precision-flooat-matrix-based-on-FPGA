module result_storage#(
    parameter size_height     =   32,         //bits of M         matrix size: M*N,
    parameter size_width      =   32          //bits of N         matrix size: M*N,
)
(
    input                                   clk,
    input                                   rst_n,
    input       [size_width  - 1 : 0]       matrix_width,
    input                                   i_valid,
    input       [31 : 0]                    mul_result
);

reg     [9  : 0]    ram_addr;


always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        ram_addr    <=  0;
    end
    else if(i_valid) begin
        ram_addr    <=  ram_addr + 1;  
    end
end

//depth : 1024
blk_mem_gen_0 blk_mem_0     (.clka( clk ), .ena( i_valid ), .wea(  1  ), .addra( ram_addr ), .dina( mul_result ), .clkb(), .enb(), .addrb(), .doutb() );



endmodule