clear;
data_pitch = csvread('/Users/tschucker/Desktop/Thesis_data/Receiver_Off_Axis_7m/Altitude_200m/data_Max_Doppler_pitch7.5deg_135deg.csv');
data = csvread('/Users/tschucker/Desktop/Thesis_data/Receiver_Off_Axis_7m/Altitude_200m/data_Max_Doppler_range_135deg.csv');

data_both = csvread('/Users/tschucker/Desktop/Thesis_data/Receiver_Off_Axis_7m/Altitude_200m/compare_pitches_at_135deg.csv');

data_15 = csvread('/Users/tschucker/Desktop/Thesis_data/Receiver_Off_Axis_7m/Altitude_200m/compare_pitches_at_135deg_15deg_add.csv');

data(:,4) = (data(:,4)./(2*pi)).*360;
data_pitch(:,4) = (data_pitch(:,4)./(2*pi)).*360;
data_both(:,4) = (data_both(:,4)./(2*pi)).*360;


figure;
hold on
plot(data_both(:,4),data_both(:,2));
plot(data_both(:,4),data_both(:,3));
plot(data_both(:,4),data_15(:,1));
hold off

legend('Pitch 0deg', '7.5deg', '15deg');
title('Max Envelope Frequencies vs Transmitter Elevation Angle');
xlabel('Elevation Angle (deg)');
ylabel('Doppler Frequency (Hz)');

figure;
hold on
plot(data_both(:,4), data_both(:,3) - data_both(:,2));
plot(data_both(:,4), data_15(:,1) - data_both(:,2));
legend('Difference 0deg and 7.5deg','Difference 0deg and 15deg');
title('Frequency Difference vs Transmitter Elevation Angle');
xlabel('Elevation Angle (deg)');
ylabel('Doppler Frequency (Hz)');
