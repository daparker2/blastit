
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

# ACDS 13.1 162 win32 2018.07.11.00:26:07

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
  set TOP_LEVEL_NAME "controller_tb"
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

set Aldec "Riviera"
if { [ string match "*Active-HDL*" [ vsim -version ] ] } {
  set Aldec "Active"
}

if { [ string match "Active" $Aldec ] } {
  scripterconf -tcl
  createdesign "$TOP_LEVEL_NAME"  "."
  opendesign "$TOP_LEVEL_NAME"
}

# ----------------------------------------
# Copy ROM/RAM files to simulation directory
alias file_copy {
  echo "\[exec\] file_copy"
  file copy -force $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_iram.hex ./
  file copy -force $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_dram.hex ./
  file copy -force $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_nios2_qsys_0_ociram_default_contents.dat ./
  file copy -force $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_nios2_qsys_0_ociram_default_contents.hex ./
  file copy -force $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_nios2_qsys_0_ociram_default_contents.mif ./
  file copy -force $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_nios2_qsys_0_rf_ram_a.dat ./
  file copy -force $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_nios2_qsys_0_rf_ram_a.hex ./
  file copy -force $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_nios2_qsys_0_rf_ram_a.mif ./
  file copy -force $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_nios2_qsys_0_rf_ram_b.dat ./
  file copy -force $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_nios2_qsys_0_rf_ram_b.hex ./
  file copy -force $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_nios2_qsys_0_rf_ram_b.mif ./
}

