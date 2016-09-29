%test convolution on range
clear;
upper_envelopes = csvread('/Users/tschucker/Desktop/Thesis_data/Receiver_Off_Axis_7m/Altitude_200m/data_upper_envelope_rangeX.csv');
lower_envelopes = csvread('/Users/tschucker/Desktop/Thesis_data/Receiver_Off_Axis_7m/Altitude_200m/data_lower_envelope_rangeX.csv');

next_upper = zeros(1,106);
next_lower = zeros(1,106);

for i = 1:41
    u = upper_envelopes(i,:);
    l = lower_envelopes(i,:);
    
%     figure;
%     hold on
%     plot(u(2:end))
%     plot(l(2:end))
%     hold off
    
    upper_conv = conv(u(2:end),next_upper);
    lower_conv = conv(l(2:end),next_lower);
    figure;
    hold on
    plot(upper_conv);
    plot(lower_conv);
    hold off
    next_upper = u(2:end);
    next_lower = l(2:end);
end

