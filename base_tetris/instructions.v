module instructions(clk, rst, curr_command, 
                    is_touch, is_lose,
                    out_data);
    parameter integer WIDTH = 8;
    parameter integer INSTRACTION_NUMBERS = 4;
    input clk, rst;
    input [WIDTH-1: 0] curr_command;
    input is_touch;
    input is_lose;
    output [2 * WIDTH-1:0] out_data;

// reg [2 * WIDTH-1:0] mem [0:INSTRACTION_NUMBERS-1];
// wire [2 * WIDTH-1:0] memory = mem[curr_command];
wire [WIDTH-1:0] prng_data;
reg [WIDTH-1:0] data;
reg enable;

// initial begin
    // $readmemb("mem_content.list", mem); // Raw binary format
// end

linear_congruential_generator #(
    .seed(8), .variant(0),
    .width_state(18), .width_output(WIDTH)
    ) LCG_instance (
    .clk(clk), .rst(rst),
    .enable(enable), .out(prng_data)
    );

wire [WIDTH-1:0] player_action;
botik player(.clk(clk), .rst(rst), .command(player_action));

reg [WIDTH-1:0] action;
// wire [2 * WIDTH-1:0] memory = mem[curr_command];
always @(posedge clk, posedge rst) begin
    enable = 1'b1;
    if (rst) begin
        action <= 8'b00000000;
        data <= 8'b00000001;
    end
    else begin
        action <= 8'b00000001;
        data <= 8'b00000001;
    end
end

/*
always @(*) begin
    if (rst || is_touch || is_lose) begin
        action <= 8'b00000000;
        data <= 1'b1;
    end
    else if (player_action == 8'b00000000) begin
        action <= 8'b00000001;
        data <= 1'b1;
        enable <= 1'b1;
    end
    else begin
        action <= player_action;
        enable <= 1'b0;
    end
end
*/
//assign out_data = {player_action, data};
assign out_data = {action, data};
//assign out_data = {8'b00000000, 8'b00000001};
// assign out_data = {memory[2*WIDTH-1:1*WIDTH], data}
endmodule