
# (C) 2001-2018 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and 
# other software and tools, and its AMPP partner logic functions, and 
# any output files any of the foregoing (including device programming 
# or simulation files), and any associated documentation or information 
# are expressly subject to the terms and conditions of the Altera 
# Program License Subscription Agreement, Altera MegaCore Function 
# License Agreement, or other applicable license agreement, including, 
# without limitation, that your use is for the sole purpose of 
# programming logic devices manufactured by Altera and sold by Altera 
# or its authorized distributors. Please refer to the applicable 
# agreement for further details.

# ACDS 13.1 162 win32 2018.10.21.20:48:53

# ----------------------------------------
# Auto-generated simulation script

# ----------------------------------------
# Initialize variables
if ![info exists SYSTEM_INSTANCE_NAME] { 
  set SYSTEM_INSTANCE_NAME ""
} elseif { ![ string match "" $SYSTEM_INSTANCE_NAME ] } { 
  set SYSTEM_INSTANCE_NAME "/$SYSTEM_INSTANCE_NAME"
}

if ![info exists TOP_LEVEL_NAME] { 
  set TOP_LEVEL_NAME "controller"
}

if ![info exists QSYS_SIMDIR] { 
  set QSYS_SIMDIR "./../"
}

if ![info exists QUARTUS_INSTALL_DIR] { 
  set QUARTUS_INSTALL_DIR "C:/altera/13.1/quartus/"
}

# ----------------------------------------
# Initialize simulation properties - DO NOT MODIFY!
set ELAB_OPTIONS ""
set SIM_OPTIONS ""
if ![ string match "*-64 vsim*" [ vsim -version ] ] {
} else {
}

# ----------------------------------------
# Copy ROM/RAM files to simulation directory
alias file_copy {
  echo "\[exec\] file_copy"
  file copy -force $QSYS_SIMDIR/submodules/controller_onchip_ram.hex ./
  file copy -force $QSYS_SIMDIR/submodules/controller_nios2e_ociram_default_contents.dat ./
  file copy -force $QSYS_SIMDIR/submodules/controller_nios2e_ociram_default_contents.hex ./
  file copy -force $QSYS_SIMDIR/submodules/controller_nios2e_ociram_default_contents.mif ./
  file copy -force $QSYS_SIMDIR/submodules/controller_nios2e_rf_ram_a.dat ./
  file copy -force $QSYS_SIMDIR/submodules/controller_nios2e_rf_ram_a.hex ./
  file copy -force $QSYS_SIMDIR/submodules/controller_nios2e_rf_ram_a.mif ./
  file copy -force $QSYS_SIMDIR/submodules/controller_nios2e_rf_ram_b.dat ./
  file copy -force $QSYS_SIMDIR/submodules/controller_nios2e_rf_ram_b.hex ./
  file copy -force $QSYS_SIMDIR/submodules/controller_nios2e_rf_ram_b.mif ./
}

