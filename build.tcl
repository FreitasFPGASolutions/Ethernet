create_project ethernet ./build -part xc7a100tcsg324-1

add_files -norecurse ./ethernet.sv
add_files -norecurse ./block_design/block_design.gen/sources_1/bd/block_design/hdl/block_design_wrapper.v
add_files -norecurse ./block_design/block_design.srcs/sources_1/bd/block_design/block_design.bd
update_compile_order -fileset sources_1
add_files -fileset constrs_1 -norecurse ./ethernet.xdc

launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1
puts "Implementation done!"

open_run impl_1
report_timing_summary
report_cdc -details -file ./cdc_report.txt

