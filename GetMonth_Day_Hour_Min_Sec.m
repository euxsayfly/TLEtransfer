function GetMonth_Day_Hour_Min_Sec(TLEtime)
%�ú����������Days�����и����е�ʱ�䣬��16259.76121521��ʾ��2016��
%�еĵ�259.76121521��.
%ע�⣺�ú�����������2000���Ժ�����и�������.

%��ȡ���.
Year=floor(TLEtime/1000)+2000;
%���㵱ǰʱ����һ���е�������.
days=floor(TLEtime)-floor(TLEtime/1000)*1000;
%�����º���.
[Month, Day] = Doy2Date(Year, days);
%���㲻��һ���ʱ�䲿�֣�����Ϊ��λ.
SmallDays=TLEtime-floor(TLEtime);
%����Hour.
Hour=floor(SmallDays*24);
%����۳���Сʱ�󣬲���һСʱ�Ĳ��֣���СʱΪ��λ.
SmallHour=SmallDays*24-Hour;
%����Minute.
Minute=floor(SmallHour*60);
%����۳������Ӻ󣬲���һ���ӵĲ��֣��Է���Ϊ��λ.
SmallMiu=SmallHour*60-Minute;
%����Sec;
Sec=floor(SmallMiu*60);
fprintf('�� �� �� ʱ �� �룺%04d%02d%02d %02d:%02d:%02d UTC\n',...
    Year,Month,Day,Hour,Minute,Sec);