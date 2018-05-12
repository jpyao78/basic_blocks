module clk_mux(
input i_clk0,
input i_clk1,
input i_sel,//0:o_clk= i_clk0;1:o_clk=i_clk1
input i_rstn,
output o_clk
);


reg clk0_d_en,clk0_dd_en;
reg clk1_d_en,clk1_dd_en;

wire   clk0_en;
wire   clk1_en;
assign clk0_en =(!i_sel) & (!clk1_dd_en); 
assign clk1_en =( i_sel) & (!clk0_dd_en); 

//clk0 path
always @(posedge i_clk0 or negedge i_rstn)begin
   if(!i_rstn)
      clk0_d_en <= 1'b0;
   else
      clk0_d_en <= clk0_en;
end

always @(posedge i_clk0 or negedge i_rstn)begin
   if(!i_rstn)
      clk0_dd_en <= 1'b0;
   else
      clk0_dd_en <= clk0_d_en;
end


//clk1 path
always @(posedge i_clk1 or negedge i_rstn)begin
   if(!i_rstn)
      clk1_d_en <= 1'b0;
   else
      clk1_d_en <= clk1_en;
end

always @(posedge i_clk1 or negedge i_rstn)begin
   if(!i_rstn)
      clk1_dd_en <= 1'b0;
   else
      clk1_dd_en <= clk1_d_en;
end

wire clk0_gated;
wire clk1_gated;

gck gck_clk0 (.i_clk(i_clk0), .i_clk_en(clk0_dd_en), .o_clk(clk0_gated));
gck gck_clk1 (.i_clk(i_clk1), .i_clk_en(clk1_dd_en), .o_clk(clk1_gated));


assign o_clk = clk0_gated | clk1_gated;

endmodule
