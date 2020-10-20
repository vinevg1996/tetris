`timescale 1 ns / 100 ps
// testbench is a module which only task is to test another module
// testbench is for simulation only, not for synthesis

module testbench;
    parameter integer MEM_WIDTH = 4;
    parameter integer MEM_HEIGHT = 4;
    parameter integer WIDTH = 8;

    reg clk, rst;

    tetris #(.MEM_WIDTH(MEM_WIDTH), .MEM_HEIGHT(MEM_HEIGHT),
             .WIDTH(WIDTH))
        _tetris(.clk(clk),
                .rst(rst));

    always begin
        #5 clk =~ clk;
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, testbench);

$display("time,  clk, instr,  state,  o_c2_y, n_c2_y, bus3, move");
$monitor("%1d     %1d      %1d      %1d       %1d       %1d       %1d       %1d",
         $time, clk,
         _tetris._cpu_step_1.instr_addr,
         _tetris._fsm.state,
         _tetris.coord_y_step_2[4 * WIDTH - 1:3 * WIDTH],
         _tetris.new_coord_y_step_2[4 * WIDTH - 1:3 * WIDTH],
         _tetris.new_bus_step_3[4 * WIDTH - 1:3 * WIDTH],
         _tetris.is_move
         );

        // simulation
        clk = 1;
        rst = 1;
        #5
        rst = 0;
        //#100
        #200
        $finish;
    end

endmodule