

col1 = 'b';
col2 = 'r';
col3 = 'k';
col4 = 'g';

AoII_mean_by_frame = reshape(mean(Total_AoIILog(:,:,:)),[],6);
AoII_mean_by_frameR = reshape(mean(Total_AoIILogR(:,:,:)),[],6);
AoI_mean_by_frame = reshape(mean(Total_AoILog(:,:,:)),[],6);
Reward_mean_by_frame = reshape(Total_RewardLog(end,:,:),[],6);
Reward_mean_by_frameR = reshape(Total_RewardLogR(end,:,:),[],6);
Tx_sum_by_frame = reshape(mean(Total_AoIILog(end,:,:)),[],6);

figure
plot(1:6,mean(AoII_mean_by_frame(1:5,:)), 'b--o'); hold on;  plot(1:6,mean(AoII_mean_by_frameR(1:5,:)), 'r--*');
plot(1:6,mean(AoII_mean_by_frame(6:10,:)), 'k--o'); hold on;  plot(1:6,mean(AoII_mean_by_frameR(6:10,:)), 'g--*');
grid minor
legend(["ILoRa U-Type 1","ALOHA U-Type 1","ILoRa U-Type 2","ALOHA U-Type 2"]);
xlabel("Frame Number");
ylabel("Mean AoII");
title("Mean AoII for same type of users");

figure
plot(1:6,mean(Reward_mean_by_frame(1:5,:)), 'b--o'); hold on;  plot(1:6,mean(Reward_mean_by_frameR(1:5,:)), 'r--*');
plot(1:6,mean(Reward_mean_by_frame(6:10,:)), 'k--o'); hold on;  plot(1:6,mean(Reward_mean_by_frameR(6:10,:)), 'g--*');
grid minor
legend(["ILoRa U-Type 1","ALOHA U-Type 1","ILoRa U-Type 2","ALOHA U-Type 2"]);
xlabel("Frame Number");
ylabel("Mean Reward");
title("Mean Reward for same type of users");

