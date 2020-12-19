module alu(// input
           action, figure, border, rho_x, rho_y,
           // output
           new_border, new_rho_x, new_rho_y,
           // control
           is_move, is_reduce
           );
    parameter integer WIDTH = 8;
    parameter integer MEM_WIDTH = 10;
    parameter integer MEM_HEIGHT = 20;
    // input
    input [WIDTH - 1:0] action, figure;
    input [MEM_WIDTH * WIDTH - 1:0] border;
    input [4 * WIDTH - 1:0] rho_x, rho_y;
    // output
    output reg [MEM_WIDTH * WIDTH - 1:0] new_border;
    output reg [4 * WIDTH - 1:0] new_rho_x, new_rho_y;
    // control
    input is_move, is_reduce;

wire I_fig, Q_fig;
assign I_fig = (figure == 8'b00000000);
assign Q_fig = (figure == 8'b00000001);

/*
reg [4 * WIDTH - 1:0] norm_rho_x;
reg [4 * WIDTH - 1:0] norm_rho_y;
*/

wire [4 * WIDTH - 1:0] norm_rho_x;
wire [4 * WIDTH - 1:0] norm_rho_y;

reassign #(.WIDTH(WIDTH))
         _reassign(// input
                   .figure(figure), .rho_x(rho_x), .rho_y(rho_y),
                   // output
                   .change_rho_x(norm_rho_x), .change_rho_y(norm_rho_y));

always @(*) begin
    if (is_move) begin
        case(action)
            8'b00000000: begin
                // load
                new_border = border;
                new_rho_x = norm_rho_x;
                new_rho_y = norm_rho_y;
            end
            8'b00000001: begin
                // down
                new_rho_x = rho_x;
                new_rho_y[4*WIDTH-1:3*WIDTH] = norm_rho_y[4*WIDTH-1:3*WIDTH] + 1;
                new_rho_y[3*WIDTH-1:2*WIDTH] = norm_rho_y[3*WIDTH-1:2*WIDTH] + 1;
                new_rho_y[2*WIDTH-1:1*WIDTH] = norm_rho_y[2*WIDTH-1:1*WIDTH] + 1;
                new_rho_y[1*WIDTH-1:0*WIDTH] = norm_rho_y[1*WIDTH-1:0*WIDTH] + 1;
            end
            8'b00000010: begin
                // left
                new_rho_y = rho_y;
                new_rho_x[4*WIDTH-1:3*WIDTH] = norm_rho_x[4*WIDTH-1:3*WIDTH] - 1;
                new_rho_x[3*WIDTH-1:2*WIDTH] = norm_rho_x[3*WIDTH-1:2*WIDTH] - 1;
                new_rho_x[2*WIDTH-1:1*WIDTH] = norm_rho_x[2*WIDTH-1:1*WIDTH] - 1;
                new_rho_x[1*WIDTH-1:0*WIDTH] = norm_rho_x[1*WIDTH-1:0*WIDTH] - 1;
            end
            8'b00000011: begin
                // right
                new_rho_y = rho_y;
                new_rho_x[4*WIDTH-1:3*WIDTH] = norm_rho_x[4*WIDTH-1:3*WIDTH] + 1;
                new_rho_x[3*WIDTH-1:2*WIDTH] = norm_rho_x[3*WIDTH-1:2*WIDTH] + 1;
                new_rho_x[2*WIDTH-1:1*WIDTH] = norm_rho_x[2*WIDTH-1:1*WIDTH] + 1;
                new_rho_x[1*WIDTH-1:0*WIDTH] = norm_rho_x[1*WIDTH-1:0*WIDTH] + 1;
            end
            8'b00000100: begin
                // rotR
                if (I_fig) begin
                    if (norm_rho_x[4*WIDTH-1:3*WIDTH] == norm_rho_x[1*WIDTH-1:0*WIDTH]) begin
                        // vertical
                        new_rho_x[4*WIDTH-1:3*WIDTH] = norm_rho_x[4*WIDTH-1:3*WIDTH] + 3;
                        new_rho_x[3*WIDTH-1:2*WIDTH] = norm_rho_x[3*WIDTH-1:2*WIDTH] + 2;
                        new_rho_x[2*WIDTH-1:1*WIDTH] = norm_rho_x[2*WIDTH-1:1*WIDTH] + 1;
                        new_rho_x[1*WIDTH-1:0*WIDTH] = norm_rho_x[1*WIDTH-1:0*WIDTH];
                        /////////////
                        new_rho_y[4*WIDTH-1:3*WIDTH] = norm_rho_y[1*WIDTH-1:0*WIDTH];
                        new_rho_y[3*WIDTH-1:2*WIDTH] = norm_rho_y[1*WIDTH-1:0*WIDTH];
                        new_rho_y[2*WIDTH-1:1*WIDTH] = norm_rho_y[1*WIDTH-1:0*WIDTH];
                        new_rho_y[1*WIDTH-1:0*WIDTH] = norm_rho_y[1*WIDTH-1:0*WIDTH];
                    end
                    else begin
                        // horisontal
                        new_rho_x[4*WIDTH-1:3*WIDTH] = norm_rho_x[1*WIDTH-1:0*WIDTH];
                        new_rho_x[3*WIDTH-1:2*WIDTH] = norm_rho_x[1*WIDTH-1:0*WIDTH];
                        new_rho_x[2*WIDTH-1:1*WIDTH] = norm_rho_x[1*WIDTH-1:0*WIDTH];
                        new_rho_x[1*WIDTH-1:0*WIDTH] = norm_rho_x[1*WIDTH-1:0*WIDTH];
                        /////////////
                        new_rho_y[4*WIDTH-1:3*WIDTH] = norm_rho_y[4*WIDTH-1:3*WIDTH];
                        new_rho_y[3*WIDTH-1:2*WIDTH] = norm_rho_y[3*WIDTH-1:2*WIDTH] + 1;
                        new_rho_y[2*WIDTH-1:1*WIDTH] = norm_rho_y[2*WIDTH-1:1*WIDTH] + 2;
                        new_rho_y[1*WIDTH-1:0*WIDTH] = norm_rho_y[1*WIDTH-1:0*WIDTH] + 3;
                    end
                end
                else begin
                    new_rho_x = norm_rho_x;
                    new_rho_y[4*WIDTH-1:3*WIDTH] = norm_rho_y[4*WIDTH-1:3*WIDTH] + 1;
                    new_rho_y[3*WIDTH-1:2*WIDTH] = norm_rho_y[3*WIDTH-1:2*WIDTH] + 1;
                    new_rho_y[2*WIDTH-1:1*WIDTH] = norm_rho_y[2*WIDTH-1:1*WIDTH] + 1;
                    new_rho_y[1*WIDTH-1:0*WIDTH] = norm_rho_y[1*WIDTH-1:0*WIDTH] + 1;
                end
            end
            8'b00000101: begin
                // rotL
                if (I_fig) begin
                    if (norm_rho_x[4*WIDTH-1:3*WIDTH] == norm_rho_x[1*WIDTH-1:0*WIDTH]) begin
                        // vertical
                        new_rho_x[4*WIDTH-1:3*WIDTH] = norm_rho_x[4*WIDTH-1:3*WIDTH] - 3;
                        new_rho_x[3*WIDTH-1:2*WIDTH] = norm_rho_x[3*WIDTH-1:2*WIDTH] - 2;
                        new_rho_x[2*WIDTH-1:1*WIDTH] = norm_rho_x[2*WIDTH-1:1*WIDTH] - 1;
                        new_rho_x[1*WIDTH-1:0*WIDTH] = norm_rho_x[1*WIDTH-1:0*WIDTH];
                        /////////////
                        new_rho_y[4*WIDTH-1:3*WIDTH] = norm_rho_y[1*WIDTH-1:0*WIDTH];
                        new_rho_y[3*WIDTH-1:2*WIDTH] = norm_rho_y[1*WIDTH-1:0*WIDTH];
                        new_rho_y[2*WIDTH-1:1*WIDTH] = norm_rho_y[1*WIDTH-1:0*WIDTH];
                        new_rho_y[1*WIDTH-1:0*WIDTH] = norm_rho_y[1*WIDTH-1:0*WIDTH];
                    end 
                    else begin
                        // horisontal
                        new_rho_x[4*WIDTH-1:3*WIDTH] = norm_rho_x[1*WIDTH-1:0*WIDTH];
                        new_rho_x[3*WIDTH-1:2*WIDTH] = norm_rho_x[1*WIDTH-1:0*WIDTH];
                        new_rho_x[2*WIDTH-1:1*WIDTH] = norm_rho_x[1*WIDTH-1:0*WIDTH];
                        new_rho_x[1*WIDTH-1:0*WIDTH] = norm_rho_x[1*WIDTH-1:0*WIDTH];
                        /////////////
                        new_rho_y[4*WIDTH-1:3*WIDTH] = norm_rho_y[4*WIDTH-1:3*WIDTH];
                        new_rho_y[3*WIDTH-1:2*WIDTH] = norm_rho_y[3*WIDTH-1:2*WIDTH] + 1;
                        new_rho_y[2*WIDTH-1:1*WIDTH] = norm_rho_y[2*WIDTH-1:1*WIDTH] + 2;
                        new_rho_y[1*WIDTH-1:0*WIDTH] = norm_rho_y[1*WIDTH-1:0*WIDTH] + 3;
                    end
                end
                else begin
                    new_rho_x = rho_x;
                    new_rho_y[4*WIDTH-1:3*WIDTH] = norm_rho_y[4*WIDTH-1:3*WIDTH] - 1;
                    new_rho_y[3*WIDTH-1:2*WIDTH] = norm_rho_y[3*WIDTH-1:2*WIDTH] - 1;
                    new_rho_y[2*WIDTH-1:1*WIDTH] = norm_rho_y[2*WIDTH-1:1*WIDTH] - 1;
                    new_rho_y[1*WIDTH-1:0*WIDTH] = norm_rho_y[1*WIDTH-1:0*WIDTH] - 1;
                end
            end
            default: begin
                new_border = border;
                new_rho_x = norm_rho_x;
                new_rho_y = norm_rho_y;
            end
        endcase
    end
    else if (is_reduce) begin
        new_rho_x = norm_rho_x;
        new_rho_y[4*WIDTH-1:3*WIDTH] = norm_rho_y[4*WIDTH-1:3*WIDTH] + 1;
        new_rho_y[3*WIDTH-1:2*WIDTH] = norm_rho_y[3*WIDTH-1:2*WIDTH] + 1;
        new_rho_y[2*WIDTH-1:1*WIDTH] = norm_rho_y[2*WIDTH-1:1*WIDTH] + 1;
        new_rho_y[1*WIDTH-1:0*WIDTH] = norm_rho_y[1*WIDTH-1:0*WIDTH] + 1;
    end
    else begin
        new_border = border;
        new_rho_x = norm_rho_x;
        new_rho_y = norm_rho_y;
    end
end


endmodule