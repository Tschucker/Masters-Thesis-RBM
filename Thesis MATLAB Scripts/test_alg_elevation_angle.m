%clear;
data_x_180 = csvread('/Users/tschucker/Desktop/Thesis_data/Receiver_Off_Axis_7m/Altitude_200m/data_Max_Doppler_range_x_average_current_frame_method.csv');

figure;
hold on
plot(data_x_180(:,5), data_x_180(:,2));
plot(data_x_180(:,5), data_x_180(:,3));
hold off
legend('Max Upper Envelope', 'Min Lower Envelope');
title('Max and Min Envelope Frequencies vs Transmitter Elevation Angle with Tx Azimuth at 180deg');
xlabel('Elevation Angle (deg)');
ylabel('Doppler Frequency (Hz)');

%---------------------------------------------------------------------------------------------------

%max doppler for reflection radius
RPM = 250;
Altitude = 200;
fc = 1e9;
c = 3e8;
Reflection_radius = 7.5;
v = ((2*pi)/60)*RPM*Reflection_radius;
max_fd = 2*(v*fc)/c;

data_x_180(:,8) = abs(data_x_180(:,8));

test_alg_angle = acos(data_x_180(:,2)/max_fd);
figure;
hold on
plot((data_x_180(:,8)/(2*pi))*360,(test_alg_angle/(2*pi))*360)
plot((data_x_180(:,8)/(2*pi))*360,(data_x_180(:,8)/(2*pi))*360)
hold off
title('Elevation Angle Comparason');
legend('Estimated Angle', 'Actual Angle');
xlabel('Elevation Angle Actual (deg)');
ylabel('Elevation Angle (deg)');

%error
angle_error = ((((test_alg_angle/(2*pi))*360) - ((data_x_180(:,8)/(2*pi))*360))./((data_x_180(:,8)/(2*pi))*360))*100;
figure;
plot((data_x_180(:,8)/(2*pi))*360,angle_error)
title('Elevation Angle Percent Error');
xlabel('Elevation Angle (deg)');
ylabel('Percent Error');

%distance
dtx_estimate = Altitude./tan(test_alg_angle);
dtx_actual = abs(data_x_180(:,5));

figure;
hold on
plot(dtx_actual,dtx_estimate)
plot(dtx_actual,dtx_actual)
hold off
title('Distance Comparason');
legend('Estimated Distance', 'Actual Distance');
xlabel('Distance Actual (m)');
ylabel('Distance (m)');

distance_error = (dtx_actual - dtx_estimate);

figure;
plot(dtx_actual,distance_error)
title('Distance Error vs. Actual Distance');
xlabel('Distance Actual (m)');
ylabel('Distance Error (m)');

distance_Perror = ((dtx_actual - dtx_estimate)./dtx_actual).*100 ;

figure;
plot(dtx_actual(5:end),distance_Perror(5:end))