# ----------------------------------------
# Create compilation libraries
proc ensure_lib { lib } { if ![file isdirectory $lib] { vlib $lib } }
ensure_lib          ./libraries/     
ensure_lib          ./libraries/work/
vmap       work     ./libraries/work/
vmap       work_lib ./libraries/work/
if ![ string match "*ModelSim ALTERA*" [ vsim -version ] ] {
  ensure_lib                  ./libraries/altera_ver/      
  vmap       altera_ver       ./libraries/altera_ver/      
  ensure_lib                  ./libraries/lpm_ver/         
  vmap       lpm_ver          ./libraries/lpm_ver/         
  ensure_lib                  ./libraries/sgate_ver/       
  vmap       sgate_ver        ./libraries/sgate_ver/       
  ensure_lib                  ./libraries/altera_mf_ver/   
  vmap       altera_mf_ver    ./libraries/altera_mf_ver/   
  ensure_lib                  ./libraries/altera_lnsim_ver/
  vmap       altera_lnsim_ver ./libraries/altera_lnsim_ver/
  ensure_lib                  ./libraries/cycloneiii_ver/  
  vmap       cycloneiii_ver   ./libraries/cycloneiii_ver/  
}
ensure_lib                                                                             ./libraries/rsp_xbar_mux_001/                                                           
vmap       rsp_xbar_mux_001                                                            ./libraries/rsp_xbar_mux_001/                                                           
ensure_lib                                                                             ./libraries/rsp_xbar_mux/                                                               
vmap       rsp_xbar_mux                                                                ./libraries/rsp_xbar_mux/                                                               
ensure_lib                                                                             ./libraries/rsp_xbar_demux_004/                                                         
vmap       rsp_xbar_demux_004                                                          ./libraries/rsp_xbar_demux_004/                                                         
ensure_lib                                                                             ./libraries/rsp_xbar_demux/                                                             
vmap       rsp_xbar_demux                                                              ./libraries/rsp_xbar_demux/                                                             
ensure_lib                                                                             ./libraries/cmd_xbar_mux_004/                                                           
vmap       cmd_xbar_mux_004                                                            ./libraries/cmd_xbar_mux_004/                                                           
ensure_lib                                                                             ./libraries/cmd_xbar_mux/                                                               
vmap       cmd_xbar_mux                                                                ./libraries/cmd_xbar_mux/                                                               
ensure_lib                                                                             ./libraries/cmd_xbar_demux_001/                                                         
vmap       cmd_xbar_demux_001                                                          ./libraries/cmd_xbar_demux_001/                                                         
ensure_lib                                                                             ./libraries/cmd_xbar_demux/                                                             
vmap       cmd_xbar_demux                                                              ./libraries/cmd_xbar_demux/                                                             
ensure_lib                                                                             ./libraries/id_router_004/                                                              
vmap       id_router_004                                                               ./libraries/id_router_004/                                                              
ensure_lib                                                                             ./libraries/id_router/                                                                  
vmap       id_router                                                                   ./libraries/id_router/                                                                  
ensure_lib                                                                             ./libraries/addr_router_001/                                                            
vmap       addr_router_001                                                             ./libraries/addr_router_001/                                                            
ensure_lib                                                                             ./libraries/addr_router/                                                                
vmap       addr_router                                                                 ./libraries/addr_router/                                                                
ensure_lib                                                                             ./libraries/nios2e_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo/
vmap       nios2e_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo ./libraries/nios2e_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo/
ensure_lib                                                                             ./libraries/nios2e_jtag_debug_module_translator_avalon_universal_slave_0_agent/         
vmap       nios2e_jtag_debug_module_translator_avalon_universal_slave_0_agent          ./libraries/nios2e_jtag_debug_module_translator_avalon_universal_slave_0_agent/         
ensure_lib                                                                             ./libraries/nios2e_instruction_master_translator_avalon_universal_master_0_agent/       
vmap       nios2e_instruction_master_translator_avalon_universal_master_0_agent        ./libraries/nios2e_instruction_master_translator_avalon_universal_master_0_agent/       
ensure_lib                                                                             ./libraries/nios2e_jtag_debug_module_translator/                                        
vmap       nios2e_jtag_debug_module_translator                                         ./libraries/nios2e_jtag_debug_module_translator/                                        
ensure_lib                                                                             ./libraries/nios2e_instruction_master_translator/                                       
vmap       nios2e_instruction_master_translator                                        ./libraries/nios2e_instruction_master_translator/                                       
ensure_lib                                                                             ./libraries/rst_controller/                                                             
vmap       rst_controller                                                              ./libraries/rst_controller/                                                             
ensure_lib                                                                             ./libraries/irq_mapper/                                                                 
vmap       irq_mapper                                                                  ./libraries/irq_mapper/                                                                 
ensure_lib                                                                             ./libraries/mm_interconnect_0/                                                          
vmap       mm_interconnect_0                                                           ./libraries/mm_interconnect_0/                                                          
ensure_lib                                                                             ./libraries/led_period/                                                                 
vmap       led_period                                                                  ./libraries/led_period/                                                                 
ensure_lib                                                                             ./libraries/rc1_control/                                                                
vmap       rc1_control                                                                 ./libraries/rc1_control/                                                                
ensure_lib                                                                             ./libraries/uart1_dvsr/                                                                 
vmap       uart1_dvsr                                                                  ./libraries/uart1_dvsr/                                                                 
ensure_lib                                                                             ./libraries/leds1_wr_val/                                                               
vmap       leds1_wr_val                                                                ./libraries/leds1_wr_val/                                                               
ensure_lib                                                                             ./libraries/sseg_counter_of/                                                            
vmap       sseg_counter_of                                                             ./libraries/sseg_counter_of/                                                            
ensure_lib                                                                             ./libraries/sseg_wr_val/                                                                
vmap       sseg_wr_val                                                                 ./libraries/sseg_wr_val/                                                                
ensure_lib                                                                             ./libraries/sseg_reset_control/                                                         
vmap       sseg_reset_control                                                          ./libraries/sseg_reset_control/                                                         
ensure_lib                                                                             ./libraries/warn_pwm_control/                                                           
vmap       warn_pwm_control                                                            ./libraries/warn_pwm_control/                                                           
ensure_lib                                                                             ./libraries/status_led_en/                                                              
vmap       status_led_en                                                               ./libraries/status_led_en/                                                              
ensure_lib                                                                             ./libraries/bcd1_status/                                                                
vmap       bcd1_status                                                                 ./libraries/bcd1_status/                                                                
ensure_lib                                                                             ./libraries/bcd1_bcd/                                                                   
vmap       bcd1_bcd                                                                    ./libraries/bcd1_bcd/                                                                   
ensure_lib                                                                             ./libraries/bcd1_control/                                                               
vmap       bcd1_control                                                                ./libraries/bcd1_control/                                                               
ensure_lib                                                                             ./libraries/bcd1_bin/                                                                   
vmap       bcd1_bin                                                                    ./libraries/bcd1_bin/                                                                   
ensure_lib                                                                             ./libraries/uart1_rx_counter/                                                           
vmap       uart1_rx_counter                                                            ./libraries/uart1_rx_counter/                                                           
ensure_lib                                                                             ./libraries/uart1_r_data/                                                               
vmap       uart1_r_data                                                                ./libraries/uart1_r_data/                                                               
ensure_lib                                                                             ./libraries/uart1_baud_control/                                                         
vmap       uart1_baud_control                                                          ./libraries/uart1_baud_control/                                                         
ensure_lib                                                                             ./libraries/uart1_wr_control/                                                           
vmap       uart1_wr_control                                                            ./libraries/uart1_wr_control/                                                           
ensure_lib                                                                             ./libraries/uart1_reset_control/                                                        
vmap       uart1_reset_control                                                         ./libraries/uart1_reset_control/                                                        
ensure_lib                                                                             ./libraries/uart1_w_data/                                                               
vmap       uart1_w_data                                                                ./libraries/uart1_w_data/                                                               
ensure_lib                                                                             ./libraries/tc1_status/                                                                 
vmap       tc1_status                                                                  ./libraries/tc1_status/                                                                 
ensure_lib                                                                             ./libraries/tc_reset_control/                                                           
vmap       tc_reset_control                                                            ./libraries/tc_reset_control/                                                           
ensure_lib                                                                             ./libraries/tc1_m/                                                                      
vmap       tc1_m                                                                       ./libraries/tc1_m/                                                                      
ensure_lib                                                                             ./libraries/daylight/                                                                   
vmap       daylight                                                                    ./libraries/daylight/                                                                   
ensure_lib                                                                             ./libraries/onchip_ram/                                                                 
vmap       onchip_ram                                                                  ./libraries/onchip_ram/                                                                 
ensure_lib                                                                             ./libraries/nios2e/                                                                     
vmap       nios2e                                                                      ./libraries/nios2e/                                                                     
ensure_lib                                                                             ./libraries/jtag_uart_0/                                                                
vmap       jtag_uart_0                                                                 ./libraries/jtag_uart_0/                                                                
ensure_lib                                                                             ./libraries/sysid_c001/                                                                 
vmap       sysid_c001                                                                  ./libraries/sysid_c001/                                                                 

