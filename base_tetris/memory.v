module memory(// input 
              new_border, new_rho_x, new_rho_y,
              // control
              clk, rst, write_mem
              );
    parameter integer MEM_WIDTH = 10;
    //parameter integer MEM_HEIGHT = 20;
    parameter integer MEM_HEIGHT = 6;
    parameter integer WIDTH = 8;
    parameter integer W = 1;
    localparam SIZE = MEM_WIDTH*MEM_HEIGHT;
    
    // input
    input [MEM_WIDTH * WIDTH - 1:0] new_border;
    input [4 * WIDTH - 1:0] new_rho_x, new_rho_y;
    // control
    input write_mem;
    input clk, rst;

//wire is_colored[0:MEM_WIDTH][0:MEM_HEIGHT];
//wire [SIZE-1:0] is_colored;
reg [SIZE-1:0] is_colored;

genvar i, j;
generate
    for(i = 0; i < MEM_WIDTH; i = i + 1) begin 
        for(j = 0; j < MEM_HEIGHT; j = j + 1) begin
          always @(*) begin
            // is_colored[i][j] = is_colored[(60-(10*j+i))-1:(60-(10*j+i)-1)]
            // is_colored[60] - (0, 0)
            // is_colored[51] - (9, 0)
            // is_colored[0] - (9, 5)
            is_colored[(60-(10*j+i))-1:(60-(10*j+i)-1)] = 
                (i == new_rho_x[8*(4-0)-1:8*(4-0-1)] && j == new_rho_y[8*(4-0)-1:8*(4-0-1)]) ||
                (i == new_rho_x[8*(4-1)-1:8*(4-1-1)] && j == new_rho_y[8*(4-1)-1:8*(4-1-1)]) ||
                (i == new_rho_x[8*(4-2)-1:8*(4-2-1)] && j == new_rho_y[8*(4-2)-1:8*(4-2-1)]) ||
                (i == new_rho_x[8*(4-3)-1:8*(4-3-1)] && j == new_rho_y[8*(4-3)-1:8*(4-3-1)]);
          end
        end
    end
  
endgenerate


/*
generate
    integer i, j;
    for(i = 0; i < MEM_WIDTH; i = i + 1)
        //genvar j;
        for(j = 0; j < MEM_HEIGHT; j = j + 1)
        begin : assign_block
        reg is_colored = (j >= new_border[(10-i)-1:(10-i-1)]) ||
                         (i == new_rho_x[0] && j == new_rho_y[0]) ||
                         (i == new_rho_x[1] && j == new_rho_y[1]) ||
                         (i == new_rho_x[2] && j == new_rho_y[2]) ||
                         (i == new_rho_x[3] && j == new_rho_y[3]);
        reset_register #(.WIDTH(1)) 
        _mem_reg(.load(write_mem), 
                 .clk(clk), .rst(rst), 
                 .rst_value(1'b0),
                 .in(is_colored), 
                 .out(mem[(SIZE-(10*j+i))-1:(60-(10*j+i)-1)]));
        end
endgenerate
*/
/*
wire mem_arr[0:MEM_WIDTH-1][0:MEM_HEIGHT-1];

reg [WIDTH-1:0] x_arr[0:3];
reg [WIDTH-1:0] y_arr[0:3];
reg [WIDTH-1:0] b_arr[0:3];
always @(*) begin
    {x_arr[0], x_arr[1], x_arr[2], x_arr[3]} = new_coord_x_step_3;
    {y_arr[0], y_arr[1], y_arr[2], y_arr[3]} = new_coord_y_step_3;
    {b_arr[0], b_arr[1], b_arr[2], b_arr[3]} = new_bus_step_3;
end

reg [MEM_WIDTH-1:0] is_full_0, is_full_1, is_full_2, is_full_3;

generate
    genvar k;
    for(k = 0; k < MEM_HEIGHT; k = k + 1)
    begin : assign_block
        is_full_0[(MEM_HEIGHT-k)-1:MEM_HEIGHT-k-1] = (y_arr[x_arr[0]] == k) ||
                                                     (b_arr[x_arr[0]] == k)
        is_full_1[(MEM_HEIGHT-k)-1:MEM_HEIGHT-k-1] = (y_arr[x_arr[1]] == k) ||
                                                     (b_arr[x_arr[1]] == k)
        is_full_2[(MEM_HEIGHT-k)-1:MEM_HEIGHT-k-1] = (y_arr[x_arr[2]] == k) ||
                                                     (b_arr[x_arr[2]] == k)
        is_full_3[(MEM_HEIGHT-k)-1:MEM_HEIGHT-k-1] = (y_arr[x_arr[3]] == k) ||
                                                     (b_arr[x_arr[3]] == k)
    end
endgenerate

generate
    genvar i;
    for(i = 0; i < MEM_HEIGHT; i = i + 1)
    begin : assign_block
        register _reg0(.load(is_write_mem),
                      .clk(clk), .rst(rst), 
                      .in(is_full_0[(MEM_HEIGHT-i)-1:MEM_HEIGHT-i-1]),
                      .out(mem_arr[i][j]));
        register _reg1(.load(is_write_mem),
                      .clk(clk), .rst(rst), 
                      .in(is_full_1[(MEM_HEIGHT-i)-1:MEM_HEIGHT-i-1]),
                      .out(mem_arr[i][j]));
        register _reg2(.load(is_write_mem),
                      .clk(clk), .rst(rst), 
                      .in(is_full_2[(MEM_HEIGHT-i)-1:MEM_HEIGHT-i-1]),
                      .out(mem_arr[i][j]));
        register _reg3(.load(is_write_mem),
                      .clk(clk), .rst(rst), 
                      .in(is_full_3[(MEM_HEIGHT-i)-1:MEM_HEIGHT-i-1]),
                      .out(mem_arr[i][j]));
    end
endgenerate
*/
endmodule