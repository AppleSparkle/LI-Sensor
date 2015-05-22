create_clock -period 20 [get_ports CLK_50]

#**************************************************************
# Create Generated Clock
#**************************************************************
derive_pll_clocks

derive_clock_uncertainty