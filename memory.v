module memory(// input 
              clk, rst, 
              new_coord_x_step_3, new_coord_y_step_3, 
              new_bus_step_3,
              // control
              is_write_mem
              );
    parameter integer MEM_WIDTH = 4;
    parameter integer MEM_HEIGHT = 4;
    parameter integer WIDTH = 8;
    
    // input
    input clk, rst;
    input [WIDTH * 4 - 1:0] new_coord_x_step_3;
    input [WIDTH * 4 - 1:0] new_coord_y_step_3;
    input [WIDTH * MEM_WIDTH - 1:0] new_bus_step_3;
    // control
    input is_write_mem;

wire [WIDTH * MEM_WIDTH - 1:0] out_bus_step_3;


generate
    genvar i;
    for(i = 0; i < MEM_WIDTH; i = i + 1)
    begin : assign_block
        register _reg(.load(is_write_mem), 
                      .clk(clk), .rst(rst), 
                      .in(new_bus_step_3[WIDTH*(MEM_WIDTH-i)-1:WIDTH*(MEM_WIDTH-i-1)]), 
                      .out(out_bus_step_3[WIDTH*(MEM_WIDTH-i)-1:WIDTH*(MEM_WIDTH-i-1)]));
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