clear;clc;
numberOfUsers = 2;
offset = 2;

r = 1;
slotSize = 0.0617; %sec
frameSize = 0.0617*200; %sec
AoII_th = frameSize*1/4;
Reward_th = frameSize-frameSize*1/4;
numFrame = 6;
t = 0:slotSize:frameSize;
tot_horizon=length(t)*numFrame;
%% First Signal Construction
freq1 = 0.7;
w = 2*pi*freq1;
sine_wave = sin(w*t + 3);
noise= randn(size(sine_wave))*0.001;
x1 = offset + sine_wave + noise;

%% Second Signal Construction
freq2= 0.4;
x2 = offset + sign(sin(2*pi*freq2*t));

%% ILoRa

currentValue = 0;
lastUpdate = 0;
information_penalty = (currentValue - lastUpdate).^2;

AoI = mod(abs(randn(1,2)),2)';

lastUpdate = zeros(numberOfUsers,1);
lastUpdate_time = zeros(numberOfUsers,1);
reward  = zeros(numberOfUsers,1);
numberofTx = zeros(numberOfUsers,1);
frameCount = 1;
real_t = 0;


AoILog = zeros(length(t),numberOfUsers);
AoIILog = zeros(length(t),numberOfUsers);
NumberofTxLog = zeros(length(t),numberOfUsers);
RewardLog = zeros(length(t),numberOfUsers);

Total_AoIILog = zeros(length(t),numberOfUsers,numFrame);
Total_AoILog = zeros(length(t),numberOfUsers,numFrame);
Total_RewardLog = zeros(length(t),numberOfUsers,numFrame);
Total_NumberofTxLog = zeros(length(t),numberOfUsers,numFrame);
for ii = 1:1:tot_horizon
    real_t = real_t + slotSize;
    i = mod(ii,length(t));
    if(i == 0)
        AoIILog(end,:) = AoII;
        AoILog(end,:) = AoI;
        NumberofTxLog(end,:) = numberofTx;
        RewardLog(end,:) = reward;
        Total_AoIILog(:,:,frameCount) = AoIILog;
        Total_AoILog(:,:,frameCount) = AoILog;
        Total_RewardLog(:,:,frameCount) = RewardLog;
        Total_NumberofTxLog(:,:,frameCount) = NumberofTxLog;
        frameCount = frameCount + 1;
        numberofTx = zeros(numberOfUsers,1);
        reward  = zeros(numberOfUsers,1);
        AoI = AoI + slotSize;
        continue;
    end
    currentValue = [x1(i) x2(i)]';
    information_penalty = (currentValue - lastUpdate).^2;
    AoII = AoI .* information_penalty;

    if AoII(1)>AoII_th && lastUpdate_time(1) + 6.2  <= real_t
        lastUpdate(1) = currentValue(1);
        lastUpdate_time(1) = real_t;
        numberofTx(1) = numberofTx(1) + 1;
        AoI(1) = 0;
        if AoII(1) <= Reward_th
            reward(1) = reward(1) + r;
        else
            reward(1) = reward(1) + r/2;
        end
    elseif AoII(2) > AoII_th && lastUpdate_time(2) + 6.2  <= real_t
        lastUpdate(2) = currentValue(2);
        lastUpdate_time(2) = real_t;
        numberofTx(2) = numberofTx(2) + 1;
        AoI(2) = 0;
        reward(2) = reward(2) + r;
        if AoII(2) <= Reward_th
            reward(2) = reward(2) + r;
        else
            reward(2) = reward(2) + r/2;
        end
    end
    AoIILog(i,:) = AoII;
    AoILog(i,:) = AoI;
    NumberofTxLog(i,:) = numberofTx;
    RewardLog(i,:) = reward;
    AoI = AoI + slotSize;
end



%% ALOHA

AoIR = mod(abs(randn(1,2)),2)';

lastUpdateR = zeros(numberOfUsers,1); 
lastUpdate_timeR = zeros(numberOfUsers,1);
rewardR  = zeros(numberOfUsers,1);
numberofTxR = zeros(numberOfUsers,1);
frameCountR = 1;

collision = 0;
no_request = 0;

total_send_user1 = 0;
total_send_user2 = 0;
real_tR = 0;

AoILogR = zeros(length(t),numberOfUsers);
AoIILogR = zeros(length(t),numberOfUsers);
NumberofTxLogR = zeros(length(t),numberOfUsers);
RewardLogR = zeros(length(t),numberOfUsers);

Total_AoIILogR = zeros(length(t),numberOfUsers,numFrame);
Total_AoILogR = zeros(length(t),numberOfUsers,numFrame);
Total_RewardLogR = zeros(length(t),numberOfUsers,numFrame);
Total_NumberofTxLogR = zeros(length(t),numberOfUsers,numFrame);

send_request_table = zeros(numberOfUsers,tot_horizon);

while true
    users = randi([0 1],numberOfUsers,1);
    if sum(users) > 0
        break
    end
end

