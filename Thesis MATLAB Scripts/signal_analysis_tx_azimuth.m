clear;

files= dir('/Users/tschucker/Desktop/Thesis_data/Receiver_Off_Axis_7m/Altitude_200m/rotate_degs_400m/*.csv');
num_files = length(files);
data = zeros(num_files,479000);
for i=1:num_files
     data(i,:)=transpose(csvread(strcat('/Users/tschucker/Desktop/Thesis_data/Receiver_Off_Axis_7m/Altitude_200m/rotate_degs_400m/',files(i).name)));
end

rpm = 250;
fs = 4000;
SNR = 50;

freqs = fftshift(fft(data,length(data),2),2);
freq = -fs/2:fs/size(freqs,2):fs/2;
freq = freq(1:end-1);

data_table = zeros(num_files,3);

for i=1:num_files
    [s,f,t,p] = spectrogram(data(i,:),5000,4000,5000,fs,'reassign','MinThreshold',-SNR,'yaxis','centered');
    angle_b1 = 0:(2*pi)/length(t):2*pi;
    angle_b2 = pi:(2*pi)/length(t):3*pi;
    z = zeros(1,length(t));
    
    log_power = 10*log10(p);
    [q,nd] = max(10*log10(p));

    lower_envelope = zeros(length(t),1);
    upper_envelope = zeros(length(t),1);

    for slice = 1:length(t)
        for j = 1:2500
            if log_power(j,slice) > -15
                lower_envelope(slice) = f(j);
                break;
            end  
        end
        for j = 2501:5000
            if (log_power(7501-j,slice) > -15) && (log_power(7501-j,slice) ~= -inf)
                upper_envelope(slice) = f(7501-j);
                break;
            end  
        end
    end
    
    lower_envelope = smooth(lower_envelope,.02);
    upper_envelope = smooth(upper_envelope,.02);
    
%     figure;
%     hold on
%     plot3(t/60,lower_envelope/1000,z,'w','linewidth',4)
%     plot3(t/60,upper_envelope/1000,z,'w','linewidth',4)
%     %plot3(t/60,f(nd)/1000,q,'r','linewidth',4)
%     %plot3(t/60,cos(angle_b1(1:end-1)),z);
%     %plot3(t/60,cos(angle_b2(1:end-1)),z);
%     spectrogram(data(i,:),5000,4000,5000,fs,'reassign','MinThreshold',-SNR,'yaxis','centered')
%     title(files(i).name);
%     hold off
%     colormap(jet);
%     colorbar
%     view(2)
   
    data_table(i,1) = max(upper_envelope); 
    data_table(i,2) = min(lower_envelope);
end

Azimuth = 0:(360)/(num_files - 1):360;

figure;
hold on
plot(Azimuth,data_table(:,1))
plot(Azimuth,data_table(:,2))
hold off
legend('Max Upper Envelope', 'Min Lower Envelope');
title('Max and Min Envelope Frequencies vs Transmitter Azimuth Angle');
xlabel('Transmitter Azimuth Angle (deg)');
ylabel('Doppler Frequency (Hz)');

difference_abs = data_table(:,1) + abs(data_table(:,2));
difference = data_table(:,1) + data_table(:,2);

figure;
hold on
plot(Azimuth,difference_abs)
plot(Azimuth,difference)
hold off

amplify = abs(difference)+difference_abs;
[M,I] = min(amplify);
figure;
plot(Azimuth,amplify)

angle_90deg = Azimuth(I);
