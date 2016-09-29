%max doppler 90deg offset rx
%this does not show exactly what happens in the simulation because of the
%offset doppler.....
clear;
RPM = 250;%changed
Altitude = 200;
fc = 1e9;
c = 3e8;

%max doppler for reflection radius
Reflection_radius = 7.5;
v = ((2*pi)/60)*RPM*Reflection_radius;
max_fd = 2*(v*fc)/c;

%Rx position (might not be needed)
Rx_z = 2;
Rx_y = 7;
Rx_x = 0;

blade_length = 7.5;
max_elevation_angle = atan(Rx_z/(blade_length - Rx_y));

max_doppler_minus = -max_fd*cos(max_elevation_angle);
max_doppler_plus = max_fd*cos(max_elevation_angle);

tip = 0:0.01:.5;
elevation_angle = atan(Rx_z./tip);
hold on
plot(360*elevation_angle/(2*pi),max_fd*cos(elevation_angle))
plot(360*elevation_angle/(2*pi),-max_fd*cos(elevation_angle))
hold off
xlabel('Elevation Angle (deg)');
ylabel('Doppler Frequency (Hz)');
title('Doppler Frequency vs. Elevation angle for 90deg Transmitter Azimuth');


