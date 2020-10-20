module tetris(clk, rst);
    parameter integer MEM_WIDTH = 4;
    parameter integer MEM_HEIGHT = 4;
    parameter integer WIDTH = 8;

    input clk, rst;

//_________________________________
// wires for step_1
//_________________________________
// _output_wires
wire [2 * WIDTH - 1:0] instr_step_1;
wire [WIDTH * 4 - 1:0] coord_x_step_1;
wire [WIDTH * 4 - 1:0] coord_y_step_1;
wire [WIDTH * MEM_WIDTH - 1:0] bus_step_1;
// _control_wires
wire is_load_PC;
wire is_load_for_launch_1_2;
wire is_write_reg, is_touch;

//_________________________________
// wires for step_2
//_________________________________
// _input_wires
wire [2 * WIDTH - 1:0] instr_step_2;
wire [WIDTH * 4 - 1:0] coord_x_step_2;
wire [WIDTH * 4 - 1:0] coord_y_step_2;
wire [WIDTH * MEM_WIDTH - 1:0] bus_step_2;
// _output_wires
wire [WIDTH * 4 - 1:0] new_coord_x_step_2;
wire [WIDTH * 4 - 1:0] new_coord_y_step_2;
wire [WIDTH * MEM_WIDTH - 1:0] new_bus_step_2;
// _control_wires
wire is_move;
wire is_load_for_launch_2_3;

//_________________________________
// wires for step_3
// _input_wires
wire [WIDTH * 4 - 1:0] new_coord_x_step_3;
wire [WIDTH * 4 - 1:0] new_coord_y_step_3;
wire [WIDTH * MEM_WIDTH - 1:0] new_bus_step_3;
//_________________________________
// _control_wires
wire is_write_mem;

// step 1
cpu_step_1 #(.MEM_WIDTH(MEM_WIDTH), .MEM_HEIGHT(MEM_HEIGHT),
             .WIDTH(WIDTH))
    _cpu_step_1(// input 
                .clk(clk), .rst(rst),
                .new_coord_x_step_3(new_coord_x_step_3),
                .new_coord_y_step_3(new_coord_y_step_3),
                .new_bus_step_3(new_bus_step_3),
                // output 
                .instr_step_1(instr_step_1),
                .coord_x_step_1(coord_x_step_1),
                .coord_y_step_1(coord_y_step_1),
                .bus_step_1(bus_step_1),
                // control
                .is_load_PC(is_load_PC),
                .is_write_reg(is_write_reg)
                );

register #(.WIDTH(2 * WIDTH)) 
    _instr_1_2_launch (.rst(rst), .clk(clk), .load(is_load_for_launch_1_2), 
                       .in(instr_step_1), .out(instr_step_2));
register #(.WIDTH(WIDTH * 4)) 
    _coord_x_1_2_launch (.rst(rst), .clk(clk), .load(is_load_for_launch_1_2), 
                         .in(coord_x_step_1), .out(coord_x_step_2));
register #(.WIDTH(WIDTH * 4)) 
    _coord_y_1_2_launch (.rst(rst), .clk(clk), .load(is_load_for_launch_1_2), 
                         .in(coord_y_step_1), .out(coord_y_step_2));
register #(.WIDTH(WIDTH * MEM_WIDTH)) 
    _bus_1_2_launch (.rst(rst), .clk(clk), .load(is_load_for_launch_1_2), 
                      .in(bus_step_1), .out(bus_step_2));

// step 2
cpu_step_2 #(.MEM_WIDTH(MEM_WIDTH), .MEM_HEIGHT(MEM_HEIGHT),
             .WIDTH(WIDTH))
    _cpu_step_2(// input 
                .clk(clk), .rst(rst),
                .instr_step_2(instr_step_2),
                .coord_x_step_2(coord_x_step_2),
                .coord_y_step_2(coord_y_step_2),
                .bus_step_2(bus_step_2),
                // output 
                .new_coord_x_step_2(new_coord_x_step_2),
                .new_coord_y_step_2(new_coord_y_step_2),
                .new_bus_step_2(new_bus_step_2),
                // control
                .is_move(is_move),
                .is_touch(is_touch)
                );

register #(.WIDTH(WIDTH * 4)) 
    _new_coord_x_2_3_launch (.rst(rst), .clk(clk), .load(is_load_for_launch_2_3), 
                             .in(new_coord_x_step_2), .out(new_coord_x_step_3));
register #(.WIDTH(WIDTH * 4)) 
    _new_coord_y_2_3_launch (.rst(rst), .clk(clk), .load(is_load_for_launch_2_3), 
                             .in(new_coord_y_step_2), .out(new_coord_y_step_3));
register #(.WIDTH(WIDTH * MEM_WIDTH)) 
    _new_regs_2_3_launch (.rst(rst), .clk(clk), .load(is_load_for_launch_2_3), 
                          .in(new_bus_step_2), .out(new_bus_step_3));

memory #(.MEM_WIDTH(MEM_WIDTH), .MEM_HEIGHT(MEM_HEIGHT),
         .WIDTH(WIDTH))
    _mem(// input 
         .clk(clk), .rst(rst),
         .new_coord_x_step_3(new_coord_x_step_3),
         .new_coord_y_step_3(new_coord_y_step_3),
         .new_bus_step_3(new_bus_step_3),
         // control
         .is_write_mem(is_write_mem)
         );

fsm #(.MEM_WIDTH(MEM_WIDTH), .MEM_HEIGHT(MEM_HEIGHT),
      .WIDTH(WIDTH))
    _fsm(// input
        .clk(clk), .rst(rst),
        .coord_x_step_2(coord_x_step_2), 
        .coord_y_step_2(coord_y_step_2), 
        .bus_step_2(bus_step_2),
        .instr_step_2(instr_step_2),
        // control_output
        .is_load_PC(is_load_PC),
        .is_write_reg(is_write_reg),
        .is_move(is_move),
        .is_write_mem(is_write_mem),
        .is_load_for_launch_1_2(is_load_for_launch_1_2),
        .is_load_for_launch_2_3(is_load_for_launch_2_3),
        .is_touch(is_touch)
        );

endmodule