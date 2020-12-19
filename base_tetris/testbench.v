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

$display("time, clk, addr, x_0, y_0, act, move, col[0], col[4], col[5], fig, new_rho_x[0], new_rho_y[0]");
$monitor("%1d     %1d    %1d     %1d     %1d    %1d    %1d    %1d    %1d    %1d    %1d    %1d    %1d",
         $time, clk,
         _tetris.instr_addr,
         _tetris.rho_x[4 * WIDTH - 1: 3 * WIDTH],
         _tetris.rho_y[4 * WIDTH - 1: 3 * WIDTH],
         _tetris.action,
         _tetris.is_move,
         _tetris._mem.is_colored[59:59],
         _tetris._mem.is_colored[46:46],
         _tetris._mem.is_colored[45:45],
         _tetris.figure,
         _tetris.new_rho_x[8*(4-0)-1:8*(4-0-1)],
         _tetris.new_rho_y[8*(4-0)-1:8*(4-0-1)]
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