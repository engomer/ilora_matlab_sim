clear;
clc;
tic
mIT = zeros(1,20);
mIIT = zeros(1,20);
mUT = zeros(1,20);

for N=50:50:1000
C = 8; %number of channels
%N = 10; %number of sources
M = 800; %Frame size
T = M*100; %time horizon

SF = randi([1 6],1,N)';
SlotSpace = [1,2,4,8,12,24]; %number of slots occupied by different sfs
SS = SlotSpace(SF)'; %slot space for each source
ST = zeros(C,M); %Scheduling Table

AoI = zeros(N,1);
AoI_th = zeros(N,1);

for n=1:1:N
    AoI(n,1) = randi([0 N],1,1);
    AoI_th(n,1) = randi([1 N],1,1);
end

t = 0;
fCount = 1;

AoII = AoI - AoI_th;
AoII(AoII<0) = 0;

AoILog = zeros(N,T);
AoIILog = zeros(N,T);
AoII_tmpLog = zeros(N,T);
TxLog = zeros(N,T);
UTLog = zeros(N,T);

Tx = Inf + zeros(N,1);
UT = zeros(N,1);

k = 0;

while t<T
    t = t + 1;
    if(k==0)
        ST = zeros(C,M);
        fCount = fCount+1;
    end
    k = mod(t,M);
    AoII_tmp = AoII;
    notDCSatisfied = find(Tx~=Inf & (t-Tx)./SS < 100); %Duty cycle check
    AoII_tmp(notDCSatisfied) = 0;
    for ch=1:C
        maxArray = cell(6,1);
        maxi = zeros(6,1);
        maxVals = zeros(6,1);
        for i= 1:6
            tmptuple(:,1) = find(SS==SlotSpace(i));
            tmptuple(:,2) = AoII_tmp(tmptuple(:,1));
            tmptuple = sortrows(tmptuple,2,'descend');
            maxArray{i,1} =  tmptuple;
            clear tmptuple;
            maxi(i,1) = maxArray{i,1}(1,1);
            maxVals(i,1) = maxArray{i,1}(1,2);
        end
        
        idx = maxi(find(maxVals==max(maxVals),1));
        %find the max of max array
        if k~=0 && ST(ch,k) == 0 && AoII_tmp(idx)~= 0 && k+SS(idx,1) < M
            ST(ch,k:k+SS(idx,1)-1) = 1;
            AoI(idx) = 0;
            AoII(idx) = 0;
            Tx(idx,1) = t;
            UT(idx,1) = UT(idx,1) + 1;
        elseif k~=0 && ST(ch,k) == 0 && AoII_tmp(idx) ~= 0 && k+SS(idx,1)>M
            candidx = find(SlotSpace<sum(ST(ch,k:end)==0));
            reducedmax = find(maxVals == max(maxVals(candidx)),1);
            ST(ch,k:k+SS(maxi(reducedmax,1))-1) = 1;
            AoI(maxi(reducedmax)) = 0;
            AoII(maxi(reducedmax)) = 0;
            Tx(maxi(reducedmax),1) = t;
            UT(maxi(1),1) = UT(maxi(1),1) + 1;
        elseif k==0 && ST(ch,M) == 0 && AoII_tmp(maxi(1))~=0
            ST(ch,100) = 1;
            AoI(maxi(1)) = 0;
            AoII(maxi(1)) = 0;
            Tx(maxi(1)) = t;
            UT(maxi(1)) = UT(maxi(1)) + 1;
        end
    end
    
    TxLog(:,t) = Tx;
    %UTLog(:,t) = UT;
    AoII_tmpLog(:,t) = AoII_tmp;
    AoILog(:,t) = AoI;
    AoIILog(:,t) = AoII;
    AoI = AoI + 1;
    AoII(AoI>=AoI_th) = AoII(AoI>=AoI_th) + 1;
    AoII(AoI<=AoI_th) = 0;
    
end

mI = mean(AoILog,'all')*62e-3;
mII = mean(AoIILog,'all')*62e-3;
mU = sum(UT)/N;

mIT(N/50) = mI;
mIIT(N/50) = mII;
mUT(N/50) = mU;
end
%plot(50:50:1000,mIT,'b--o');grid minor; xlabel("Number of Sources"); ylabel("Avg AoI (sec)");
%save("ILoRa_800_frame_size.mat");
toc