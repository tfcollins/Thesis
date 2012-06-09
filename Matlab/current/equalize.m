Tsym = 1e-6; % Symbol period (s)
bitsPerSymbol = 2;  % Number of bits per PSK symbol
M = 2.^bitsPerSymbol;  % PSK alphabet size (number of modulation levels)
nPayload = 400;  % Number of payload symbols
nTrain = 100;  % Number of training symbols
nTail = 20; % Number of tail symbols
pskmodObj = modem.pskmod(M); % Modulator object
hStream = RandStream.create('mt19937ar', 'seed', 12345);
% Training sequence symbols
xTrainSym = randi(hStream, [0 M-1], 1, nTrain);
% Modulated training sequence
xTrain = modulate(pskmodObj, xTrainSym);
% Tail sequence symbols
xTailSym = randi(hStream, [0 M-1], 1, nTail);
% Modulated tail sequence
xTail = modulate(pskmodObj, xTailSym);


%% Filter Parameters
nSymFilt = 8;  % Number of symbol periods spanned by each filter
osfFilt = 4;  % Oversampling factor for filter (samples per symbol)
rolloff = 0.25;  % Rolloff factor
Tsamp = Tsym/osfFilt; % TX signal sample period (s)
orderFilt = nSymFilt*osfFilt;  % Filter order (number of taps - 1)

% Filter responses and structures
hTxFilt = fdesign.interpolator(osfFilt, 'Square Root Raised Cosine', ...
    osfFilt, 'N,Beta', orderFilt, rolloff);
hRxFilt = fdesign.decimator(osfFilt, 'Square Root Raised Cosine', ...
    osfFilt, 'N,Beta', orderFilt, rolloff);
hDTxFilt = design(hTxFilt); hDRxFilt = design(hRxFilt);
hDTxFilt.PersistentMemory = true; hDRxFilt.PersistentMemory = true;

%% Add Noise
EsNodB = 20;  % Ratio of symbol energy to noise power spectral density (dB)
snrdB = EsNodB - 10*log10(osfFilt); % Signal-to-noise ratio per sample (dB)

%% Simulate
simName = 'Linear equalization for frequency-flat fading';  % Used to label figu
re window.

% Multipath channel
fd = 30;  % Maximum Doppler shift (Hz)
chan = rayleighchan(Tsamp, fd);  % Create channel object.
chan.ResetBeforeFiltering = 0;  % Allow state retention across blocks.

% Adaptive equalizer
nWeights = 1;  % Single weight
stepSize = 0.1;  % Step size for LMS algorithm
alg = lms(stepSize);  % Adaptive algorithm object
eqObj = lineareq(nWeights, alg, pskmodObj.Constellation);  % Equalizer object

% Link simulation
nBlocks = 50;  % Number of transmission blocks in simulation
for block = 1:nBlocks, commadapteqloop; end  % Run link simulation in a loop

%% Sim 2, with frequency selective fading
simName = 'Linear equalization for frequency-flat fading';  % Used to label figu
re window.

% Multipath channel
fd = 30;  % Maximum Doppler shift (Hz)
chan = rayleighchan(Tsamp, fd);  % Create channel object.
chan.ResetBeforeFiltering = 0;  % Allow state retention across blocks.

% Adaptive equalizer
nWeights = 1;  % Single weight
stepSize = 0.1;  % Step size for LMS algorithm
alg = lms(stepSize);  % Adaptive algorithm object
eqObj = lineareq(nWeights, alg, pskmodObj.Constellation);  % Equalizer object

% Link simulation
nBlocks = 50;  % Number of transmission blocks in simulation
for block = 1:nBlocks, commadapteqloop; end  % Run link simulation in a loop

%% Sim 3, DFE Decision Feedback Equalization
simName = 'Linear equalization for frequency-flat fading';  % Used to label figu
re window.

% Multipath channel
fd = 30;  % Maximum Doppler shift (Hz)
chan = rayleighchan(Tsamp, fd);  % Create channel object.
chan.ResetBeforeFiltering = 0;  % Allow state retention across blocks.

% Adaptive equalizer
nWeights = 1;  % Single weight
stepSize = 0.1;  % Step size for LMS algorithm
alg = lms(stepSize);  % Adaptive algorithm object
eqObj = lineareq(nWeights, alg, pskmodObj.Constellation);  % Equalizer object

% Link simulation
nBlocks = 50;  % Number of transmission blocks in simulation
for block = 1:nBlocks, commadapteqloop; end  % Run link simulation in a loop


