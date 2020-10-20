module reset_register(load, in, clk, rst, rst_value, out);
    parameter integer WIDTH = 8;
    input [WIDTH-1:0] in;
    input load, clk, rst;
    input [WIDTH-1:0] rst_value;
    output reg [WIDTH-1:0] out;

    reg without_load;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            out <= rst_value;
        end
        else begin
            if (load) begin
                out <= in;
            end
            else begin
                without_load <= 8'b0;
            end
        end
    end

endmodule