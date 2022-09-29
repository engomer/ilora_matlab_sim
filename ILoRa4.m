clear;
clc;
tic
mean_AoI = zeros(1,20);
mean_AoII = zeros(1,20);
mean_Util = zeros(1,20);
mean_Reward = zeros(1,20);
total_Reward = zeros(1,20);
total_Util = zeros(1,20);
reward = 1;
step_size = 50;
for N=50:step_size:1000
    Ch = 8; %number of channels
    %N = 10; %number of sources
    M = 300; %Frame size
    T = M*100; %time horizon
    
    SF = randi([1 6],1,N)';
    SS = [1,2,4,8,12,24]; %number of slots occupied by different sfs
    SlotSpace = SS(SF)'; %slot space for each source
    Sch_table = zeros(Ch,M); %Scheduling Table
    
    AoI = zeros(N,1);
    AoII_th = zeros(N,1);
    Reward_th = zeros(N,1);
    inf_penalty_fnc = zeros(N,1);
    for n=1:1:N
        AoI(n,1) = randi([0 N],1,1);
        Reward_th(n,1) = randi([0 N],1,1);
        AoII_th(n,1) = randi([0 Reward_th(n,1)],1,1);
        inf_penalty_fnc(n,1) = randi([0 1],1,1);
    end
    
    t = 0;
    fCount = 1;
    
    AoII = AoI.*inf_penalty_fnc;
    
    
    AoILog = zeros(N,T);
    AoIILog = zeros(N,T);
    Total_reward_Log = zeros(N,T);
    AoII_tmpLog = zeros(N,T);
    TxLog = zeros(N,T);
    
    Tx = Inf + zeros(N,1);
    Util = zeros(N,1);
    reward_Log = zeros(N,1);
    
    k = 0;
    while t<T
        t = t + 1;
        if(k==0)
            Sch_table = zeros(Ch,M);
            fCount = fCount+1;
        end
        k = mod(t,M);
        
        AoII_tmp = AoII;
        notDuty_Cyc_Satisfied = find(Tx~=Inf & (t-Tx)./SlotSpace < 100); %Duty cycle check
        AoII_tmp(notDuty_Cyc_Satisfied) = 0;
        AoII_th_notSatisfied = find(AoII_tmp<AoII_th);
        inf_penalty_fnc(AoII_th_notSatisfied) = 0;
        AoII_usable_users 
        for ch=1:Ch
            sch_Array = cell(6,1);
            
            AoII_full_reward = AoII_tmp(AoII_tmp<Reward_th & AoII_tmp > 0);
            AoII_full_reward_idx = find(AoII_tmp<Reward_th & AoII_tmp > 0);
            AoII_half_reward = AoII_tmp(AoII_tmp>=Reward_th & AoII_tmp > 0);
            AoII_half_reward_idx = find(AoII_tmp>=Reward_th & AoII_tmp > 0);
            SS_AoII_full_reward_idx = SlotSpace(AoII_full_reward_idx);
            SS_AoII_half_reward_idx = SlotSpace(AoII_half_reward_idx);
            for i= 1:6
                if isempty(AoII_full_reward_idx(SS_AoII_full_reward_idx==SS(i)))~=1
                    tmptuple1(:,1) = AoII_full_reward_idx(SS_AoII_full_reward_idx==SS(i));
                    tmptuple1(:,2) = AoII_tmp(tmptuple1(:,1));
                end
                if isempty(AoII_half_reward_idx(SS_AoII_half_reward_idx==SS(i)))~=1
                    tmptuple2(:,1) = AoII_half_reward_idx(SS_AoII_half_reward_idx==SS(i));
                    tmptuple2(:,2) = AoII_tmp(tmptuple2(:,1));
                end
                if exist("tmptuple1","var") && exist("tmptuple2","var")
                    tmptuple = [tmptuple1;tmptuple2];
                elseif exist("tmptuple1","var")
                    tmptuple = tmptuple1;
                elseif exist("tmptuple2","var")
                    tmptuple = tmptuple2;
                else
                    tmptuple = [];
                end
                
                sch_Array{i,1} =  tmptuple;
                clear tmptuple1 tmptuple2 tmptuple;
            end
            empty_cell_count = 0;
            for ii = 1:6
                empty_cell_count = empty_cell_count + isempty(sch_Array{ii,1});
            end
            random_selector = randi([1 6],1,1);
            while isempty(sch_Array{random_selector,1}) && empty_cell_count ~= 6
                random_selector = randi([1 6],1,1);
            end
            
            if empty_cell_count ~= 6
                idx = sch_Array{random_selector,1}(1,1);
                if isempty(sch_Array{1,1})~= 1
                    idx_first = sch_Array{1,1}(1,1);
                end
                %find the max of max array
                if k~=0 && Sch_table(ch,k) == 0 && AoII_tmp(idx)~= 0 && k+SlotSpace(idx,1) < M
                    Sch_table(ch,k:k+SlotSpace(idx,1)-1) = 1;
                    AoI(idx) = 0;
                    AoII(idx) = 0;
                    Tx(idx,1) = t;
                    Util(idx,1) = Util(idx,1) + 1;
                    inf_penalty_fnc(idx,1) = 0;
                    if sum(AoII_full_reward_idx==idx) == 1
                        reward_Log(idx,1) = reward;
                    end
                    if sum(AoII_half_reward_idx==idx) == 1
                        reward_Log(idx,1) = reward/2;
                    end
                elseif k~=0 && Sch_table(ch,k) == 0 && AoII_tmp(idx) ~= 0 && k+SlotSpace(idx,1)>M
                    cand_idx = find(SS<sum(Sch_table(ch,k:end)==0));
                    
                    for ii = cand_idx(end):-1:1
                        if isempty(sch_Array{ii,1}) == 1
                            continue;
                        else
                            idx_second = sch_Array{ii,1}(1,1);
                            break;
                        end
                    end
                    if exist("idx_second","var")== 1
                        Sch_table(ch,k:k+SlotSpace(idx_second)-1) = 1;
                        AoI(idx_second) = 0;
                        AoII(idx_second) = 0;
                        Tx(idx_second,1) = t;
                        Util(idx_second,1) = Util(idx_second,1) + 1;
                        inf_penalty_fnc(idx_second,1) = 0;
                        if sum(AoII_full_reward_idx==idx_second) == 1
                            reward_Log(idx_second,1) = reward;
                        end
                        if sum(AoII_half_reward_idx==idx_second) == 1
                            reward_Log(idx_second,1) = reward/2;
                        end
                    end
                elseif k==0 && Sch_table(ch,M) == 0 && AoII_tmp(idx_first)~=0 && exist("idx_first","var")
                    Sch_table(ch,100) = 1;
                    AoI(idx_first) = 0;
                    AoII(idx_first) = 0;
                    Tx(idx_first) = t;
                    Util(idx_first) = Util(idx_first) + 1;
                    inf_penalty_fnc(idx_first,1) = 0;
                    if sum(AoII_full_reward_idx==idx_first) == 1
                        reward_Log(idx_first,1) = reward;
                    end
                    if sum(AoII_half_reward_idx==idx_first) == 1
                        reward_Log(idx_first,1) = reward/2;
                    end
                end
            end
        end
        
        TxLog(:,t) = Tx;
        AoII_tmpLog(:,t) = AoII_tmp;
        AoILog(:,t) = AoI;
        AoIILog(:,t) = AoII;
        Total_reward_Log(:,t) = reward_Log;
        AoI = AoI + 1;
        AoII = AoI.*inf_penalty_fnc;
        
        for n=1:1:N
            inf_penalty_fnc(n,1) = randi([0 1],1,1);
        end
         
    end
    
    mI = mean(AoILog,'all')*61.7e-3;
    mII = mean(AoIILog,'all')*61.7e-3;
    mU = sum(Util)/N;
    mR = sum(reward_Log)/N;
    
    mean_AoI(N/step_size) = mI;
    mean_AoII(N/step_size) = mII;
    mean_Util(N/step_size) = mU;
    mean_Reward(N/step_size) = mR;
    total_Util(N/step_size) = sum(Util);
    total_Reward(N/step_size) = sum(reward_Log);
end
save("AoII_th_and_reward_th_AoIIlessthanrewardModified_50to1000u_300fsize_100mhorizon.mat");
toc