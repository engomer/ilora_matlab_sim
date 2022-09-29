clear;clc;
tic
%for A=48:48:960
Nnum = [A/6 A/6 A/6 A/6 A/6 A/6]; %user numbers for sfs
ch7 = 0;
ch8 = 0;
if sum(Nnum > 100)
    [mN,mI] = max(Nnum);
    ch7 = mI;
    Nnum(mI) = Nnum(mI) - 100;
end
if sum(Nnum > 100)
    [mN,mI] = max(Nnum);
    ch8 = mI;
    Nnum(mI) = Nnum(mI) - 100;
end
n = sum(Nnum);
ToA = [6200 11300 20600 37100 82300 148300]; %ToA's for sfs
Ages = cell(1,6);
W = cell(1,6);
for sf =1:6
    Ages{sf} = randi(ToA(:,sf),1,Nnum(:,sf));
    W{sf} = zeros(Nnum(1,sf),1);
end
T = 1.7e6;
AgeLog = cell(1,6);
for t=1:1:T
    modFrame = mod(t,1700);
    modSF = mod(modFrame,ToA/100);
    for sf=1:1:6
        if(modSF(:,sf) == 0 && max(Ages{sf})>(ToA(:,sf)+ToA(:,sf)/100))
            [~,idx] = max(Ages{sf});
            Ages{sf}(:,idx) = 0;
            W{sf}(idx,1) = W{sf}(idx,1)+1;
            if(ch7==sf || ch8==sf)
                [~,idx] = max(Ages{sf});
                Ages{sf}(:,idx) = 0;
                W{sf}(idx,1) = W{sf}(idx,1)+1;
            end
        end
        AgeLog{sf}(:,t) = Ages{sf};
        Ages{sf} = Ages{sf}+1;
    end
end
meanUser = zeros(1.7e6,6);
for sf=1:6
    meanUser(:,sf) = mean(AgeLog{sf},1)/1000;
end
meanSF = mean(meanUser,'all');
clear AgeLog;
clear Ages;
%meanT(A/48) = meanSF;
%end
toc;

save("FLoRa.mat");