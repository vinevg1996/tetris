module cpu_step_1(// input 
                  clk, rst,
                  new_coord_x_step_3, new_coord_y_step_3,
                  new_bus_step_3,
                  // output 
                  instr_step_1, 
                  coord_x_step_1, coord_y_step_1, 
                  bus_step_1,
                  // control
                  is_load_PC, is_write_reg, is_touch
                  );
    parameter integer MEM_WIDTH = 4;
    parameter integer MEM_HEIGHT = 4;
    parameter integer WIDTH = 8;
    parameter integer INSTRACTION_NUMBERS = 4;

    // input
    input clk, rst;
    input [WIDTH * 4 - 1:0] new_coord_x_step_3;
    input [WIDTH * 4 - 1:0] new_coord_y_step_3;
    input [WIDTH * MEM_WIDTH - 1:0] new_bus_step_3;
    // output
    output [2 * WIDTH - 1:0] instr_step_1;
    output [WIDTH * 4 - 1:0] coord_x_step_1;
    output [WIDTH * 4 - 1:0] coord_y_step_1;
    output [WIDTH * MEM_WIDTH - 1:0] bus_step_1;
    // control
    input is_load_PC, is_write_reg, is_touch;

wire [WIDTH-1:0] instr_addr;
wire [WIDTH-1:0] new_instr_addr;

adder #(.WIDTH(WIDTH))
    _adder_plus_one(.clk(clk), .rst(rst),
                    .x(instr_addr), .y(8'b1), .out(new_instr_addr));

PC _PC(.load(is_load_PC), .clk(clk), .rst(rst), 
       .in(new_instr_addr), .out(instr_addr));

instructions #(.INSTRACTION_NUMBERS(INSTRACTION_NUMBERS)) 
              _inst(.rst(rst), .curr_command(instr_addr), 
                    .out_data(instr_step_1));

border #(.WIDTH(WIDTH), .MEM_WIDTH(MEM_WIDTH))
    _border(.clk(clk), .rst(rst), .new_coord_x_step_3(new_coord_x_step_3),
            .new_coord_y_step_3(new_coord_y_step_3), 
            .new_bus_step_3(new_bus_step_3),
            .coord_x_step_1(coord_x_step_1), .coord_y_step_1(coord_y_step_1),
            .bus_step_1(bus_step_1), 
            .is_write_reg(is_write_reg), .is_touch(is_touch));

endmodule