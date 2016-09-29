clear;

altitude = 200;
range = 0.1:0.1:10000;
elevation = (atan(altitude./range)./(2*pi))*360;

plot(range,elevation)
title('Transmitter Range vs Elevation Angle at an Altitude of 200m');
xlabel('Range (m)');
ylabel('Elevation Angle (deg)');