# ----------------------------------------
# Create compilation libraries
proc ensure_lib { lib } { if ![file isdirectory $lib] { vlib $lib } }
ensure_lib      ./libraries     
ensure_lib      ./libraries/work
vmap       work ./libraries/work
ensure_lib                  ./libraries/altera_ver      
vmap       altera_ver       ./libraries/altera_ver      
ensure_lib                  ./libraries/lpm_ver         
vmap       lpm_ver          ./libraries/lpm_ver         
ensure_lib                  ./libraries/sgate_ver       
vmap       sgate_ver        ./libraries/sgate_ver       
ensure_lib                  ./libraries/altera_mf_ver   
vmap       altera_mf_ver    ./libraries/altera_mf_ver   
ensure_lib                  ./libraries/altera_lnsim_ver
vmap       altera_lnsim_ver ./libraries/altera_lnsim_ver
ensure_lib                  ./libraries/cycloneiii_ver  
vmap       cycloneiii_ver   ./libraries/cycloneiii_ver  
ensure_lib                                                                                   ./libraries/altera_common_sv_packages                                                        
vmap       altera_common_sv_packages                                                         ./libraries/altera_common_sv_packages                                                        
ensure_lib                                                                                   ./libraries/rsp_xbar_mux_001                                                                 
vmap       rsp_xbar_mux_001                                                                  ./libraries/rsp_xbar_mux_001                                                                 
ensure_lib                                                                                   ./libraries/rsp_xbar_mux                                                                     
vmap       rsp_xbar_mux                                                                      ./libraries/rsp_xbar_mux                                                                     
ensure_lib                                                                                   ./libraries/rsp_xbar_demux_001                                                               
vmap       rsp_xbar_demux_001                                                                ./libraries/rsp_xbar_demux_001                                                               
ensure_lib                                                                                   ./libraries/rsp_xbar_demux                                                                   
vmap       rsp_xbar_demux                                                                    ./libraries/rsp_xbar_demux                                                                   
ensure_lib                                                                                   ./libraries/cmd_xbar_mux_001                                                                 
vmap       cmd_xbar_mux_001                                                                  ./libraries/cmd_xbar_mux_001                                                                 
ensure_lib                                                                                   ./libraries/cmd_xbar_mux                                                                     
vmap       cmd_xbar_mux                                                                      ./libraries/cmd_xbar_mux                                                                     
ensure_lib                                                                                   ./libraries/cmd_xbar_demux_001                                                               
vmap       cmd_xbar_demux_001                                                                ./libraries/cmd_xbar_demux_001                                                               
ensure_lib                                                                                   ./libraries/cmd_xbar_demux                                                                   
vmap       cmd_xbar_demux                                                                    ./libraries/cmd_xbar_demux                                                                   
ensure_lib                                                                                   ./libraries/id_router_003                                                                    
vmap       id_router_003                                                                     ./libraries/id_router_003                                                                    
ensure_lib                                                                                   ./libraries/id_router_001                                                                    
vmap       id_router_001                                                                     ./libraries/id_router_001                                                                    
ensure_lib                                                                                   ./libraries/id_router                                                                        
vmap       id_router                                                                         ./libraries/id_router                                                                        
ensure_lib                                                                                   ./libraries/addr_router_001                                                                  
vmap       addr_router_001                                                                   ./libraries/addr_router_001                                                                  
ensure_lib                                                                                   ./libraries/addr_router                                                                      
vmap       addr_router                                                                       ./libraries/addr_router                                                                      
ensure_lib                                                                                   ./libraries/nios2_qsys_0_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo
vmap       nios2_qsys_0_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo ./libraries/nios2_qsys_0_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo
ensure_lib                                                                                   ./libraries/nios2_qsys_0_jtag_debug_module_translator_avalon_universal_slave_0_agent         
vmap       nios2_qsys_0_jtag_debug_module_translator_avalon_universal_slave_0_agent          ./libraries/nios2_qsys_0_jtag_debug_module_translator_avalon_universal_slave_0_agent         
ensure_lib                                                                                   ./libraries/nios2_qsys_0_instruction_master_translator_avalon_universal_master_0_agent       
vmap       nios2_qsys_0_instruction_master_translator_avalon_universal_master_0_agent        ./libraries/nios2_qsys_0_instruction_master_translator_avalon_universal_master_0_agent       
ensure_lib                                                                                   ./libraries/nios2_qsys_0_jtag_debug_module_translator                                        
vmap       nios2_qsys_0_jtag_debug_module_translator                                         ./libraries/nios2_qsys_0_jtag_debug_module_translator                                        
ensure_lib                                                                                   ./libraries/nios2_qsys_0_instruction_master_translator                                       
vmap       nios2_qsys_0_instruction_master_translator                                        ./libraries/nios2_qsys_0_instruction_master_translator                                       
ensure_lib                                                                                   ./libraries/rst_controller                                                                   
vmap       rst_controller                                                                    ./libraries/rst_controller                                                                   
ensure_lib                                                                                   ./libraries/irq_mapper                                                                       
vmap       irq_mapper                                                                        ./libraries/irq_mapper                                                                       
ensure_lib                                                                                   ./libraries/mm_interconnect_0                                                                
vmap       mm_interconnect_0                                                                 ./libraries/mm_interconnect_0                                                                
ensure_lib                                                                                   ./libraries/ign_en                                                                           
vmap       ign_en                                                                            ./libraries/ign_en                                                                           
ensure_lib                                                                                   ./libraries/jtag_uart_0                                                                      
vmap       jtag_uart_0                                                                       ./libraries/jtag_uart_0                                                                      
ensure_lib                                                                                   ./libraries/boost                                                                            
vmap       boost                                                                             ./libraries/boost                                                                            
ensure_lib                                                                                   ./libraries/warning_en                                                                       
vmap       warning_en                                                                        ./libraries/warning_en                                                                       
ensure_lib                                                                                   ./libraries/command_en                                                                       
vmap       command_en                                                                        ./libraries/command_en                                                                       
ensure_lib                                                                                   ./libraries/system_status                                                                    
vmap       system_status                                                                     ./libraries/system_status                                                                    
ensure_lib                                                                                   ./libraries/disp_en_brightness                                                               
vmap       disp_en_brightness                                                                ./libraries/disp_en_brightness                                                               
ensure_lib                                                                                   ./libraries/command_rx                                                                       
vmap       command_rx                                                                        ./libraries/command_rx                                                                       
ensure_lib                                                                                   ./libraries/command_tx                                                                       
vmap       command_tx                                                                        ./libraries/command_tx                                                                       
ensure_lib                                                                                   ./libraries/iram                                                                             
vmap       iram                                                                              ./libraries/iram                                                                             
ensure_lib                                                                                   ./libraries/sysid_c001                                                                       
vmap       sysid_c001                                                                        ./libraries/sysid_c001                                                                       
ensure_lib                                                                                   ./libraries/dram                                                                             
vmap       dram                                                                              ./libraries/dram                                                                             
ensure_lib                                                                                   ./libraries/nios2_qsys_0                                                                     
vmap       nios2_qsys_0                                                                      ./libraries/nios2_qsys_0                                                                     
ensure_lib                                                                                   ./libraries/controller_inst_ign_en_bfm                                                       
vmap       controller_inst_ign_en_bfm                                                        ./libraries/controller_inst_ign_en_bfm                                                       
ensure_lib                                                                                   ./libraries/controller_inst_boost_bfm                                                        
vmap       controller_inst_boost_bfm                                                         ./libraries/controller_inst_boost_bfm                                                        
ensure_lib                                                                                   ./libraries/controller_inst_warning_en_bfm                                                   
vmap       controller_inst_warning_en_bfm                                                    ./libraries/controller_inst_warning_en_bfm                                                   
ensure_lib                                                                                   ./libraries/controller_inst_command_en_bfm                                                   
vmap       controller_inst_command_en_bfm                                                    ./libraries/controller_inst_command_en_bfm                                                   
ensure_lib                                                                                   ./libraries/controller_inst_system_status_bfm                                                
vmap       controller_inst_system_status_bfm                                                 ./libraries/controller_inst_system_status_bfm                                                
ensure_lib                                                                                   ./libraries/controller_inst_disp_en_brightness_bfm                                           
vmap       controller_inst_disp_en_brightness_bfm                                            ./libraries/controller_inst_disp_en_brightness_bfm                                           
ensure_lib                                                                                   ./libraries/controller_inst_command_rx_bfm                                                   
vmap       controller_inst_command_rx_bfm                                                    ./libraries/controller_inst_command_rx_bfm                                                   
ensure_lib                                                                                   ./libraries/controller_inst_command_tx_bfm                                                   
vmap       controller_inst_command_tx_bfm                                                    ./libraries/controller_inst_command_tx_bfm                                                   
ensure_lib                                                                                   ./libraries/controller_inst_clk_bfm                                                          
vmap       controller_inst_clk_bfm                                                           ./libraries/controller_inst_clk_bfm                                                          
ensure_lib                                                                                   ./libraries/controller_inst                                                                  
vmap       controller_inst                                                                   ./libraries/controller_inst                                                                  

