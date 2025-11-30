# FPGA GameSystem

**Basys3 Hardware Platform for Simple 2D Games**  

A modular FPGA platform supporting simple 2D games such as **Tetris**, **Snake**, or **Pong**. Integrates VGA output, keypad & joystick input, and flash memory support.

---

## Table of Contents
- [Hardware Used](#hardware-used)  
- [Project Goals](#project-goals)  
- [System Architecture](#system-architecture)  
- [Weekly Progress](#weekly-progress)  
- [Repository Structure](#repository-structure)  
- [Tools Used](#tools-used)  
- [Team Roles](#team-roles)  

---

## Hardware Used


| Component   | Description |
|------------|-------------|
| Pmod KYPD  | 16-button keypad |
| Pmod JSTK2 | Two-axis joystick with SPI |
| Pmod SF3   | 32 MB serial flash memory |
| VGA Output | 640×480 @ 60 Hz, 25 MHz pixel clock generated from Basys3 100 MHz clock |

---

## Project Goals

- Build a working FPGA platform capable of running multiple small games  
- Maintain **modularity, testability, and extensibility**  
- Implement **stable VGA timing and pixel output**  
- Handle **keypad and joystick input** reliably  
- Add flash storage for simple settings or save data  
- Coordinate modules via a central **System Controller**  

---

## System Architecture

| Subsystem | Description |
|-----------|-------------|
| **VGA Display** | HSYNC & VSYNC generation, RGB pixel output, BRAM for tilemaps & sprites, 640×480 @ 60 Hz |
| **Input** | Keypad scanning FSM with debouncing, SPI joystick interface, onboard switches & buttons |
| **Flash Memory** | SPI master interface for storing settings or save data |
| **Game Core & System Controller** | Main FSM handling reset, menu, game & save states; updates VGA tilemap; communicates with flash & input subsystems |
| **Clock, Reset & Top-Level Integration** | Generates 25 MHz pixel clock from 100 MHz board clock; distributes reset; connects all modules; defines `.xdc` pin assignments |
 

---

## Weekly Progress

| Week | Focus | Achievements | Next Steps |
|------|-------|--------------|------------|
| 1 | [Planning & Initial Setup](Reports/1_Week1_HDL_Report.pdf) | High-level block design, subsystem roles assigned, researched PMOD interfaces and VGA timing | Prepare for subsystem development |
| 2 | [Subsystem Development](Reports/2_ReportWeek2_HDL.pdf) | VGA timing verified, color test pattern displayed; keypad FSM implemented and simulated | Add joystick & flash memory subsystem |
| 3 | [Subsystem Integration](Reports/3_Week%203%20Project%20Report.pdf) | VGA + keypad integrated, project builds successfully, test patterns display correctly | Integrate flash memory, joystick, and Game Core logic |

---

## Repository Structure
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

## Tools Used

- Vivado WebPACK  
- Basys3 FPGA board  
- Vivado Simulator  
- ModelSim  
- GTKWave  
- GitHub for version control  

---

## Team Roles

- [Cathal O'Regan](https://github.com/oregancathal123) - VGA and clock generation

- [Jamie O'Connor](https://github.com/404JayNotFound) - [Input and flash memory](InputMemory_Subsystem) 

- [Alan O'Connell](https://github.com/Alan64578) - System Controller and top-level integration

