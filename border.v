module border(// input 
              clk, rst,
              new_coord_x_step_3, new_coord_y_step_3,
              new_bus_step_3,
              // output
              coord_x_step_1, coord_y_step_1, bus_step_1,
              // control
              is_write_reg, is_touch
              );
    parameter integer MEM_WIDTH = 4;
    parameter integer WIDTH = 8;
    
    // input
    input clk, rst;
    input [WIDTH * 4 - 1:0] new_coord_x_step_3;
    input [WIDTH * 4 - 1:0] new_coord_y_step_3;
    input [WIDTH * MEM_WIDTH - 1:0] new_bus_step_3;
    // output
    output [WIDTH * 4 - 1:0] coord_x_step_1;
    output [WIDTH * 4 - 1:0] coord_y_step_1;
    output [WIDTH * MEM_WIDTH - 1:0] bus_step_1;
    // control
    input is_write_reg, is_touch;

generate
    genvar i;
    for(i = 0; i < 4; i = i + 1)
    begin : assign_block_1
        reset_register #(.WIDTH(WIDTH))
            _x_coord(.load(is_write_reg), 
                     .clk(clk), .rst(rst || is_touch), 
                     .in(new_coord_x_step_3[WIDTH*(4-i)-1:WIDTH*(4-i-1)]), 
                     .rst_value(i),
                     .out(coord_x_step_1[WIDTH*(4-i)-1:WIDTH*(4-i-1)]));
    end
endgenerate

generate
    genvar j;
    for(j = 0; j < 4; j = j + 1)
    begin : assign_block_2
        reset_register #(.WIDTH(WIDTH))
            _y_coord(.load(is_write_reg), 
                     .clk(clk), .rst(rst || is_touch), 
                     .in(new_coord_y_step_3[WIDTH*(4-j)-1:WIDTH*(4-j-1)]), 
                     .rst_value(8'b0),
                     .out(coord_y_step_1[WIDTH*(4-j)-1:WIDTH*(4-j-1)]));
    end
endgenerate

generate
    genvar k;
    for(k = 0; k < MEM_WIDTH; k = k + 1)
    begin : assign_block_3
        reset_register #(.WIDTH(WIDTH))
            _reg(.load(is_write_reg), 
                 .clk(clk), .rst(rst), 
                 .in(new_bus_step_3[WIDTH*(MEM_WIDTH-k)-1:WIDTH*(MEM_WIDTH-k-1)]), 
                 .rst_value(3),
                 .out(bus_step_1[WIDTH*(MEM_WIDTH-k)-1:WIDTH*(MEM_WIDTH-k-1)]));
    end
endgenerate

endmodule