# ----------------------------------------
# Compile device library files
alias dev_com {
  echo "\[exec\] dev_com"
  if ![ string match "*ModelSim ALTERA*" [ vsim -version ] ] {
    vlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives.v" -work altera_ver      
    vlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/220model.v"          -work lpm_ver         
    vlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate.v"             -work sgate_ver       
    vlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf.v"         -work altera_mf_ver   
    vlog -sv "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_lnsim.sv"     -work altera_lnsim_ver
    vlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/cycloneiii_atoms.v"  -work cycloneiii_ver  
  }
}

# ----------------------------------------
# Compile the design files in correct order
alias com {
  echo "\[exec\] com"
  vlog -sv "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                        -work rsp_xbar_mux_001                                                           
  vlog -sv "$QSYS_SIMDIR/submodules/controller_mm_interconnect_0_rsp_xbar_mux_001.sv"   -work rsp_xbar_mux_001                                                           
  vlog -sv "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                        -work rsp_xbar_mux                                                               
  vlog -sv "$QSYS_SIMDIR/submodules/controller_mm_interconnect_0_rsp_xbar_mux.sv"       -work rsp_xbar_mux                                                               
  vlog -sv "$QSYS_SIMDIR/submodules/controller_mm_interconnect_0_rsp_xbar_demux_004.sv" -work rsp_xbar_demux_004                                                         
  vlog -sv "$QSYS_SIMDIR/submodules/controller_mm_interconnect_0_rsp_xbar_demux.sv"     -work rsp_xbar_demux                                                             
  vlog -sv "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                        -work cmd_xbar_mux_004                                                           
  vlog -sv "$QSYS_SIMDIR/submodules/controller_mm_interconnect_0_cmd_xbar_mux_004.sv"   -work cmd_xbar_mux_004                                                           
  vlog -sv "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                        -work cmd_xbar_mux                                                               
  vlog -sv "$QSYS_SIMDIR/submodules/controller_mm_interconnect_0_cmd_xbar_mux.sv"       -work cmd_xbar_mux                                                               
  vlog -sv "$QSYS_SIMDIR/submodules/controller_mm_interconnect_0_cmd_xbar_demux_001.sv" -work cmd_xbar_demux_001                                                         
  vlog -sv "$QSYS_SIMDIR/submodules/controller_mm_interconnect_0_cmd_xbar_demux.sv"     -work cmd_xbar_demux                                                             
  vlog -sv "$QSYS_SIMDIR/submodules/controller_mm_interconnect_0_id_router_004.sv"      -work id_router_004                                                              
  vlog -sv "$QSYS_SIMDIR/submodules/controller_mm_interconnect_0_id_router.sv"          -work id_router                                                                  
  vlog -sv "$QSYS_SIMDIR/submodules/controller_mm_interconnect_0_addr_router_001.sv"    -work addr_router_001                                                            
  vlog -sv "$QSYS_SIMDIR/submodules/controller_mm_interconnect_0_addr_router.sv"        -work addr_router                                                                
  vlog     "$QSYS_SIMDIR/submodules/altera_avalon_sc_fifo.v"                            -work nios2e_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo
  vlog -sv "$QSYS_SIMDIR/submodules/altera_merlin_slave_agent.sv"                       -work nios2e_jtag_debug_module_translator_avalon_universal_slave_0_agent         
  vlog -sv "$QSYS_SIMDIR/submodules/altera_merlin_burst_uncompressor.sv"                -work nios2e_jtag_debug_module_translator_avalon_universal_slave_0_agent         
  vlog -sv "$QSYS_SIMDIR/submodules/altera_merlin_master_agent.sv"                      -work nios2e_instruction_master_translator_avalon_universal_master_0_agent       
  vlog -sv "$QSYS_SIMDIR/submodules/altera_merlin_slave_translator.sv"                  -work nios2e_jtag_debug_module_translator                                        
  vlog -sv "$QSYS_SIMDIR/submodules/altera_merlin_master_translator.sv"                 -work nios2e_instruction_master_translator                                       
  vlog     "$QSYS_SIMDIR/submodules/altera_reset_controller.v"                          -work rst_controller                                                             
  vlog     "$QSYS_SIMDIR/submodules/altera_reset_synchronizer.v"                        -work rst_controller                                                             
  vlog -sv "$QSYS_SIMDIR/submodules/controller_irq_mapper.sv"                           -work irq_mapper                                                                 
  vlog     "$QSYS_SIMDIR/submodules/controller_mm_interconnect_0.v"                     -work mm_interconnect_0                                                          
  vlog     "$QSYS_SIMDIR/submodules/controller_led_period.v"                            -work led_period                                                                 
  vlog     "$QSYS_SIMDIR/submodules/controller_rc1_control.v"                           -work rc1_control                                                                
  vlog     "$QSYS_SIMDIR/submodules/controller_uart1_dvsr.v"                            -work uart1_dvsr                                                                 
  vlog     "$QSYS_SIMDIR/submodules/controller_leds1_wr_val.v"                          -work leds1_wr_val                                                               
  vlog     "$QSYS_SIMDIR/submodules/controller_sseg_counter_of.v"                       -work sseg_counter_of                                                            
  vlog     "$QSYS_SIMDIR/submodules/controller_sseg_wr_val.v"                           -work sseg_wr_val                                                                
  vlog     "$QSYS_SIMDIR/submodules/controller_sseg_reset_control.v"                    -work sseg_reset_control                                                         
  vlog     "$QSYS_SIMDIR/submodules/controller_warn_pwm_control.v"                      -work warn_pwm_control                                                           
  vlog     "$QSYS_SIMDIR/submodules/controller_status_led_en.v"                         -work status_led_en                                                              
  vlog     "$QSYS_SIMDIR/submodules/controller_bcd1_status.v"                           -work bcd1_status                                                                
  vlog     "$QSYS_SIMDIR/submodules/controller_bcd1_bcd.v"                              -work bcd1_bcd                                                                   
  vlog     "$QSYS_SIMDIR/submodules/controller_bcd1_control.v"                          -work bcd1_control                                                               
  vlog     "$QSYS_SIMDIR/submodules/controller_bcd1_bin.v"                              -work bcd1_bin                                                                   
  vlog     "$QSYS_SIMDIR/submodules/controller_uart1_rx_counter.v"                      -work uart1_rx_counter                                                           
  vlog     "$QSYS_SIMDIR/submodules/controller_uart1_r_data.v"                          -work uart1_r_data                                                               
  vlog     "$QSYS_SIMDIR/submodules/controller_uart1_baud_control.v"                    -work uart1_baud_control                                                         
  vlog     "$QSYS_SIMDIR/submodules/controller_uart1_wr_control.v"                      -work uart1_wr_control                                                           
  vlog     "$QSYS_SIMDIR/submodules/controller_uart1_reset_control.v"                   -work uart1_reset_control                                                        
  vlog     "$QSYS_SIMDIR/submodules/controller_uart1_w_data.v"                          -work uart1_w_data                                                               
  vlog     "$QSYS_SIMDIR/submodules/controller_tc1_status.v"                            -work tc1_status                                                                 
  vlog     "$QSYS_SIMDIR/submodules/controller_tc_reset_control.v"                      -work tc_reset_control                                                           
  vlog     "$QSYS_SIMDIR/submodules/controller_tc1_m.v"                                 -work tc1_m                                                                      
  vlog     "$QSYS_SIMDIR/submodules/controller_daylight.v"                              -work daylight                                                                   
  vlog     "$QSYS_SIMDIR/submodules/controller_onchip_ram.v"                            -work onchip_ram                                                                 
  vlog     "$QSYS_SIMDIR/submodules/controller_nios2e.v"                                -work nios2e                                                                     
  vlog     "$QSYS_SIMDIR/submodules/controller_nios2e_jtag_debug_module_sysclk.v"       -work nios2e                                                                     
  vlog     "$QSYS_SIMDIR/submodules/controller_nios2e_jtag_debug_module_tck.v"          -work nios2e                                                                     
  vlog     "$QSYS_SIMDIR/submodules/controller_nios2e_jtag_debug_module_wrapper.v"      -work nios2e                                                                     
  vlog     "$QSYS_SIMDIR/submodules/controller_nios2e_oci_test_bench.v"                 -work nios2e                                                                     
  vlog     "$QSYS_SIMDIR/submodules/controller_nios2e_test_bench.v"                     -work nios2e                                                                     
  vlog     "$QSYS_SIMDIR/submodules/controller_jtag_uart_0.v"                           -work jtag_uart_0                                                                
  vlog     "$QSYS_SIMDIR/submodules/controller_sysid_c001.vo"                           -work sysid_c001                                                                 
  vlog     "$QSYS_SIMDIR/controller.v"                                                                                                                                   
}

