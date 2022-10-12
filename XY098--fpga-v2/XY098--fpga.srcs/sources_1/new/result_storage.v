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
reg     [15 : 0]    shift_addr_en;
reg     [15 : 0]    wr_count;
reg     [9  : 0]    ram_addr;

wire        wea_0 ;
wire        wea_1 ;
wire        wea_2 ;
wire        wea_3 ;
wire        wea_4 ;
wire        wea_5 ;
wire        wea_6 ;
wire        wea_7 ;
wire        wea_8 ;
wire        wea_9 ;
wire        wea_10;
wire        wea_11;
wire        wea_12;
wire        wea_13;
wire        wea_14;
wire        wea_15;

assign      wea_0   =   shift_addr_en[0 : 0 ];
assign      wea_1   =   shift_addr_en[1 : 1 ];
assign      wea_2   =   shift_addr_en[2 : 2 ];
assign      wea_3   =   shift_addr_en[3 : 3 ];
assign      wea_4   =   shift_addr_en[4 : 4 ];
assign      wea_5   =   shift_addr_en[5 : 5 ];
assign      wea_6   =   shift_addr_en[6 : 6 ];
assign      wea_7   =   shift_addr_en[7 : 7 ];
assign      wea_8   =   shift_addr_en[8 : 8 ];
assign      wea_9   =   shift_addr_en[9 : 9 ];
assign      wea_10  =   shift_addr_en[10: 10];
assign      wea_11  =   shift_addr_en[11: 11];
assign      wea_12  =   shift_addr_en[12: 12];
assign      wea_13  =   shift_addr_en[13: 13];
assign      wea_14  =   shift_addr_en[14: 14];
assign      wea_15  =   shift_addr_en[15: 15];

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        wr_count    <=  0;
    end
    else if(i_valid) begin
        wr_count    <=  wr_count == matrix_width - 1 ?  0 : wr_count + 1;  
    end
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        ram_addr    <=  0;
    end
    else if(i_valid && wr_count == matrix_width - 1) begin
        ram_addr = ram_addr + 1;
    end
end

always@(posedge clk or  negedge rst_n) begin
    if(!rst_n) begin
        shift_addr_en   <=  1;
    end
    else if(i_valid) begin
        if(wr_count == matrix_width - 1) begin
            shift_addr_en   <=  1;
        end
        else begin
            shift_addr_en   <=  shift_addr_en << 1;
        end
    end
end



//depth : 1024
blk_mem_gen_0 blk_mem_0     (.clka( clk ), .ena( i_valid ), .wea(  wea_0  ), .addra( ram_addr ), .dina( mul_result ), .clkb(), .enb(), .addrb(), .doutb() );
blk_mem_gen_0 blk_mem_1     (.clka( clk ), .ena( i_valid ), .wea(  wea_1  ), .addra( ram_addr ), .dina( mul_result ), .clkb(), .enb(), .addrb(), .doutb() );
blk_mem_gen_0 blk_mem_2     (.clka( clk ), .ena( i_valid ), .wea(  wea_2  ), .addra( ram_addr ), .dina( mul_result ), .clkb(), .enb(), .addrb(), .doutb() );
blk_mem_gen_0 blk_mem_3     (.clka( clk ), .ena( i_valid ), .wea(  wea_3  ), .addra( ram_addr ), .dina( mul_result ), .clkb(), .enb(), .addrb(), .doutb() );
blk_mem_gen_0 blk_mem_4     (.clka( clk ), .ena( i_valid ), .wea(  wea_4  ), .addra( ram_addr ), .dina( mul_result ), .clkb(), .enb(), .addrb(), .doutb() );
blk_mem_gen_0 blk_mem_5     (.clka( clk ), .ena( i_valid ), .wea(  wea_5  ), .addra( ram_addr ), .dina( mul_result ), .clkb(), .enb(), .addrb(), .doutb() );
blk_mem_gen_0 blk_mem_6     (.clka( clk ), .ena( i_valid ), .wea(  wea_6  ), .addra( ram_addr ), .dina( mul_result ), .clkb(), .enb(), .addrb(), .doutb() );
blk_mem_gen_0 blk_mem_7     (.clka( clk ), .ena( i_valid ), .wea(  wea_7  ), .addra( ram_addr ), .dina( mul_result ), .clkb(), .enb(), .addrb(), .doutb() );
blk_mem_gen_0 blk_mem_8     (.clka( clk ), .ena( i_valid ), .wea(  wea_8  ), .addra( ram_addr ), .dina( mul_result ), .clkb(), .enb(), .addrb(), .doutb() );
blk_mem_gen_0 blk_mem_9     (.clka( clk ), .ena( i_valid ), .wea(  wea_9  ), .addra( ram_addr ), .dina( mul_result ), .clkb(), .enb(), .addrb(), .doutb() );
blk_mem_gen_0 blk_mem_10    (.clka( clk ), .ena( i_valid ), .wea(  wea_10 ), .addra( ram_addr ), .dina( mul_result ), .clkb(), .enb(), .addrb(), .doutb() );
blk_mem_gen_0 blk_mem_11    (.clka( clk ), .ena( i_valid ), .wea(  wea_11 ), .addra( ram_addr ), .dina( mul_result ), .clkb(), .enb(), .addrb(), .doutb() );
blk_mem_gen_0 blk_mem_12    (.clka( clk ), .ena( i_valid ), .wea(  wea_12 ), .addra( ram_addr ), .dina( mul_result ), .clkb(), .enb(), .addrb(), .doutb() );
blk_mem_gen_0 blk_mem_13    (.clka( clk ), .ena( i_valid ), .wea(  wea_13 ), .addra( ram_addr ), .dina( mul_result ), .clkb(), .enb(), .addrb(), .doutb() );
blk_mem_gen_0 blk_mem_14    (.clka( clk ), .ena( i_valid ), .wea(  wea_14 ), .addra( ram_addr ), .dina( mul_result ), .clkb(), .enb(), .addrb(), .doutb() );
blk_mem_gen_0 blk_mem_15    (.clka( clk ), .ena( i_valid ), .wea(  wea_15 ), .addra( ram_addr ), .dina( mul_result ), .clkb(), .enb(), .addrb(), .doutb() );



endmodule
