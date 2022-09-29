tic
n7 = 300;
ch7 = 0;
ch8 = 0;
if(n7>100)
    ch7 = 1;
end
if(n7>200)
    ch8 = 1;
end
% n8 = 100;
% n9 = 100;
% n10 = 100;
% n11 = 100;
% n12 = 100;
% n_array = [n7 n8 n9 n10 n11 n12];
% n = sum(n_array);
% ch7 = find(n_array==max(n_array));
% n_array(ch7)=n_array(ch7)-100;
% ch8 = find(n_array==max(n_array));
% ch8 = ch8(1);
% n_array = [n7 n8 n9 n10 n11 n12];
ages7 = randi(6200,1,n7);
% ages8 = randi(11300,1,n8);
% ages9 = randi(20600,1,n9);
% ages10 = randi(37100,1,n10);
% ages11 = randi(82300,1,n11);
% ages12 = randi(148300,1,n12);
horizon = 1.7e6;
ages_horizon = zeros(n7,horizon);
winners = zeros(1,n7);

for i=1:horizon
    % SF-7
    if(mod(mod(i,1700),62)==0)
        if(max(ages7)>6262)
            i7 = find(ages7==max(ages7));
            ages7(i7)= 0;
            winners(i7) = winners(i7) + 1;
            if(ch7 == 1 && max(ages7)>6262)
                i7 = find(ages7==max(ages7));
                ages7(i7)= 0;
                winners(i7) = winners(i7) + 1;
            end
            if(ch8 == 1 && max(ages7)>6262)
                i7 = find(ages7==max(ages7));
                ages7(i7)= 0;
                winners(i7) = winners(i7) + 1;
            end
        end
    end
%     % SF-8
%     if(mod(mod(i,1700),113)==0)
%         if(max(ages8)>11413)
%             i8 = find(ages8==max(ages8));
%             ages8(i8)= 0;
%             winners(i8+n7) = winners(i8+n7) + 1;
%             if(ch7 == 2)
%                 i8 = find(ages8==max(ages8));
%                 ages8(i8)= 0;
%                 winners(i8+n7) = winners(i8+n7) + 1;
%             end
%             if(ch8 == 2)
%                 i8 = find(ages8==max(ages8));
%                 ages8(i8)= 0;
%                 winners(i8+n7) = winners(i8+n7) + 1;
%             end
%         end
%     end
%     % SF-9
%     if(mod(mod(i,1700),206)==0)
%         if(max(ages9)>20806)
%             i9 = find(ages9==max(ages9));
%             ages9(i9)= 0;
%             winners(i9+n7+n8) = winners(i9+n7+n8) + 1;
%             if(ch7 == 3)
%                 i9 = find(ages9==max(ages9));
%                 ages9(i9)= 0;
%                 winners(i9+n7+n8) = winners(i9+n7+n8) + 1;
%             end
%             if(ch8 == 3)
%                 i9 = find(ages9==max(ages9));
%                 ages9(i9)= 0;
%                 winners(i9+n7+n8) = winners(i9+n7+n8) + 1;
%             end
%         end
%     end
%     %SF-10
%     if(mod(mod(i,1700),371)==0)
%         if(max(ages10)>37471)
%             i10 = find(ages10==max(ages10));
%             ages10(i10)= 0;
%             winners(i10+n7+n8+n9) = winners(i10+n7+n8+n9) + 1;
%             if(ch7 == 4)
%                 i10 = find(ages10==max(ages10));
%                 ages10(i10)= 0;
%                 winners(i10+n7+n8+n9) = winners(i10+n7+n8+n9) + 1;
%             end
%             if(ch8 == 4)
%                 i10 = find(ages10==max(ages10));
%                 ages10(i10)= 0;
%                 winners(i10+n7+n8+n9) = winners(i10+n7+n8+n9) + 1;
%             end
%         end
%     end
%     % SF-11
%     if(mod(mod(i,1700),823)==0)
%         if(max(ages11)>83123)
%             i11 = find(ages11==max(ages11));
%             ages11(i11)= 0;
%             winners(i11+n-n11-n12) = winners(i11+n-n11-n12) + 1;
%             if(ch7 == 5)
%                 i11 = find(ages11==max(ages11));
%                 ages11(i11)= 0;
%                 winners(i11+n-n11-n12) = winners(i11+n-n11-n12) + 1;
%             end
%             if(ch8 == 5)
%                 i11 = find(ages11==max(ages11));
%                 ages11(i11)= 0;
%                 winners(i11+n-n11-n12) = winners(i11+n-n11-n12) + 1;
%             end
%         end
%     end
%     % SF-12
%     if(mod(mod(i,1700),1483)==0)
%         if(max(ages12)>149783)
%             i12 = find(ages12==max(ages12));
%             ages12(i12)= 0;
%             winners(i12+n-n12) = winners(i12+n-n12) + 1;
%             if(ch7 == 6)
%                 i12 = find(ages12==max(ages12));
%                 ages12(i12)= 0;
%                 winners(i12+n-n12) = winners(i12+n-n12) + 1;
%             end
%             if(ch8 == 6)
%                 i12 = find(ages12==max(ages12));
%                 ages12(i12)= 0;
%                 winners(i12+n-n12) = winners(i12+n-n12) + 1;
%             end
%         end
%     end
    ages_horizon(1:n7,i)=ages7;
%     ages_horizon(n7+1:n7+n8,i)=ages8;
%     ages_horizon(n7+n8+1:n7+n8+n9,i)=ages9;
%     ages_horizon(n7+n8+n9+1:n-n11-n12,i)=ages10;
%     ages_horizon(n-n11-n12+1:n-n12,i)=ages11;
%     ages_horizon(n-n12+1:n,i)=ages12;
    ages7 = ages7 + 1;
%     ages8 = ages8 + 1;
%     ages9 = ages9 + 1;
%     ages10 = ages10 + 1;
%     ages11 = ages11 + 1;
%     ages12 = ages12 + 1;
end

mean_age7  = mean(ages_horizon(1:n7,:),"all");
% mean_age8  = mean(ages_horizon(n7+1:n7+n8,:),"all");
% mean_age9  = mean(ages_horizon(n7+n8+1:n7+n8+n9,:),"all");
% mean_age10 = mean(ages_horizon(n7+n8+n9+1:n-n11-n12,:),"all");
% mean_age11 = mean(ages_horizon(n-n11-n12+1:n-n12,:),"all");
% mean_age12 = mean(ages_horizon(n-n12+1:n,:),"all");

%mean_age = (mean_age7 + mean_age8 + mean_age9 + mean_age10 + mean_age11 + mean_age12)/6;

toc

plot(nodes,flora,LineWidth=1.5,Marker="*");
hold on
plot(nodes,lora,LineWidth=1.5,Marker="x");
grid minor




