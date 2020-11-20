//`timescale 1 ns / 100 ps
// testbench is a module which only task is to test another module
// testbench is for simulation only, not for synthesis

module testbench;
    parameter integer MEM_WIDTH = 10;
    //parameter integer MEM_HEIGHT = 20;
    parameter integer MEM_HEIGHT = 6;
    parameter integer WIDTH = 8;
    parameter integer INSTRACTION_NUMBERS = 8;

    reg clk, rst;

    tetris #(.WIDTH(WIDTH), .MEM_WIDTH(MEM_WIDTH), 
             .MEM_HEIGHT(MEM_HEIGHT), .INSTRACTION_NUMBERS(INSTRACTION_NUMBERS))
        _tetris(.clk(clk),
                .rst(rst));

    always begin
        #5 clk =~ clk;
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, testbench);

$display("time, clk, addr, x_0, x_1, x_2, x_3, y_0, y_1, y_2, y_3, act, move");
$monitor("%1d     %1d    %1d     %1d     %1d    %1d    %1d    %1d    %1d    %1d     %1d     %1d     %1d",
         $time, clk,
         _tetris.instr_addr,
         _tetris.rho_x[4 * WIDTH - 1: 3 * WIDTH],
         _tetris.rho_x[3 * WIDTH - 1: 2 * WIDTH],
         _tetris.rho_x[2 * WIDTH - 1: 1 * WIDTH],
         _tetris.rho_x[1 * WIDTH - 1: 0 * WIDTH],
         _tetris.rho_y[4 * WIDTH - 1: 3 * WIDTH],
         _tetris.rho_y[3 * WIDTH - 1: 2 * WIDTH],
         _tetris.rho_y[2 * WIDTH - 1: 1 * WIDTH],
         _tetris.rho_y[1 * WIDTH - 1: 0 * WIDTH],
         _tetris.action,
         _tetris.is_move
         );
        // simulation
        clk = 1;
        rst = 1;
        #5
        rst = 0;
        #100
        //#200
        $finish;
    end

endmodule