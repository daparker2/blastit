
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

# ACDS 13.1 162 win32 2018.10.06.18:07:26

# ----------------------------------------
# ncsim - auto-generated simulation script

# ----------------------------------------
# initialize variables
TOP_LEVEL_NAME="controller_tb"
QSYS_SIMDIR="./../"
QUARTUS_INSTALL_DIR="C:/altera/13.1/quartus/"
SKIP_FILE_COPY=0
SKIP_DEV_COM=0
SKIP_COM=0
SKIP_ELAB=0
SKIP_SIM=0
USER_DEFINED_ELAB_OPTIONS=""
USER_DEFINED_SIM_OPTIONS="-input \"@run 100; exit\""

# ----------------------------------------
# overwrite variables - DO NOT MODIFY!
# This block evaluates each command line argument, typically used for 
# overwriting variables. An example usage:
#   sh <simulator>_setup.sh SKIP_ELAB=1 SKIP_SIM=1
for expression in "$@"; do
  eval $expression
  if [ $? -ne 0 ]; then
    echo "Error: This command line argument, \"$expression\", is/has an invalid expression." >&2
    exit $?
  fi
done

# ----------------------------------------
# initialize simulation properties - DO NOT MODIFY!
ELAB_OPTIONS=""
SIM_OPTIONS=""
if [[ `ncsim -version` != *"ncsim(64)"* ]]; then
  :
else
  :
fi

# ----------------------------------------
# create compilation libraries
mkdir -p ./libraries/work/
mkdir -p ./libraries/altera_common_sv_packages/
mkdir -p ./libraries/rsp_xbar_mux_001/
mkdir -p ./libraries/rsp_xbar_mux/
mkdir -p ./libraries/rsp_xbar_demux_004/
mkdir -p ./libraries/rsp_xbar_demux/
mkdir -p ./libraries/cmd_xbar_mux_004/
mkdir -p ./libraries/cmd_xbar_mux/
mkdir -p ./libraries/cmd_xbar_demux_001/
mkdir -p ./libraries/cmd_xbar_demux/
mkdir -p ./libraries/id_router_004/
mkdir -p ./libraries/id_router/
mkdir -p ./libraries/addr_router_001/
mkdir -p ./libraries/addr_router/
mkdir -p ./libraries/nios2e_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo/
mkdir -p ./libraries/nios2e_jtag_debug_module_translator_avalon_universal_slave_0_agent/
mkdir -p ./libraries/nios2e_instruction_master_translator_avalon_universal_master_0_agent/
mkdir -p ./libraries/nios2e_jtag_debug_module_translator/
mkdir -p ./libraries/nios2e_instruction_master_translator/
mkdir -p ./libraries/rst_controller/
mkdir -p ./libraries/irq_mapper/
mkdir -p ./libraries/mm_interconnect_0/
mkdir -p ./libraries/led_period/
mkdir -p ./libraries/rc1_control/
mkdir -p ./libraries/uart1_dvsr/
mkdir -p ./libraries/leds1_wr_val/
mkdir -p ./libraries/sseg_counter_of/
mkdir -p ./libraries/sseg_wr_val/
mkdir -p ./libraries/sseg_reset_control/
mkdir -p ./libraries/warn_pwm_control/
mkdir -p ./libraries/status_led_en/
mkdir -p ./libraries/bcd1_status/
mkdir -p ./libraries/bcd1_bcd/
mkdir -p ./libraries/bcd1_control/
mkdir -p ./libraries/bcd1_bin/
mkdir -p ./libraries/uart1_status_control/
mkdir -p ./libraries/uart1_r_data/
mkdir -p ./libraries/uart1_baud_control/
mkdir -p ./libraries/uart1_wr_control/
mkdir -p ./libraries/uart1_reset_control/
mkdir -p ./libraries/uart1_w_data/
mkdir -p ./libraries/tc1_status/
mkdir -p ./libraries/tc_reset_control/
mkdir -p ./libraries/tc1_m/
mkdir -p ./libraries/daylight/
mkdir -p ./libraries/onchip_ram/
mkdir -p ./libraries/nios2e/
mkdir -p ./libraries/jtag_uart_0/
mkdir -p ./libraries/sysid_c001/
mkdir -p ./libraries/controller_inst_reset_bfm/
mkdir -p ./libraries/controller_inst_clock_50_bfm/
mkdir -p ./libraries/controller_inst/
mkdir -p ./libraries/altera_ver/
mkdir -p ./libraries/lpm_ver/
mkdir -p ./libraries/sgate_ver/
mkdir -p ./libraries/altera_mf_ver/
mkdir -p ./libraries/altera_lnsim_ver/
mkdir -p ./libraries/cycloneiii_ver/