# ----------------------------------------
# Elaborate top level design
alias elab {
  echo "\[exec\] elab"
  eval vsim -t ps $ELAB_OPTIONS -L work -L work_lib -L rsp_xbar_mux_001 -L rsp_xbar_mux -L rsp_xbar_demux_004 -L rsp_xbar_demux -L cmd_xbar_mux_004 -L cmd_xbar_mux -L cmd_xbar_demux_001 -L cmd_xbar_demux -L id_router_004 -L id_router -L addr_router_001 -L addr_router -L nios2e_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo -L nios2e_jtag_debug_module_translator_avalon_universal_slave_0_agent -L nios2e_instruction_master_translator_avalon_universal_master_0_agent -L nios2e_jtag_debug_module_translator -L nios2e_instruction_master_translator -L rst_controller -L irq_mapper -L mm_interconnect_0 -L led_period -L rc1_control -L uart1_dvsr -L leds1_wr_val -L sseg_counter_of -L sseg_wr_val -L sseg_reset_control -L warn_pwm_control -L status_led_en -L bcd1_status -L bcd1_bcd -L bcd1_control -L bcd1_bin -L uart1_rx_counter -L uart1_r_data -L uart1_baud_control -L uart1_wr_control -L uart1_reset_control -L uart1_w_data -L tc1_status -L tc_reset_control -L tc1_m -L daylight -L onchip_ram -L nios2e -L jtag_uart_0 -L sysid_c001 -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneiii_ver $TOP_LEVEL_NAME
}

