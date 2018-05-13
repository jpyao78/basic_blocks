module clk_mux4(
input       i_rstn,
input       i_clk0,
input       i_clk1,
input       i_clk2,
input       i_clk3,
input [1:0] i_sel,

output      o_clk
);

reg clk0_d_en;
reg clk1_d_en;
reg clk2_d_en;
reg clk3_d_en;
reg clk0_dd_en;
reg clk1_dd_en;
reg clk2_dd_en;
reg clk3_dd_en;

wire sel0,sel1,sel2,sel3;

assign sel0 = i_sel == 2'h0;
assign sel1 = i_sel == 2'h1;
assign sel2 = i_sel == 2'h2;
assign sel3 = i_sel == 2'h3;

wire clk0_en,clk1_en,clk2_en,clk3_en;

assign clk0_en = sel0 & (!(clk1_dd_en | clk2_dd_en | clk3_dd_en));
assign clk1_en = sel1 & (!(clk0_dd_en | clk2_dd_en | clk3_dd_en));
assign clk2_en = sel2 & (!(clk0_dd_en | clk1_dd_en | clk3_dd_en));
assign clk3_en = sel3 & (!(clk0_dd_en | clk1_dd_en | clk2_dd_en));

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

//clk2 path
always @(posedge i_clk2 or negedge i_rstn)begin
   if(!i_rstn)
      clk2_d_en <= 1'b0;
   else
      clk2_d_en <= clk2_en;
end

always @(posedge i_clk2 or negedge i_rstn)begin
   if(!i_rstn)
      clk2_dd_en <= 1'b0;
   else
      clk2_dd_en <= clk2_d_en;
end

//clk3 path
always @(posedge i_clk3 or negedge i_rstn)begin
   if(!i_rstn)
      clk3_d_en <= 1'b0;
   else
      clk3_d_en <= clk3_en;
end

always @(posedge i_clk3 or negedge i_rstn)begin
   if(!i_rstn)
      clk3_dd_en <= 1'b0;
   else
      clk3_dd_en <= clk3_d_en;
end


wire clk0_gated;
wire clk1_gated;
wire clk2_gated;
wire clk3_gated;

gck gck_clk0 (.i_clk(i_clk0), .i_clk_en(clk0_dd_en), .o_clk(clk0_gated));
gck gck_clk1 (.i_clk(i_clk1), .i_clk_en(clk1_dd_en), .o_clk(clk1_gated));
gck gck_clk2 (.i_clk(i_clk2), .i_clk_en(clk2_dd_en), .o_clk(clk2_gated));
gck gck_clk3 (.i_clk(i_clk3), .i_clk_en(clk3_dd_en), .o_clk(clk3_gated));


assign o_clk = clk0_gated | clk1_gated | clk2_gated | clk3_gated;


endmodule

