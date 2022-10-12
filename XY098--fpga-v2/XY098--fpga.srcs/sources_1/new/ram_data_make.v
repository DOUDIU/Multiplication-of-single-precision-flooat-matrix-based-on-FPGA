module ram_data_make#(
    parameter matrix_width = 32         //bits of L         matrix multiply: M*L L*N,
)(
    input                                    clk,
    input                                    rst_n,

    output                                   o_valid,   //each matrix enter will bring a high pulse
    output           [31 : 0]                mul_f  ,     //first
    output           [31 : 0]                mul_s  ,     //second

    output           [matrix_width - 1 : 0]   matrix_f_width,//L         matrix multiply: M*L L*N,
    output           [matrix_width - 1 : 0]   matrix_s_width //N         matrix multiply: M*L L*N,
    );

    reg                 read_enable;
    reg                 read_enable_d1;
    reg                 read_enable_d2;

    reg     [11 : 0]    f_heigth_count_max;  
    reg     [11 : 0]    row_count_max;
    reg     [11 : 0]    column_count_max;
 
    reg     [11 : 0]    f_heigth_count;  
    reg     [11 : 0]    row_count;
    reg     [11 : 0]    column_count;
 
    reg     [7  : 0]    block_info_addr;
 
    wire    [7  : 0]    matrix_f_height_tem;                //M         matrix multiply: M*L L*N,
    wire    [7  : 0]    matrix_f_width_with_s_height_tem;   //L         matrix multiply: M*L L*N,
    wire    [7  : 0]    matrix_s_width_tem;                 //N         matrix multiply: M*L L*N,
 
    wire    [31 : 0]    data_f ;
    wire    [31 : 0]    data_s ;
    reg     [31 : 0]    data_f_d1;
    reg     [31 : 0]    data_s_d1;

    wire    [10 : 0]    addr_data_f;
    wire    [10 : 0]    addr_data_s;

    
    reg     [10 : 0]    addr_data_f_base;
    reg     [10 : 0]    addr_data_s_base;

    reg                 pulse_out;
    reg                 pulse_out_d1;
    reg                 pulse_out_d2;

    reg    [matrix_width - 1 : 0]   matrix_f_width_d1,matrix_f_width_d2;
    reg    [matrix_width - 1 : 0]   matrix_s_width_d1,matrix_s_width_d2;

    always@(*)begin
        if(!rst_n)
            read_enable     <=  0;
        else if({matrix_f_height_tem,matrix_f_width_with_s_height_tem,matrix_s_width_tem} == 0)
            read_enable     <=  0;
        else
            read_enable     <=  1;
    end 

    always@(*)begin
        if(!rst_n)
            column_count_max    <=  0;
        else
            column_count_max    <=  matrix_f_width_with_s_height_tem;
    end

    always@(*)begin
        if(!rst_n)
            row_count_max    <=  0;
        else
            row_count_max    <=  matrix_s_width_tem;
    end

    always@(*)begin
        if(!rst_n)
            f_heigth_count_max    <=  0;
        else
            f_heigth_count_max    <=  matrix_f_height_tem;
    end

    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)
            column_count   <=  0;
        else if(column_count == column_count_max - 1)
            column_count   <=  0;
        else
            column_count   <=  read_enable ? column_count + 1 : 0;
    end

    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)
            row_count   <=  0;
        else if(column_count == column_count_max - 1) begin
            if(row_count == row_count_max - 1)
                row_count   <=  0;
            else
                row_count   <=  read_enable ? row_count + 1 : 0;
        end
    end

    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)
            f_heigth_count  <=  0;
        else if(row_count   ==  row_count_max - 1 && column_count == column_count_max - 1)
            if(f_heigth_count   ==  f_heigth_count_max - 1)
                f_heigth_count  <=  0;
            else
                f_heigth_count  <=  read_enable ? f_heigth_count + 1 : 0;
    end

    always@(posedge clk or negedge rst_n)begin
        if(!rst_n) 
            block_info_addr <=  0;
        else if(row_count   ==  row_count_max - 1 && column_count == column_count_max - 2)begin //ahead of 1 clk accumulate block_info_addr
            if(f_heigth_count   ==  f_heigth_count_max - 1)
                block_info_addr <=  block_info_addr + 1;
        end
    end

    always@(posedge clk or negedge rst_n)begin
        if(!rst_n) 
            block_info_addr <=  0;
        else if(row_count   ==  row_count_max - 1 && column_count == column_count_max - 2)begin //ahead of 1 clk accumulate block_info_addr
            if(f_heigth_count   ==  f_heigth_count_max - 1)
                block_info_addr <=  block_info_addr + 1;
        end
    end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n)
        addr_data_f_base    <=  0;
    else if( (row_count   ==  row_count_max - 1) && (column_count == column_count_max - 1) && (f_heigth_count   ==  f_heigth_count_max - 1) )
        addr_data_f_base    <=  addr_data_f_base + f_heigth_count_max * column_count_max;
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n)
        addr_data_s_base    <=  0;
    else if( (row_count   ==  row_count_max - 1) && (column_count == column_count_max - 1) && (f_heigth_count   ==  f_heigth_count_max - 1) )
        addr_data_s_base    <=  addr_data_s_base + row_count_max      * column_count_max;
