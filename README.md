# DPLL_VSDSquadronFPGAMini

---

## 🧠 Introduction

This project implements a simplified **Digital Phase-Locked Loop (DPLL)** on an FPGA board using Verilog HDL. A DPLL is an essential building block in many **digital communication** and **signal processing systems**, primarily used to synchronize a locally generated signal (usually a clock or data stream) with an incoming reference signal.

### 🔍 What is a DPLL?

A **DPLL (Digital Phase-Locked Loop)** is the digital version of an analog Phase-Locked Loop (PLL). It has the same primary function: **tracking the phase and frequency** of a reference clock. In digital implementations, this is typically done using discrete-time components:

* **Phase Detector (PD)**: Compares the phase of input and output signals.
* **Loop Filter (usually just a register in simple DPLLs)**: Smooths the phase error.
* **Numerically Controlled Oscillator (NCO)**: Updates the output frequency based on the filtered error.

Together, these form a feedback system that locks onto the reference frequency and maintains synchronization.

### ⚙️ How This Project Works

* The `dpll_top.v` module implements the DPLL logic using a **simple counter-based phase accumulator**, allowing you to simulate phase alignment.
* The **RGB LEDs** on the FPGA board indicate the phase/frequency by blinking at rates proportional to the DPLL’s internal oscillator output.

  * Green, red, and blue lights blink in a pattern based on the generated clock frequency.
  * This creates a **visible indicator** of frequency changes based on different control values (phase increments).

### 🧪 Simulation and Testing

* You can simulate the design using **Icarus Verilog** and **GTKWave**:

  * The testbench (`dpll_tb.v`) generates inputs and checks the DPLL output behavior.
  * Waveforms (`dpll.vcd`) show how the phase accumulator and output clock behave over time.
* This simulation helps **validate the logic before deploying to hardware**, especially useful for debugging or academic demonstration.

### 📟 Hardware Implementation

* The design is built and flashed using **Yosys**, **nextpnr**, and **openFPGALoader**.
* The board used is the **Tang Nano 9K**, which provides:

  * 3 controllable RGB LEDs.
  * On-board USB for power, flashing, and optional UART.
* After flashing, the LED pattern changes reflect different `phase_inc` values.

---

### 🚀 Significance and Applications

The DPLL design is a simple but powerful example of how **feedback systems** can be implemented digitally. It’s relevant to:

* **Clock data recovery** (e.g., in Ethernet, USB)
* **Digital demodulation** (e.g., BPSK/QPSK)
* **Synthesizers and modulation systems**
* **Timing synchronization** in software-defined radios

This project showcases not only **hardware design skills** (Verilog, synthesis, flashing) but also **software integration** (UART communication, simulation). It’s ideal for learning how digital feedback control loops work in real time.

---