# ----------------------------------------
# copy RAM/ROM files to simulation directory
if [ $SKIP_FILE_COPY -eq 0 ]; then
  cp -f $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_onchip_ram.hex ./
  cp -f $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_nios2e_ociram_default_contents.dat ./
  cp -f $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_nios2e_ociram_default_contents.hex ./
  cp -f $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_nios2e_ociram_default_contents.mif ./
  cp -f $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_nios2e_rf_ram_a.dat ./
  cp -f $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_nios2e_rf_ram_a.hex ./
  cp -f $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_nios2e_rf_ram_a.mif ./
  cp -f $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_nios2e_rf_ram_b.dat ./
  cp -f $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_nios2e_rf_ram_b.hex ./
  cp -f $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_nios2e_rf_ram_b.mif ./
fi

# ----------------------------------------
# compile device library files
if [ $SKIP_DEV_COM -eq 0 ]; then
  ncvlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives.v" -work altera_ver      
  ncvlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/220model.v"          -work lpm_ver         
  ncvlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate.v"             -work sgate_ver       
  ncvlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf.v"         -work altera_mf_ver   
  ncvlog -sv "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_lnsim.sv"     -work altera_lnsim_ver
  ncvlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/cycloneiii_atoms.v"  -work cycloneiii_ver  
fi

