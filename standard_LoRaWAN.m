clear;clc;
tic
for n=48:48:960
horizon = 1.7e6;
%n=960;
n7 = n/6;
n8 = n/6;
n9 = n/6;
n10 = n/6;
n11 = n/6;
n12 = n/6;
ages7 = randi(6200,1,n7);
channels7 = randi(8,1,n7);
ages8 = randi(11300,1,n8);
channels8 = randi(8,1,n8);
ages9 = randi(20600,1,n9);
channels9 = randi(8,1,n9);
ages10 = randi(37100,1,n10);
channels10 = randi(8,1,n10);
ages11 = randi(82300,1,n11);
channels11 = randi(8,1,n11);
ages12 = randi(148300,1,n12);
channels12 = randi(8,1,n12);
states_table = zeros(n,horizon);
colcount7 = 0;
colcount8 = 0;
colcount9 = 0;
colcount10 = 0;
colcount11 = 0;
colcount12 = 0;
winners = zeros(1,n);
yancount7 = zeros(1,n7);
yancount8 = zeros(1,n8);
yancount9 = zeros(1,n9);
yancount10 = zeros(1,n10);
yancount11 = zeros(1,n11);
yancount12 = zeros(1,n12);
for i=1:horizon
    for j=1:n7
        if(ages7(j)==6200 || yancount7(j) == 6200)
            ages72 = abs(ages7-6200);
            ages7ind = find(ages72<62);
            for k = 1:length(ages7ind)
                if(ages7ind(k)~=j)
                    if(channels7(ages7ind(k))==channels7(j))
                        col7flag = 1;
                    end
                end
            end
            if(col7flag == 1)
                ages7(j)=ages7(j)+1;
                colcount7 = colcount7 + 1;
                yancount7(j)=1;
            elseif(col7flag == 0)
                ages7(j)=0;
                channels7(j)=randi(8);
                winners(j)=winners(j)+1;
                yancount7(j)=0;
            end
        else
            ages7(j)=ages7(j)+1;
            if(yancount7(j)>0)
                yancount7(j) = yancount7(j) + 1;
            end
        end
    end
    for j=1:n8
        if(ages8(j)==11300 || yancount8(j)==11300)
            ages82 = abs(ages8-11300);
            ages8ind = find(ages82<113);
            for k = 1:length(ages8ind)
                if(ages8ind(k)~=j)
                    if(channels8(ages8ind(k))==channels8(j))
                        col8flag = 1;
                    end
                end
            end
            if(col8flag == 1)
                ages8(j)=ages8(j)+1;
                colcount8 = colcount8 + 1;
                yancount8(j)=1;
            elseif(col8flag == 0)
                ages8(j)=0;
                channels8(j)=randi(8);
                winners(j+n7)=winners(j+n7)+1;
                yancount8(j)=0;
            end
        else
            ages8(j)=ages8(j)+1;
            if(yancount8(j)>0)
                yancount8(j) = yancount8(j) + 1;
            end
        end
    end
    for j=1:n9
        if(ages9(j)==20600)
            ages92 = abs(ages9-20600);
            ages9ind = find(ages92<206);
            for k = 1:length(ages9ind)
                if(ages9ind(k)~=j)
                    if(channels9(ages9ind(k))==channels9(j))
                        col9flag = 1;
                    end
                end
            end
            if(col9flag == 1)
                ages9(j)=ages9(j)+1;
                colcount9 = colcount9 + 1;
                yancount9(j)=1;
            elseif(col9flag == 0)
                ages9(j)=0;
                channels9(j)=randi(8);
                winners(j+n7+n8)=winners(j+n7+n8)+1;
                yancount9(j)=0;
            end
        else
            ages9(j)=ages9(j)+1;
            if(yancount9(j)>0)
                yancount9(j) = yancount9(j) + 1;
            end
        end
    end
    for j=1:n10
        if(ages10(j)==37100)
            ages102 = abs(ages10-37100);
            ages10ind = find(ages102<371);
            for k = 1:length(ages10ind)
                if(ages10ind(k)~=j)
                    if(channels10(ages10ind(k))==channels10(j))
                        col10flag = 1;
                    end
                end
            end
            if(col10flag == 1)
                ages10(j)=ages10(j)+1;
                colcount10 = colcount10 + 1;
                yancount10(j)=1;
            elseif(col10flag == 0)
                ages10(j)=0;
                channels10(j)=randi(8);
                winners(j+n7+n8+n9)=winners(j+n7+n8+n9)+1;
                yancount10(j)=0;
            end
        else
            ages10(j)=ages10(j)+1;
            if(yancount10(j)>0)
                yancount10(j) = yancount10(j) + 1;
            end
        end
    end
    for j=1:n11
        if(ages11(j)==82300)
            ages112 = abs(ages11-82300);
            ages11ind = find(ages112<823);
            for k = 1:length(ages11ind)
                if(ages11ind(k)~=j)
                    if(channels11(ages11ind(k))==channels11(j))
                        col11flag = 1;
                    end
                end
            end
            if(col11flag == 1)
                ages11(j)=ages11(j)+1;
                colcount11 = colcount11 + 1;
                yancount11(j)=1;
            elseif(col11flag == 0)
                ages11(j)=0;
                channels11(j)=randi(8);
                winners(j+n-n12-n11)=winners(j+n-n12-n11)+1;
                yancount11(j)=0;
            end
        else
            ages11(j)=ages11(j)+1;
            if(yancount11(j)>0)
                yancount11(j) = yancount11(j) + 1;
            end
        end
    end
    for j=1:n12
        if(ages12(j)==148300)
            ages122 = abs(ages12-148300);
            ages12ind = find(ages122<1483);
            for k = 1:length(ages12ind)
                if(ages12ind(k)~=j)
                    if(channels12(ages12ind(k))==channels12(j))
                        col12flag = 1;
                    end
                end
            end
            if(col12flag == 1)
                ages12(j)=ages12(j)+1;
                colcount12 = colcount12 + 1;
                yancount12(j)=1;
            elseif(col12flag == 0)
                ages12(j)=0;
                channels12(j)=randi(8);
                winners(j+n-n12)=winners(j+n-n12)+1;
                yancount12(j)=0;
            end
        else
            ages12(j)=ages12(j)+1;
            if(yancount12(j)>0)
                yancount12(j) = yancount12(j) + 1;
            end
        end
    end
    col7flag = 0;
    col8flag = 0;
    col9flag = 0;
    col10flag = 0;
    col11flag = 0;
    col12flag = 0;
    states_table(1:n7,i)=ages7;
    states_table(n7+1:n7+n8,i)=ages8;
    states_table(n7+n8+1:n7+n8+n9,i)=ages9;
    states_table(n7+n8+n9+1:n-n12-n11,i)=ages10;
    states_table(n-n12-n11+1:n-n12,i)=ages11;
    states_table(n-n12+1:n,i)=ages12;
end
statest(n/48) = mean(states_table,'all');
Wm(n/48) = sum(winners)/n;
end
toc
save("standard_lora.mat");





