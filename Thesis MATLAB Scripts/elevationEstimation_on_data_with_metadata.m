%test alg for elevation angle only sweep
clear;
%data_rangeFar_180deg
%--------------------------------------------------------------------------
%Load Data
%--------------------------------------------------------------------------
files= dir('/Users/tschucker/Desktop/Thesis_data/Receiver_Off_Axis_7m/Altitude_200m/data_range_270deg_meta/*.csv');
num_files = length(files);
data = zeros(num_files,959006); %479000;
for i=1:num_files
     data(i,:)=transpose(csvread(strcat('/Users/tschucker/Desktop/Thesis_data/Receiver_Off_Axis_7m/Altitude_200m/data_range_270deg_meta/',files(i).name)));
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
data = sortrows(data,4);

location_data = data(:,1:6);
signal_data = data(:,7:end);

data_table = zeros(num_files,3);

for i=1:num_files
    
    [s,f,t,p] = spectrogram(signal_data(i,:),5000,500,5000,fs,'yaxis','centered');
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
   
    data_table(i,1) = max(upper_envelope); 
    data_table(i,2) = min(lower_envelope);
    
%     figure;
%     hold on
%     plot3(t/60,lower_envelope/1000,z,'b','linewidth',4)
%     plot3(t/60,upper_envelope/1000,z,'r','linewidth',4)
%     spectrogram(signal_data(i,:),5000,500,5000,fs,'yaxis','centered')
%     colormap(jet);
%     colorbar
%     view(2)
%     title(num2str(location_data(i,4)));
%     hold off
end

figure;
hold on

plot((location_data(:,5)/(2*pi))*360,data_table(:,1))
plot((location_data(:,5)/(2*pi))*360,data_table(:,2))
hold off
legend('Max Doppler Profile', 'Min Doppler Profile');
title('Max and Min Doppler Profile Frequencies vs Transmitter Elevation Angle');
xlabel('Transmitter Elevation Angle (deg)');
ylabel('Doppler Frequency (Hz)');

test_alg_angle = acos(data_table(:,1)/max_fd);
actual = location_data(:,5);

figure;
hold on
plot((actual/(2*pi))*360,(test_alg_angle/(2*pi))*360)
plot((actual/(2*pi))*360,(actual/(2*pi))*360)
hold off
title('Elevation Angle Comparason with Tx at Azimuth Angle of 180deg');
legend('Estimated Angle', 'Actual Angle');
xlabel('Elevation Angle Actual (deg)');
ylabel('Elevation Angle (deg)');

error = ((test_alg_angle - actual)./actual)*100;

figure;
plot((actual/(2*pi))*360,error)
title('Elevation Angle Percent Error vs Actual Elevation Angle');
xlabel('Elevation Angle (deg)');
ylabel('Error (%)');