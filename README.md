# Waveform Wars – DSP Design Challenge

## Team Information

* **Team Name:** Ep
* **Team Leader:** Pothireddy Nishma Reddy
* **Team Members:** Sharath

---

## Project Overview

This repository contains the complete implementation for the **Waveform Wars – DSP Design Challenge**, addressing both mandatory problem statements using **pure Digital Signal Processing (DSP) techniques** implemented in **MATLAB**.

The project focuses on:

1. **Acoustic Echo Cancellation (AEC)** for hands-free systems using adaptive filtering
2. **Audio Source Separation (BSS)** using time–frequency analysis and spectral masking

No machine learning, pretrained models, or AI-based libraries are used, in strict compliance with the competition rules.

---

## Repository Structure

```
.
├── PS1_Acoustic_Echo_Cancellation.m
├── PS2_Audio_Source_Separation.m
├── removed_echo.wav
├── EXTRACTED_SPEECH.wav
├── EXTRACTED_INTERFERENCE.wav
├── Report.pdf
└── README.md
```

> Note: Output `.wav` files are generated after successful execution of the MATLAB scripts.

---

## Problem Statement 1: Acoustic Echo Cancellation

### Description

In hands-free audio systems, the microphone captures both the desired near-end speech and an undesired echo of the far-end loudspeaker signal. This module implements an **NLMS-based adaptive filter** to model the acoustic echo path and cancel the echo in real time.

### Key Techniques Used

* Normalized Least Mean Squares (NLMS) adaptive filtering
* Long-tap FIR filter for room impulse response modeling
* Energy-based stability handling during double-talk scenarios
* Residual noise suppression using soft gating

### Input

* Live microphone input
* Far-end reference signal (played audio)

### Output

* `removed_echo.wav` — echo-suppressed microphone signal

### How to Run

1. Connect a microphone and speaker/headphones
2. Open MATLAB
3. Run:

   ```matlab
   PS1_Acoustic_Echo_Cancellation
   ```
4. Speak during recording while audio plays
5. Output file will be saved automatically

---

## Problem Statement 2: Audio Source Separation

### Description

This module separates two simultaneously active audio sources (speech and tonal interference) from a single-channel recording using **STFT-based spectral masking**.

### Key Techniques Used

* Short-Time Fourier Transform (STFT)
* Statistical noise profiling
* Adaptive frequency-domain masking
* Median filtering for artifact reduction

### Input

* `mixed.wav` (placed in the `Downloads` directory)

### Output

* `EXTRACTED_SPEECH.wav` — separated speech signal
* `EXTRACTED_INTERFERENCE.wav` — separated tonal interference

### How to Run

1. Place `mixed.wav` in your system `Downloads` folder
2. Open MATLAB
3. Run:

   ```matlab
   PS2_Audio_Source_Separation
   ```
4. Output files will be saved to the `Downloads` directory

---

## Software Requirements

* MATLAB R2021a or later
* Signal Processing Toolbox
* DSP System Toolbox (for real-time audio I/O in PS1)

---

## Constraints and Compliance

✔ Pure DSP-based implementation
✔ No machine learning or neural networks
✔ No pretrained models or AI libraries
✔ Fully compliant with Waveform Wars competition rules

---

## Notes for Evaluation

* Filter lengths and step sizes are tunable for different acoustic environments
* Source separation assumes partial frequency-domain separability
* All algorithms are explainable and mathematically interpretable

---

## Acknowledgments

This project was developed as part of the **Waveform Wars – DSP Design Challenge**, focusing on real-world audio signal processing problems using classical DSP techniques.

---

**End of README**
