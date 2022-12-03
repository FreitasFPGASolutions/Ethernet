module ethernet (
  input CLK_100_i,
  output LED4_o,
  output LED5_o,
  output LED6_o,
  output LED7_o,
  input eth_col,
  input eth_crs,
  output eth_mdc,
  inout eth_mdio,
  output eth_ref_clk,
  output eth_rstn,
  input eth_rx_clk,
  input eth_rx_dv,
  input [3:0] eth_rxd,
  input eth_rxerr,
  input eth_tx_clk,
  output eth_tx_en,
  output [3:0] eth_txd
);

//Block Design
logic clk_25;
logic mmcm_locked;
logic axi_aresetn = 0;

assign eth_ref_clk = clk_25;

block_design_wrapper bd (
  .MDIO_0_mdc     (eth_mdc),
  .MDIO_0_mdio_io (eth_mdio),
  .MII_0_col      (eth_col),
  .MII_0_crs      (eth_crs),
  .MII_0_rst_n    (eth_rstn),
  .MII_0_rx_clk   (eth_rx_clk),
  .MII_0_rx_dv    (eth_rx_dv),
  .MII_0_rx_er    (eth_rxerr),
  .MII_0_rxd      (eth_rxd),
  .MII_0_tx_clk   (eth_tx_clk),
  .MII_0_tx_en    (eth_tx_en),
  .MII_0_txd      (eth_txd),
  .axi_aclk       (CLK_100_i),
  .axi_aresetn    (axi_aresetn),
  .clk_25         (clk_25),
  .mmcm_locked    (mmcm_locked)
);

//LEDs
logic [27:0] clk_100_count = 0;
logic clk_100_led = 0;
logic [27:0] clk_25_count = 0;
logic clk_25_led = 0;

assign LED4_o = clk_100_led;
assign LED5_o = clk_25_led;
assign LED6_o = mmcm_locked;
assign LED7_o = 1;

always @ (posedge CLK_100_i)
begin
  clk_100_count <= clk_100_count + 1;
  if (clk_100_count == 28'h100)
    axi_aresetn <= 1;
  if (clk_100_count == 28'h5F5E100)
    begin
      clk_100_led <= ~clk_100_led;
      clk_100_count <= 0;
    end
end

always @ (posedge clk_25)
begin
  clk_25_count <= clk_25_count + 1;
  if (clk_25_count == 28'h17D7840)
    begin
      clk_25_led <= ~clk_25_led;
      clk_25_count <= 0;
    end
end

endmodule
