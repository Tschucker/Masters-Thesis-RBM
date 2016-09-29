%test alg for azimuth angle
clear;

files= dir('/Users/tschucker/Desktop/Thesis_data/Receiver_Off_Axis_7m/Altitude_200m/rotate_degs_50m/*.csv');
num_files = length(files);
data = zeros(num_files,479000); %959000;
for i=1:num_files
     data(i,:)=transpose(csvread(strcat('/Users/tschucker/Desktop/Thesis_data/Receiver_Off_Axis_7m/Altitude_200m/rotate_degs_50m/',files(i).name)));
end

rpm = 250;
fs = 4000;
SNR = 50;

%shift data for different start sections
%data = circshift(data,31,1);

data_table = zeros(num_files,3);

for i=1:num_files
    [s,f,t,p] = spectrogram(data(i,:),5000,4000,5000,fs,'reassign','MinThreshold',-SNR,'yaxis','centered');
    angle_b1 = 0:(2*pi)/length(t):2*pi;
    angle_b2 = pi:(2*pi)/length(t):3*pi;
    z = zeros(1,length(t));
    
    log_power = 10*log10(p);
    [q,nd] = max(10*log10(p));
    
    [M_q,I_q] = max(abs(nd-2500));
    
    lower_envelope = zeros(length(t),1);
    upper_envelope = zeros(length(t),1);

    for slice = 1:length(t)
        for j = 1:2500
            if log_power(j,slice) > -10
                lower_envelope(slice) = f(j);
                break;
            end  
        end
        for j = 2501:5000
            if (log_power(7501-j,slice) > -10) && (log_power(7501-j,slice) ~= -inf)
                upper_envelope(slice) = f(7501-j);
                break;
            end  
        end
    end
    
    lower_envelope = smooth(lower_envelope,.02);
    upper_envelope = smooth(upper_envelope,.02);
   
    data_table(i,1) = max(upper_envelope); 
    data_table(i,2) = min(lower_envelope);
end

Azimuth = 0:(360)/(num_files - 1):360;

%data_table(:,2) = smooth(data_table(:,2),.1); helps with noisy min values

figure;
hold on
plot(Azimuth,data_table(:,1))
plot(Azimuth,data_table(:,2))
hold off
legend('Max Upper Envelope', 'Min Lower Envelope');
title('Max and Min Envelope Frequencies vs Transmitter Azimuth Angle');
xlabel('Transmitter Azimuth Angle (deg)');
ylabel('Doppler Frequency (Hz)');

figure;
hold on
plot(Azimuth,data_table(:,1))
plot(Azimuth,abs(data_table(:,2)))
hold off
legend('Max Upper Envelope', '| Min Lower Envelope |');
title('Max and Absolute value of Min Envelope Frequencies vs Transmitter Azimuth Angle');
xlabel('Transmitter Azimuth Angle (deg)');
ylabel('Doppler Frequency (Hz)');

difference_abs = data_table(:,1) + abs(data_table(:,2));
difference = data_table(:,1) + data_table(:,2);

figure;
hold on
plot(Azimuth,difference_abs)
plot(Azimuth,difference)
hold off
legend('Max Envelope + | Min Envelope |','Max Envelope + Min Envelope');
title('Intermediate Analysis Values');
xlabel('Transmitter Azimuth Angle (deg)');
ylabel('not sure...');

figure;
hold on
plot(Azimuth,difference)
hold off
title('Difference between Max and Min Envelope Calculations');
xlabel('Transmitter Azimuth Angle (deg)');
ylabel('Frequency Difference(Hz)');

amplify =  abs(difference) + difference_abs;
[M,I] = min(amplify);
figure;
plot(Azimuth,amplify)
title('Amplified Minimum for 90deg Estimation');
xlabel('Transmitter Azimuth Angle (deg)');
ylabel('Frequency (Hz)');

