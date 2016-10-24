clear;

files= dir('/Users/tschucker/Desktop/Thesis_data/Receiver_Off_Axis_7m/Altitude_200m/data_tx0/*.csv');
num_files = length(files);
data = zeros(num_files,479000);
for i=1:num_files
     data(i,:)=transpose(csvread(strcat('/Users/tschucker/Desktop/Thesis_data/Receiver_Off_Axis_7m/Altitude_200m/data_tx0/',files(i).name)));
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
    
    t_fixed = 0:(1/(rpm/60))/length(t):(1/(rpm/60));
    t_fixed = t_fixed(2:end);
    
    log_power = 10*log10(p);
    [q,nd] = max(10*log10(p));
    
    ave_q(i) = mean(q);

    lower_envelope = zeros(length(t),1);
    upper_envelope = zeros(length(t),1);

    for slice = 1:length(t)
        for j = 1:2500
            if log_power(j,slice) > ave_q(i)
                lower_envelope(slice) = f(j);
                break;
            end  
        end
        for j = 2501:5000
            if (log_power(7501-j,slice) > ave_q(i)) && (log_power(7501-j,slice) ~= -inf)
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
%     
%     figure;
%     hold on
%     plot3(t_fixed,upper_envelope,z,'r','linewidth',4)
%     plot3(t_fixed,lower_envelope,z,'b','linewidth',4)
%     title(files(i).name);
%     legend('Upper Envelope', 'Lower Envelope');
%     xlabel('Time (s)');
%     ylabel('Doppler Frequency (Hz)');
%     hold off
    
    data_table(i,2) = min(lower_envelope);
    data_table(i,1) = max(upper_envelope); 
end

figure;
pitch = 0:30/(num_files-1):30;
hold on
plot(pitch,data_table(:,1))
plot(pitch,data_table(:,2))
hold off
legend('Max Doppler Profile', 'Min Doppler Profile');
title('Max and Min Envelope Frequencies vs Rotor Pitch');
xlabel('Rotor Pitch (deg)');
ylabel('Doppler Frequency (Hz)');