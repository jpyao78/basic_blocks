module rstn_sync(
input  i_clk,
input  i_rstn,
input  i_test_mode,
output o_rstn
);

//sync 1
reg rstn;
always @(posedge i_clk or negedge i_rstn)begin
  if(!i_rstn)
     rstn <= 1'h0;
  else
     rstn <= 1'h1;
end

//sync 2
reg rstn_d;
always @(posedge i_clk or negedge i_rstn)begin
  if(!i_rstn)
     rstn_d <= 1'h0;
  else
     rstn_d <= rstn;
end

assign o_rstn = i_test_mode ? i_rstn : rstn_d;

endmodule
