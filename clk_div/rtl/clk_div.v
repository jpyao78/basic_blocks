module clk_div(

input       i_clk,
input       i_rstn,
input [7:0] i_div,
input       i_div_tog,

output      o_clk
);


reg div_is_0; // i_div = 0
reg div_is_1; // i_div = 1
reg div_is_even;//i_div = 2,4,6,...

wire div_is_0_next;
wire div_is_1_next;
wire div_is_even_next;

//sync
reg tog_sync, tog_d;
always @(posedge i_clk or negedge i_rstn)begin
   if(!i_rstn)begin
      tog_sync <= 1'b0;
      tog_d    <= 1'b0;
   end
   else begin
      tog_sync <= i_div_tog;
      tog_d    <= tog_sync;
   end
end

reg [7:0] div_sync;
reg [7:0] div_cnt, div_last;
wire      div_sync_load;
assign    div_sync_load = tog_sync ^ tog_d;


always @(posedge i_clk or negedge i_rstn)begin
   if(!i_rstn)
      div_sync <= 8'h0;
   else if(div_sync_load)
      div_sync <= i_div;
end


wire    div_last_load;
assign  div_last_load = ((div_cnt == 8'h0) || (div_last == 8'h0)) && (div_sync != div_last);
always @(posedge i_clk or negedge i_rstn)begin
   if(!i_rstn)
      div_last <= 8'h0;
   else if(div_last_load)
      div_last <= div_sync;
end


////////////////////////////////////////////////////////////////
wire [7:0] div_cnt_next;
assign     div_cnt_next = div_cnt + 8'h1;
wire [7:0] div_cnt_half;
assign     div_cnt_half = {1'b0,div_last[7:1]};

//div_last == 0 or 1
wire   div_last_01;
assign div_last_01 = div_last[7:1] == 7'h0;

wire    div_cnt_return;
assign  div_cnt_return = (div_cnt_next == div_last) || div_last_01;
always @(posedge i_clk or negedge i_rstn)begin
   if(!i_rstn)
      div_cnt <= 8'h0;
   else if(div_cnt_return)
      div_cnt <= 8'h0;
   else
      div_cnt <= div_cnt_next;
end


/////////////////////////////////////////
//clk even
reg clk_even;

wire   clk_even_load;
assign clk_even_load = (div_cnt == div_cnt_half)|(div_cnt == 8'h0); 

always @(posedge i_clk or negedge i_rstn)begin
   if(!i_rstn)
     clk_even <= 1'b0;
   else if(div_is_0 | div_is_1)
     clk_even <= 1'b0;
   else if(clk_even_load)
     clk_even <= ~clk_even & (!(div_is_0 | div_is_1)); 
end

//==1 if even
//else delay of clk_even
reg clk_even_d;
always @(negedge i_clk or negedge i_rstn)begin
   if(!i_rstn)
      clk_even_d <= 1'b0;
   else
      clk_even_d <= clk_even | div_is_even_next;
end

assign div_is_0_next    =  div_last_01 & (!div_last[0]);       
assign div_is_1_next    =  div_last_01 &   div_last[0] ;
assign div_is_even_next =(!div_last_01)& (!div_last[0]);    


always @(posedge i_clk or negedge i_rstn)begin
   if(!i_rstn) begin
     div_is_0    <= 1'h0;
     div_is_1    <= 1'h0;
     div_is_even <= 1'h0;
   end
   else begin
     div_is_0    <= div_is_0_next    ; 
     div_is_1    <= div_is_1_next    ;
     div_is_even <= div_is_even_next ;
   end
end


wire clk1x;
gck  gck_clk_1(.i_clk(i_clk), .i_clk_en(div_is_1), .o_clk(clk1x));

wire   clk_others;
assign clk_others = clk_even & clk_even_d;

assign o_clk = clk1x | clk_others;

endmodule
