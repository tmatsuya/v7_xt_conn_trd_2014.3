## Download a bit file to the FPGA on the VC709

open_hw
connect_hw_server -host localhost -port 60001
current_hw_target [get_hw_targets */xilinx_tcf/Digilent/*]
set_property PARAM.FREQUENCY 15000000 [get_hw_targets */xilinx_tcf/Digilent/*]
open_hw_target
current_hw_device [lindex [get_hw_devices] 0]
refresh_hw_device -update_hw_probes false [lindex [get_hw_devices] 0]

## Assumes execution from ready_to_test directory with xt_connectivity_trd.bit file in it
set_property PROGRAM.FILE {xt_connectivity_trd.bit} [lindex [get_hw_devices] 0]
program_hw_devices [lindex [get_hw_devices] 0]
refresh_hw_device [lindex [get_hw_devices] 0]

close_hw
