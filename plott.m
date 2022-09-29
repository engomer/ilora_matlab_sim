%%
%load("all1.mat");
N1 = 48:48:960;
N2 = 50:50:1000;
SLora = statest;
ILoRa = mIT;
figure;

plot(N1,ILoRa,"b--o");
hold on;
%plot(N1,Flora,"r--*");
plot(N2,SLora/1000 ,"r--*");


xlabel("Number of users");
ylabel("Average AoI (sec)");
grid MINOR
legend(["ILoRa","Standard LoRa"],"Location","northwest");


%%
clear;clc;
load("standard_lora2.mat");
load("ILoRa_800_frame_size.mat");
figure
plot(50:50:1000,mUT,"b--o");
hold on;
plot(48:48:960,Wm,"r--*");
xlabel("Number of users");
ylabel("Average Utility");
grid minor
legend(["ILoRa","Standard LoRa"]);

%%
clear;clc;
load("ILora400f.mat");
load("standard_lora.mat");
load("ILoRa_onlymeans_800_frame_size.mat");
figure
plot(50:50:1000,mUT,"b--o");
hold on;
plot(50:50:1000,mUT_400,"g--+");
plot(48:48:960,Wm,"r--*");
xlabel("Number of Sources");
ylabel("Average Utility");
grid minor
legend(["ILoRa fSize = 800","ILoRa fSize = 400","Standard LoRa"]);