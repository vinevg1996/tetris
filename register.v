module register(load, in, clk, rst, out);
    parameter integer WIDTH = 8;
    input [WIDTH-1:0] in;
    input load, clk, rst;
    output reg [WIDTH-1:0] out;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            out <= 0;
        end
        else begin
            if (load) begin
                out <= in;
            end
        end
    end

endmodule