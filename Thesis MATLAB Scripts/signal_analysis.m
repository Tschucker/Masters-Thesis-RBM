clear;
total_samples = 479000;%959000 

files= dir('/Users/tschucker/Desktop/Thesis_data/Receiver_Off_Axis_7m/Altitude_200m/rotate_degs_200m/*.csv');
num_files = length(files);
data = zeros(num_files,total_samples);
for i=1:num_files
     data(i,:)=transpose(csvread(strcat('/Users/tschucker/Desktop/Thesis_data/Receiver_Off_Axis_7m/Altitude_200m/rotate_degs_200m/',files(i).name)));
end

rpm = 250;
fs = 4000;
fs_real = 1/((1/(rpm/60))/total_samples);
SNR = 50;
%'reassign','MinThreshold',-SNR,

data_table = zeros(num_files,3);

upper_envelope_table = zeros(num_files,106);
lower_envelope_table = zeros(num_files,106);

for i=1:num_files
    [s,f,t,p] = spectrogram(data(i,:),5000,500,5000,fs,'yaxis','centered');
    angle_b1 = 0:(2*pi)/length(t):2*pi;
    angle_b2 = pi:(2*pi)/length(t):3*pi;
    z = zeros(1,length(t));
    
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
%     
%     hold on
%     plot3(t/60,lower_envelope/1000,z,'w','linewidth',4)
%     plot3(t/60,upper_envelope/1000,z,'w','linewidth',4)
%     plot3(t/60,f(nd)/1000,q,'r','linewidth',4)
%     spectrogram(data(i,:),5000,500,5000,fs,'yaxis','centered')
%     colormap(jet);
%     colorbar
%     view(2)
%     title(files(i).name);
%     hold off
%     
%     upper_envelope_table(i,:) = upper_envelope;
%     lower_envelope_table(i,:) = lower_envelope;
    
%     figure;
%     hold on
%     plot(upper_envelope)
%     plot(lower_envelope)
%     hold off
    
    data_table(i,2) = min(lower_envelope);
    data_table(i,1) = max(upper_envelope);
    
end

Azimuth = 0:(360)/(num_files - 1):360;%not correct needs to be elevation

figure;
hold on
plot(Azimuth,data_table(:,1))
plot(Azimuth,data_table(:,2))
hold off
legend('Max Doppler Profile', 'Min Doppler Profile');
title('Max and Min Envelope Frequencies vs Transmitter Azimuth Angle');
xlabel('Transmitter Azimuth Angle (deg)');
ylabel('Doppler Frequency (Hz)');

figure;
plot(ave_q)