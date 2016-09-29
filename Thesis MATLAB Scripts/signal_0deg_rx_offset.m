%signal not ready.....
clear;
RPM = 250;
Altitude = 200;
fc = 1e9;
fs = 4000;
c = 3e8;

Rx_position = [0;7;Altitude-2];
Tx_position = [0;0;0];

Blade = 0:0.1:7.5;
Blade_rotation = 0:0.1:4*pi;
Blade_normal = [0;0;-1];

for r = 10:10:1000

i = 1;
for R = -Blade_rotation
    for B = Blade
        hit_point = [[cos(R), -sin(R); sin(R), cos(R)]*[B;0];Altitude];
        
        perp = [-hit_point(2), hit_point(1), 0];
        perp_normalized = perp/sqrt(perp(1)^2 + perp(2)^2 + perp(3)^2);
        
        Reflection_radius = B;
        v = ((2*pi)/60)*RPM*Reflection_radius;
        max_fd = 2*(v*fc)/c;
        
        Tx2Blade = hit_point - Tx_position;
        Tx2Blade_normalized = Tx2Blade/sqrt(Tx2Blade(1)^2 + Tx2Blade(2)^2 + Tx2Blade(3)^2);
        
        Blade2Rx = hit_point - Rx_position;
        Blade2Rx_normalized = Blade2Rx/sqrt(Blade2Rx(1)^2 + Blade2Rx(2)^2 + Blade2Rx(3)^2);
        
        Reflection = -Tx2Blade_normalized + (2 * Blade_normal) * dot(Tx2Blade_normalized,Blade_normal);
        
        Reflection_angle(i) = dot(Blade2Rx_normalized,Reflection);
        doppler_angle(i) = dot(Blade2Rx_normalized,perp_normalized);
        dop_freq(i) = max_fd*doppler_angle(i);
        
        if(acos(Reflection_angle(i)) < (pi/3))
            power(i) = (Reflection_angle(i))^2;
        else
            power(i) = 0;
        end
        signal(i) = sqrt(power(i))*cos(2*pi*dop_freq(i));
        i= i+1;
    end 
end

% figure
% plot(acos(doppler_angle))
% title('doppler angle')
% figure;
% plot(acos(Reflection_angle))
% title('reflection angle')
% figure;
% plot(dop_freq)
% title('doppler freq')
% figure;
% plot(power);
% title('power')
% 
% figure;
% scatter3(1:length(dop_freq),dop_freq,power);
% title('3d')

% figure;
% plot(dop_freq.*power)
max_dop(r/10) = max(dop_freq.*power);
min_dop(r/10) = min(dop_freq.*power);
Tx_position(1) = r;
end

figure;
hold on
plot(max_dop)
plot(min_dop)
hold off