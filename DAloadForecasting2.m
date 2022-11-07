function y = DAloadForecasting2(date, temperature, isHoliday)

date = datenum(date);
if date < 7e5
    date = x2mdate(date);
end

if iscell(isHoliday)
    isHoliday = isHoliday{1};
end
if ischar(isHoliday)
    if strcmpi(isHoliday(1),'N')
        isWorkingDay = true;
    else
        isWorkingDay = false;
    end
else
    isWorkingDay = ~isHoliday;
end
isWorkingDay = logical(isWorkingDay) & ~ismember(weekday(date),[1 7]);
    wld = readmatrix('WeekLoadData.xlsm','Sheet','To be filtered','Range','A1:C2005');
    %wld = readmatrix('WeekLoadData.xlsm','Sheet','Oct Data');
    data2 = LoadDataFilter2(wld);
    %s = load('OctFilteredLoad.mat');
    %data2 = s.data2;
    %data2.Date = x2mdate(data2.Date);
    %ind = data2.Date >= date-7 & floor(data2.Date) <= date-1;
    %sl = data2.System_Load;
    sl = data2.System_Load(ind);
ave24 = filter(ones(24,1)/24, 1, sl);
loadPredictors = [sl(1:24) sl(end-23:end) ave24(end-23:end)];

X = [temperature (1:24)' weekday(date)*ones(24,1) isWorkingDay*ones(24,1) loadPredictors];
nn = 'My_NNModel_SCG2.mat';
disp("Using "+nn);
model1 = load(nn);
y1 = sim(model1.net, X')';
al=[9742
9486
9391
9400
9660
10217
10906
11328
10643
9794
9129
8765
8569
8709
9192
10410
11535
12500
12690
12295
11720
11095
10490
9940
];
%ind2 = floor(data2.Date)==date;
%yor = data2.System_Load(ind2);
mape = mean((abs(y1-al)./al*100));
%mape = mean((abs(y1-yor)./yor*100));
fprintf('MAPE for %s = %f\n',datestr(date),mape);
% Create load profile plot
com = [y1 al];
fig = clf;
if isdeployed
    set(fig,'Visible','off')
end
%plot(y1/1e3, '.-');
plot([y1 al]/1e3, '.-');
xlabel('Hour');
ylabel('Load (x1000 MW)');
title(sprintf('Load Forecast Profile for %s', datestr(date)))
grid on;
print -dmeta
y = y1;