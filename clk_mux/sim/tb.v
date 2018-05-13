`timescale  1ns/1ps

module tb;

reg clk0;
reg clk1;
reg clk2;
reg clk3;
reg rstn;
reg [1:0] sel;


initial begin
  clk0 = 1'b0;
  clk1 = 1'b0;
  clk2 = 1'b0;
  clk3 = 1'b0;
  rstn = 1'b1;

  sel  = 1'b0;
  #100; 
  rstn = 1'b0;
  #100; 
  rstn = 1'b1;

  $display("%t, sel switch start...",$time);
  //sel switch
  #101;
  sel  = 2'h2;
  #121;
  sel  = 2'h1;
  #221;
  sel  = 2'h0;
  #221;
  sel  = 2'h3;
  #221;
  sel  = 2'h2;
  #221;
  sel  = 2'h0;
  #221;
  sel  = 2'h3;
  #221;
  sel  = 2'h1;
  #221;
  sel  = 2'h2;
  #221;
  sel  = 2'h3;
  #221;
  sel  = 2'h0;
  #1000;
  $finish;
end

always #3.3 clk0 = ~clk0;
always #8.7 clk1 = ~clk1;
always #4.7 clk2 = ~clk2;
always #5.7 clk3 = ~clk3;

wire clk_out2;

clk_mux i_clk_mux(
.i_clk0 (clk0   ),
.i_clk1 (clk1   ),
.i_sel  (sel[0] ),//0:o_clk= i_clk0;1:o_clk=i_clk1
.i_rstn (rstn   ),
.o_clk  (clk_out2)
);


wire clk_out4;
clk_mux4  i_clk_mux4(
.i_clk0 (clk0   ),
.i_clk1 (clk1   ),
.i_clk2 (clk2   ),
.i_clk3 (clk3   ),
.i_sel  (sel    ),//0:o_clk= i_clk0;1:o_clk=i_clk1
.i_rstn (rstn   ),
.o_clk  (clk_out4)
);


initial begin
     $fsdbDumpfile("tb.fsdb");
     $fsdbDumpvars();
end

endmodule
