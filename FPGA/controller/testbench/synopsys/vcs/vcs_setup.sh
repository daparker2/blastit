
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

# ACDS 13.1 162 win32 2018.08.05.18:13:24

# ----------------------------------------
# vcs - auto-generated simulation script

# ----------------------------------------
# initialize variables
TOP_LEVEL_NAME="controller_tb"
QSYS_SIMDIR="./../../"
QUARTUS_INSTALL_DIR="C:/altera/13.1/quartus/"
SKIP_FILE_COPY=0
SKIP_ELAB=0
SKIP_SIM=0
USER_DEFINED_ELAB_OPTIONS=""
USER_DEFINED_SIM_OPTIONS="+vcs+finish+100"
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
if [[ `vcs -platform` != *"amd64"* ]]; then
  :
else
  :
fi

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

vcs -lca -timescale=1ps/1ps -sverilog +verilog2001ext+.v -ntb_opts dtm $ELAB_OPTIONS $USER_DEFINED_ELAB_OPTIONS \
  -v $QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives.v \
  -v $QUARTUS_INSTALL_DIR/eda/sim_lib/220model.v \
  -v $QUARTUS_INSTALL_DIR/eda/sim_lib/sgate.v \
  -v $QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf.v \
  $QUARTUS_INSTALL_DIR/eda/sim_lib/altera_lnsim.sv \
  -v $QUARTUS_INSTALL_DIR/eda/sim_lib/cycloneiii_atoms.v \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/verbosity_pkg.sv \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/altera_merlin_arbitrator.sv \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_mm_interconnect_0_rsp_xbar_mux_001.sv \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_mm_interconnect_0_rsp_xbar_mux.sv \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_mm_interconnect_0_rsp_xbar_demux_004.sv \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_mm_interconnect_0_rsp_xbar_demux.sv \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_mm_interconnect_0_cmd_xbar_mux_004.sv \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_mm_interconnect_0_cmd_xbar_mux.sv \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_mm_interconnect_0_cmd_xbar_demux_001.sv \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_mm_interconnect_0_cmd_xbar_demux.sv \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_mm_interconnect_0_id_router_004.sv \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_mm_interconnect_0_id_router.sv \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_mm_interconnect_0_addr_router_001.sv \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_mm_interconnect_0_addr_router.sv \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/altera_avalon_sc_fifo.v \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/altera_merlin_slave_agent.sv \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/altera_merlin_burst_uncompressor.sv \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/altera_merlin_master_agent.sv \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/altera_merlin_slave_translator.sv \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/altera_merlin_master_translator.sv \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/altera_reset_controller.v \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/altera_reset_synchronizer.v \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_irq_mapper.sv \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_mm_interconnect_0.v \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_led_period.v \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_rc1_control.v \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_uart1_dvsr.v \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_leds_wr_val.v \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_sseg_counter_of.v \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_sseg_wr_val.v \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_sseg_reset_control.v \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_warn_pwm_control.v \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_status_led_en.v \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_bcd1_status.v \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_bcd1_bcd.v \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_bcd1_control.v \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_bcd1_bin.v \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_uart1_status_control.v \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_uart1_r_data.v \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_uart1_baud_control.v \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_uart1_wr_control.v \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_uart1_reset_control.v \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_uart1_w_data.v \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_tc1_status.v \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_tc_reset_control.v \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_tc1_m.v \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_daylight.v \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_onchip_ram.v \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_nios2e.v \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_nios2e_jtag_debug_module_sysclk.v \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_nios2e_jtag_debug_module_tck.v \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_nios2e_jtag_debug_module_wrapper.v \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_nios2e_oci_test_bench.v \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_nios2e_test_bench.v \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_jtag_uart_0.v \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/controller_sysid_c001.vo \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/altera_conduit_bfm_0018.sv \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/altera_conduit_bfm_0017.sv \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/altera_conduit_bfm_0016.sv \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/altera_conduit_bfm_0015.sv \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/altera_conduit_bfm_0014.sv \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/altera_conduit_bfm_0013.sv \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/altera_conduit_bfm_0012.sv \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/altera_conduit_bfm_0011.sv \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/altera_conduit_bfm_0010.sv \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/altera_conduit_bfm_0009.sv \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/altera_conduit_bfm_0008.sv \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/altera_conduit_bfm_0007.sv \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/altera_conduit_bfm_0006.sv \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/altera_conduit_bfm_0005.sv \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/altera_conduit_bfm_0004.sv \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/altera_conduit_bfm_0003.sv \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/altera_conduit_bfm_0002.sv \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/altera_conduit_bfm.sv \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/altera_avalon_reset_source.sv \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/altera_avalon_clock_source.sv \
  $QSYS_SIMDIR/controller_tb/simulation/submodules/controller.v \
  $QSYS_SIMDIR/controller_tb/simulation/controller_tb.v \
  -top $TOP_LEVEL_NAME
# ----------------------------------------
# simulate
if [ $SKIP_SIM -eq 0 ]; then
  ./simv $SIM_OPTIONS $USER_DEFINED_SIM_OPTIONS
fi
