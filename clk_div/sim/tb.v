`timescale 1ns/1ps
module tb;

reg clk;
reg rstn;

reg [7:0] div;
reg       div_tog;


initial begin
   clk = 1'b0;
   div_tog = 1'b0;
   rstn= 1'b1;
   div = 8'h0;
   #100;
   rstn= 1'b0;
   #100;
   rstn= 1'b1;

   repeat(100) begin
      #2210;
      div     = $random & 5'h0f;
      div_tog = ~div_tog;
   end

   #1000;
   $finish;
end

always #3.78 clk = ~clk;

wire o_clk;

clk_div i_clk_div(
.i_clk    (clk),
.i_rstn   (rstn),
.i_div    (div),
.i_div_tog(div_tog),
.o_clk    (o_clk)
);


initial begin
     $fsdbDumpfile("tb.fsdb");
     $fsdbDumpvars();
end

endmodule
