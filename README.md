# Waveform Wars – DSP Design Challenge

## Team Information

* **Team Name:** Ep
* **Team Leader:** Pothireddy Nishma Reddy
* **Team Members:** Sharath

---

## Project Overview

This repository contains the complete MATLAB-based implementation for the **Waveform Wars – DSP Design Challenge**. The project addresses **both mandatory problem statements** using **pure Digital Signal Processing (DSP) techniques**, strictly adhering to the competition rules (no machine learning or pretrained models).

The two problems solved are:

1. **Acoustic Echo Cancellation (AEC)** in hands-free systems
2. **Audio Source Separation (BSS)** using frequency-domain analysis

---

## Repository Structure

The repository is organized into clearly separated folders for code and results of each problem statement:

```
.
├── PS1/
│   └── Code/
│       └── echo_cancellation.m
│
├── PS1_RESULTS/
│   ├── removed_echo.wav
│   └── PS1_plots.png
│
├── PS2/
│   └── Code/
│       └── separation.m
│
├── PS2_RESULTS/
│   ├── EXTRACTED_SPEECH.wav
│   ├── EXTRACTED_INTERFERENCE.wav
│   └── PS2_spectrograms.png
│
├── Waveform Wars Team-Ep Report.pdf
└── README.md
```

---

## Problem Statement 1: Acoustic Echo Cancellation (PS1)

### Description

In hands-free audio systems, the microphone captures both the desired near-end speech and an undesired echo of the far-end loudspeaker signal. This module implements an **NLMS-based adaptive filter** to estimate the acoustic echo path and suppress the echo effectively.

### Techniques Used

* Normalized Least Mean Squares (NLMS) adaptive filtering
* Long-tap FIR filter for room impulse response modeling
* Energy-based stability handling for double-talk conditions
* Residual echo suppression using soft gating

### How to Run PS1

1. Navigate to the PS1 code directory:

   ```bash
   cd PS1/Code
   ```
2. Open MATLAB and run:

   ```matlab
   Acoustic_Echo_Cancellation
   ```
3. Ensure a microphone and speaker/headphones are connected
4. Speak during the recording phase while audio plays

### Output

All results are stored in the **PS1_RESULTS/** folder:

* `removed_echo.wav` – Echo-cancelled microphone signal
* Time-domain waveform plots

---

## Problem Statement 2: Audio Source Separation (PS2)

### Description

This module separates two simultaneously active audio sources (speech and tonal interference) from a single-channel recording using **STFT-based spectral masking**, without any learning-based methods.

### Techniques Used

* Short-Time Fourier Transform (STFT)
* Statistical noise profiling from initial frames
* Adaptive frequency-domain masking
* Median filtering for artifact reduction

### How to Run PS2

1. Place the input file `mixed.wav` in your system **Downloads** directory
2. Navigate to the PS2 code directory:

   ```bash
   cd PS2/Code
   ```
3. Open MATLAB and run:

   ```matlab
   Audio_Source_Separation
   ```

### Output

All results are stored in the **PS2_RESULTS/** folder:

* `EXTRACTED_SPEECH.wav` – Separated speech signal
* `EXTRACTED_INTERFERENCE.wav` – Separated interference signal
* Spectrogram visualizations

---

## Software Requirements

* MATLAB R2021a or later
* Signal Processing Toolbox
* DSP System Toolbox (required for real-time audio I/O in PS1)

---

## Compliance Statement

✔ Pure DSP-based implementation
✔ No machine learning or neural networks
✔ No pretrained models or AI libraries
✔ Fully compliant with Waveform Wars competition rules

---

## Notes for Evaluators

* Filter length and step size parameters are configurable for different acoustic environments
* Source separation assumes partial frequency-domain separability
* All algorithms are mathematically interpretable and explainable

---

## Acknowledgments

This project was developed as part of the **Waveform Wars – DSP Design Challenge**, focusing on real-world audio signal processing problems using classical DSP techniques.

---

**End of README**
