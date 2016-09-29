clear;
center_zero = csvread('/Users/tschucker/Desktop/Thesis_data/Receiver_Centered/Altitude_200m/data_maxDoppler_range_180deg_new_apxMethod5.csv');

% figure;
% hold on
% plot((center_zero(:,4)/(2*pi))*360, center_zero(:,2));
% plot((center_zero(:,4)/(2*pi))*360, center_zero(:,3));
% hold off
% legend('Max Upper Envelope', 'Min Lower Envelope');
% title('Max and Min Envelope Frequencies vs Transmitter Elevation Angle with Tx Azimuth at 180deg');
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

distance_Rx = 2;
lambda_Tx = c/fc;
RPM_rads = (2*pi/60)*RPM;

r_estimate = (center_zero(:,2)*c)./(2*fc*RPM_rads);
theta_estimate = atan(distance_Rx./r_estimate);
dtx_estimate = ((Altitude./tan(theta_estimate)) + r_estimate);
alpha_estimate = atan(Altitude./dtx_estimate);

dtx_adjusted = dtx_estimate;
actual = center_zero(:,1);
error_dtx = (abs(dtx_adjusted) - abs(actual));

figure;
hold on;
plot(dtx_adjusted)
plot(actual)
hold off;

figure;
plot(error_dtx)

scan_dist = 0:.01:700;

equality = (center_zero(:,2).*(Altitude+distance_Rx))/(2*(RPM_rads/lambda_Tx)*distance_Rx);
scan_func = scan_dist.*cos(atan(Altitude./scan_dist));

distance_tx_estimate = zeros(1,11);
for i = 1:length(equality)
    index = find(scan_func < equality(i));
    distance_tx_estimate(i) = scan_dist(index(end));
end


figure;
hold on
plot(center_zero(:,1),distance_tx_estimate)
hold off

%test_alg_angle = acos(center_zero(:,2)/max_fd);

% figure;
% hold on
% plot((center_zero(:,4)/(2*pi))*360,(test_alg_angle/(2*pi))*360)
% plot((center_zero(:,4)/(2*pi))*360,(center_zero(:,4)/(2*pi))*360)
% hold off
% title('Elevation Angle Comparason');
% legend('Estimated Angle', 'Actual Angle');
% xlabel('Elevation Angle Actual (deg)');
% ylabel('Elevation Angle (deg)');
% 
% %error
% angle_error = ((((test_alg_angle/(2*pi))*360) - ((center_zero(:,4)/(2*pi))*360))./((center_zero(:,4)/(2*pi))*360))*100;
% figure;
% plot((center_zero(:,4)/(2*pi))*360,angle_error)
% title('Elevation Angle Percent Error');
% xlabel('Elevation Angle (deg)');
% ylabel('Percent Error');
% 
% %distance
% dtx_estimate = Altitude./tan(test_alg_angle);
% dtx_actual = abs(center_zero(:,1));
% 
% figure;
% hold on
% plot(dtx_actual,dtx_estimate)
% plot(dtx_actual,dtx_actual)
% hold off
% title('Distance Comparason');
% legend('Estimated Distance', 'Actual Distance');
% xlabel('Distance Actual (m)');
% ylabel('Distance (m)');
% 
% distance_error = dtx_actual - dtx_estimate;
% 
% figure;
% plot(dtx_actual,distance_error)
% title('Distance Error vs. Actual Distance');
% xlabel('Distance Actual (m)');
% ylabel('Distance Error (m)');