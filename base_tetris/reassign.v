module reassign(// input
                figure, rho_x, rho_y,
                // output
                change_rho_x, change_rho_y
                );
    parameter integer WIDTH = 8;

// input
input [WIDTH-1:0] figure;
input [4*WIDTH-1:0] rho_x, rho_y;
// output
output reg [4*WIDTH-1:0] change_rho_x, change_rho_y;

wire I_fig;
assign I_fig = (figure == 8'b00000000);

always @(*) begin
    if (I_fig) begin
        if (rho_x[4*WIDTH-1:3*WIDTH] == rho_x[1*WIDTH-1:0*WIDTH]) begin
            // vertical
            change_rho_x = rho_x;
            if (rho_y[4*WIDTH-1:3*WIDTH] > rho_y[1*WIDTH-1:0*WIDTH]) begin
                // rho_y[0] > rho_y[3]
                change_rho_y[4*WIDTH-1:3*WIDTH] = rho_y[1*WIDTH-1:0*WIDTH];
                change_rho_y[3*WIDTH-1:2*WIDTH] = rho_y[2*WIDTH-1:1*WIDTH];
                change_rho_y[4*WIDTH-1:1*WIDTH] = rho_y[3*WIDTH-1:2*WIDTH];
                change_rho_y[1*WIDTH-1:0*WIDTH] = rho_y[4*WIDTH-1:3*WIDTH];
            end
            else begin
                change_rho_y = rho_y;
            end
        end
        else begin
            // horisontal
            change_rho_y = rho_y;
            if (rho_x[4*WIDTH-1:3*WIDTH] > rho_x[1*WIDTH-1:0*WIDTH]) begin
                // rho_x[0] > rho_x[3]
                change_rho_x[4*WIDTH-1:3*WIDTH] = rho_x[1*WIDTH-1:0*WIDTH];
                change_rho_x[3*WIDTH-1:2*WIDTH] = rho_x[2*WIDTH-1:1*WIDTH];
                change_rho_x[4*WIDTH-1:1*WIDTH] = rho_x[3*WIDTH-1:2*WIDTH];
                change_rho_x[1*WIDTH-1:0*WIDTH] = rho_x[4*WIDTH-1:3*WIDTH];
            end
            else begin
                change_rho_x = rho_x;
            end
        end
    end
    else begin
        change_rho_x = rho_x;
        change_rho_y = rho_y;
    end
end

endmodule