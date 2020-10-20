module adder (clk, rst, x, y, out);
    parameter integer WIDTH = 8;
    input clk, rst;
    input [WIDTH-1:0] x, y;
    //output reg [WIDTH-1:0] out;
    output [WIDTH-1:0] out;

    assign out = x + y;

endmodule
