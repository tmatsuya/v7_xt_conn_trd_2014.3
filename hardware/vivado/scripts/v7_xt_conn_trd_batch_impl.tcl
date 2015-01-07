# Vivado Launch Script in batch mode

source scripts/v7_xt_conn_trd.tcl

launch_run -to_step write_bitstream [get_runs impl_1]

wait_on_run impl_1