end

assign  addr_data_f = addr_data_f_base + f_heigth_count * column_count_max + column_count;
assign  addr_data_s = addr_data_s_base + row_count      * column_count_max + column_count;


block_info u_block_info (
    .clka(clk),                 // input wire clka
    .ena(1),                    // input wire ena
    .wea(0),                    // input wire [0 : 0]  wea
    .addra(block_info_addr),    // input wire [7 : 0]  addra
    .dina(),                    // input wire [23 : 0] dina
    .douta({matrix_f_height_tem,matrix_f_width_with_s_height_tem,matrix_s_width_tem})  // output wire [23 : 0] douta
);

origin_data u_origin_data_f (
  .clka(clk),               // input wire clka
  .ena(read_enable),        // input wire ena
  .wea(0),                  // input wire [0 : 0] wea
  .addra(addr_data_f),      // input wire [10 : 0] addra
  .dina(),                  // input wire [31 : 0] dina
  .douta(data_f)            // output wire [31 : 0] douta
);

origin_data_s u_origin_data_s (
  .clka(clk),    // input wire clka
  .ena(read_enable ),      // input wire ena
  .wea(0),      // input wire [0 : 0] wea
  .addra(addr_data_s),  // input wire [10 : 0] addra
  .dina(),    // input wire [31 : 0] dina
  .douta(data_s)  // output wire [31 : 0] douta
);

always@(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        read_enable_d1  <=  0;
        read_enable_d2  <=  0;
    end
    else begin
        read_enable_d1  <=  read_enable;
        read_enable_d2  <=  read_enable_d1;
    end
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        pulse_out   <=  0;
    else if( (row_count   ==  row_count_max - 1) && (column_count == column_count_max - 1) && (f_heigth_count   ==  f_heigth_count_max - 1) )
        pulse_out   <=  1;
    else
        pulse_out   <=  0;
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        pulse_out_d1    <=  0;
    else
        pulse_out_d1    <=  pulse_out || !read_enable_d1&read_enable ;
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        pulse_out_d2    <=  0;
    else
        pulse_out_d2    <=  pulse_out_d1;
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        data_f_d1       <=  0;
    else
        data_f_d1       <=  data_f;
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        data_s_d1       <=  0;
    else
        data_s_d1       <=  data_s;
end



always@(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        matrix_f_width_d1   <=  0;
        matrix_s_width_d1   <=  0;
        matrix_f_width_d2   <=  0;
        matrix_s_width_d2   <=  0;
    end
    else begin
        matrix_f_width_d1   <=  matrix_f_width_with_s_height_tem;
        matrix_s_width_d1   <=  matrix_s_width_tem;
        matrix_f_width_d2   <=  matrix_f_width_d1;
        matrix_s_width_d2   <=  matrix_s_width_d1;
    end
end


assign  o_valid         =   read_enable_d2;
assign  mul_f           =   data_f_d1;
assign  mul_s           =   data_s_d1;
assign  matrix_f_width  =   matrix_f_width_d2;
assign  matrix_s_width  =   matrix_s_width_d2;

endmodule

