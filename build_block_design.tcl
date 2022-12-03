create_project block_design ./block_design -part xc7a100tcsg324-1

create_bd_design "block_design"
update_compile_order -fileset sources_1

  # Create interface ports
  set MDIO_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:mdio_rtl:1.0 MDIO_0 ]

  set MII_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:mii_rtl:1.0 MII_0 ]


  # Create ports
  set axi_aclk [ create_bd_port -dir I -type clk axi_aclk ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_RESET {axi_aresetn} \
 ] $axi_aclk
  set axi_aresetn [ create_bd_port -dir I -type rst axi_aresetn ]
  set clk_25 [ create_bd_port -dir O -type clk clk_25 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {25000000} \
 ] $clk_25
  set mmcm_locked [ create_bd_port -dir O mmcm_locked ]

  # Create instance: axi_ethernetlite_0, and set properties
  set axi_ethernetlite_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_ethernetlite:3.0 axi_ethernetlite_0 ]

  # Create instance: axi_traffic_gen_0, and set properties
  set axi_traffic_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_traffic_gen:3.0 axi_traffic_gen_0 ]
  set_property -dict [ list \
   CONFIG.C_ATG_MIF_DATA_DEPTH {256} \
   CONFIG.C_ATG_MODE {AXI4-Lite} \
   CONFIG.C_ATG_SYSINIT_MODES {System_Test} \
   CONFIG.C_ATG_SYSTEM_CMD_MAX_RETRY {2147483647} \
   CONFIG.C_ATG_SYSTEM_INIT_ADDR_MIF {../../../../../../../axi_traffic_generator_addr.coe} \
   CONFIG.C_ATG_SYSTEM_INIT_CTRL_MIF {../../../../../../../axi_traffic_generator_ctrl.coe} \
   CONFIG.C_ATG_SYSTEM_INIT_DATA_MIF {../../../../../../../axi_traffic_generator_data.coe} \
   CONFIG.C_ATG_SYSTEM_INIT_MASK_MIF {../../../../../../../axi_traffic_generator_mask.coe} \
 ] $axi_traffic_gen_0

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CLKOUT1_JITTER {181.828} \
   CONFIG.CLKOUT1_PHASE_ERROR {104.359} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {25.000} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {9.125} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {36.500} \
   CONFIG.USE_RESET {false} \
 ] $clk_wiz_0

  # Create instance: ila_0, and set properties
  set ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_0 ]
  set_property -dict [ list \
   CONFIG.C_NUM_OF_PROBES {19} \
   CONFIG.C_SLOT_0_AXI_PROTOCOL {AXI4LITE} \
 ] $ila_0

  # Create instance: ila_1, and set properties
  set ila_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_1 ]
  set_property -dict [ list \
   CONFIG.C_ENABLE_ILA_AXI_MON {false} \
   CONFIG.C_MONITOR_TYPE {Native} \
   CONFIG.C_NUM_OF_PROBES {3} \
   CONFIG.C_PROBE2_WIDTH {32} \
 ] $ila_1

  # Create instance: vio_0, and set properties
  set vio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:vio:3.0 vio_0 ]
  set_property -dict [ list \
   CONFIG.C_EN_PROBE_IN_ACTIVITY {0} \
   CONFIG.C_NUM_PROBE_IN {0} \
 ] $vio_0

  # Create interface connections
  connect_bd_intf_net -intf_net axi_ethernetlite_0_MDIO [get_bd_intf_ports MDIO_0] [get_bd_intf_pins axi_ethernetlite_0/MDIO]
  connect_bd_intf_net -intf_net axi_ethernetlite_0_MII [get_bd_intf_ports MII_0] [get_bd_intf_pins axi_ethernetlite_0/MII]
  connect_bd_intf_net -intf_net axi_traffic_gen_0_M_AXI_LITE_CH1 [get_bd_intf_pins axi_ethernetlite_0/S_AXI] [get_bd_intf_pins axi_traffic_gen_0/M_AXI_LITE_CH1]
connect_bd_intf_net -intf_net [get_bd_intf_nets axi_traffic_gen_0_M_AXI_LITE_CH1] [get_bd_intf_pins axi_traffic_gen_0/M_AXI_LITE_CH1] [get_bd_intf_pins ila_0/SLOT_0_AXI]

  # Create port connections
  connect_bd_net -net axi_ethernetlite_0_ip2intc_irpt [get_bd_pins axi_ethernetlite_0/ip2intc_irpt] [get_bd_pins ila_1/probe0]
  connect_bd_net -net axi_traffic_gen_0_done [get_bd_pins axi_traffic_gen_0/done] [get_bd_pins ila_1/probe1]
  connect_bd_net -net axi_traffic_gen_0_status [get_bd_pins axi_traffic_gen_0/status] [get_bd_pins ila_1/probe2]
  connect_bd_net -net clk_in1_0_1 [get_bd_ports axi_aclk] [get_bd_pins axi_ethernetlite_0/s_axi_aclk] [get_bd_pins axi_traffic_gen_0/s_axi_aclk] [get_bd_pins clk_wiz_0/clk_in1] [get_bd_pins ila_0/clk] [get_bd_pins ila_1/clk] [get_bd_pins vio_0/clk]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_ports clk_25] [get_bd_pins clk_wiz_0/clk_out1]
  connect_bd_net -net clk_wiz_0_locked [get_bd_ports mmcm_locked] [get_bd_pins clk_wiz_0/locked]
  connect_bd_net -net s_axi_aresetn_0_1 [get_bd_ports axi_aresetn] [get_bd_pins axi_ethernetlite_0/s_axi_aresetn]
  connect_bd_net -net vio_0_probe_out0 [get_bd_pins axi_traffic_gen_0/s_axi_aresetn] [get_bd_pins vio_0/probe_out0]

  # Create address segments
  assign_bd_address -offset 0x00000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_traffic_gen_0/Reg1] [get_bd_addr_segs axi_ethernetlite_0/S_AXI/Reg] -force

make_wrapper -files [get_files ./block_design/block_design.srcs/sources_1/bd/block_design/block_design.bd] -top
add_files -norecurse ./block_design/block_design.gen/sources_1/bd/block_design/hdl/block_design_wrapper.v

