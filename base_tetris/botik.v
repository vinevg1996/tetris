module botik(clk, rst, command);
  input clk;
  input rst;
  output [7:0] command;
  // output [31:0] cc;

  reg [31:0] shift_reg;
  wire next_bit;

  assign next_bit =
    shift_reg[31] ^
    shift_reg[30] ^
    shift_reg[29] ^
    shift_reg[27] ^
    shift_reg[25] ^
    shift_reg[ 0];
  assign command = {5'b0, shift_reg[31:29]};
  // assign cc = shift_reg;

  always @(posedge clk, posedge rst)
  begin
    if(rst) begin
      shift_reg <= 32'h1;
    end else begin
      shift_reg <= { next_bit, shift_reg[31:1] };
    end
  end
endmodule // botik
