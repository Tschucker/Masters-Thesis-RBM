%clear;
data_y = csvread('/Users/tschucker/Desktop/Thesis_data/Receiver_Off_Axis_7m/Altitude_200m/data_Max_Doppler_range_y_nMethod.csv');

figure;
hold on
plot(data_y(:,1), data_y(:,2));
plot(data_y(:,1), data_y(:,3));
hold off
legend('Max Upper Envelope', 'Min Lower Envelope');
title('Max and Min Envelope Frequencies vs Transmitter Elevation Angle with Tx Azimuth at 180deg');
xlabel('range m');
ylabel('Doppler Frequency (Hz)');