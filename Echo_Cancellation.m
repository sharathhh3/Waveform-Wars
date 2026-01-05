clear; clc;

% 1. PARAMETERS & CONFIGURATION
Fs = 16000;             
RecordDuration = 10;    
FrameSize = 512;        
M = 512;                % Filter taps
mu_max = 0.15;          
delta = 1e-3;
geigel_threshold = 0.5;

% Load music (Far-End)
load handel; 
music_audio = resample(y, Fs, 8192);
music_audio = music_audio / max(abs(music_audio)) * 0.4; 
L_music = length(music_audio); % Actual length of music file

% 2. HARDWARE SETUP
try
    deviceReader = audioDeviceReader('SampleRate', Fs, 'SamplesPerFrame', FrameSize);
    deviceWriter = audioDeviceWriter('SampleRate', Fs);
catch
    error('Audio hardware not found. Ensure your mic and speakers are connected.');
end

% Storage for recording
total_samples = RecordDuration * Fs;
num_frames = floor(total_samples / FrameSize);

recorded_mic = zeros(num_frames * FrameSize, 1);
reference_music = zeros(num_frames * FrameSize, 1);
output_signal = zeros(num_frames * FrameSize, 1);

% 3. LIVE RECORDING & PLAYBACK PHASE
fprintf('--- PHASE 1: RECORDING (10 SECONDS) ---\n');
fprintf('Starting in 3... 2... 1...\n');
pause(3);

fprintf('RECORDING STARTED! Speak now...\n');
music_ptr = 1;

for k = 1 : num_frames
    % --- FIXED INDEXING LOGIC ---
    % If music is about to run out, wrap back to the beginning
    if (music_ptr + FrameSize - 1) > L_music
        music_ptr = 1; 
    end
    
    idx_music = music_ptr : (music_ptr + FrameSize - 1);
    idx_storage = (k-1)*FrameSize + (1:FrameSize);
    
    % Get Music Frame
    x_frame = music_audio(idx_music);
    music_ptr = music_ptr + FrameSize;
    
    % Play music and simultaneously read mic
    deviceWriter(x_frame); 
    d_frame = deviceReader();
    
    % Store raw signals
    recorded_mic(idx_storage) = d_frame;
    reference_music(idx_storage) = x_frame;
end

release(deviceReader);
release(deviceWriter);
fprintf('RECORDING FINISHED.\n\n');

% 4. ENHANCED POST-PROCESSING
fprintf('--- PHASE 2: ENHANCED FILTERING ---\n');
M = 1024;               % Increase taps for better room coverage
w = zeros(M, 1);
x_buffer = zeros(M, 1);
mu_max = 0.25;          % Slightly higher for faster convergence
delta = 1e-2;           % Increased for stability

for k = 1:num_frames
    idx = (k-1)*FrameSize + (1:FrameSize);
    x_frame = reference_music(idx);
    d_frame = recorded_mic(idx);
    
    % Use a smoothed energy estimate for better DTD
    mic_energy = sum(d_frame.^2);
    far_energy = sum(x_buffer.^2) + eps;
    
    e_frame = zeros(FrameSize, 1);
    for n = 1:FrameSize
        x_buffer = [x_frame(n); x_buffer(1:M-1)];
        y_est = w' * x_buffer;
        err = d_frame(n) - y_est;
        
        % Adaptive step size logic
        norm_term = (x_buffer' * x_buffer) + delta;
        w = w + (mu_max / norm_term) * err * x_buffer;
        
        e_frame(n) = err;
    end
    
    % Simple "Soft-Gate" to clean up residual noise
    residual_power = mean(e_frame.^2);
    if residual_power < 0.005
        e_frame = e_frame * 0.5; % Attenuate noise floor
    end
    
    output_signal(idx) = e_frame;
end

% 5. SAVE AND PLOT
% Normalize output to prevent clipping in the wav file
output_signal = output_signal / max(abs(output_signal) + eps);

audiowrite('removed_echo.wav', output_signal, Fs);
fprintf('✓ Success! File saved as "removed_echo.wav"\n');

% Visualization
figure('Name', 'AEC Performance');
t_axis = (0:length(output_signal)-1)/Fs;
subplot(2,1,1);
plot(t_axis, recorded_mic);
title('Original Microphone Input (Music Echo + Your Voice)');
grid on; ylabel('Amplitude');

subplot(2,1,2);
plot(t_axis, output_signal);
title('Processed Output (Echo Removed - "removed\_echo.wav")');
grid on; ylabel('Amplitude'); xlabel('Time (s)');