# ----------------------------------------
# Compile device library files
alias dev_com {
  echo "\[exec\] dev_com"
  vlog +define+SKIP_KEYWORDS_PRAGMA "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives.v" -work altera_ver      
  vlog                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/220model.v"          -work lpm_ver         
  vlog                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate.v"             -work sgate_ver       
  vlog                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf.v"         -work altera_mf_ver   
  vlog                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_lnsim.sv"     -work altera_lnsim_ver
  vlog                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/cycloneiii_atoms.v"  -work cycloneiii_ver  
}

# ----------------------------------------
# Compile the design files in correct order
alias com {
  echo "\[exec\] com"
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/verbosity_pkg.sv"                                                                 -work altera_common_sv_packages                                                        
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/altera_merlin_arbitrator.sv"                         -l altera_common_sv_packages -work rsp_xbar_mux_001                                                                 
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_mm_interconnect_0_rsp_xbar_mux_001.sv"    -l altera_common_sv_packages -work rsp_xbar_mux_001                                                                 
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/altera_merlin_arbitrator.sv"                         -l altera_common_sv_packages -work rsp_xbar_mux                                                                     
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_mm_interconnect_0_rsp_xbar_mux.sv"        -l altera_common_sv_packages -work rsp_xbar_mux                                                                     
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_mm_interconnect_0_rsp_xbar_demux_001.sv"  -l altera_common_sv_packages -work rsp_xbar_demux_001                                                               
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_mm_interconnect_0_rsp_xbar_demux.sv"      -l altera_common_sv_packages -work rsp_xbar_demux                                                                   
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/altera_merlin_arbitrator.sv"                         -l altera_common_sv_packages -work cmd_xbar_mux_001                                                                 
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_mm_interconnect_0_cmd_xbar_mux_001.sv"    -l altera_common_sv_packages -work cmd_xbar_mux_001                                                                 
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/altera_merlin_arbitrator.sv"                         -l altera_common_sv_packages -work cmd_xbar_mux                                                                     
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_mm_interconnect_0_cmd_xbar_mux.sv"        -l altera_common_sv_packages -work cmd_xbar_mux                                                                     
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_mm_interconnect_0_cmd_xbar_demux_001.sv"  -l altera_common_sv_packages -work cmd_xbar_demux_001                                                               
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_mm_interconnect_0_cmd_xbar_demux.sv"      -l altera_common_sv_packages -work cmd_xbar_demux                                                                   
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_mm_interconnect_0_id_router_003.sv"       -l altera_common_sv_packages -work id_router_003                                                                    
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_mm_interconnect_0_id_router_001.sv"       -l altera_common_sv_packages -work id_router_001                                                                    
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_mm_interconnect_0_id_router.sv"           -l altera_common_sv_packages -work id_router                                                                        
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_mm_interconnect_0_addr_router_001.sv"     -l altera_common_sv_packages -work addr_router_001                                                                  
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_mm_interconnect_0_addr_router.sv"         -l altera_common_sv_packages -work addr_router                                                                      
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/altera_avalon_sc_fifo.v"                                                          -work nios2_qsys_0_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/altera_merlin_slave_agent.sv"                        -l altera_common_sv_packages -work nios2_qsys_0_jtag_debug_module_translator_avalon_universal_slave_0_agent         
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/altera_merlin_burst_uncompressor.sv"                 -l altera_common_sv_packages -work nios2_qsys_0_jtag_debug_module_translator_avalon_universal_slave_0_agent         
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/altera_merlin_master_agent.sv"                       -l altera_common_sv_packages -work nios2_qsys_0_instruction_master_translator_avalon_universal_master_0_agent       
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/altera_merlin_slave_translator.sv"                   -l altera_common_sv_packages -work nios2_qsys_0_jtag_debug_module_translator                                        
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/altera_merlin_master_translator.sv"                  -l altera_common_sv_packages -work nios2_qsys_0_instruction_master_translator                                       
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/altera_reset_controller.v"                                                        -work rst_controller                                                                   
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/altera_reset_synchronizer.v"                                                      -work rst_controller                                                                   
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_irq_mapper.sv"                            -l altera_common_sv_packages -work irq_mapper                                                                       
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_mm_interconnect_0.v"                                                   -work mm_interconnect_0                                                                
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_ign_en.v"                                                              -work ign_en                                                                           
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_jtag_uart_0.v"                                                         -work jtag_uart_0                                                                      
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_boost.v"                                                               -work boost                                                                            
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_warning_en.v"                                                          -work warning_en                                                                       
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_command_en.v"                                                          -work command_en                                                                       
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_system_status.v"                                                       -work system_status                                                                    
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_disp_en_brightness.v"                                                  -work disp_en_brightness                                                               
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_command_rx.v"                                                          -work command_rx                                                                       
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_command_tx.v"                                                          -work command_tx                                                                       
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_iram.v"                                                                -work iram                                                                             
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_sysid_c001.vo"                                                         -work sysid_c001                                                                       
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_dram.v"                                                                -work dram                                                                             
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_nios2_qsys_0.v"                                                        -work nios2_qsys_0                                                                     
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_nios2_qsys_0_jtag_debug_module_sysclk.v"                               -work nios2_qsys_0                                                                     
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_nios2_qsys_0_jtag_debug_module_tck.v"                                  -work nios2_qsys_0                                                                     
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_nios2_qsys_0_jtag_debug_module_wrapper.v"                              -work nios2_qsys_0                                                                     
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_nios2_qsys_0_oci_test_bench.v"                                         -work nios2_qsys_0                                                                     
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_nios2_qsys_0_test_bench.v"                                             -work nios2_qsys_0                                                                     
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/altera_conduit_bfm_0008.sv"                          -l altera_common_sv_packages -work controller_inst_ign_en_bfm                                                       
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/altera_conduit_bfm_0007.sv"                          -l altera_common_sv_packages -work controller_inst_boost_bfm                                                        
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/altera_conduit_bfm_0006.sv"                          -l altera_common_sv_packages -work controller_inst_warning_en_bfm                                                   
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/altera_conduit_bfm_0005.sv"                          -l altera_common_sv_packages -work controller_inst_command_en_bfm                                                   
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/altera_conduit_bfm_0004.sv"                          -l altera_common_sv_packages -work controller_inst_system_status_bfm                                                
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/altera_conduit_bfm_0003.sv"                          -l altera_common_sv_packages -work controller_inst_disp_en_brightness_bfm                                           
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/altera_conduit_bfm_0002.sv"                          -l altera_common_sv_packages -work controller_inst_command_rx_bfm                                                   
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/altera_conduit_bfm.sv"                               -l altera_common_sv_packages -work controller_inst_command_tx_bfm                                                   
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/altera_avalon_clock_source.sv"                       -l altera_common_sv_packages -work controller_inst_clk_bfm                                                          
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller.v"                                                                     -work controller_inst                                                                  
  vlog  "$QSYS_SIMDIR/controller_tb/simulation/controller_tb.v"                                                                                                                                                                    
}

