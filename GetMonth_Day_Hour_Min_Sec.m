function GetMonth_Day_Hour_Min_Sec(TLEtime)
%该函数输入参数Days是两行根数中的时间，如16259.76121521表示是2016年
%中的第259.76121521天.
%注意：该函数仅适用于2000年以后的两行根数计算.

%获取年份.
Year=floor(TLEtime/1000)+2000;
%计算当前时刻在一年中的整天数.
days=floor(TLEtime)-floor(TLEtime/1000)*1000;
%计算月和日.
[Month, Day] = Doy2Date(Year, days);
%计算不足一天的时间部分，以天为单位.
SmallDays=TLEtime-floor(TLEtime);
%计算Hour.
Hour=floor(SmallDays*24);
%计算扣除整小时后，不足一小时的部分，以小时为单位.
SmallHour=SmallDays*24-Hour;
%计算Minute.
Minute=floor(SmallHour*60);
%计算扣除正分钟后，不足一分钟的部分，以分钟为单位.
SmallMiu=SmallHour*60-Minute;
%计算Sec;
Sec=floor(SmallMiu*60);
fprintf('年 月 日 时 分 秒：%04d%02d%02d %02d:%02d:%02d UTC\n',...
    Year,Month,Day,Hour,Minute,Sec);