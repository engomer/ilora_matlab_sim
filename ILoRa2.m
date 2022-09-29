clear;
clc;
tic
%j=1;
%for N = 100:100:1000

C = 8; %number of channels
N = 100; %number of sources
M = 100; %Frame size
T = M*100; %time horizon

SF = randi([1 6],1,N)';
SlotSpace = [1,2,4,8,12,24]; %number of slots occupied by different sfs
SS = SlotSpace(SF)'; %slot space for each source
ST = zeros(C,M); %Scheduling Table

AoI = zeros(N,1);
AoI_th = zeros(N,1);
TxTime = Inf + zeros(N,1);
for n=1:1:N
    AoI(n,1) = randi([0 30],1,1);
    AoI_th(n,1) = randi([0 60],1,1);
end

t = 0;
fCount = 1;
AoII = AoI - AoI_th;
AoII(AoII<0) = 0;

Tx = Inf+ zeros(N,1);
while t<T
    t=t+1;
    k = mod(t,M);
    maxArray = cell(6,1);
    AoII_tmp = AoII;
    nottx = find(Tx~=Inf & (t-Tx)./SS < 99);
    AoII_tmp(nottx,1) = 0;
    for ch=1:C
        %find max for each sf
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
        if k~=0 && ST(ch,k) == 0 && max(maxVals)~=0
            %idx = find(AoII==max(AoII),1);
            if k+SS(idx,1) <= M
                ST(ch,k:k+SS(idx,1)-1) = 1;
                AoI(idx) = 0;
                AoII(idx) = 0;
                Tx(idx,1) = t;
            else %%elseif deyip koşullu mu yazılsa
                candidx = find(SlotSpace<sum(ST(ch,k:end)==0));
                reducedmax = find(maxVals == max(maxVals(candidx)),1);
                ST(ch,k:k+SS(maxi(reducedmax,1))-1) = 1;
                AoI(maxi(reducedmax)) = 0;
                AoII(maxi(reducedmax)) = 0;
                Tx(maxi(reducedmax),1) = t;
            end

        end
        if k==0 && ST(ch,100) == 0 && max(maxVals)~=0
            ST(ch,100) = 1;
            AoI(maxi(1)) = 0;
            AoII(maxi(1)) = 0;
            Tx(maxi(1),1) = t;
        end
    end
    
    if(k==0)
        ST = zeros(C,M);
        fCount = fCount+1;
    end
    AoILog(:,t) = AoI;
    AoIILog(:,t) = AoII;
    %AoILog(:,t) = mean(AoI);
    %AoIILog(:,t) = mean(AoII);
    AoI = AoI + 1;
    AoII(find(AoI>AoI_th)) = AoII(find(AoI>AoI_th)) + 1;
    AoII(find(AoI<=AoI_th)) = 0;
    
end

mI = mean(AoILog,'all')*62e-3;
mII = mean(AoIILog,'all')*62e-3;
%mI(j) = mean(AoILog,'all')*62e-3;
%mII(j) = mean(AoIILog,'all')*62e-3;
%j = j+1;
%end
toc