# ----------------------------------------
# Elaborate the top level design with novopt option
alias elab_debug {
  echo "\[exec\] elab_debug"
  eval vsim -novopt -t ps $ELAB_OPTIONS -L work -L work_lib -L rsp_xbar_mux_001 -L rsp_xbar_mux -L rsp_xbar_demux_004 -L rsp_xbar_demux -L cmd_xbar_mux_004 -L cmd_xbar_mux -L cmd_xbar_demux_001 -L cmd_xbar_demux -L id_router_004 -L id_router -L addr_router_001 -L addr_router -L nios2e_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo -L nios2e_jtag_debug_module_translator_avalon_universal_slave_0_agent -L nios2e_instruction_master_translator_avalon_universal_master_0_agent -L nios2e_jtag_debug_module_translator -L nios2e_instruction_master_translator -L rst_controller -L irq_mapper -L mm_interconnect_0 -L led_period -L rc1_control -L uart1_dvsr -L leds1_wr_val -L sseg_counter_of -L sseg_wr_val -L sseg_reset_control -L warn_pwm_control -L status_led_en -L bcd1_status -L bcd1_bcd -L bcd1_control -L bcd1_bin -L uart1_rx_counter -L uart1_r_data -L uart1_baud_control -L uart1_wr_control -L uart1_reset_control -L uart1_w_data -L tc1_status -L tc_reset_control -L tc1_m -L daylight -L onchip_ram -L nios2e -L jtag_uart_0 -L sysid_c001 -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneiii_ver $TOP_LEVEL_NAME
}

