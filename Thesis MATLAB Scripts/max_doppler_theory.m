clear;
RPM = 250;%changed
Altitude = 200;
fc = 1e9;
c = 3e8;

%max doppler for reflection radius
Reflection_radius = 7.5;
v = ((2*pi)/60)*RPM*Reflection_radius;
max_fd = 2*(v*fc)/c; % re-radiated frequency......

%Rx position (might not be needed)
Rx_z = 2;
Rx_y = 7;
Rx_x = 0;

%Tx position in radius and angle
Rotor_angle = 0:(2*pi)/100:2*pi;
Tx_radius = 0:100/4:100;


data = zeros(5,101);

for r = Tx_radius
    i = 1;
    for theta = Rotor_angle
        rotor_x = Reflection_radius * cos(theta);
        rotor_y = Reflection_radius * sin(theta);
        distance_rx = sqrt((Rx_x - rotor_x)^2+(Rx_y - rotor_y)^2);
        Rx_angle = atan(Rx_z/distance_rx);
        Tx_elevation_angle = atan(Altitude/r);
        
        data(r/25 + 1, i) = -max_fd*cos(Tx_elevation_angle)*cos(theta);
        i = i + 1;
    end
end
hold on
for j = 1:5
    plot(360*Rotor_angle/(2*pi),data(j,:),'linewidth',4)
end
hold off
axis([0 360 -600 600]);
title('Doppler Frequency vs. Rotor Position with varying Elevation Angle');
xlabel('Rotor Position (deg)');
ylabel('Doppler Frequency (Hz)');
legend(strcat(num2str(360*atan(Altitude/Tx_radius(1))/(2*pi)),' deg'), strcat(num2str(360*atan(Altitude/Tx_radius(2))/(2*pi)),' deg'),strcat(num2str(360*atan(Altitude/Tx_radius(3))/(2*pi)),' deg'),strcat(num2str(360*atan(Altitude/Tx_radius(4))/(2*pi)),' deg'), strcat(num2str(360*atan(Altitude/Tx_radius(5))/(2*pi)),' deg'));
