# Vivado Launch Script

#### Change design settings here #######
set design xt_conn_trd 
set rtl_top xt_connectivity_trd
set sim_top board
set device xc7vx690t-2-ffg1761
set bit_settings v7_xt_conn_bit_rev1_0.xdc
# Valid choices for TRD_MODE are LOOPBACK, BASE, FULL, NODDR3
set TRD_MODE "FULL"
########################################
# Setting proper parameters for chosen TRD mode
if {$TRD_MODE == "LOOPBACK"} {
  set BASE_ONLY 0
  set LOOPBACK_ONLY 1
  set NO_DDR3 1
} elseif {$TRD_MODE == "BASE"} {
  set BASE_ONLY 1
  set LOOPBACK_ONLY 0
  set NO_DDR3 0
} elseif {$TRD_MODE == "NODDR3"} {
  set BASE_ONLY 0
  set LOOPBACK_ONLY 0
  set NO_DDR3 1
} else {
  set BASE_ONLY 0
  set LOOPBACK_ONLY 0
  set NO_DDR3 0
}
########################################

# Project Settings
create_project -name ${design} -force -dir "./runs" -part ${device}
set_property source_mgmt_mode DisplayOnly [current_project]

set_property top ${rtl_top} [current_fileset]


  if {$LOOPBACK_ONLY} {
    puts "Using DMA Loopback design with no DDR3 or Ethernet"
    set_property verilog_define { {DMA_LOOPBACK=1} {USE_PVTMON=1} } [current_fileset]
  } elseif {$BASE_ONLY} {
    puts "Using PCIe, DMA, DDR3, and Virtual FIFO, but no Ethernet"
    set_property verilog_define { {USE_DDR3_FIFO=1} {BASE_ONLY=1} {USE_PVTMON=1} } [current_fileset]
  } elseif {$NO_DDR3} {
    puts "Using PCIe, DMA, Ethernet, but no DDR3"
    set_property verilog_define { {USE_XPHY=1} {USE_PVTMON=1} } [current_fileset]
  } else {
    puts "Using full Targeted Reference Design, with DDR3 and Ethernet"
    set_property verilog_define { {USE_DDR3_FIFO=1} {USE_XPHY=1} {USE_PVTMON=1} } [current_fileset]
  }

