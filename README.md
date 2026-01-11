# README — DEP & BTP Projects

This repository documents two major academic projects:
1. **DEP (Device Engineering Project)** — ULPAC: Ultra-Low-Power Atomic Clock  
2. **BTP (Bachelor Thesis Project)** — Transistor Implementation of a Bandgap Reference (BGR) for a Current Driver

---

## 1. DEP — ULPAC (Device Engineering Project)

**Title:** ULPAC — A Miniaturized Ultra-Low-Power Atomic Clock  

### Overview
The Device Engineering Project (DEP) focuses on the design, modeling, and simulation of a **Chip-Scale Atomic Clock (CSAC)** front-end using **Coherent Population Trapping (CPT)**. The system employs a directly modulated **VCSEL operating at 894.6 nm** (Cs D₁ line) and a control loop that locks the laser bias current to the CPT resonance minimum.

The project emphasizes ultra-low-power operation while maintaining frequency stability suitable for precision timing applications.

### Key Components
- **VCSEL Modeling**
  - Bias current vs wavelength relationship
  - Power-efficient operation for CSAC applications
- **CPT Physics Package**
  - Three-level Λ system
  - Narrow resonance linewidth and high Q-factor
- **Lock-in Detection**
  - Phase-sensitive detection to extract the CPT error signal
  - Low-pass filtering to obtain a stable DC discriminator
- **System Controller**
  - Two-point coarse and fine tuning algorithm
  - Bias current optimization and disturbance rejection

### Tools & Methods
- MATLAB and Simulink for system-level modeling
- Analytical modeling of VCSEL behavior
- Simulation of controller convergence and robustness

### Outcome
The project successfully demonstrates:
- Stable locking of VCSEL bias current to CPT resonance
- Robust recovery from disturbances
- Feasibility of an ultra-low-power atomic frequency reference

---

## 2. BTP — Transistor Implementation of BGR for Current Driver

**Title:** Transistor Implementation of a Bandgap Reference (BGR) for VCSEL Current Driver  

### Overview
The Bachelor Thesis Project (BTP) focuses on the **design and transistor-level implementation of a Bandgap Reference (BGR)** intended for use in a **VCSEL current driver**. The BGR provides a temperature- and supply-independent reference voltage essential for stable laser biasing.

### Key Features
- **Banba-style Low-Voltage BGR**
  - Combination of PTAT and CTAT components
  - Designed for low supply voltage operation (~1.2 V)
- **Operational Amplifier Design**
  - Initial ideal op-amp based analysis
  - Final implementation using a **5-transistor OTA**
- **Stability Enhancement**
  - Miller compensation for improved phase margin
  - Starter circuit considerations for reliable biasing

### Simulations & Results
- Cadence-based DC, AC, and transient simulations
- Reference voltage ≈ 0.6 V at 1.2 V supply
- Temperature sweep shows improved stability with OTA-based design
- Bode plots confirm adequate gain and phase margin

### Tools Used
- Cadence Virtuoso for schematic design and simulation
- AC, DC, and transient analyses for verification

---

## 3. Repository Contents

- `DEP_Report (CP301) (3).pdf`  
  Full report detailing the ULPAC Device Engineering Project, including theory, modeling, simulations, and results.

- `BTP (Transistor Implementation of BGR for Current Driver).pptx`  
  Presentation containing circuit schematics, Cadence simulation results, and design insights for the BGR and OTA.

---

## 4. Authors & Credits

### DEP — Device Engineering Project
- **Authors:** Aryan Arora, Srijan Kumar Kar  
- **Mentor:** Azhar Yaseen N.J.  
- **Supervisor:** Dr. Devarshi Mrinal Das  

### BTP — Bachelor Thesis Project
- Project work documented in the BTP presentation slides  
- Author details as per the title slide / presentation metadata

---

## 5. Notes

- The BGR designed in the BTP is intended to serve as a stable bias/reference block for the VCSEL driver used in the DEP system.
- Together, these projects demonstrate a complete flow from **device-level physics and control** to **transistor-level circuit implementation**.

---



.
