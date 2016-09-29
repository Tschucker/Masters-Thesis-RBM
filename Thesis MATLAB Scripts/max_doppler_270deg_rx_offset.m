%max doppler 270deg offset rx
%looks great :)
clear;
RPM = 250;%changed
Altitude = 200;
fc = 1e9;
c = 3e8;

%max doppler for reflection radius
Reflection_radius = 5;
v = ((2*pi)/60)*RPM*Reflection_radius;
max_fd = 2*(v*fc)/c;

%Rx position (might not be needed)
Rx_z = 2;
Rx_y = 7;
Rx_x = 0;

Tx_radius = 0:1:450;
elevation_angle = atan(Altitude./(Tx_radius + Reflection_radius));
doppler_plus = max_fd*cos(elevation_angle);
doppler_minus = -max_fd*cos(elevation_angle);
hold on
plot(360*elevation_angle/(2*pi),doppler_plus)
plot(360*elevation_angle/(2*pi),doppler_minus)
hold off
xlabel('Elevation Angle (deg)');
ylabel('Doppler Frequency (Hz)');
title('Doppler Frequency vs. Elevation angle for 270deg Transmitter Azimuth');

