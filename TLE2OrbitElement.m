function OrbitElement=TLE2OrbitElement(TLEfileName,LineNum)
%�ú������ļ��е����й������ת��Ϊ��Ҫ����ʽ�Ĺ������.
%�������TLEfileNameΪ�洢���и������ļ�.
%�������LineNum���ļ�����������, ������ΪLineNum/2.
%����LineNum������ͨ��Excel��ȡ�����ļ�������Excel��ŵõ�.
%�������ΪOrbitElement����, ����Ϊ��Ԫ��Ŀ, ����Ϊ10, �����ҷֱ��ǣ�
%��1��ʱ�䣺�Է���ʱ�����������.
%��2���볤�ᣬ��λm.
%��3��ƫ����.
%��4����ǣ���λdeg.
%��5��������ྭ����λdeg.
%��6�����ص�Ǿ࣬��λdeg.
%��7��ƽ����ǣ���λdeg.
%��8�����ص�߶ȣ���λm.
%��9��Զ�ص�߶ȣ���λm.
%��10��ƽ������߶ȣ���λm.

%������������, ��λm^3/s^2.
EarthMiu=3.986004405e14;
%����ƽ���뾶, ��λm.
EarthRadiusMean=6371.393e3;

%�������������ļ�.
fid=fopen(TLEfileName,'r');
%����ÿһ������.
for i=1:LineNum
    DataByLine{i}=fgets(fid);
end
fclose(fid);
%DataByLine��cell�������ͣ�DataByLine{i}��ʾ��i���ַ���.
%DataByLine����Ŀ�����ļ��е���������.

%���������е���Ԫ��Ŀ.
EpochNum=LineNum/2;
%�������������ֵ.
OrbitElement=zeros(EpochNum,10);
%�����һ����Ԫʱ�̵����, ȡ����λ��ʾ.
StrTime=DataByLine{1};
Year0=str2num(StrTime(19:20));
%����ÿ����Ԫʱ�̵�����.
for k=1:EpochNum
    %���㵱ǰ��Ԫ��ʱ��, �Է������1��1��0ʱ0��0�����������.
    %��ǰ��Ԫʱ�����ڵ�����.
    CurrentTimeLine=k*2-1;
    %��ȡ��ǰ�����ַ�����.
    StrTime=DataByLine{CurrentTimeLine};
    %��ȡ��ǰ����ַ���.
    Year=StrTime(19:20);
    %���ת��Ϊ����.
    Year=str2num(Year);
    %��ȡ��ǰ�����ַ���.
    Date=StrTime(21:32);
    %����ת��Ϊ����.
    Date=str2num(Date);
    %���㵱ǰ��Ԫ��ʱ��.
    OrbitElement(k,1)=GetCurrentTime(Year0,Year,Date);
    
    %���㵱ǰ��Ԫʱ�̹���������ڵ�����.
    CurrentElementLine=k*2;
    %��ȡ������ǰ��Ԫʱ�̹���������ַ���.
    StrElement=DataByLine{CurrentElementLine};
    %����ÿ��Ĺ��Ȧ��.
    RevDay=str2num(StrElement(53:63));
    %����������, ��λs.
    OrbitPeriod=24*3600/RevDay;
    %���㵱ǰʱ�̹���볤��.
    OrbitElement(k,2)=(EarthMiu*(OrbitPeriod^2)/4/pi/pi)^(1/3);
    
    %��ȡƫ�����ַ���.
    StrEcc=strcat('0.',StrElement(27:33));
    %������ƫ����.
    OrbitElement(k,3)=str2num(StrEcc);
    
    %��ȡ����ַ���.
    StrInclination=StrElement(9:16);
    %���������.
    OrbitElement(k,4)=str2num(StrInclination);
    
    %��ȡ����������ྭ���ַ���.
    StrRAAN=StrElement(18:25);
    %����������ྭ.
    OrbitElement(k,5)=str2num(StrRAAN);
    
    %��ȡ���н��ص�Ǿ���ַ���.
    StrxOmega=StrElement(35:42);
    %������ص�Ǿ�.
    OrbitElement(k,6)=str2num(StrxOmega);
    
    %��ȡ����ƽ����ǵ��ַ���.
    StrM=StrElement(44:51);
    %����ƽ�����.
    OrbitElement(k,7)=str2num(StrM);
    
    %������ص�߶�.
    OrbitElement(k,8)=OrbitElement(k,2)...
        *(1-OrbitElement(k,3))-EarthRadiusMean;
    
    %����Զ�ص�߶�.
    OrbitElement(k,9)=OrbitElement(k,2)...
        *(1+OrbitElement(k,3))-EarthRadiusMean;
    
    %����ƽ������߶�.
    OrbitElement(k,10)=0.5*...
        (OrbitElement(k,8)+OrbitElement(k,9));
end
%����ʼʱ����Ϊ0, ������������е�һ��ʱ��Ϊ����ڷ���ʱ�̵�����.
OrbitElement(:,1)=OrbitElement(:,1)-OrbitElement(1,1);
%�ж�OrbitElement��������ȫ��ͬ����������, ��ɾ������һ��.
DiffOrbitElement=diff(OrbitElement(:,1)); %��һ��ʱ������.
%���Ҳ�ֺ�Ϊ0��λ��.
ZeroPosition=find(DiffOrbitElement==0);
%����������ȫ��ͬ���У�ɾ�����е�һ��.
OrbitElement(ZeroPosition,:)=[];
%���������д���ļ�, �����ļ�.
fid=fopen('OrbitElement.txt','wt');
for k=1:(EpochNum-length(ZeroPosition))
    %��ÿһ������д���ļ�.
    fprintf(fid,'%15.12e ',OrbitElement(k,:));
    fprintf(fid,'\n');
end
fclose(fid);