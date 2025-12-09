###############################################
# CLOCK INPUT
###############################################
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

###############################################
# RESET (BTN0)
###############################################
set_property PACKAGE_PIN U18 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

###############################################
# VGA OUTPUTS
###############################################
set_property PACKAGE_PIN A3 [get_ports hsync]
set_property PACKAGE_PIN B4 [get_ports vsync]
set_property IOSTANDARD LVCMOS33 [get_ports {hsync vsync}]

# Red
set_property PACKAGE_PIN A4 [get_ports {vga_r[0]}]
set_property PACKAGE_PIN C5 [get_ports {vga_r[1]}]
set_property PACKAGE_PIN A5 [get_ports {vga_r[2]}]
set_property PACKAGE_PIN B5 [get_ports {vga_r[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_r[*]}]

# Green
set_property PACKAGE_PIN B6 [get_ports {vga_g[0]}]
set_property PACKAGE_PIN A6 [get_ports {vga_g[1]}]
set_property PACKAGE_PIN C6 [get_ports {vga_g[2]}]
set_property PACKAGE_PIN A7 [get_ports {vga_g[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_g[*]}]

# Blue
set_property PACKAGE_PIN C7 [get_ports {vga_b[0]}]
set_property PACKAGE_PIN B7 [get_ports {vga_b[1]}]
set_property PACKAGE_PIN D7 [get_ports {vga_b[2]}]
set_property PACKAGE_PIN D8 [get_ports {vga_b[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_b[*]}]

###############################################
# PMOD KYPD (JA)
###############################################
# Columns (outputs)
set_property PACKAGE_PIN J1 [get_ports {kypd_cols[0]}]
set_property PACKAGE_PIN L2 [get_ports {kypd_cols[1]}]
set_property PACKAGE_PIN J2 [get_ports {kypd_cols[2]}]
set_property PACKAGE_PIN G2 [get_ports {kypd_cols[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {kypd_cols[*]}]

# Rows (inputs)
set_property PACKAGE_PIN H1 [get_ports {kypd_rows[0]}]
set_property PACKAGE_PIN K2 [get_ports {kypd_rows[1]}]
set_property PACKAGE_PIN H2 [get_ports {kypd_rows[2]}]
set_property PACKAGE_PIN G3 [get_ports {kypd_rows[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {kypd_rows[*]}]

###############################################
# PMOD JSTK2 (JB)
###############################################
set_property PACKAGE_PIN A14 [get_ports jstk_miso]
set_property PACKAGE_PIN A16 [get_ports jstk_mosi]
set_property PACKAGE_PIN B15 [get_ports jstk_sck]
set_property PACKAGE_PIN B16 [get_ports jstk_cs]
set_property IOSTANDARD LVCMOS33 [get_ports {jstk_*}]

###############################################
# PMOD SF3 (JC)
###############################################
set_property PACKAGE_PIN D12 [get_ports flash_miso]
set_property PACKAGE_PIN D13 [get_ports flash_mosi]
set_property PACKAGE_PIN C12 [get_ports flash_sck]
set_property PACKAGE_PIN C13 [get_ports flash_cs]
set_property IOSTANDARD LVCMOS33 [get_ports {flash_*}]
