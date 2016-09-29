clear;
data_45 = csvread('/Users/tschucker/Desktop/Thesis_data/Receiver_Off_Axis_7m/Altitude_200m/data_Max_Doppler_range_45deg.csv');
data_135 = csvread('/Users/tschucker/Desktop/Thesis_data/Receiver_Off_Axis_7m/Altitude_200m/data_Max_Doppler_range_135deg.csv');
data_225 = csvread('/Users/tschucker/Desktop/Thesis_data/Receiver_Off_Axis_7m/Altitude_200m/data_Max_Doppler_range_225deg.csv');
data_315 = csvread('/Users/tschucker/Desktop/Thesis_data/Receiver_Off_Axis_7m/Altitude_200m/data_Max_Doppler_range_315deg.csv');
data_x_0 = csvread('/Users/tschucker/Desktop/Thesis_data/Receiver_Off_Axis_7m/Altitude_200m/data_Max_Doppler_range_x_0deg.csv');
data_x_180 = csvread('/Users/tschucker/Desktop/Thesis_data/Receiver_Off_Axis_7m/Altitude_200m/data_Max_Doppler_range_x_180deg.csv');
data_y_90 = csvread('/Users/tschucker/Desktop/Thesis_data/Receiver_Off_Axis_7m/Altitude_200m/data_Max_Doppler_range_y_90deg.csv');
data_y_270 = csvread('/Users/tschucker/Desktop/Thesis_data/Receiver_Off_Axis_7m/Altitude_200m/data_Max_Doppler_range_y_270deg.csv');


% figure;
% hold on
% plot((data_45(:,4)/(2*pi))*360,data_45(:,2));
% plot((data_45(:,4)/(2*pi))*360,data_45(:,3));
% hold off
% legend('Max Upper Envelope', 'Min Lower Envelope');
% title('Max and Min Envelope Frequencies vs Transmitter Elevation Angle with Tx Azimuth at 45deg');
% xlabel('Elevation Angle (deg)');
% ylabel('Doppler Frequency (Hz)');
% 
% figure;
% hold on
% plot((data_135(:,4)/(2*pi))*360,data_135(:,2));
% plot((data_135(:,4)/(2*pi))*360,data_135(:,3));
% hold off
% legend('Max Upper Envelope', 'Min Lower Envelope');
% title('Max and Min Envelope Frequencies vs Transmitter Elevation Angle with Tx Azimuth at 135deg');
% xlabel('Elevation Angle (deg)');
% ylabel('Doppler Frequency (Hz)');
% 
% figure;
% hold on
% plot((data_225(:,4)/(2*pi))*360,data_225(:,2));
% plot((data_225(:,4)/(2*pi))*360,data_225(:,3));
% hold off
% legend('Max Upper Envelope', 'Min Lower Envelope');
% title('Max and Min Envelope Frequencies vs Transmitter Elevation Angle with Tx Azimuth at 225deg');
% xlabel('Elevation Angle (deg)');
% ylabel('Doppler Frequency (Hz)');
% 
% figure;
% hold on
% plot((data_315(:,4)/(2*pi))*360,data_315(:,2));
% plot((data_315(:,4)/(2*pi))*360,data_315(:,3));
% hold off
% legend('Max Upper Envelope', 'Min Lower Envelope');
% title('Max and Min Envelope Frequencies vs Transmitter Elevation Angle with Tx Azimuth at 315deg');
% xlabel('Elevation Angle (deg)');
% ylabel('Doppler Frequency (Hz)');
% 
% figure;
% hold on
% plot((data_x_0(:,4)/(2*pi))*360,data_x_0(:,2));
% plot((data_x_0(:,4)/(2*pi))*360,data_x_0(:,3));
% hold off
% legend('Max Upper Envelope', 'Min Lower Envelope');
% title('Max and Min Envelope Frequencies vs Transmitter Elevation Angle with Tx Azimuth at 0deg');
% xlabel('Elevation Angle (deg)');
% ylabel('Doppler Frequency (Hz)');
% 
% figure;
% hold on
% plot((data_x_180(:,4)/(2*pi))*360,data_x_180(:,2));
% plot((data_x_180(:,4)/(2*pi))*360,data_x_180(:,3));
% hold off
% legend('Max Upper Envelope', 'Min Lower Envelope');
% title('Max and Min Envelope Frequencies vs Transmitter Elevation Angle with Tx Azimuth at 180deg');
% xlabel('Elevation Angle (deg)');
% ylabel('Doppler Frequency (Hz)');
% 
% figure;
% hold on
% plot((data_y_90(:,4)/(2*pi))*360,data_y_90(:,2));
% plot((data_y_90(:,4)/(2*pi))*360,data_y_90(:,3));
% hold off
% legend('Max Upper Envelope', 'Min Lower Envelope');
% title('Max and Min Envelope Frequencies vs Transmitter Elevation Angle with Tx Azimuth at 90deg');
% xlabel('Elevation Angle (deg)');
% ylabel('Doppler Frequency (Hz)');
% 
% figure;
% hold on
% plot((data_y_270(:,4)/(2*pi))*360,data_y_270(:,2));
% plot((data_y_270(:,4)/(2*pi))*360,data_y_270(:,3));
% hold off
% legend('Max Upper Envelope', 'Min Lower Envelope');
% title('Max and Min Envelope Frequencies vs Transmitter Elevation Angle with Tx Azimuth at 270deg');
% xlabel('Elevation Angle (deg)');
% ylabel('Doppler Frequency (Hz)');

