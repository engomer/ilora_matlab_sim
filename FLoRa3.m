clear;
clc;
tic
for N=50:100:1000
C = 6; %number of channels
%N = 100; %number of sources
M = 24; %Frame size
T = M*100; %time horizon

SF = randi([1 6],1,N)';
SlotSpace = [1,2,4,8,12,24]; %number of slots occupied by different sfs
SS = SlotSpace(SF)'; %slot space for each source
ST = zeros(C,M); %Scheduling Table

AoI = zeros(N,1);
AoI_th = zeros(N,1);
TxLog = zeros(N,T);
for n=1:1:N
    AoI(n,1) = randi([0 N],1,1);
    AoI_th(n,1) = randi([1 N],1,1);
end

t = 0;
fCount = 1;

AoILog = zeros(N,T);

Tx = Inf + zeros(N,1);
k = 0;
while t<T
    t = t + 1;
    if(k==0)
        ST = zeros(C,M);
        fCount = fCount+1;
    end
    k = mod(t,M);
    AoI_tmp = AoI;
    notDCSatisfied = find(Tx~=Inf & (t-Tx)./SS < 100); %Duty cycle check
    AoI_tmp(notDCSatisfied) = 0;
    for ch=1:C
        maxArray = cell(6,1);
        for i= 1:6
            tmptuple(:,1) = find(SS==SlotSpace(i));
            tmptuple(:,2) = AoI_tmp(tmptuple(:,1));
            tmptuple = sortrows(tmptuple,2,'descend');
            maxArray{i,1} =  tmptuple;
            clear tmptuple;
        end
        %find the max of max array
        idx = find(maxArray{ch,1}(:,2)==max(maxArray{ch,1}(:,2)),1);
        if k~=0 && ST(ch,k) == 0 && AoI_tmp(maxArray{ch,1}(idx,1),1)~= 0 && k+SS(maxArray{ch,1}(idx,1),1) <= M
            ST(ch,k:k+SS(maxArray{ch,1}(idx,1),1)-1) = 1;
            AoI(maxArray{ch,1}(idx,1)) = 0;
            Tx(maxArray{ch,1}(idx,1),1) = t;
        elseif k==0 && ST(ch,M) == 0 && AoI_tmp(maxArray{ch,1}(idx,1))~=0 && ch==1
            ST(ch,100) = 1;
            AoI(maxArray{ch,1}(idx,1)) = 0;
            Tx(maxArray{ch,1}(idx,1),1) = t;
        end
    end
    
    TxLog(:,t) = Tx;
    AoILog(:,t) = AoI;
    AoI = AoI + 1;

    
end

mI = mean(AoILog,'all')*62e-3;
mIT(N/50) = mI;
end
%plot(50:50:1000,mI,'b--o');grid minor; xlabel("Number of Sources"); ylabel("Avg AoI (sec)");

toc
%save("ILoRa.mat");