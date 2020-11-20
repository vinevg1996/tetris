module memory(// input 
              new_border, new_rho_x, new_rho_y,
              // control
              clk, rst, write_mem
              );
    parameter integer MEM_WIDTH = 10;
    parameter integer MEM_HEIGHT = 20;
    parameter integer WIDTH = 8;
    
    // input
    input [MEM_WIDTH * WIDTH - 1:0] new_border;
    input [4 * WIDTH - 1:0] new_rho_x, new_rho_y;
    // control
    input write_mem;
    input clk, rst;

wire [MEM_WIDTH * WIDTH - 1:0] mem_border;

generate
    genvar i;
    for(i = 0; i < MEM_WIDTH; i = i + 1)
    begin : assign_block
        reset_register 
            _reg(.load(write_mem), 
                 .clk(clk), .rst(rst), 
                 .rst_value(8'b0),
                 .in(new_border[WIDTH*(MEM_WIDTH-i)-1:WIDTH*(MEM_WIDTH-i-1)]), 
                 .out(mem_border[WIDTH*(MEM_WIDTH-i)-1:WIDTH*(MEM_WIDTH-i-1)]));
    end
endgenerate

/*
wire mem_arr[0:MEM_WIDTH-1][0:MEM_HEIGHT-1];

reg [WIDTH-1:0] x_arr[0:3];
reg [WIDTH-1:0] y_arr[0:3];
reg [WIDTH-1:0] b_arr[0:3];
always @(*) begin
    {x_arr[0], x_arr[1], x_arr[2], x_arr[3]} = new_coord_x_step_3;
    {y_arr[0], y_arr[1], y_arr[2], y_arr[3]} = new_coord_y_step_3;
    {b_arr[0], b_arr[1], b_arr[2], b_arr[3]} = new_bus_step_3;
end

reg [MEM_WIDTH-1:0] is_full_0, is_full_1, is_full_2, is_full_3;

generate
    genvar k;
    for(k = 0; k < MEM_HEIGHT; k = k + 1)
    begin : assign_block
        is_full_0[(MEM_HEIGHT-k)-1:MEM_HEIGHT-k-1] = (y_arr[x_arr[0]] == k) ||
                                                     (b_arr[x_arr[0]] == k)
        is_full_1[(MEM_HEIGHT-k)-1:MEM_HEIGHT-k-1] = (y_arr[x_arr[1]] == k) ||
                                                     (b_arr[x_arr[1]] == k)
        is_full_2[(MEM_HEIGHT-k)-1:MEM_HEIGHT-k-1] = (y_arr[x_arr[2]] == k) ||
                                                     (b_arr[x_arr[2]] == k)
        is_full_3[(MEM_HEIGHT-k)-1:MEM_HEIGHT-k-1] = (y_arr[x_arr[3]] == k) ||
                                                     (b_arr[x_arr[3]] == k)
    end
endgenerate

generate
    genvar i;
    for(i = 0; i < MEM_HEIGHT; i = i + 1)
    begin : assign_block
        register _reg0(.load(is_write_mem),
                      .clk(clk), .rst(rst), 
                      .in(is_full_0[(MEM_HEIGHT-i)-1:MEM_HEIGHT-i-1]),
                      .out(mem_arr[i][j]));
        register _reg1(.load(is_write_mem),
                      .clk(clk), .rst(rst), 
                      .in(is_full_1[(MEM_HEIGHT-i)-1:MEM_HEIGHT-i-1]),
                      .out(mem_arr[i][j]));
        register _reg2(.load(is_write_mem),
                      .clk(clk), .rst(rst), 
                      .in(is_full_2[(MEM_HEIGHT-i)-1:MEM_HEIGHT-i-1]),
                      .out(mem_arr[i][j]));
        register _reg3(.load(is_write_mem),
                      .clk(clk), .rst(rst), 
                      .in(is_full_3[(MEM_HEIGHT-i)-1:MEM_HEIGHT-i-1]),
                      .out(mem_arr[i][j]));
    end
endgenerate
*/
endmodule