#**************************************************************
# This .sdc file is created by Terasic Tool.
# Users are recommended to modify this file to match users logic.
#**************************************************************

#**************************************************************
# Create Clock
#**************************************************************
create_clock -name {clk} -period "50.000000 MHz" [get_ports CLOCK_50]

#**************************************************************
# Create Generated Clock
#**************************************************************
#derive_pll_clocks

#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

# This command can be safely left in the SDC even if no PLLs exist in the design
derive_clock_uncertainty



#**************************************************************
# Set Input Delay
#**************************************************************

# Constrain the input I/O path
set_input_delay -clock {clk} -max 3 [all_inputs]
set_input_delay -clock {clk} -min 2 [all_inputs]

#**************************************************************
# Set Output Delay
#**************************************************************

# Constrain the output I/O path
set_output_delay -clock {clk} 2 [all_outputs]

#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************



#**************************************************************
# Set Load
#**************************************************************