%---------------------------------------------------------------------------------------------------

%max doppler for reflection radius
RPM = 250;
Altitude = 200;
fc = 1e9;
c = 3e8;
Reflection_radius = 7.5;
v = ((2*pi)/60)*RPM*Reflection_radius;
max_fd = 2*(v*fc)/c;

test_alg_angle_180 = acos(data_x_180(:,2)/max_fd);
test_alg_angle_0 = acos(abs(data_x_0(:,3))/max_fd);
test_alg_angle_270 = acos(data_y_270(:,2)/max_fd);
test_alg_angle_90 = acos(data_y_90(:,2)/max_fd);

test_alg_angle_45 = acos(abs(data_45(:,3))/max_fd);
test_alg_angle_135 = acos(data_135(:,2)/max_fd);
test_alg_angle_225 = acos(data_225(:,2)/max_fd);
test_alg_angle_315 = acos(abs(data_315(:,3))/max_fd);

figure;
hold on

plot((data_x_0(:,4)/(2*pi))*360,(test_alg_angle_0/(2*pi))*360)
plot((data_45(:,4)/(2*pi))*360,(test_alg_angle_45/(2*pi))*360)
plot((data_y_90(:,4)/(2*pi))*360,(test_alg_angle_90/(2*pi))*360)
plot((data_135(:,4)/(2*pi))*360,(test_alg_angle_135/(2*pi))*360)
plot((data_x_180(:,4)/(2*pi))*360,(test_alg_angle_180/(2*pi))*360)
plot((data_225(:,4)/(2*pi))*360,(test_alg_angle_225/(2*pi))*360)
plot((data_y_270(:,4)/(2*pi))*360,(test_alg_angle_270/(2*pi))*360)
plot((data_315(:,4)/(2*pi))*360,(test_alg_angle_315/(2*pi))*360)

plot((data_x_180(:,4)/(2*pi))*360,(data_x_180(:,4)/(2*pi))*360)
plot((data_45(:,4)/(2*pi))*360,(data_45(:,4)/(2*pi))*360)

hold off
legend('0','45','90','135','180','225','270','315','actual1','actual2')

%plot error
test = ((test_alg_angle_0/(2*pi))*360) - ((data_x_0(:,4)/(2*pi))*360);

figure;
hold on

plot((data_x_0(:,4)/(2*pi))*360,((test_alg_angle_0/(2*pi))*360) - ((data_x_0(:,4)/(2*pi))*360))
plot((data_45(:,4)/(2*pi))*360,(test_alg_angle_45/(2*pi))*360 - (data_45(:,4)/(2*pi))*360)
plot((data_y_90(:,4)/(2*pi))*360,((test_alg_angle_90/(2*pi))*360 - (data_y_90(:,4)/(2*pi))*360))
plot((data_135(:,4)/(2*pi))*360,(test_alg_angle_135/(2*pi))*360 - (data_135(:,4)/(2*pi))*360)
plot((data_x_180(:,4)/(2*pi))*360,(test_alg_angle_180/(2*pi))*360 - (data_x_180(:,4)/(2*pi))*360)
plot((data_225(:,4)/(2*pi))*360,(test_alg_angle_225/(2*pi))*360 - (data_225(:,4)/(2*pi))*360)
plot((data_y_270(:,4)/(2*pi))*360,(test_alg_angle_270/(2*pi))*360 - (data_y_270(:,4)/(2*pi))*360)
plot((data_315(:,4)/(2*pi))*360,(test_alg_angle_315/(2*pi))*360 - (data_315(:,4)/(2*pi))*360)

hold off
legend('0','45','90','135','180','225','270','315')



