clear;clc;
close all;
offset = 2;
alpha = 0.5;
beta = 1.5;
r = 1;
slotSize = 0.0617;
frameSize = 10;
numFrame = 10;
%% First Signal Construction
t = 0:slotSize:frameSize;
freq = 1;
w = 2*pi*freq;

sine_wave = sin(w*t);
noise= randn(size(sine_wave))*0.1;
x1 = offset + sine_wave + noise;

%% Second Signal Construction
a = 1;
b = 2;
x2_low = a;
x2_high = b;

pulsewidth = 0.2;
x2 = offset + sign(sine_wave);


%% ILoRa

currentValueR = 0;
lastUpdateR = 0;
information_penalty = (currentValueR - lastUpdateR).^2;

AoIR = mod(abs(randn(1,2)),2)';
AoII_th = alpha;
Reward_th = beta;
lastUpdateR = [0 0]';
lastUpdate_timeR = [0 0]';
rewardR  = [0 0]';
numberofTxR = [0 0]';
frameCountR = 1;

collision = 0;
no_request = 0;

duty_cycle = frameSize/slotSize/100;

total_send_user1 = 0;
total_send_user2 = 0;
for ii = 1:1:length(t)*numFrame
    i = mod(ii,length(t));
    if(i == 0)
        rewardR  = [0 0]';
        AoIR = AoIR + slotSize;
        Total_AoIILogR(frameCountR,:,:) = AoIILogR;
        Total_AoILogR(frameCountR,:,:) = AoILogR;
        Total_RewardLogR(frameCountR,:,:) = RewardLogR;
        Total_NumberofTxLogR(frameCountR,:,:) = NumberofTxLogR;
        frameCountR = frameCountR + 1;
        numberofTxR = [0;0];
        continue;
    end
    currentValueR = [x1(i) x2(i)]';
    information_penalty = (currentValueR - lastUpdateR).^2;
    AoIIR = AoIR .* information_penalty;
    
    % r reward case
    user1_en = randi([0 1], 1,1);
    user2_en = randi([0 1], 1,1);
    
    if user1_en == 1 && user2_en == 0 && numberofTxR(1) < duty_cycle
        lastUpdateR(1) = currentValueR(1);
        lastUpdate_timeR(1) = t(i);
        numberofTxR(1) = numberofTxR(1) + 1;
        AoIR(1) = 0;
        rewardR(1) = rewardR(1) + r;
        total_send_user1 = total_send_user1 +1;
    elseif user1_en == 0 && user2_en == 1  && numberofTxR(2) < duty_cycle
        disp("burdayım")
        lastUpdateR(2) = currentValueR(2);
        lastUpdate_timeR(2) = t(i);
        numberofTxR(2) = numberofTxR(2) + 1;
        AoIR(2) = 0;
        rewardR(2) = rewardR(2) + r;
        total_send_user2 = total_send_user2 +1;
    elseif user1_en == 1 && user2_en == 1 && numberofTxR(2) < duty_cycle && numberofTxR(1) < duty_cycle
        collision = collision + 1;
    else
        no_request = no_request + 1;
    end
    
    AoIILogR(i,:) = AoIIR;
    AoILogR(i,:) = AoIR;
    NumberofTxLogR(i,:) = numberofTxR;
    RewardLogR(i,:) = rewardR;
    AoIR = AoIR + slotSize;
end

plot(AoIILog)
title = ("AoII graph");
xlabel("time")
ylabel("AoII")
figure
plot(RewardLog)
title = ("Reward graph");
xlabel("time")
ylabel("Reward")