# ----------------------------------------
# Elaborate top level design
alias elab {
  echo "\[exec\] elab"
  eval vsim +access +r -t ps $ELAB_OPTIONS -L work -L altera_common_sv_packages -L rsp_xbar_mux_001 -L rsp_xbar_mux -L rsp_xbar_demux_001 -L rsp_xbar_demux -L cmd_xbar_mux_001 -L cmd_xbar_mux -L cmd_xbar_demux_001 -L cmd_xbar_demux -L id_router_003 -L id_router_001 -L id_router -L addr_router_001 -L addr_router -L nios2_qsys_0_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo -L nios2_qsys_0_jtag_debug_module_translator_avalon_universal_slave_0_agent -L nios2_qsys_0_instruction_master_translator_avalon_universal_master_0_agent -L nios2_qsys_0_jtag_debug_module_translator -L nios2_qsys_0_instruction_master_translator -L rst_controller -L irq_mapper -L mm_interconnect_0 -L ign_en -L jtag_uart_0 -L boost -L warning_en -L command_en -L system_status -L disp_en_brightness -L command_rx -L command_tx -L iram -L sysid_c001 -L dram -L nios2_qsys_0 -L controller_inst_ign_en_bfm -L controller_inst_boost_bfm -L controller_inst_warning_en_bfm -L controller_inst_command_en_bfm -L controller_inst_system_status_bfm -L controller_inst_disp_en_brightness_bfm -L controller_inst_command_rx_bfm -L controller_inst_command_tx_bfm -L controller_inst_clk_bfm -L controller_inst -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneiii_ver $TOP_LEVEL_NAME
}

