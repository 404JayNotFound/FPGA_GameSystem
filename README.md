# FPGA GameSystem  
Basys3 Hardware Platform for Simple 2D Games

This project creates a modular hardware platform on the Basys3 FPGA that can support simple 2D games such as Tetris, Snake or Pong. The aim is to design and integrate the hardware subsystems needed for games, including VGA output, keypad and joystick input and flash memory support.

---

### Hardware Used

- Pmod KYPD (16-button keypad)  
- Pmod JSTK2 (two-axis joystick with SPI interface)  
- Pmod SF3 (32 MB serial flash memory)  
- VGA output (25 MHz pixel clock generated from the Basys3 100 MHz clock)

---

---

## Project Goals

- Build a working FPGA platform that multiple small games can run on  
- Keep subsystems modular, testable and easy to extend  
- Implement stable VGA timing and pixel output  
- Handle keypad and joystick input  
- Add flash storage for simple settings or save data  
- Use a central System Controller to coordinate modules  

---

---

# System Architecture

### VGA Display Subsystem
- Generates HSYNC and VSYNC timing  
- Provides RGB pixel output  
- Uses BRAM for tilemap and sprite graphics  
- Targets 640×480 at 60 Hz  

---

### Input Subsystem
- Keypad scanning finite state machine  
- Debouncing for stable keypress detection  
- SPI interface for the joystick  
- Handles buttons and onboard switches  

---

### Flash Memory Subsystem
- SPI master for the Pmod SF3 module  
- Used for storing settings or simple save data  

---

### Game Core and System Controller
- Main finite state machine  
- Handles reset, menu, game and save states  
- Updates the VGA tilemap based on input  
- Communicates with flash and input subsystems  

---

### Clock, Reset and Top-Level Integration
- Generates the 25 MHz pixel clock  
- Distributes system reset  
- Connects all subsystem modules  
- Defines pin assignments through the .xdc file  

---

---

# Weekly Progress

## Week 1: Planning and Initial Setup
- Reviewed the project brief  
- Chose Tetris as a baseline target game  
- Designed the high-level block architecture  
- Assigned subsystem roles  
- Researched PMOD interfaces and VGA timing requirements  
- Planned inter-module communication  

---

## Week 2: Subsystem Development

### VGA Progress
- Generated HSYNC and VSYNC timing  
- Verified pixel clock generation  
- Displayed a simple alternating colour test pattern  
- Began planning tilemap BRAM usage  

### Input Progress
- Designed the keypad scanning FSM  
- Implemented keypad module in Verilog  
- Created a simulation testbench  
- Researched joystick SPI protocol  

### Integration Progress
- Created the first version of `top.v`  
- Started the `.xdc` constraint file  
- Defined signal connections and interfaces  
- Planned memory map structure  

---

## Week 3: Subsystem Integration

### Completed Work
- Integrated VGA, keypad and System Controller  
- Project builds and synthesizes without errors  
- VGA test pattern displays correctly on a monitor  
- Keypad input works at the top level  
- Cleaned project directory for GitHub  

### Next Steps
- Add flash memory subsystem  
- Add joystick subsystem  
- Link Game Core logic to VGA tilemap  

---

---

# Repository Structure

```
/src
    /vga
    /keypad
    /joystick
    /flash
    /system_controller
    /top
/xdc
/docs
/sim
README.md
```

---

# Tools Used

- Vivado WebPACK  
- Basys3 FPGA board  
- Vivado Simulator  
- ModelSim  
- GTKWave  
- GitHub for version control  

---

# Team Roles

- Member A: VGA and clock generation  
- Member B: Input and flash memory  
- Member C: System Controller and top-level integration  
