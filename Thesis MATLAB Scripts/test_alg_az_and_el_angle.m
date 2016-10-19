%test alg for azimuth angle
clear;

%--------------------------------------------------------------------------
%Load Data
%--------------------------------------------------------------------------
files= dir('/Users/tschucker/Desktop/Thesis_data/Receiver_Off_Axis_7m/Altitude_200m/pitch7.5deg_rotation_200m2/*.csv');
num_files = length(files);
data = zeros(num_files,959006); %959000;  479000
for i=1:num_files
     data(i,:)=transpose(csvread(strcat('/Users/tschucker/Desktop/Thesis_data/Receiver_Off_Axis_7m/Altitude_200m/pitch7.5deg_rotation_200m2/',files(i).name)));
end

%--------------------------------------------------------------------------
%Known Constants
%--------------------------------------------------------------------------
fs = 4000;
RPM = 250;
Altitude = 200;
fc = 1e9;
c = 3e8;
tx_range = 200;
pitch_corrected = 0;

%--------------------------------------------------------------------------
%Find Doppler Envelopes
%--------------------------------------------------------------------------

%shift data for different start sections
%data = circshift(data,11,1);

data_table = zeros(num_files,3);

location_data = data(:,1:6);
data = data(:,7:end);

for i=1:num_files
    [s,f,t,p] = spectrogram(data(i,:),5000,500,5000,fs,'yaxis','centered');
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
        for j = 1:2500
            if log_power(j,slice) > ave_q_now(i)
                lower_envelope(slice) = f(j);
                break;
            end  
        end
        for j = 2501:5000
            if (log_power(7501-j,slice) > ave_q_now(i)) && (log_power(7501-j,slice) ~= -inf)
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
%     spectrogram(data(i,:),5000,500,5000,fs,'yaxis','centered')
%     colormap(jet);
%     colorbar
%     view(2)
%     title(num2str(location_data(i,4)));
%     hold off
end

%fix estimation error on first envelope -----
data_table(1,1) = data_table(num_files,1);
data_table(1,2) = data_table(num_files,2);
%important ----------------------------------


%--------------------------------------------------------------------------
%Azimuth angle find
%--------------------------------------------------------------------------
upper = data_table(:,1);
lower = data_table(:,2);
correct_fd = zeros(1,length(upper));

%difference calc
difference = data_table(:,1) - abs(data_table(:,2));

%correct for pitch
zero_correct = max(data_table(:,1)) - abs(min(data_table(:,2)));
if(zero_correct > .1*max(difference))
    difference = difference - (zero_correct/1);
    pitch_corrected = 1;
end

%corrected doppler frequency for processing
for i = 1:length(upper)
    if(difference(i) < 0)
       correct_fd(i) = abs(lower(i));
    else
       correct_fd(i) = upper(i);
    end
end

