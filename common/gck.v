module gck(
input i_clk,
input i_clk_en,

output o_clk
);

reg latch;
always @(i_clk or i_clk_en)begin
    if(!i_clk)
        latch = i_clk_en;
end

assign o_clk = i_clk & latch;

endmodule
