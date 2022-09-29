clear;
clc;
tic

for N=50:50:1000

C = 8; %number of channels
%N = ; %number of sources
M = 300; %Frame size
T = M*100; %time horizon

SlotSpace = 1; %number of slots occupied by different sfs
SS = SlotSpace + zeros(N,1); %slot space for each source
ST = zeros(C,M); %Scheduling Table

AoI = zeros(N,1);
AoI_th = zeros(N,1);

for n=1:1:N
    AoI(n,1) = randi([0 M],1,1);
    AoI_th(n,1) = randi([1 M],1,1);
end

t = 0;
fCount = 1;

AoII = AoI - AoI_th;
AoII(AoII<0) = 0;

AoILog = zeros(N,T);
AoIILog = zeros(N,T);
TxLog = zeros(N,T);
AoII_tmpLog = zeros(N,T);

Tx = Inf + zeros(N,1);
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

        idx = find(AoII_tmp==max(AoII_tmp),1);
        %find the max of max array
        if k~=0 && ST(ch,k) == 0 && AoII_tmp(idx)~= 0 && k+SS(idx,1) < M
            ST(ch,k) = 1;
            AoI(idx) = 0;
            AoII(idx) = 0;
            Tx(idx) = t;
        elseif k==0 && ST(ch,M) == 0 && AoII_tmp(idx)~=0
            ST(ch,100) = 1;
            AoI(idx) = 0;
            AoII(idx) = 0;
            Tx(idx) = t;
        end
    end
    
    TxLog(:,t) = Tx;
    AoII_tmpLog(:,t) = AoII_tmp;
    AoILog(:,t) = AoI;
    AoIILog(:,t) = AoII;
    AoI = AoI + 1;
    AoII(AoI>=AoI_th) = AoII(AoI>=AoI_th) + 1;
    AoII(AoI<=AoI_th) = 0;
    
end

mI = mean(AoILog,'all')*62e-3;
mII = mean(AoIILog,'all')*62e-3;

mIT(N/50) = mI;
mIIT(N/50) = mII;

end
plot(50:50:1000,mIT,'b--o');grid minor; xlabel("Number of Sources"); ylabel("Avg AoI (sec)");
toc