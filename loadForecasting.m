function y= loadForecasting(date, temperature, isHoliday)

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
    s = load('ISONECA_Data2.mat');
    data2 = s.data2;
    ind = data2.NumDate >= date-7 & floor(data2.NumDate) <= date-1;
    value1 = data2.Hr_End(ind);
    value2 = data2.Dry_Bulb(ind);
    value3 = data2.Dew_Point(ind);
    value4 = data2.System_Load(ind);
    value5 = data2.NumDate(ind);
    value6 = data2.Date(ind);
    data3 = struct('Date',value6,'Hr_End',value1,'Dry_Bulb',value2,'Dew_Point',value3,'System_Load',value4,'NumDate',value5);
if isempty(data3(1).System_Load)
    error('Not enough historical data for forecast.');
end
    
ave24 = filter(ones(24,1)/24, 1, data3(1).System_Load);
loadPredictors = [data3(1).System_Load(1:24) data3(1).System_Load(end-23:end) ave24(end-23:end)];

X = [temperature (1:24)' weekday(date)*ones(24,1) isWorkingDay*ones(24,1) loadPredictors];

try
    model1 = load('C:\Temp\Forecaster\NNModel.mat');
catch
    model1 = load('My_NNModel.mat');
end

try
    y1 = sim(model1.net, X')';
catch ME
    save C:\error.mat ME model1
    y1 = zeros(24,1);
end

% Create load profile plot

fig = clf;
if isdeployed
    set(fig,'Visible','off')
end
plot(y1/1e3, '.-');
xlabel('Hour');
ylabel('Load (x1000 MW)');
title(sprintf('Load Forecast Profile for %s', datestr(date)))
grid on;
legend('Neural Net','Location','best');
print -dmeta
y = y1;