send_request_table(:,1) = users;

for iiR = 1:1:tot_horizon
    
    real_tR = real_tR + slotSize;
    iR = mod(iiR,length(t));
    if(iR == 0)
        
        AoIILogR(end,:) = AoIIR;
        AoILogR(end,:) = AoIR;
        NumberofTxLogR(end,:) = numberofTxR;
        RewardLogR(end,:) = rewardR;
        Total_AoIILogR(:,:,frameCountR) = AoIILogR;
        Total_AoILogR(:,:,frameCountR) = AoILogR;
        Total_RewardLogR(:,:,frameCountR) = RewardLogR;
        Total_NumberofTxLogR(:,:,frameCountR) = NumberofTxLogR;
        frameCountR = frameCountR + 1;
        numberofTxR = zeros(numberOfUsers,1);
        rewardR  = zeros(numberOfUsers,1);

        AoIR = AoIR + slotSize;
        continue;
    end
    currentValueR = [x1(iR) x2(iR)]';
    information_penaltyR = (currentValueR - lastUpdateR).^2;
    AoIIR = AoIR .* information_penaltyR;
    
    
    user1_en = randi([0 1], 1,1);%*randi([0 1], 1,1)*randi([0 1], 1,1)*randi([0 1], 1,1)*randi([0 1], 1,1)*randi([0 1], 1,1);
    user2_en = randi([0 1], 1,1);%*randi([0 1], 1,1)*randi([0 1], 1,1)*randi([0 1], 1,1)*randi([0 1], 1,1)*randi([0 1], 1,1);
    
    if user1_en == 1 && user2_en == 0 && lastUpdate_timeR(1) + 6.2  <= real_tR
        lastUpdateR(1) = currentValueR(1);
        lastUpdate_timeR(1) = real_tR;
        numberofTxR(1) = numberofTxR(1) + 1;
        AoIR(1) = 0;
        if AoIIR(1) <= Reward_th
            rewardR(1) = rewardR(1) + r;
        else
            rewardR(1) = rewardR(1) + r/2;
        end
        total_send_user1 = total_send_user1 +1;
    elseif user1_en == 0 && user2_en == 1  && lastUpdate_timeR(2) + 6.2  <= real_tR
        lastUpdateR(2) = currentValueR(2);
        lastUpdate_timeR(2) = real_tR;
        numberofTxR(2) = numberofTxR(2) + 1;
        AoIR(2) = 0;
        if AoIIR(2) <= Reward_th
            rewardR(2) = rewardR(2) + r;
        else
            rewardR(2) = rewardR(2) + r/2;
        end
        total_send_user2 = total_send_user2 +1;
    elseif user1_en == 1 && user2_en == 1 && lastUpdate_timeR(1) + 6.2  <= real_tR && lastUpdate_timeR(2) + 6.2  <= real_tR
        collision = collision + 1;
    else
        no_request = no_request + 1;
    end
    
    AoIILogR(iR,:) = AoIIR;
    AoILogR(iR,:) = AoIR;
    NumberofTxLogR(iR,:) = numberofTxR;
    RewardLogR(iR,:) = rewardR;
    AoIR = AoIR + slotSize;
end
%% Plot
col1 = 'b';
col2 = 'r';
col3 = 'k';
col4 = 'g';
figure
subplot(2,2,1);
title("AoI");
plot(t,AoILog(:,1), col1);
hold on
plot(t,AoILogR(:,1), col2);
plot(t,AoILog(:,2), col3);
plot(t,AoILogR(:,2),col4);
legend(["ILoRa User 1","ALOHA User 1","ILoRa User 2","ALOHA User 2"]);
xlabel("Time (sec)");
ylabel("AoI");

subplot(2,2,2);
title("AoII");
plot(t,AoIILog(:,1), col1);
hold on
plot(t,AoIILogR(:,1), col2);
plot(t,AoIILog(:,2), col3);
plot(t,AoIILogR(:,2),col4);
legend(["ILoRa User 1","ALOHA User 1","ILoRa User 2","ALOHA User 2"]);
xlabel("Time (sec)");
ylabel("AoII");

subplot(2,2,3);

title("Reward");
plot(t,RewardLog(:,1), col1);
hold on
plot(t,RewardLogR(:,1), col2);
plot(t,RewardLog(:,2), col3);
plot(t,RewardLogR(:,2),col4);
legend(["ILoRa User 1","ALOHA User 1","ILoRa User 2","ALOHA User 2"]);
xlabel("Time (sec)");
ylabel("Reward");

subplot(2,2,4);
title("Number of Transmissions");
plot(t,NumberofTxLog(:,1), col1);
hold on
plot(t,NumberofTxLogR(:,1), col2);
plot(t,NumberofTxLog(:,2), col3);
plot(t,NumberofTxLogR(:,2),col4);
legend(["ILoRa User 1","ALOHA User 1","ILoRa User 2","ALOHA User 2"]);
xlabel("Time (sec)");
ylabel("Number of Transmissions");