figure;
hold on
plot(Azimuth,amplify)
plot(Azimuth(I),amplify(I),'o')
hold off
title('Max + | Min | Envelope');
legend('Max + | Min | Envelope','Minimum');
xlabel('Transmitter Azimuth Angle (deg)');
ylabel('Frequency (Hz)');

angle_90deg_estimate = Azimuth(I);

figure;
hold on
plot(Azimuth,difference)
plot(Azimuth(I),difference(I),'o')
hold off
title('Transmitter Azimuth Estimation After full 360deg Rotation');
legend('Difference between Max and Min Envelope','90deg Estimation Point');
xlabel('Transmitter Azimuth Angle (deg)');
ylabel('Frequency Difference (Hz)');

%--------------------------------------------------------------------------
%max doppler for reflection radius
RPM = 250;
Altitude = 200;
fc = 1e9;
c = 3e8;
Reflection_radius = 7.5;
v_actual_max = ((2*pi)/60)*RPM*Reflection_radius;
max_fd_max = 2*(v_actual_max*fc)/c;

azimuth_rads = 0:(2*pi)/(num_files - 1):2*pi;

upper = data_table(:,1);
lower = data_table(:,2);
correct_fd = zeros(1,length(upper));

for i = 1:length(upper)
    if(difference(i) < 0)
       correct_fd(i) = abs(lower(i));
    else
       correct_fd(i) = upper(i);
    end
end

figure;
plot(Azimuth,correct_fd);

max_r = 7.5;
min_r = max_r*(min(correct_fd)/max(correct_fd));
[n,l] = min(correct_fd);
%20 is based on the samplings of the azimuth
min2_r = max_r*(correct_fd(l+20)/max(correct_fd));

r_zero_to_pi = abs((max_r-min_r)*cos(azimuth_rads))+min_r;

r_zero_to_pi = r_zero_to_pi(1:21);

r_pi_to_2pi = abs(((max_r-min2_r)/.75)*cos(azimuth_rads))+min2_r;

r_pi_to_2pi(r_pi_to_2pi > 7.5) = 7.5;
r_pi_to_2pi = r_pi_to_2pi(22:end);

r_profile = [r_zero_to_pi,r_pi_to_2pi];
r_profile_actual = (correct_fd*60*c)./(4*pi*RPM*fc*cos(atan(200/50)));

figure;
hold on
plot(Azimuth,r_profile);
plot(Azimuth,r_profile_actual);
hold off

figure;
plot(Azimuth, (r_profile - r_profile_actual));
title('error in r profile');

v_actual = ((2*pi)/60)*RPM*r_profile_actual;
max_fd_actual = 2*(v_actual*fc)/c;
test_alg_Elevation_angle_actual = acos(correct_fd./max_fd_actual);

v = ((2*pi)/60)*RPM*r_profile;
max_fd = 2*(v*fc)/c;
test_alg_Elevation_angle = acos(correct_fd./max_fd);

figure;
hold on
plot(Azimuth,test_alg_Elevation_angle_actual)
plot(Azimuth,test_alg_Elevation_angle)
hold off

figure;
plot(Azimuth,((test_alg_Elevation_angle - test_alg_Elevation_angle_actual)./test_alg_Elevation_angle_actual)*100)
title('percent error alg')

%works amazingly......
test_adjust_r = 7.5*(correct_fd./max(correct_fd));
v_adj = ((2*pi)/60)*RPM*test_adjust_r;
max_fd_adj = 2*(v_adj*fc)/c;
test_alg_Elevation_angle_adj = acos(correct_fd./max_fd_adj);

figure;
hold on
plot(Azimuth,test_adjust_r);
plot(Azimuth,r_profile_actual);
hold off

figure;
hold on
plot(Azimuth,test_alg_Elevation_angle_actual)
plot(Azimuth,test_alg_Elevation_angle_adj)
hold off

figure;
plot(Azimuth,((test_alg_Elevation_angle_adj - test_alg_Elevation_angle_actual)./test_alg_Elevation_angle_actual)*100)
title('percent error max')