# Project Constraints
  if {$LOOPBACK_ONLY} {
    add_files -fileset constrs_1 -norecurse ../sources/constraints/v7_xt_conn_trd_loopback.xdc
    add_files -fileset constrs_1 -norecurse ../sources/constraints/${bit_settings}
  } elseif {$BASE_ONLY} {
    add_files -fileset constrs_1 -norecurse ../sources/constraints/v7_xt_conn_trd_base.xdc
    add_files -fileset constrs_1 -norecurse ../sources/constraints/${bit_settings}
  } elseif {$NO_DDR3} {
    add_files -fileset constrs_1 -norecurse ../sources/constraints/v7_xt_xgemac_xphy.xdc
    add_files -fileset constrs_1 -norecurse ../sources/constraints/v7_xt_conn_trd_noddr3.xdc
    add_files -fileset constrs_1 -norecurse ../sources/constraints/${bit_settings}
  } else {
    # FULL case
    add_files -fileset constrs_1 -norecurse ../sources/constraints/v7_xt_xgemac_xphy.xdc
    add_files -fileset constrs_1 -norecurse ../sources/constraints/v7_xt_conn_trd.xdc
    add_files -fileset constrs_1 -norecurse ../sources/constraints/${bit_settings}
  }


  # Project Design Files from IP Catalog (comment out IPs using legacy Coregen cores)
  read_ip -files {../sources/ip_catalog/pcie3_x8_ip/pcie3_x8_ip.xci}  
  
  if {!$LOOPBACK_ONLY} {
    read_ip -files {../sources/ip_catalog/axi4lite_crossbar/axi4lite_crossbar.xci}
  }
  
  if {!$LOOPBACK_ONLY && !$BASE_ONLY} {
    read_ip -files {../sources/ip_catalog/axis_async_fifo/axis_async_fifo.xci} 
    read_ip -files {../sources/ip_catalog/cmd_fifo_xgemac_rxif/cmd_fifo_xgemac_rxif.xci} 
  }
  
  if {!$LOOPBACK_ONLY && !$NO_DDR3} {
    read_ip -files {../sources/ip_catalog/axis_ic_4x1_wr/axis_ic_4x1_wr.xci}   
    read_ip -files {../sources/ip_catalog/axis_ic_1x4_rd/axis_ic_1x4_rd.xci}   
    read_ip -files {../sources/ip_catalog/axi_vfifo_ctrl_ip/axi_vfifo_ctrl_ip.xci}   
    read_ip -files {../sources/ip_catalog/mig_axi_mm_dual/mig_axi_mm_dual.xci}  
  }
  
  if {!$LOOPBACK_ONLY && $NO_DDR3} {
    read_ip -files {../sources/ip_catalog/axis_ic_wr/axis_ic_wr.xci} 
    read_ip -files {../sources/ip_catalog/axis_ic_rd/axis_ic_rd.xci} 
  }
  
  if {!$LOOPBACK_ONLY && !$BASE_ONLY} {
    read_ip -files {../sources/ip_catalog/ten_gig_eth_mac_axi_st_ip/ten_gig_eth_mac_axi_st_ip.xci} 
    read_ip -files {../sources/ip_catalog/ten_gig_eth_pcs_pma_ip/ten_gig_eth_pcs_pma_ip.xci} 
    read_ip -files {../sources/ip_catalog/ten_gig_eth_pcs_pma_ip_shared_logic_in_core/ten_gig_eth_pcs_pma_ip_shared_logic_in_core.xci} 
  }
  
  
  #- NWL Packet DMA source
  read_verilog "../sources/ip_cores/dma/netlist/eval/dma_back_end_axi.vp"
  
  if {!$LOOPBACK_ONLY} {
    read_verilog "../sources/hdl/common/axilite_system.v"
  }
  
  #- AXI4LITE IPIF
  read_verilog "../sources/ip_cores/axi_lite_ipif/address_decoder.v"
  read_verilog "../sources/ip_cores/axi_lite_ipif/axi_lite_ipif.v"
  read_verilog "../sources/ip_cores/axi_lite_ipif/pselect_f.v"
  read_verilog "../sources/ip_cores/axi_lite_ipif/counter_f.v"
  read_verilog "../sources/ip_cores/axi_lite_ipif/slave_attachment.v"
  
  # Other Custom logic source files
  read_verilog "../sources/hdl/common/synchronizer_simple.v"
  read_verilog "../sources/hdl/common/synchronizer_vector.v"
  read_verilog "../sources/hdl/common/registers.v"
  read_verilog "../sources/hdl/common/user_registers_slave.v"
  read_verilog "../sources/hdl/common/pcie_monitor_gen3.v"
  read_verilog "../sources/hdl/packet_dma_axi.v"
  
  if {!$LOOPBACK_ONLY && !$NO_DDR3} {
    read_verilog "../sources/hdl/axis_vfifo_ctrl_ip.v"
  }
  
  if {!$LOOPBACK_ONLY && $NO_DDR3} {
    read_verilog "../sources/hdl/axis_ic_bram.v"
  }
  
  if {!$LOOPBACK_ONLY && !$BASE_ONLY} {
    read_verilog "../sources/hdl/network_path/rx_interface.v"
    read_verilog "../sources/hdl/network_path/network_path_shared.v"
    read_verilog "../sources/hdl/network_path/network_path.v"
  }
  
  
  read_vhdl "../sources/hdl/pvtmon/kcpsm6.vhd"
  read_vhdl "../sources/hdl/pvtmon/power_test_control.vhd"
  read_vhdl "../sources/hdl/pvtmon/vc709_power_test.vhd"
  read_vhdl "../sources/hdl/pvtmon/power_test_control_program.vhd"
  
  if {!$LOOPBACK_ONLY || !$BASE_ONLY} {
    read_vhdl "../sources/hdl/clock_control/clock_control.vhd"
    read_vhdl "../sources/hdl/clock_control/clock_control_program.vhd"
  }
  
  if {!$LOOPBACK_ONLY} {
    read_verilog "../sources/hdl/gen_chk/crc32_D32_wrapper.v"
    read_verilog "../sources/hdl/gen_chk/hdr_crc_checker.v"
    read_verilog "../sources/hdl/gen_chk/hdr_crc_insert.v"
    read_verilog "../sources/hdl/gen_chk/axi_stream_gen.v"
    read_verilog "../sources/hdl/gen_chk/axi_stream_crc_gen_check.v"
  }
  
  read_verilog "../sources/hdl/pipe_clock.v"
  read_verilog "../sources/hdl/xt_connectivity_trd.v"
    
  generate_target {synthesis simulation} [get_ips]


#Setting Synthesis options
set_property strategy Flow_PerfOptimized_High [get_runs synth_1]
#Setting Implementation options
set_property steps.phys_opt_design.is_enabled true [get_runs impl_1]

# Pick best strategy for different runs
  if {$TRD_MODE == "LOOPBACK"} {
	set_property strategy Performance_RefinePlacement [get_runs impl_1]
  } elseif {$TRD_MODE == "BASE"} {
	set_property strategy Performance_NetDelay_medium [get_runs impl_1]
  } elseif {$TRD_MODE == "NODDR3"} {
	set_property strategy Performance_ExplorePostRoutePhysOpt [get_runs impl_1]
  } else {
	set_property strategy Performance_Explore [get_runs impl_1]
  } 


