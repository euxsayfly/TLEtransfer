function y=GetCurrentTime(Year0,Year,Date)
%该函数计算从Year0年1月1日0时0分0秒起算，到
%Year年的第Date天的天数.
%Year0和Year均是两位整数, 取年份后两位.
%如果这个两个位数大于50，则认为是19**年的，
%否则认为是20**年的.
%Date, y是带小数的双精度数据.

%计算四位数的年份.
if Year0>50
    Year0=1900+Year0;
else
    Year0=2000+Year0;
end

if Year>50
    Year=1900+Year;
else
    Year=2000+Year;
end

%设定输出函数的初始值.
y=0;
%计算从Year0年开始到Year年的正年数的天数.
for k=Year0:1:(Year-1)
    if mod(k,4)==0  %判断为闰年.
        temp=366;
    else
        temp=365;
    end
    y=y+temp;
end
%计算输出值, 从Year0到Year年第Date天的天数.
y=y+Date;