# ----------------------------------------
# compile design files in correct order
if [ $SKIP_COM -eq 0 ]; then
  ncvlog -sv "$QSYS_SIMDIR/controller_tb/simulation/submodules/verbosity_pkg.sv"                                   -work altera_common_sv_packages                                                   -cdslib ./cds_libs/altera_common_sv_packages.cds.lib                                                  
  ncvlog -sv "$QSYS_SIMDIR/controller_tb/simulation/submodules/altera_merlin_arbitrator.sv"                        -work rsp_xbar_mux_001                                                            -cdslib ./cds_libs/rsp_xbar_mux_001.cds.lib                                                           
  ncvlog -sv "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_mm_interconnect_0_rsp_xbar_mux_001.sv"   -work rsp_xbar_mux_001                                                            -cdslib ./cds_libs/rsp_xbar_mux_001.cds.lib                                                           
  ncvlog -sv "$QSYS_SIMDIR/controller_tb/simulation/submodules/altera_merlin_arbitrator.sv"                        -work rsp_xbar_mux                                                                -cdslib ./cds_libs/rsp_xbar_mux.cds.lib                                                               
  ncvlog -sv "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_mm_interconnect_0_rsp_xbar_mux.sv"       -work rsp_xbar_mux                                                                -cdslib ./cds_libs/rsp_xbar_mux.cds.lib                                                               
  ncvlog -sv "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_mm_interconnect_0_rsp_xbar_demux_004.sv" -work rsp_xbar_demux_004                                                          -cdslib ./cds_libs/rsp_xbar_demux_004.cds.lib                                                         
  ncvlog -sv "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_mm_interconnect_0_rsp_xbar_demux.sv"     -work rsp_xbar_demux                                                              -cdslib ./cds_libs/rsp_xbar_demux.cds.lib                                                             
  ncvlog -sv "$QSYS_SIMDIR/controller_tb/simulation/submodules/altera_merlin_arbitrator.sv"                        -work cmd_xbar_mux_004                                                            -cdslib ./cds_libs/cmd_xbar_mux_004.cds.lib                                                           
  ncvlog -sv "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_mm_interconnect_0_cmd_xbar_mux_004.sv"   -work cmd_xbar_mux_004                                                            -cdslib ./cds_libs/cmd_xbar_mux_004.cds.lib                                                           
  ncvlog -sv "$QSYS_SIMDIR/controller_tb/simulation/submodules/altera_merlin_arbitrator.sv"                        -work cmd_xbar_mux                                                                -cdslib ./cds_libs/cmd_xbar_mux.cds.lib                                                               
  ncvlog -sv "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_mm_interconnect_0_cmd_xbar_mux.sv"       -work cmd_xbar_mux                                                                -cdslib ./cds_libs/cmd_xbar_mux.cds.lib                                                               
  ncvlog -sv "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_mm_interconnect_0_cmd_xbar_demux_001.sv" -work cmd_xbar_demux_001                                                          -cdslib ./cds_libs/cmd_xbar_demux_001.cds.lib                                                         
  ncvlog -sv "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_mm_interconnect_0_cmd_xbar_demux.sv"     -work cmd_xbar_demux                                                              -cdslib ./cds_libs/cmd_xbar_demux.cds.lib                                                             
  ncvlog -sv "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_mm_interconnect_0_id_router_004.sv"      -work id_router_004                                                               -cdslib ./cds_libs/id_router_004.cds.lib                                                              
  ncvlog -sv "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_mm_interconnect_0_id_router.sv"          -work id_router                                                                   -cdslib ./cds_libs/id_router.cds.lib                                                                  
  ncvlog -sv "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_mm_interconnect_0_addr_router_001.sv"    -work addr_router_001                                                             -cdslib ./cds_libs/addr_router_001.cds.lib                                                            
  ncvlog -sv "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_mm_interconnect_0_addr_router.sv"        -work addr_router                                                                 -cdslib ./cds_libs/addr_router.cds.lib                                                                
  ncvlog     "$QSYS_SIMDIR/controller_tb/simulation/submodules/altera_avalon_sc_fifo.v"                            -work nios2e_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo -cdslib ./cds_libs/nios2e_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo.cds.lib
  ncvlog -sv "$QSYS_SIMDIR/controller_tb/simulation/submodules/altera_merlin_slave_agent.sv"                       -work nios2e_jtag_debug_module_translator_avalon_universal_slave_0_agent          -cdslib ./cds_libs/nios2e_jtag_debug_module_translator_avalon_universal_slave_0_agent.cds.lib         
  ncvlog -sv "$QSYS_SIMDIR/controller_tb/simulation/submodules/altera_merlin_burst_uncompressor.sv"                -work nios2e_jtag_debug_module_translator_avalon_universal_slave_0_agent          -cdslib ./cds_libs/nios2e_jtag_debug_module_translator_avalon_universal_slave_0_agent.cds.lib         
  ncvlog -sv "$QSYS_SIMDIR/controller_tb/simulation/submodules/altera_merlin_master_agent.sv"                      -work nios2e_instruction_master_translator_avalon_universal_master_0_agent        -cdslib ./cds_libs/nios2e_instruction_master_translator_avalon_universal_master_0_agent.cds.lib       
  ncvlog -sv "$QSYS_SIMDIR/controller_tb/simulation/submodules/altera_merlin_slave_translator.sv"                  -work nios2e_jtag_debug_module_translator                                         -cdslib ./cds_libs/nios2e_jtag_debug_module_translator.cds.lib                                        
  ncvlog -sv "$QSYS_SIMDIR/controller_tb/simulation/submodules/altera_merlin_master_translator.sv"                 -work nios2e_instruction_master_translator                                        -cdslib ./cds_libs/nios2e_instruction_master_translator.cds.lib                                       
  ncvlog     "$QSYS_SIMDIR/controller_tb/simulation/submodules/altera_reset_controller.v"                          -work rst_controller                                                              -cdslib ./cds_libs/rst_controller.cds.lib                                                             
  ncvlog     "$QSYS_SIMDIR/controller_tb/simulation/submodules/altera_reset_synchronizer.v"                        -work rst_controller                                                              -cdslib ./cds_libs/rst_controller.cds.lib                                                             
  ncvlog -sv "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_irq_mapper.sv"                           -work irq_mapper                                                                  -cdslib ./cds_libs/irq_mapper.cds.lib                                                                 
  ncvlog     "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_mm_interconnect_0.v"                     -work mm_interconnect_0                                                           -cdslib ./cds_libs/mm_interconnect_0.cds.lib                                                          
  ncvlog     "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_led_period.v"                            -work led_period                                                                  -cdslib ./cds_libs/led_period.cds.lib                                                                 
  ncvlog     "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_rc1_control.v"                           -work rc1_control                                                                 -cdslib ./cds_libs/rc1_control.cds.lib                                                                
  ncvlog     "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_uart1_dvsr.v"                            -work uart1_dvsr                                                                  -cdslib ./cds_libs/uart1_dvsr.cds.lib                                                                 
  ncvlog     "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_leds1_wr_val.v"                          -work leds1_wr_val                                                                -cdslib ./cds_libs/leds1_wr_val.cds.lib                                                               
  ncvlog     "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_sseg_counter_of.v"                       -work sseg_counter_of                                                             -cdslib ./cds_libs/sseg_counter_of.cds.lib                                                            
  ncvlog     "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_sseg_wr_val.v"                           -work sseg_wr_val                                                                 -cdslib ./cds_libs/sseg_wr_val.cds.lib                                                                
  ncvlog     "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_sseg_reset_control.v"                    -work sseg_reset_control                                                          -cdslib ./cds_libs/sseg_reset_control.cds.lib                                                         
  ncvlog     "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_warn_pwm_control.v"                      -work warn_pwm_control                                                            -cdslib ./cds_libs/warn_pwm_control.cds.lib                                                           
  ncvlog     "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_status_led_en.v"                         -work status_led_en                                                               -cdslib ./cds_libs/status_led_en.cds.lib                                                              
  ncvlog     "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_bcd1_status.v"                           -work bcd1_status                                                                 -cdslib ./cds_libs/bcd1_status.cds.lib                                                                
  ncvlog     "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_bcd1_bcd.v"                              -work bcd1_bcd                                                                    -cdslib ./cds_libs/bcd1_bcd.cds.lib                                                                   
  ncvlog     "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_bcd1_control.v"                          -work bcd1_control                                                                -cdslib ./cds_libs/bcd1_control.cds.lib                                                               
  ncvlog     "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_bcd1_bin.v"                              -work bcd1_bin                                                                    -cdslib ./cds_libs/bcd1_bin.cds.lib                                                                   
  ncvlog     "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_uart1_status_control.v"                  -work uart1_status_control                                                        -cdslib ./cds_libs/uart1_status_control.cds.lib                                                       
  ncvlog     "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_uart1_r_data.v"                          -work uart1_r_data                                                                -cdslib ./cds_libs/uart1_r_data.cds.lib                                                               
  ncvlog     "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_uart1_baud_control.v"                    -work uart1_baud_control                                                          -cdslib ./cds_libs/uart1_baud_control.cds.lib                                                         
  ncvlog     "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_uart1_wr_control.v"                      -work uart1_wr_control                                                            -cdslib ./cds_libs/uart1_wr_control.cds.lib                                                           
  ncvlog     "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_uart1_reset_control.v"                   -work uart1_reset_control                                                         -cdslib ./cds_libs/uart1_reset_control.cds.lib                                                        
  ncvlog     "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_uart1_w_data.v"                          -work uart1_w_data                                                                -cdslib ./cds_libs/uart1_w_data.cds.lib                                                               
  ncvlog     "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_tc1_status.v"                            -work tc1_status                                                                  -cdslib ./cds_libs/tc1_status.cds.lib                                                                 
  ncvlog     "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_tc_reset_control.v"                      -work tc_reset_control                                                            -cdslib ./cds_libs/tc_reset_control.cds.lib                                                           
  ncvlog     "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_tc1_m.v"                                 -work tc1_m                                                                       -cdslib ./cds_libs/tc1_m.cds.lib                                                                      
  ncvlog     "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_daylight.v"                              -work daylight                                                                    -cdslib ./cds_libs/daylight.cds.lib                                                                   
  ncvlog     "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_onchip_ram.v"                            -work onchip_ram                                                                  -cdslib ./cds_libs/onchip_ram.cds.lib                                                                 
  ncvlog     "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_nios2e.v"                                -work nios2e                                                                      -cdslib ./cds_libs/nios2e.cds.lib                                                                     
  ncvlog     "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_nios2e_jtag_debug_module_sysclk.v"       -work nios2e                                                                      -cdslib ./cds_libs/nios2e.cds.lib                                                                     
  ncvlog     "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_nios2e_jtag_debug_module_tck.v"          -work nios2e                                                                      -cdslib ./cds_libs/nios2e.cds.lib                                                                     
  ncvlog     "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_nios2e_jtag_debug_module_wrapper.v"      -work nios2e                                                                      -cdslib ./cds_libs/nios2e.cds.lib                                                                     
  ncvlog     "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_nios2e_oci_test_bench.v"                 -work nios2e                                                                      -cdslib ./cds_libs/nios2e.cds.lib                                                                     
  ncvlog     "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_nios2e_test_bench.v"                     -work nios2e                                                                      -cdslib ./cds_libs/nios2e.cds.lib                                                                     
  ncvlog     "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_jtag_uart_0.v"                           -work jtag_uart_0                                                                 -cdslib ./cds_libs/jtag_uart_0.cds.lib                                                                
  ncvlog     "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller_sysid_c001.vo"                           -work sysid_c001                                                                  -cdslib ./cds_libs/sysid_c001.cds.lib                                                                 
  ncvlog -sv "$QSYS_SIMDIR/controller_tb/simulation/submodules/altera_avalon_reset_source.sv"                      -work controller_inst_reset_bfm                                                   -cdslib ./cds_libs/controller_inst_reset_bfm.cds.lib                                                  
  ncvlog -sv "$QSYS_SIMDIR/controller_tb/simulation/submodules/altera_avalon_clock_source.sv"                      -work controller_inst_clock_50_bfm                                                -cdslib ./cds_libs/controller_inst_clock_50_bfm.cds.lib                                               
  ncvlog     "$QSYS_SIMDIR/controller_tb/simulation/submodules/controller.v"                                       -work controller_inst                                                             -cdslib ./cds_libs/controller_inst.cds.lib                                                            
  ncvlog     "$QSYS_SIMDIR/controller_tb/simulation/controller_tb.v"                                                                                                                                                                                                                                       
fi

# ----------------------------------------
# elaborate top level design
if [ $SKIP_ELAB -eq 0 ]; then
  ncelab -access +w+r+c -namemap_mixgen $ELAB_OPTIONS $USER_DEFINED_ELAB_OPTIONS $TOP_LEVEL_NAME
fi

# ----------------------------------------
# simulate
if [ $SKIP_SIM -eq 0 ]; then
  eval ncsim -licqueue $SIM_OPTIONS $USER_DEFINED_SIM_OPTIONS $TOP_LEVEL_NAME
fi
