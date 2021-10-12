% a = group_data(:,1);
% b = nansum((group_data(a==4,2:5))>=0)/sum(a==4)
% b = nansum((group_data(a==5,2:5))>=0)/sum(a==5)


% a = group_data(:,1);
% group_data(group_data<-100)=nan;
% b = nansum((group_data(a==1,2:5)))./nansum((group_data(a==1,2:5))>-100)
% b = nansum((group_data(a==2,2:5))>0)./nansum((group_data(a==2,2:5))>-100)
% b = nansum((group_data(a==3,2:5))>0)./nansum((group_data(a==3,2:5))>-100)
% b = nansum((group_data(a==4,2:5))>0)./nansum((group_data(a==4,2:5))>-100)
% b = nansum((group_data(a==5,2:5))>0)./nansum((group_data(a==5,2:5))>-100)

% a = group_data(:,1);
% b = nansum((group_data(a==1,2:5))>0)/sum(a==1)
% b = nansum((group_data(a==2,2:5))>0)/sum(a==2)
% b = nansum((group_data(a==3,2:5))>0)/sum(a==3)
% b = nansum((group_data(a==4,2:5))>0)/sum(a==4)
% b = nansum((group_data(a==5,2:5))>0)/sum(a==5)

% alldata = mean_elevation(:);
% 
% sum(alldata<1500)./sum(alldata>0)
% sum(alldata>=1500 & alldata<2500)./sum(alldata>0)
% sum(alldata>=2500 & alldata<3500)./sum(alldata>0)
% sum(alldata>=3500 & alldata<4500)./sum(alldata>0)
% sum(alldata>=4500)./sum(alldata>0)

a = group_data(:,1);
group_data(group_data<-1 | group_data>1)=nan;
b = nanmean((group_data(a==1,2:5)))
b = nanmean((group_data(a==2,2:5)))
b = nanmean((group_data(a==3,2:5)))
b = nanmean((group_data(a==4,2:5)))
b = nanmean((group_data(a==5,2:5)))


