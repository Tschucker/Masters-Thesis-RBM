%envelope calculation
clear;
%test_locationdatainfile_4
%Altitude_200m/rx_test_Bistatic_dop0.000000rad2
samples = csvread('/Users/tschucker/Desktop/Thesis_data/Receiver_Off_Axis_7m/.csv');
rpm = 250;

%B = horzcat(samples,samples)';

% altitude = samples(1);
% tx_x = samples(2);
% tx_y = samples(3);
% r = samples(4);
% elevation = samples(5);
% azimuth = samples(6);

location = samples(1:6);

samples = samples(7:end);

figure;
plot(real(samples))

fs = 4000;%program
fs_real = 1/((1/(rpm/60))/length(samples));
SNR = 50;

[s,f,t,p] = spectrogram(samples,5000,500,5000,fs_real,'reassign','MinThreshold',-SNR,'yaxis','centered');
log_power = 10*log10(p);
[q,nd] = max(10*log10(p));

ave_q = mean(q);

lower_envelope = zeros(length(t),1);
upper_envelope = zeros(length(t),1);

for i = 1:length(t)
    for j = 1:2500
        if log_power(j,i) > ave_q
            lower_envelope(i) = f(j);
            break;
        end  
    end
    for j = 2501:5000
        if (log_power(7501-j,i) > ave_q) && (log_power(7501-j,i) ~= -inf)
            upper_envelope(i) = f(7501-j);
            break;
        end  
    end
end

angle_b1 = 0:(2*pi)/length(t):2*pi;
angle_b2 = pi:(2*pi)/length(t):3*pi;
z = zeros(1,length(t));

figure;
hold on
plot3(t*1000,smooth(lower_envelope/1e6,.02),z,'b','linewidth',4)
plot3(t*1000,smooth(upper_envelope/1e6,.02),z,'r','linewidth',4)
%plot3(t*1000,cos(angle_b1(1:end-1)),z);
%plot3(t*1000,cos(angle_b2(1:end-1)),z);
legend('Lower Doppler Profile','Upper Doppler Profile');
spectrogram(samples,5000,500,5000,fs_real,'yaxis','centered')
hold off
ylabel('Doppler Frequency (kHz)');
colormap(jet);
colorbar
view(2)

figure;
periodogram(samples,rectwin(length(samples)),length(samples),fs,'centered')