# ----------------------------------------
# Compile all the design files and elaborate the top level design
alias ld "
  dev_com
  com
  elab
"

# ----------------------------------------
# Compile all the design files and elaborate the top level design with -novopt
alias ld_debug "
  dev_com
  com
  elab_debug
"

# ----------------------------------------
# Print out user commmand line aliases
alias h {
  echo "List Of Command Line Aliases"
  echo
  echo "file_copy                     -- Copy ROM/RAM files to simulation directory"
  echo
  echo "dev_com                       -- Compile device library files"
  echo
  echo "com                           -- Compile the design files in correct order"
  echo
  echo "elab                          -- Elaborate top level design"
  echo
  echo "elab_debug                    -- Elaborate the top level design with novopt option"
  echo
  echo "ld                            -- Compile all the design files and elaborate the top level design"
  echo
  echo "ld_debug                      -- Compile all the design files and elaborate the top level design with -novopt"
  echo
  echo 
  echo
  echo "List Of Variables"
  echo
  echo "TOP_LEVEL_NAME                -- Top level module name."
  echo
  echo "SYSTEM_INSTANCE_NAME          -- Instantiated system module name inside top level module."
  echo
  echo "QSYS_SIMDIR                   -- Qsys base simulation directory."
  echo
  echo "QUARTUS_INSTALL_DIR           -- Quartus installation directory."
}
file_copy
h