%for pitch correction
if(pitch_corrected)
    %w = 0:(2*pi/(num_files-1)):2*pi;
    %correct_fd = correct_fd + (zero_correct/2)*cos(w);
    difference = difference + (zero_correct/2);
    correct_fd = correct_fd-((difference'./max(difference)).*(zero_correct/2));
end

[Min,Imin] = min(correct_fd);
[Max,Imax] = max(correct_fd);

%peak prominence calc
min_peak_prominence = (1/(Max - Min))*.01;
[pk,lc] = findpeaks(1./correct_fd,'NPeaks',2,'MinPeakProminence',min_peak_prominence);

%double check average power against peaks to fix 90deg
if(length(lc) > 1)
    if(ave_q(lc(1)) < ave_q(lc(2)))
        I_90deg = lc(1);
    else
        I_90deg = lc(2);
    end
else
    I_90deg = lc;
end
Azimuth = 0:(360)/(num_files - 1):360;

error_minMethod = 100*(Azimuth(I_90deg) - 90)/90;
error_peakMethod = 100*(Azimuth(Imin) - 90)/90;

%Azimuth estimation plots
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

figure;
hold on
plot(Azimuth,difference)
hold off
title('Pitch Adjusted Difference between Max and Min Envelope Calculations');
xlabel('Transmitter Azimuth Angle (deg)');
ylabel('Frequency Difference(Hz)');

figure;
hold on
plot(Azimuth,1./correct_fd)
plot(Azimuth(lc),pk,'x')
hold off
title('Peaks of Inverted Correct Doppler Frequency')
legend('Correct Doppler Frequency', 'Peaks')
xlabel('Transmitter Azimuth Angle (deg)');
ylabel('Period (s)');

figure;
hold on
plot(Azimuth,ave_q)
plot(Azimuth(lc),ave_q(lc),'x')
hold off
title('Average Power vs Azimuth Angle')
legend('Average Power', 'Peak Locations')
xlabel('Transmitter Azimuth Angle (deg)');
ylabel('Average Power (dB)');

figure;
hold on
plot(Azimuth,correct_fd)
title('Correct Doppler Frequency')
xlabel('Transmitter Azimuth Angle (deg)');
ylabel('Frequency (Hz)');

figure;
hold on
plot(Azimuth,correct_fd)
plot(Azimuth(Imin),correct_fd(Imin),'o','MarkerSize',12)
%plot(Azimuth(I_90deg),correct_fd(I_90deg),'x')
hold off
title('Pitch Adjusted Correct Doppler Frequency with Minimum');
legend('Correct Doppler Frequency','Minimum');%,'90deg Estimate');
xlabel('Transmitter Azimuth Angle (deg)');
ylabel('Frequency (Hz)');

%print out
Altitude
(atan(Altitude/tx_range)/(2*pi))*360
AzimuthError = Azimuth(I_90deg) - 90
PercentAzimuthError = ((Azimuth(I_90deg) - 90)/90)*100

if(length(lc) > 1)
    PercentPeakDifference = ((pk(2) - pk(1))/pk(1))*100
    PowerDifference = -(abs(ave_q(lc(1))) + abs(ave_q(lc(2))))

    FrequencyDifference = correct_fd(lc(2)) - correct_fd(lc(1))
end
%--------------------------------------------------------------------------
%Elevation angle find
%--------------------------------------------------------------------------

%Actual radius and elevation angle calculations
r_profile_actual = (correct_fd*60*c)./(4*pi*RPM*fc*cos(atan(Altitude/tx_range)));
v_actual = ((2*pi)/60)*RPM*r_profile_actual;
max_fd_actual = 2*(v_actual*fc)/c;
test_alg_Elevation_angle_actual = acos(correct_fd./max_fd_actual);

%Estimated radius and elevation angle calculations
test_adjust_r = 7.5*(correct_fd./max(correct_fd));
v_adj = ((2*pi)/60)*RPM*test_adjust_r;
max_fd_adj = 2*(v_adj*fc)/c;
test_alg_Elevation_angle_adj = acos(correct_fd./max_fd_adj);

%elevation plots
figure;
hold on
%plot(Azimuth,r_profile_actual);
plot(Azimuth,test_adjust_r);
hold off
title('Estimated Reflection Radius')
xlabel('Azimuth Angle (deg)');
ylabel('Radius (m)');

figure;
hold on
plot(Azimuth,(test_alg_Elevation_angle_actual/(2*pi))*360)
plot(Azimuth,(test_alg_Elevation_angle_adj/(2*pi))*360)
hold off
%axis([0,360,70,80]);
title('Actual Elevation Angle and Estimated Elevation Angle vs Azimuth Angle')
legend('Actual Angle','Estimated Angle');
xlabel('Azimuth Angle (deg)');
ylabel('Elevation Angle (deg)');

figure;
plot(Azimuth,((test_alg_Elevation_angle_adj - test_alg_Elevation_angle_actual)./test_alg_Elevation_angle_actual)*100)
title('Percent Error between Algorithims')

figure;
plot(Azimuth,((test_alg_Elevation_angle_adj - atan(Altitude/tx_range))./atan(Altitude/tx_range))*100);
%axis([0,360,-.9,-.8]);
title('Elevation Angle Percent Error vs Azimuth Angle')
xlabel('Azimuth Angle (deg)');
ylabel('Error (%)');

figure;
plot(Azimuth,((test_alg_Elevation_angle_actual - atan(Altitude/tx_range))./atan(Altitude/tx_range))*100);
title('Percent Error actual')

AverageElevationError = (mean((test_alg_Elevation_angle_adj - atan(Altitude/tx_range)))/(2*pi))*360
AverageElevationPercentError = mean(((test_alg_Elevation_angle_adj - atan(Altitude/tx_range))./atan(Altitude/tx_range))*100)
