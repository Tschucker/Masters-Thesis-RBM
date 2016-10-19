%max doppler 180deg offset rx
%looks great :)
clear;
RPM = 250;%changed
Altitude = 200;
fc = 1e9;
c = 3e8;

%max doppler for reflection radius
Reflection_radius = 7.5;
v = ((2*pi)/60)*RPM*Reflection_radius;
max_fd = 2*(v*fc)/c;

Tx_radius = 0:1:450;
elevation_angle = atan(Altitude./(Tx_radius));

doppler_minus = max_fd*cos(elevation_angle);
doppler_plus = -ones(1,length(Tx_radius));


hold on
plot(360*elevation_angle/(2*pi),doppler_minus)
plot(360*elevation_angle/(2*pi),doppler_plus)
hold off
xlabel('Elevation Angle (deg)');
ylabel('Doppler Frequency (Hz)');
legend('Max Upper Envelope', 'Min Lower Envelope');
title('Theoretical Doppler Frequency vs. Elevation angle for 180deg Transmitter Azimuth');

% %Rx position (might not be needed)
% Rx_z = Altitude - 2;
% Rx_y = 7;
% Rx_x = 0;
% Receiver = [Rx_x, Rx_y, Rx_z];
% 
% Blade_rotation_update = 2*pi/(900 -1);
% mRotation = [cos(Blade_rotation_update),-sin(Blade_rotation_update);sin(Blade_rotation_update),cos(Blade_rotation_update)];
% Blade_points = zeros(3,100);
% Blade_points(1,:) = 0:7.5/(100 -1):7.5;
% Blade_points(3,:) = Altitude;
% 
% for r = Tx_radius
%     for Blade_angle = 0:900
%         for i = 1:length(Blade_points)
%            temp = mRotation*[Blade_points(1,i);Blade_points(2,i)];
%            Blade_points(1,i) = temp(1);
%            Blade_points(2,i) = temp(2);
%            
%         end
%         
%     end
%     %reset blade
%     Blade_points = zeros(3,100);
%     Blade_points(1,:) = 0:7.5/(100 -1):7.5;
%     Blade_points(3,:) = Altitude;
% end
