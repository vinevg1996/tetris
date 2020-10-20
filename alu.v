module alu(// input 
           clk, rst, command, dir, 
           coord_x_step_2, coord_y_step_2, 
           bus_step_2,
           // output 
           new_coord_x_step_2, new_coord_y_step_2, 
           new_bus_step_2,
           // control
           is_move, is_touch
           );
    parameter integer MEM_WIDTH = 4;
    parameter integer MEM_HEIGHT = 4;
    parameter integer WIDTH = 8;

    // input
    input clk, rst;
    input [WIDTH-1:0] command;
    input [WIDTH-1:0] dir;
    input [WIDTH * 4 - 1:0] coord_x_step_2;
    input [WIDTH * 4 - 1:0] coord_y_step_2;
    input [WIDTH * MEM_WIDTH - 1:0] bus_step_2;
    // output
    output reg [WIDTH * 4 - 1:0] new_coord_x_step_2;
    output reg [WIDTH * 4 - 1:0] new_coord_y_step_2;
    output reg [WIDTH * MEM_WIDTH - 1:0] new_bus_step_2;
    // control
    input is_move, is_touch;

always @(*) begin
    if (is_move) begin
        if (dir == 8'b00000000) begin
            new_coord_x_step_2 = coord_x_step_2;
            new_bus_step_2 = bus_step_2;
            new_coord_y_step_2[WIDTH * 4 - 1:WIDTH * 3] = coord_y_step_2[WIDTH * 4 - 1:WIDTH * 3] + 8'b1;
            new_coord_y_step_2[WIDTH * 3 - 1:WIDTH * 2] = coord_y_step_2[WIDTH * 3 - 1:WIDTH * 2] + 8'b1;
            new_coord_y_step_2[WIDTH * 2 - 1:WIDTH * 1] = coord_y_step_2[WIDTH * 2 - 1:WIDTH * 1] + 8'b1;
            new_coord_y_step_2[WIDTH * 1 - 1:WIDTH * 0] = coord_y_step_2[WIDTH * 1 - 1:WIDTH * 0] + 8'b1;
        end
        else begin
            new_coord_y_step_2 = coord_y_step_2;
        end
    end
    else begin
        new_coord_x_step_2 = coord_x_step_2;
        new_coord_y_step_2 = coord_y_step_2;
        if (is_touch) begin
            new_bus_step_2[WIDTH * 4 - 1:WIDTH * 3] = coord_y_step_2[WIDTH * 4 - 1:WIDTH * 3];
            new_bus_step_2[WIDTH * 3 - 1:WIDTH * 2] = coord_y_step_2[WIDTH * 3 - 1:WIDTH * 2];
            new_bus_step_2[WIDTH * 2 - 1:WIDTH * 1] = coord_y_step_2[WIDTH * 2 - 1:WIDTH * 1];
            new_bus_step_2[WIDTH * 1 - 1:WIDTH * 0] = coord_y_step_2[WIDTH * 1 - 1:WIDTH * 0];
        end
        else begin
            new_bus_step_2 = bus_step_2;
        end
    end
end

endmodule