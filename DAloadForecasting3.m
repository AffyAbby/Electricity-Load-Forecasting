function [y, mape]= DAloadForecasting3(date, isHoliday)

date = datenum(date);
if date < 7e5
    date = x2mdate(date);
end
if strcmpi(isHoliday(1),'N')
    isWorkingDay = true;
else
    isWorkingDay = false;
end
isWorkingDay = logical(isWorkingDay) & ~ismember(weekday(date),[1 7]);
    temp = readmatrix('WeekLoadData.xlsm','Sheet','Oct Temps');
    temp = dataset(temp(:,1),temp(:,2),temp(:,3),temp(:,4));
    temp=set(temp,'VarNames',{'Date','Hr_End','Dry_Bulb','Dew_Point'});
    temp.Date = x2mdate(temp.Date);
    ind0 = temp.Date==date;
    temperature = [temp.Dry_Bulb(ind0) temp.Dew_Point(ind0)];
    %wld = readmatrix('WeekLoadData.xlsm','Sheet','Oct Data');
    %data2 = LoadDataFilter2(wld);
    %LoadDataFilter2
    s = load('OctFilteredLoad.mat');
    data2 = s.data2;
    data2.Date = x2mdate(data2.Date);
    ind = data2.Date >= date-7 & floor(data2.Date) <= date-1;
    sl = data2.System_Load(ind);
ave24 = filter(ones(24,1)/24, 1, sl);
loadPredictors = [sl(1:24) sl(end-23:end) ave24(end-23:end)];
X = [temperature (1:24)' weekday(date)*ones(24,1) isWorkingDay*ones(24,1) loadPredictors];
nn = 'My_NNModel_SCG7.mat';
disp("Using "+nn);
model1 = load(nn);
y1 = sim(model1.net, X')';
ind2 = floor(data2.Date)==date;
yor = data2.System_Load(ind2);
mape = mean((abs(y1-yor)./yor*100));
fprintf('MAPE for %s = %f\n',datestr(date),mape);
% Create load profile plot
fig = clf;
if isdeployed
    set(fig,'Visible','off')
end
plot([y1 yor]/1e3, '.-');
xlabel('Hour');
ylabel('Load (x1000 MW)');
title(sprintf('Load Forecast Profile for %s', datestr(date)))
grid on;
print -dmeta
y = y1;