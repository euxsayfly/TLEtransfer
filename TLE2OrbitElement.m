function OrbitElement=TLE2OrbitElement(TLEfileName,LineNum)
%该函数将文件中的两行轨道根数转换为六要素形式的轨道根数.
%输入变量TLEfileName为存储两行根数的文件.
%输入变量LineNum是文件中数据行数, 星历数为LineNum/2.
%关于LineNum，可以通过Excel读取星历文件，根据Excel序号得到.
%输出函数为OrbitElement矩阵, 行数为历元数目, 列数为10, 从左到右分别是：
%（1）时间：自发射时刻起算的天数.
%（2）半长轴，单位m.
%（3）偏心率.
%（4）倾角，单位deg.
%（5）升交点赤经，单位deg.
%（6）近地点角距，单位deg.
%（7）平近点角，单位deg.
%（8）近地点高度，单位m.
%（9）远地点高度，单位m.
%（10）平均轨道高度，单位m.

%地球引力常数, 单位m^3/s^2.
EarthMiu=3.986004405e14;
%地球平均半径, 单位m.
EarthRadiusMean=6371.393e3;

%读入星历数据文件.
fid=fopen(TLEfileName,'r');
%读入每一行数据.
for i=1:LineNum
    DataByLine{i}=fgets(fid);
end
fclose(fid);
%DataByLine是cell数据类型，DataByLine{i}表示第i行字符串.
%DataByLine的数目等于文件中的数据行数.

%计算星历中的历元数目.
EpochNum=LineNum/2;
%定义输出变量初值.
OrbitElement=zeros(EpochNum,10);
%计算第一个历元时刻的年份, 取后两位表示.
StrTime=DataByLine{1};
Year0=str2num(StrTime(19:20));
%计算每个历元时刻的星历.
for k=1:EpochNum
    %计算当前历元的时间, 自发射年份1月1日0时0分0秒起算的天数.
    %当前历元时刻所在的行数.
    CurrentTimeLine=k*2-1;
    %提取当前行数字符数据.
    StrTime=DataByLine{CurrentTimeLine};
    %提取当前年份字符串.
    Year=StrTime(19:20);
    %年份转换为数字.
    Year=str2num(Year);
    %提取当前天数字符串.
    Date=StrTime(21:32);
    %天数转换为数字.
    Date=str2num(Date);
    %计算当前历元的时间.
    OrbitElement(k,1)=GetCurrentTime(Year0,Year,Date);
    
    %计算当前历元时刻轨道根数所在的行数.
    CurrentElementLine=k*2;
    %提取包含当前历元时刻轨道根数的字符串.
    StrElement=DataByLine{CurrentElementLine};
    %计算每天的轨道圈数.
    RevDay=str2num(StrElement(53:63));
    %计算轨道周期, 单位s.
    OrbitPeriod=24*3600/RevDay;
    %计算当前时刻轨道半长轴.
    OrbitElement(k,2)=(EarthMiu*(OrbitPeriod^2)/4/pi/pi)^(1/3);
    
    %提取偏心率字符串.
    StrEcc=strcat('0.',StrElement(27:33));
    %计算轨道偏心率.
    OrbitElement(k,3)=str2num(StrEcc);
    
    %提取倾角字符串.
    StrInclination=StrElement(9:16);
    %计算轨道倾角.
    OrbitElement(k,4)=str2num(StrInclination);
    
    %提取含有升交点赤经的字符串.
    StrRAAN=StrElement(18:25);
    %计算升交点赤经.
    OrbitElement(k,5)=str2num(StrRAAN);
    
    %提取含有近地点角距的字符串.
    StrxOmega=StrElement(35:42);
    %计算近地点角距.
    OrbitElement(k,6)=str2num(StrxOmega);
    
    %提取含有平近点角的字符串.
    StrM=StrElement(44:51);
    %计算平近点角.
    OrbitElement(k,7)=str2num(StrM);
    
    %计算近地点高度.
    OrbitElement(k,8)=OrbitElement(k,2)...
        *(1-OrbitElement(k,3))-EarthRadiusMean;
    
    %计算远地点高度.
    OrbitElement(k,9)=OrbitElement(k,2)...
        *(1+OrbitElement(k,3))-EarthRadiusMean;
    
    %计算平均轨道高度.
    OrbitElement(k,10)=0.5*...
        (OrbitElement(k,8)+OrbitElement(k,9));
end
%将起始时间设为0, 这样输出变量中第一列时间为相对于发射时刻的天数.
OrbitElement(:,1)=OrbitElement(:,1)-OrbitElement(1,1);
%判断OrbitElement矩阵中完全相同的相邻两行, 并删除其中一行.
DiffOrbitElement=diff(OrbitElement(:,1)); %第一列时间项差分.
%查找差分后为0的位置.
ZeroPosition=find(DiffOrbitElement==0);
%对于两个完全相同的行，删除其中的一行.
OrbitElement(ZeroPosition,:)=[];
%将输出变量写入文件, 定义文件.
fid=fopen('OrbitElement.txt','wt');
for k=1:(EpochNum-length(ZeroPosition))
    %将每一行数据写入文件.
    fprintf(fid,'%15.12e ',OrbitElement(k,:));
    fprintf(fid,'\n');
end
fclose(fid);