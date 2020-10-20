module fsm (// input
           clk, rst,
           coord_x_step_2, coord_y_step_2, 
           bus_step_2, instr_step_2,
           // control_output
           is_load_PC, is_write_reg,
           is_move, is_write_mem,
           is_load_for_launch_1_2, is_load_for_launch_2_3,
           is_touch
           );
    parameter integer MEM_WIDTH = 4;
    parameter integer MEM_HEIGHT = 4;
    parameter integer WIDTH = 8;

    // input
    input clk, rst;
    input [WIDTH * 4 - 1:0] coord_x_step_2;
    input [WIDTH * 4 - 1:0] coord_y_step_2;
    input [WIDTH * MEM_WIDTH - 1:0] bus_step_2;
    input [WIDTH * 2 - 1:0] instr_step_2;
    // control_output
    output reg is_load_PC, is_write_reg;
    output reg is_move, is_write_mem;
    output reg is_load_for_launch_1_2, is_load_for_launch_2_3;
    output reg is_touch;

reg [1:0] state, next_state;

localparam S_LOAD = 0, S_1_2 = 1, S_2_3 = 2, S_WRITE = 3;
/*
// x_coord and y_coord to array
reg [WIDTH-1:0] x_arr[0:3];
reg [WIDTH-1:0] y_arr[0:3];
generate
    genvar i1;
    for(i1 = 0; i1 < 4; i1 = i1 + 1)
    begin : assign_block_1
        x_arr[i1] = coord_x_step_2[WIDTH*(4-i1)-1:WIDTH*(4-i1-1)]
        y_arr[i1] = coord_y_step_2[WIDTH*(4-i1)-1:WIDTH*(4-i1-1)]
    end
endgenerate

// bus_coord to array
reg [WIDTH-1:0] b_arr[0:MEM_WIDTH-1];
generate
    genvar i2;
    for(i2 = 0; i2 < MEM_WIDTH; i2 = i2 + 1)
    begin : assign_block_2
        b_arr[i2] = bus_step_2[WIDTH*(4-i2)-1:WIDTH*(4-i2-1)]
    end
endgenerate
*/

// x_coord and y_coord to array
reg [WIDTH-1:0] x_arr[0:3];
reg [WIDTH-1:0] y_arr[0:3];
reg [WIDTH-1:0] b_arr[0:3];
always @(*) begin
    {x_arr[0], x_arr[1], x_arr[2], x_arr[3]} = coord_x_step_2;
    {y_arr[0], y_arr[1], y_arr[2], y_arr[3]} = coord_y_step_2;
    {b_arr[0], b_arr[1], b_arr[2], b_arr[3]} = bus_step_2;
end

always @(*) begin
    is_move = (y_arr[x_arr[0]] < b_arr[x_arr[0]]) &&
              (y_arr[x_arr[1]] < b_arr[x_arr[1]]) &&
              (y_arr[x_arr[2]] < b_arr[x_arr[2]]) &&
              (y_arr[x_arr[3]] < b_arr[x_arr[3]]);
    is_touch = (y_arr[x_arr[0]] == b_arr[x_arr[0]]) ||
              (y_arr[x_arr[1]] == b_arr[x_arr[1]]) ||
              (y_arr[x_arr[2]] == b_arr[x_arr[2]]) ||
              (y_arr[x_arr[3]] == b_arr[x_arr[3]]);
end

always @(*) begin
    //is_move = 1'b1;
    case(state)
        S_LOAD: begin
            is_load_PC = 1'b1;
            is_write_reg = 1'b0;
            is_write_mem = 1'b0;
            is_load_for_launch_1_2 = 1'b0;
            is_load_for_launch_2_3 = 1'b0;
            next_state = S_1_2;
        end
        S_1_2: begin
            is_load_PC = 1'b0;
            is_write_reg = 1'b0;
            is_write_mem = 1'b0;
            is_load_for_launch_1_2 = 1'b1;
            is_load_for_launch_2_3 = 1'b0;
            next_state = S_2_3;
        end
        S_2_3: begin
            is_load_PC = 1'b0;
            is_write_reg = 1'b0;
            is_write_mem = 1'b0;
            is_load_for_launch_1_2 = 1'b0;
            is_load_for_launch_2_3 = 1'b1;
            next_state = S_WRITE;
        end
        S_WRITE: begin
            is_load_PC = 1'b0;
            is_write_reg = 1'b1;
            is_write_mem = 1'b1;
            is_load_for_launch_1_2 = 1'b0;
            is_load_for_launch_2_3 = 1'b0;
            next_state = S_LOAD;
        end
        default: next_state = S_LOAD;
    endcase
end

always @(posedge clk, posedge rst) begin
    if(rst) 
        state <= S_LOAD;
    else 
        state <= next_state;
end

endmodule