# ----------------------------------------
# Elaborate the top level design with -dbg -O2 option
alias elab_debug {
  echo "\[exec\] elab_debug"
  eval vsim -dbg -O2 +access +r -t ps $ELAB_OPTIONS -L work -L altera_common_sv_packages -L rsp_xbar_mux_001 -L rsp_xbar_mux -L rsp_xbar_demux_001 -L rsp_xbar_demux -L cmd_xbar_mux_001 -L cmd_xbar_mux -L cmd_xbar_demux_001 -L cmd_xbar_demux -L id_router_003 -L id_router_001 -L id_router -L addr_router_001 -L addr_router -L nios2_qsys_0_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo -L nios2_qsys_0_jtag_debug_module_translator_avalon_universal_slave_0_agent -L nios2_qsys_0_instruction_master_translator_avalon_universal_master_0_agent -L nios2_qsys_0_jtag_debug_module_translator -L nios2_qsys_0_instruction_master_translator -L rst_controller -L irq_mapper -L mm_interconnect_0 -L ign_en -L jtag_uart_0 -L boost -L warning_en -L command_en -L system_status -L disp_en_brightness -L command_rx -L command_tx -L iram -L sysid_c001 -L dram -L nios2_qsys_0 -L controller_inst_ign_en_bfm -L controller_inst_boost_bfm -L controller_inst_warning_en_bfm -L controller_inst_command_en_bfm -L controller_inst_system_status_bfm -L controller_inst_disp_en_brightness_bfm -L controller_inst_command_rx_bfm -L controller_inst_command_tx_bfm -L controller_inst_clk_bfm -L controller_inst -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneiii_ver $TOP_LEVEL_NAME
}

# ----------------------------------------
# Compile all the design files and elaborate the top level design
alias ld "
  dev_com
  com
  elab
"

# ----------------------------------------
# Compile all the design files and elaborate the top level design with -dbg -O2
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
  echo "elab_debug                    -- Elaborate the top level design with -dbg -O2 option"
  echo
  echo "ld                            -- Compile all the design files and elaborate the top level design"
  echo
  echo "ld_debug                      -- Compile all the design files and elaborate the top level design with -dbg -O2"
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
