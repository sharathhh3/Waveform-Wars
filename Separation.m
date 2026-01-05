% =========================================================================
% BSS FINAL (FIXED): CORRECTED SOURCE SEPARATION & RECONSTRUCTION
% =========================================================================
clear; clc; close all;

% 1. LOAD INPUT
[~, homeDir] = system('echo $HOME'); homeDir = strtrim(homeDir);
inputPath = fullfile(homeDir, 'Downloads', 'mixed.wav');
[mix, Fs] = audioread(inputPath);
if size(mix, 2) > 1; mix = mean(mix, 2); end 

% 2. STFT 
winLen = 1024; overlap = 768; nfft = 2048;
win = hamming(winLen, 'periodic');
[S, F, T] = stft(mix, Fs, 'Window', win, 'OverlapLength', overlap, 'FFTLength', nfft);
S_mag = abs(S);
S_phase = angle(S);

% 3. ESTIMATE INTERFERENCE (The "Yellow Bands")
% We analyze the first few frames to find the exact frequency of the tonal noise.
noise_profile = mean(S_mag(:, 1:40), 2); 
noise_std = std(S_mag(:, 1:40), 0, 2);

% 4. DUAL-CHANNEL RECONSTRUCTION
[rows, cols] = size(S_mag);
S_Source1_Mag = zeros(rows, cols); % This will be our SPEECH
S_Source2_Mag = zeros(rows, cols); % This will be our NOISE/FLUTE

% Threshold for Tonal/Constant Interference
tonal_thresh = noise_profile + (1.5 * noise_std); 

for t = 1:cols
    % Identify which bins belong to the tonal interference bands
    is_tonal = S_mag(:, t) > tonal_thresh & (S_mag(:, t) < noise_profile * 5); 
    
    % Source 2 (Noise/Flute): Collects the tonal horizontal energy
    S_Source2_Mag(is_tonal, t) = S_mag(is_tonal, t);
    
    % Source 1 (Speech): Collects everything else, then applies a light Wiener filter
    % to suppress the remaining background hiss.
    speech_mask = ~is_tonal;
    S_Source1_Mag(speech_mask, t) = max(S_mag(speech_mask, t) - noise_profile(speech_mask), 0.05 * S_mag(speech_mask, t));
end

% 5. POLISHING (Median Filter specifically on Speech to remove artifacts)
S_Source1_Mag = medfilt2(S_Source1_Mag, [1 3]);

% 6. TIME-DOMAIN RECONSTRUCTION
S_Speech = S_Source1_Mag .* exp(1i * S_phase);
S_Noise  = S_Source2_Mag .* exp(1i * S_phase);

sep_speech = real(istft(S_Speech, Fs, 'Window', win, 'OverlapLength', overlap, 'FFTLength', nfft));
sep_noise  = real(istft(S_Noise, Fs, 'Window', win, 'OverlapLength', overlap, 'FFTLength', nfft));

% 7. NORMALIZE & SAVE (Explicitly Labelled)
sep_speech = sep_speech / (max(abs(sep_speech)) + eps);
sep_noise  = sep_noise / (max(abs(sep_noise)) + eps);

audiowrite(fullfile(homeDir, 'Downloads', 'EXTRACTED_SPEECH.wav'), sep_speech, Fs);
audiowrite(fullfile(homeDir, 'Downloads', 'EXTRACTED_INTERFERENCE.wav'), sep_noise, Fs);

% 8. VISUAL VERIFICATION
figure('Name', 'Source Separation: Final Validation');
subplot(2,1,1); imagesc(T, F, 20*log10(S_Source1_Mag + eps)); axis xy; 
title('Extracted Speech Channel'); ylabel('Frequency (Hz)');
subplot(2,1,2); imagesc(T, F, 20*log10(S_Source2_Mag + eps)); axis xy; 
title('Extracted Interference Channel (The Yellow Bands)'); ylabel('Frequency (Hz)');
colormap jet;