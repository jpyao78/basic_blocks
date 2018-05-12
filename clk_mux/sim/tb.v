`timescale  1ns/1ps

module tb;

reg clk0;
reg clk1;
reg rstn;
reg sel;


initial begin
  clk0 = 1'b0;
  clk1 = 1'b0;
  rstn = 1'b1;
  sel  = 1'b0;
  #100; 
  rstn = 1'b0;
  #100; 
  rstn = 1'b1;

  $display("%t, sel switch start...",$time);
  //sel switch
  #101;
  sel  = 1'b1;
  #121;
  sel  = 1'b0;
  #221;
  sel  = 1'b1;
  #221;
  sel  = 1'b0;
  #221;
  sel  = 1'b1;
  #221;
  sel  = 1'b0;
  #1000;
  $finish;
end

always #3.3 clk0 = ~clk0;
always #8.7 clk1 = ~clk1;

wire clk_out;

clk_mux i_clk_mux(
.i_clk0 (clk0   ),
.i_clk1 (clk1   ),
.i_sel  (sel    ),//0:o_clk= i_clk0;1:o_clk=i_clk1
.i_rstn (rstn   ),
.o_clk  (clk_out)
);

initial begin
     $fsdbDumpfile("tb.fsdb");
     $fsdbDumpvars();
end

endmodule
