module matrix_mul_top #(
    parameter matrix_width = 32         //bits of L         matrix multiply: M*L L*N,
)
(
    input                                   clk,
    input                                   rst_n,

    input                                   i_valid,//each matrix enter will bring a high pulse
    input           [31 : 0]                mul_f,//first
    input           [31 : 0]                mul_s,//second

    input           [matrix_width -1 : 0]   matrix_f_width,//L         matrix multiply: M*L L*N,
    input           [matrix_width -1 : 0]   matrix_s_width,//N         matrix multiply: M*L L*N,
    
    output          [matrix_width -1 : 0]   matrix_width_out,//N         matrix multiply: M*L L*N,         
    output  reg                             o_valid,
    output  reg     [31 : 0]                mul_result
);

    integer i;

    wire    [31 : 0]                    mul_tem_result;
    wire                                mul_result_valid;

    wire                                add_result_valid;
    wire    [31 : 0]                    add_tem_result;
    reg     [31 : 0]                    sum_tem_result;


    reg     [matrix_width - 1 : 0]      matrix_f_width_d    [14 : 0];
    reg     [matrix_width - 1 : 0]      matrix_s_width_d    [14 : 0];
    wire    [matrix_width - 1 : 0]      matrix_valid_width;
    reg     [matrix_width - 1 : 0]      sum_counter;

    assign    matrix_valid_width  =     matrix_f_width_d[9];
    assign    matrix_width_out    =     matrix_s_width_d[13];

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            for(i = 0 ;i < 15 ; i = i + 1) begin
                matrix_f_width_d[i]     <=  0;
                matrix_s_width_d[i]     <=  0;
            end
        end
        else if(i_valid) begin
            matrix_f_width_d[0]         <=  matrix_f_width;
            matrix_s_width_d[0]         <=  matrix_s_width;
            for(i = 0 ;i < 14; i = i + 1) begin
                matrix_f_width_d[i + 1] <=  matrix_f_width_d[i];
                matrix_s_width_d[i + 1] <=  matrix_s_width_d[i];
            end
        end
    end



//multiply IP
    floating_point_0 mul_floating_point (
        .aclk                   (clk),                      // input wire aclk

        .s_axis_a_tvalid        (i_valid),                  // input wire s_axis_a_tvalid
        .s_axis_a_tready        (),                         // output wire s_axis_a_tready
        .s_axis_a_tdata         (mul_f),                    // input wire [31 : 0] s_axis_a_tdata

        .s_axis_b_tvalid        (i_valid),                  // input wire s_axis_b_tvalid
        .s_axis_b_tready        (),                         // output wire s_axis_b_tready
        .s_axis_b_tdata         (mul_s),                    // input wire [31 : 0] s_axis_b_tdata

        .m_axis_result_tvalid   (mul_result_valid),         // output wire m_axis_result_tvalid
        .m_axis_result_tready   (1),                        // input wire m_axis_result_tready
        .m_axis_result_tdata    (mul_tem_result)            // output wire [31 : 0] m_axis_result_tdata
    );

//add IP
    floating_point_1 add_floating_point (
        .aclk                   (clk),                          // input wire aclk

        .s_axis_a_tvalid        (mul_result_valid),             // input wire s_axis_a_tvalid
        .s_axis_a_tready        (),                             // output wire s_axis_a_tready
        .s_axis_a_tdata         (mul_tem_result),               // input wire [31 : 0] s_axis_a_tdata

        .s_axis_b_tvalid        (mul_result_valid),             // input wire s_axis_b_tvalid
        .s_axis_b_tready        (),                             // output wire s_axis_b_tready
        .s_axis_b_tdata         (sum_tem_result),               // input wire [31 : 0] s_axis_b_tdata

        .m_axis_result_tvalid   (add_result_valid),             // output wire m_axis_result_tvalid
        .m_axis_result_tready   (1),                            // input wire m_axis_result_tready
        .m_axis_result_tdata    (add_tem_result)                // output wire [31 : 0] m_axis_result_tdata
    );

    always@(posedge clk or negedge rst_n) begin
        if(!rst_n)
            sum_counter <=  0;
        else if(add_result_valid)
            sum_counter <=  sum_counter == matrix_valid_width - 1 ? 0 : sum_counter + 1'b1;
        else
            sum_counter <=  0;
    end

    always@(negedge clk or negedge rst_n) begin
        if(!rst_n) begin
            sum_tem_result  <=  0;
        end
        else if(add_result_valid) begin
            sum_tem_result  <=  sum_counter == matrix_valid_width - 1 ? 0 : add_tem_result;
        end
    end

    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            mul_result  <=  0;
            o_valid     <=  0;
        end
        else if(add_result_valid) begin
            mul_result  <= sum_counter == matrix_valid_width - 1 ? add_tem_result : 0;
            o_valid     <= sum_counter == matrix_valid_width - 1 ? 1 : 0;
        end
        else begin
            mul_result  <= 0;
            o_valid     <= 0;
        end
    end

endmodule
