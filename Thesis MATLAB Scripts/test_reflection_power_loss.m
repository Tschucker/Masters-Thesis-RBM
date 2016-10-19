%test reflection power
theta_i = pi/100;
epsilon = 0.001;
P_i = 10;

theta_t = asin(sin(theta_i)/sqrt(epsilon));
Gamma = (cos(theta_i) - sqrt(epsilon)*cos(theta_t))/(cos(theta_i) + sqrt(epsilon)*cos(theta_t));
P_reflected = P_i*abs(Gamma);