# Set OOC for DMA for best timing results
  create_fileset -blockset -define_from dma_back_end_axi dma_back_end_axi

  # Constrain DMA during OOC synthesis
  create_fileset -constrset dma_constraints
  add_files -fileset dma_constraints -norecurse ../sources/constraints/dma_back_end_axi_ooc.xdc
  add_files -fileset dma_back_end_axi [get_files dma_back_end_axi_ooc.xdc]
  set_property USED_IN {out_of_context synthesis implementation} [get_files dma_back_end_axi_ooc.xdc]
  set_property strategy Flow_PerfOptimized_High [get_runs dma_back_end_axi_synth_1]

####################
# Set up Simulations
set_property top ${sim_top} [get_filesets sim_1]
set_property include_dirs { ../sources/testbench ../sources/testbench/dsport ../sources/testbench/include ../sources/hdl/gen_chk ./} [get_filesets sim_1]

  if {$LOOPBACK_ONLY} {
    set_property verilog_define { {USE_PIPE_SIM=1} {SIMULATION=1} {DMA_LOOPBACK=1} } [get_filesets sim_1]
  } elseif {$BASE_ONLY} {
    set_property verilog_define { {USE_PIPE_SIM=1} {SIMULATION=1} {USE_DDR3_FIFO=1} {BASE_ONLY=1} {x4Gb=1} {sg107E=1} {x8=1}} [get_filesets sim_1]
  } elseif {$NO_DDR3} {
    set_property verilog_define { {USE_PIPE_SIM=1} {SIMULATION=1} {USE_XPHY=1} {NW_PATH_ENABLE=1} } [get_filesets sim_1]
  } else {
    set_property verilog_define { {USE_PIPE_SIM=1} {SIMULATION=1} {USE_DDR3_FIFO=1} {USE_XPHY=1} {NW_PATH_ENABLE=1} {x4Gb=1} {sg107E=1} {x8=1}} [get_filesets sim_1]
  }

# Vivado Simulator settings
set_property -name xsim.simulate.xsim.more_options -value {-testplusarg TESTNAME=basic_test} -objects [get_filesets sim_1]
set_property xsim.simulate.runtime {200us} [get_filesets sim_1]
if {$LOOPBACK_ONLY || $NO_DDR3} {
    set_property XSIM.TCLBATCH "../../../../scripts/xsim_wave_loopback.tcl" [get_filesets sim_1]
# FULL or BASE
} else {
    set_property XSIM.TCLBATCH "../../../../scripts/xsim_wave.tcl" [get_filesets sim_1]
}

# Default to MTI
set_property target_simulator ModelSim [current_project]

# MTI settings
set_property modelsim.simulate.runtime {200us} [get_filesets sim_1]
set_property -name modelsim.compile.vlog.more_options -value +acc -objects [get_filesets sim_1]
set_property -name modelsim.simulate.vsim.more_options -value {+notimingchecks +TESTNAME=basic_test } -objects [get_filesets sim_1]
set_property compxlib.compiled_library_dir {} [current_project]

if {$LOOPBACK_ONLY || $NO_DDR3} {
     set_property modelsim.simulate.custom_udo "../../../../scripts/wave_loopback.do" [get_filesets sim_1]
# FULL or BASE
} else {
     set_property modelsim.simulate.custom_udo "../../../../scripts/wave.do" [get_filesets sim_1]
}

# PCIe TB files (simulation only)
add_files -fileset sim_1 "../sources/testbench/pipe_clock.v"
add_files -fileset sim_1 "../sources/testbench/dsport/pci_exp_usrapp_com.v"
add_files -fileset sim_1 "../sources/testbench/dsport/pci_exp_usrapp_tx.v"
add_files -fileset sim_1 "../sources/testbench/dsport/pci_exp_usrapp_cfg.v"
add_files -fileset sim_1 "../sources/testbench/dsport/pci_exp_usrapp_rx.v"
add_files -fileset sim_1 "../sources/testbench/dsport/xilinx_pcie_3_0_7vx_rp.v"
add_files -fileset sim_1 "../sources/testbench/board.v"

add_files -fileset sim_1 "../sources/testbench/pcie3_x8_ip_gt_top_pipe.v"

if {$LOOPBACK_ONLY || $NO_DDR3} {
    set_property include_dirs { ../sources/testbench ../sources/testbench/dsport ../sources/testbench/include ../sources/hdl/gen_chk} [get_filesets sim_1]

} else {
    set_property include_dirs { ../sources/testbench ../sources/testbench/dsport ../sources/testbench/include ../sources/hdl/gen_chk ../sources/ip_catalog/mig_axi_mm_dual/mig_axi_mm_dual/example_design/sim} [get_filesets sim_1]
  
}


if {!$LOOPBACK_ONLY && !$NO_DDR3} {
    add_files -fileset sim_1 -norecurse ../sources/ip_catalog/mig_axi_mm_dual/mig_axi_mm_dual/example_design/sim/c0_ddr3_model.v
    add_files -fileset sim_1 -norecurse ../sources/ip_catalog/mig_axi_mm_dual/mig_axi_mm_dual/example_design/sim/c1_ddr3_model.v
}



