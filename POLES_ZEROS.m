
%% REMEMBER TO LOOK HANDS OS WEEK 6
[signal, Fs] = audioread('Pop1.wav');
signal = signal(:, 1); 

order = 12;
A = lpc(signal, order);
B = 1; 

% Compute and display poles and zeros
poles = roots(A); 
zeros = roots(B); 
disp('Poles:');
disp(poles);
disp('Zeros:');
disp(zeros);

% Define numerator and denominator coefficients
B = poly(zeros); 
A = poly(poles); 

% Plot the pole-zero plot
figure;
zplane(B, A);
title('Pole-Zero Plot');

% Plot the frequency response
figure;
freqz(B, A, 1024, Fs);
title('Frequency Response');

% Plot the impulse response
figure;
impz(B, A);
title('Impulse Response');

% Move zeros and poles to new locations
new_zeros = 1.05 * zeros; 
new_poles = 1.05 * poles; 

%NEWWWWWW
B_new = poly(new_zeros);
A_new = poly(new_poles);

%UPDATED PLOT
figure;
zplane(B_new, A_new);
title('Updated Pole-Zero Plot');
figure;
freqz(B_new, A_new, 1024, Fs);
title('Updated Frequency Response');
figure;
impz(B_new, A_new);
title('Updated Impulse Response');
