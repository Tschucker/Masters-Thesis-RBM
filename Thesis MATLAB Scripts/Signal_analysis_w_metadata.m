%test alg for elevation angle only sweep
clear;

%--------------------------------------------------------------------------
%Load Data
%--------------------------------------------------------------------------
files= dir('/Users/tschucker/Desktop/Thesis_data/Receiver_Off_Axis_7m/Altitude_200m/pitch7.5deg_rotation_200m2/*.csv');
num_files = length(files);
%data = zeros(num_files,959006); %479000;
for i=1:num_files
     data(i,:)=transpose(csvread(strcat('/Users/tschucker/Desktop/Thesis_data/Receiver_Off_Axis_7m/Altitude_200m/pitch7.5deg_rotation_200m2/',files(i).name)));
end

%--------------------------------------------------------------------------
%Known Constants
%--------------------------------------------------------------------------
fs = 4000;
RPM = 250;
fc = 1e9;
c = 3e8;

Reflection_radius = 7.5;
v = ((2*pi)/60)*RPM*Reflection_radius;
max_fd = 2*(v*fc)/c;

%--------------------------------------------------------------------------
%Find Doppler Envelopes
%--------------------------------------------------------------------------

%sort data by radius r
%data = sortrows(data,4);

location_data = data(:,1:6);
signal_data = data(:,7:end);

data_table = zeros(num_files,3);

window = 5000;
noverlap = 500;

%signal_data = decimate(signal_data,10);
% Fpass = 1000;
% Fstop = 1400;
% Apass = 1;
% Astop = 200;
% Fs = 4e3;
% 
% d = designfilt('lowpassfir', ...
%   'PassbandFrequency',Fpass,'StopbandFrequency',Fstop, ...
%   'PassbandRipple',Apass,'StopbandAttenuation',Astop, ...
%   'DesignMethod','equiripple','SampleRate',Fs);
% 
% fvtool(d)
% 
% signal_data = filter(d,signal_data);

for i=1:num_files
    
    [s,f,t,p] = spectrogram(signal_data(i,:),window,noverlap,window,fs,'yaxis','centered');
    angle_b1 = 0:(2*pi)/length(t):2*pi;
    angle_b2 = pi:(2*pi)/length(t):3*pi;
    z = zeros(1,length(t));
    
    log_power = 10*log10(p);
    [q,nd] = max(10*log10(p));
    
    ave_q(i) = mean(q);
    ave_q_now(i) = mean(ave_q);
    
    lower_envelope = zeros(length(t),1);
    upper_envelope = zeros(length(t),1);

    for slice = 1:length(t)
        for j = 1:(window/2)
            if log_power(j,slice) > ave_q_now(i)
                lower_envelope(slice) = f(j);
                break;
            end  
        end
        for j = ((window/2)+1):window
            if (log_power((((window/2)+1)+ window)-j,slice) > ave_q_now(i)) && (log_power((((window/2)+1)+ window)-j,slice) ~= -inf)
                upper_envelope(slice) = f((((window/2)+1)+ window)-j);
                break;
            end  
        end
    end
    
    lower_envelope = smooth(lower_envelope,.02);
    upper_envelope = smooth(upper_envelope,.02);
   
    data_table(i,1) = max(upper_envelope); 
    data_table(i,2) = min(lower_envelope);
     
%     figure;
%     hold on
%     spectrogram(signal_data(i,:),window,noverlap,window,fs,'yaxis','centered')
%     plot3(t/60,lower_envelope/1000,z,'b','linewidth',4)
%     plot3(t/60,upper_envelope/1000,z,'r','linewidth',4)
%     colormap(jet);
%     colorbar
%     view(2)
%     title(num2str(location_data(i,4)));
%     hold off
    
%     n = 2^nextpow2(length(signal_data(i,:)));
%     Y = fftshift(fft(signal_data(i,:),n));
%     f = fs*((-n/2):(n/2))/n;
%     f = f(1:end-1);
%     P = abs(Y/n);
%     figure;
%     plot(f,abs(Y))
    
end
Azimuth = 0:(360)/(num_files - 1):360;
figure;
hold on
plot(Azimuth,data_table(:,1))
plot(Azimuth,data_table(:,2))
hold off
legend('Max Upper Envelope', 'Min Lower Envelope');
title('Max and Min Envelope Frequencies vs Transmitter Azimuth Angle with 7.5deg Pitch');
xlabel('Transmitter Azimuth Angle (deg)');
ylabel('Doppler Frequency (Hz)');

% figure;
% plot(abs(signal_data(1,:)))