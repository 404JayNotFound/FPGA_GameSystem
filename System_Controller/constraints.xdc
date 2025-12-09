## Clock
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

## Reset
set_property PACKAGE_PIN U18 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

## VGA signals
set_property PACKAGE_PIN V4 [get_ports hsync]
set_property PACKAGE_PIN T4 [get_ports vsync]

set_property PACKAGE_PIN R3 [get_ports {vga_r[3]}]
set_property PACKAGE_PIN R4 [get_ports {vga_r[2]}]
set_property PACKAGE_PIN N3 [get_ports {vga_r[1]}]
set_property PACKAGE_PIN N4 [get_ports {vga_r[0]}]

set_property PACKAGE_PIN K3 [get_ports {vga_g[3]}]
set_property PACKAGE_PIN K4 [get_ports {vga_g[2]}]
set_property PACKAGE_PIN J3 [get_ports {vga_g[1]}]
set_property PACKAGE_PIN J4 [get_ports {vga_g[0]}]

set_property PACKAGE_PIN U3 [get_ports {vga_b[3]}]
set_property PACKAGE_PIN U4 [get_ports {vga_b[2]}]
set_property PACKAGE_PIN V3 [get_ports {vga_b[1]}]
set_property PACKAGE_PIN V5 [get_ports {vga_b[0]}]

## Keypad rows (inputs)
# Replace these with the PMOD header pins you use
# set_property PACKAGE_PIN ? [get_ports {kypd_rows[0]}]
# set_property PACKAGE_PIN ? [get_ports {kypd_rows[1]}]
# set_property PACKAGE_PIN ? [get_ports {kypd_rows[2]}]
# set_property PACKAGE_PIN ? [get_ports {kypd_rows[3]}]

## Keypad columns (outputs)
# set_property PACKAGE_PIN ? [get_ports {kypd_cols[0]}]
# set_property PACKAGE_PIN ? [get_ports {kypd_cols[1]}]
# set_property PACKAGE_PIN ? [get_ports {kypd_cols[2]}]
# set_property PACKAGE_PIN ? [get_ports {kypd_cols[3]}]

## Joystick SPI pins
# Placeholder until Member B provides module
# set_property PACKAGE_PIN ? [get_ports jstk_sck]

## Flash SPI pins
# Placeholder until Member B provides module
# set_property PACKAGE_PIN ? [get_ports flash_cs]
