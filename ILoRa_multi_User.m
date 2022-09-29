clear;clc;
numberOfUsers = 10;
offset = 2;

r = 1;
slotSize = 0.0617; %sec
frameSize = 0.0617*300; %sec
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
x11 = offset + sine_wave + noise;
x12 = offset + sin(w*t + randi([1 10],1,1)) + noise;
x13 = offset + sin(w*t + randi([1 10],1,1)) + noise;
x14 = offset + sin(w*t + randi([1 10],1,1)) + noise;
x15 = offset + sin(w*t + randi([1 10],1,1)) + noise;

%% Second Signal Construction
freq2 = 0.4;
x21 = offset + sign(sin(2*pi*freq2*t + randi([1 10],1,1)));
x22 = offset + sign(sin(2*pi*freq2*t + randi([1 10],1,1)));
x23 = offset + sign(sin(2*pi*freq2*t + randi([1 10],1,1)));
x24 = offset + sign(sin(2*pi*freq2*t + randi([1 10],1,1)));
x25 = offset + sign(sin(2*pi*freq2*t + randi([1 10],1,1)));
%% ILoRa

currentValue = 0;
lastUpdate = 0;
information_penalty = (currentValue - lastUpdate).^2;

AoI = mod(abs(randn(1,numberOfUsers)),2)';

lastUpdate = zeros(numberOfUsers,1);
lastUpdate_time = -Inf + zeros(numberOfUsers,1);
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
    currentValue = [x11(i) x12(i) x13(i) x14(i) x15(i) x21(i) x22(i) x23(i) x24(i) x25(i)]';
    information_penalty = (currentValue - lastUpdate).^2;
    AoII = AoI .* information_penalty;
    
    selected_AoII = AoII(AoII>AoII_th & lastUpdate_time + 6.2 <= real_t);
    if ~isempty(selected_AoII)
        idx = find(AoII==selected_AoII(1));
        lastUpdate(idx) = currentValue(idx);
        lastUpdate_time(idx) = real_t;
        numberofTx(idx) = numberofTx(idx) + 1;
        AoI(idx) = 0;
        if AoII(idx) <= Reward_th
            reward(idx) = reward(idx) + r;
        else
            reward(idx) = reward(idx) + r/2;
        end
    end
    AoIILog(i,:) = AoII;
    AoILog(i,:) = AoI;
    NumberofTxLog(i,:) = numberofTx;
    RewardLog(i,:) = reward;
    AoI = AoI + slotSize;
end



%% ALOHA

AoIR = mod(abs(randn(1,numberOfUsers)),2)';

lastUpdateR = zeros(numberOfUsers,1);
lastUpdate_timeR = -Inf + zeros(numberOfUsers,1);
rewardR  = zeros(numberOfUsers,1);
numberofTxR = zeros(numberOfUsers,1);
frameCountR = 1;

collision = 0;
no_request = 0;

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
    currentValueR = [x11(iR) x12(iR) x13(iR) x14(iR) x15(iR) x21(iR) x22(iR) x23(iR) x24(iR) x25(iR)]';
    information_penaltyR = (currentValueR - lastUpdateR).^2;
    AoIIR = AoIR .* information_penaltyR;
    
    idx_ones  = find(users==1);
    idx_zeros = find(users==0);
    
    if sum(users) > 1
        if lastUpdate_timeR(idx_ones) + 6.2 <= real_tR %buraya bakalım
            collision = collision + 1;
        end
        for k = 1:1: sum(users)
            delay = ceil(exprnd(15));
            send_request_table(idx_ones(k),iiR + delay) = 1;
            send_request_table(idx_ones(k),iiR) = 0;
        end
    elseif(sum(users) < 1)
        no_request = no_request + 1;
    end
    
    for j = 1:1:numberOfUsers - sum(users) %0 olan durumlar
        if sum(send_request_table(idx_zeros(j),iiR:end)) < 1
            send_request_table(idx_zeros(j),iiR+1) = randi([0 1],1,1);
        end
    end
    
    users = send_request_table(:,iiR);
    
    if sum(users) == 1
        idxR = find(users==1);
        if lastUpdate_timeR(idxR) + 6.2  <= real_tR
            lastUpdateR(idxR) = currentValueR(idxR);
            lastUpdate_timeR(idxR) = real_tR;
            numberofTxR(idxR) = numberofTxR(idxR) + 1;
            AoIR(idxR) = 0;
            send_request_table(idxR,iiR) = 0;
            if AoIIR(idxR) <= Reward_th
                rewardR(idxR) = rewardR(idxR) + r;
            else
                rewardR(idxR) = rewardR(idxR) + r/2;
            end
        end
    end
    
    AoIILogR(iR,:) = AoIIR;
    AoILogR(iR,:) = AoIR;
    NumberofTxLogR(iR,:) = numberofTxR;
    RewardLogR(iR,:) = rewardR;
    AoIR = AoIR + slotSize;
end

%% results
fprintf("meanAoII: %.2f , mean AoIIR: %.2f , total_Reward: %g , total_RewardR: %g, total_Tx: %g, total_TxR: %g\n",mean(Total_AoIILog,'all'), mean(Total_AoIILogR,'all'), sum(Total_RewardLog(end,:,:),'all'), sum(Total_RewardLogR(end,:,:),'all'),sum(Total_NumberofTxLog(end,:,:),'all'),sum(Total_NumberofTxLogR(end,:,:),'all'));
fprintf("meanAoIIU1: %.2f , mean AoIIRU1: %.2f , total_RewardU1: %g , total_RewardRU1: %g, total_TxU1: %g, total_TxRU1: %g\n",mean(Total_AoIILog(:,1:5,:),'all'), mean(Total_AoIILogR(:,1:5,:),'all'), sum(Total_RewardLog(end,1:5,:),'all'), sum(Total_RewardLogR(end,1:5,:),'all'),sum(Total_NumberofTxLog(end,1:5,:),'all'),sum(Total_NumberofTxLogR(end,1:5,:),'all'));
fprintf("meanAoIIU2: %.2f , mean AoIIRU2: %.2f , total_RewardU2: %g , total_RewardRU2: %g, total_TxU2: %g, total_TxRU2: %g\n",mean(Total_AoIILog(:,6:10,:),'all'), mean(Total_AoIILogR(:,6:10,:),'all'), sum(Total_RewardLog(end,6:10,:),'all'), sum(Total_RewardLogR(end,6:10,:),'all'),sum(Total_NumberofTxLog(end,6:10,:),'all'),sum(Total_NumberofTxLogR(end,6:10,:),'all'));



