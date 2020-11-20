module control_fsm(// input
                   instr_addr, action, figure,
                   rho_x, rho_y, border,
                   // output
                   write_reg, write_mem, is_move, 
                   is_load_PC,
                   is_touch, is_load_fig
                   );
    parameter integer WIDTH = 8;
    parameter integer MEM_WIDTH = 10;
    parameter integer MEM_HEIGHT = 20;
    parameter integer INSTRACTION_NUMBERS = 4;
    // input
    input [WIDTH-1:0] instr_addr, action, figure;
    input [4*WIDTH-1:0] rho_x, rho_y;
    input [MEM_WIDTH * WIDTH - 1:0] border;
    // output
    output reg write_reg, write_mem, is_move, is_load_PC;
    output reg is_touch, is_load_fig;

integer rho_x_array [0:3];
integer rho_y_array [0:3];
integer assume_rho_x_array [0:3];
integer assume_rho_y_array [0:3];
integer border_array [0:9];

always @(*) begin : assign_array
    rho_x_array[0] = rho_x[4*WIDTH-1:3*WIDTH];
    rho_x_array[1] = rho_x[3*WIDTH-1:2*WIDTH];
    rho_x_array[2] = rho_x[2*WIDTH-1:1*WIDTH];
    rho_x_array[3] = rho_x[1*WIDTH-1:0*WIDTH];
    //////////////////////////////////////////
    rho_y_array[0] = rho_y[4*WIDTH-1:3*WIDTH];
    rho_y_array[1] = rho_y[3*WIDTH-1:2*WIDTH];
    rho_y_array[2] = rho_y[2*WIDTH-1:1*WIDTH];
    rho_y_array[3] = rho_y[1*WIDTH-1:0*WIDTH];
    //////////////////////////////////////////
    border_array[0] = border[10*WIDTH-1:9*WIDTH];
    border_array[1] = border[9*WIDTH-1:8*WIDTH];
    border_array[2] = border[8*WIDTH-1:7*WIDTH];
    border_array[3] = border[7*WIDTH-1:6*WIDTH];
    border_array[4] = border[6*WIDTH-1:5*WIDTH];
    border_array[5] = border[5*WIDTH-1:4*WIDTH];
    border_array[6] = border[4*WIDTH-1:3*WIDTH];
    border_array[7] = border[3*WIDTH-1:2*WIDTH];
    border_array[8] = border[2*WIDTH-1:1*WIDTH];
    border_array[9] = border[1*WIDTH-1:0*WIDTH];
end

always @(*) begin
    if (instr_addr < INSTRACTION_NUMBERS) begin
        is_load_PC = 1'b1;
        write_reg = 1'b1;
        write_mem = 1'b1;
    end
    else begin
        is_load_PC = 1'b0;
        write_reg = 1'b0;
        write_mem = 1'b0;
    end
end

integer id_0, id_1, id_2, id_3;
always @(*) begin
    if (action == 8'b00000000) begin
        is_move = 1'b0;
        is_load_fig = 1'b1;
    end
    else if (action == 8'b00000001) begin
        // down
        is_load_fig = 1'b0;
        id_0 = rho_x_array[0];
        id_1 = rho_x_array[1];
        id_2 = rho_x_array[2];
        id_3 = rho_x_array[3];
        is_move = (rho_y_array[0] < border_array[id_0] - 1) &&
                  (rho_y_array[1] < border_array[id_1] - 1) &&
                  (rho_y_array[2] < border_array[id_2] - 1) &&
                  (rho_y_array[3] < border_array[id_3] - 1);
    end
    else if (action == 8'b00000010) begin
        // left
        is_load_fig = 1'b0;
        is_move = (rho_x_array[0] > 0) &&
                  (rho_x_array[1] > 0) &&
                  (rho_x_array[2] > 0) &&
                  (rho_x_array[3] > 0);
    end
    else if (action == 8'b00000011) begin
        // right
        is_load_fig = 1'b0;
        is_move = (rho_x_array[0] < 9) &&
                  (rho_x_array[1] < 9) &&
                  (rho_x_array[2] < 9) &&
                  (rho_x_array[3] < 9);
    end
    else if (action == 8'b00000100) begin
        // rotR
        is_load_fig = 1'b0;
        if (rho_x_array[0] == rho_x_array[3]) begin
            // vertical
            assume_rho_x_array[0] = rho_x_array[0] + 3;
            assume_rho_x_array[1] = rho_x_array[1] + 2;
            assume_rho_x_array[2] = rho_x_array[2] + 1;
            assume_rho_x_array[3] = rho_x_array[3];
            /////////////
            assume_rho_y_array[0] = rho_y_array[3];
            assume_rho_y_array[1] = rho_y_array[3];
            assume_rho_y_array[2] = rho_y_array[3];
            assume_rho_y_array[3] = rho_y_array[3];
            /////////////
            id_0 = assume_rho_x_array[0];
            id_1 = assume_rho_x_array[1];
            id_2 = assume_rho_x_array[2];
            id_3 = assume_rho_x_array[3];
            is_move = (assume_rho_y_array[0] < border_array[id_0]) &&
                      (assume_rho_y_array[1] < border_array[id_1]) &&
                      (assume_rho_y_array[2] < border_array[id_2]) &&
                      (assume_rho_y_array[3] < border_array[id_3]) &&
                      (assume_rho_x_array[0] < 9);
        end
        else begin
            // horisontal
            assume_rho_x_array[3] = rho_x_array[0];
            assume_rho_x_array[2] = rho_x_array[0];
            assume_rho_x_array[1] = rho_x_array[0];
            assume_rho_x_array[0] = rho_x_array[0];
            /////////////
            assume_rho_y_array[0] = rho_y_array[0];
            assume_rho_y_array[1] = rho_y_array[1] + 1;
            assume_rho_y_array[2] = rho_y_array[2] + 2;
            assume_rho_y_array[3] = rho_y_array[3] + 3;
            /////////////
            id_0 = assume_rho_x_array[0];
            id_1 = assume_rho_x_array[1];
            id_2 = assume_rho_x_array[2];
            id_3 = assume_rho_x_array[3];
            is_move = (assume_rho_y_array[0] < border_array[id_0]) &&
                      (assume_rho_y_array[1] < border_array[id_1]) &&
                      (assume_rho_y_array[2] < border_array[id_2]) &&
                      (assume_rho_y_array[3] < border_array[id_3]) &&
                      (assume_rho_x_array[0] < 9);
        end
    end
    else begin
        is_move = 1'b0;
        is_load_fig = 1'b0;
    end
end

endmodule