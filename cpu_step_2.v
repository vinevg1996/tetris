module cpu_step_2(// input 
                  clk, rst,
                  instr_step_2, 
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
    input [2 * WIDTH - 1:0] instr_step_2;
    input [WIDTH * 4 - 1:0] coord_x_step_2;
    input [WIDTH * 4 - 1:0] coord_y_step_2;
    input [WIDTH * MEM_WIDTH - 1:0] bus_step_2;
    // output
    output [WIDTH * 4 - 1:0] new_coord_x_step_2;
    output [WIDTH * 4 - 1:0] new_coord_y_step_2;
    output [WIDTH * MEM_WIDTH - 1:0] new_bus_step_2;
    // control
    input is_move, is_touch;

wire [WIDTH-1:0] command;
wire [WIDTH-1:0] dir;

assign command = instr_step_2[2 * WIDTH - 1:WIDTH];
assign dir = instr_step_2[WIDTH - 1:0];

alu #(.MEM_WIDTH(MEM_WIDTH), .MEM_HEIGHT(MEM_HEIGHT),
      .WIDTH(WIDTH))
     _alu(// input
          .clk(clk), .rst(rst), .command(command), .dir(dir),
          .coord_x_step_2(coord_x_step_2), .coord_y_step_2(coord_y_step_2), 
          .bus_step_2(bus_step_2),
          // output
          .new_coord_x_step_2(new_coord_x_step_2),
          .new_coord_y_step_2(new_coord_y_step_2),
          .new_bus_step_2(new_bus_step_2),
          // control
          .is_move(is_move),
          .is_touch(is_touch)
          );

endmodule