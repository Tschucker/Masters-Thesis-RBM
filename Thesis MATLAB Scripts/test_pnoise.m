% Create 16-QAM modulator
    hMod = comm.RectangularQAMModulator(16, ...
        'NormalizationMethod','Average power', 'AveragePower',10);
% Create phase noise System object
    hPhNoise = comm.PhaseNoise('Level',[-35 -100], ...
        'FrequencyOffset',[10 200], ...
        'SampleRate',1024);
% Generate modulated symbols
    modData = step(hMod, randi([0 15], 1000, 1));
% Apply phase noise and plot the result
    y = step(hPhNoise, modData);
    scatterplot(y)