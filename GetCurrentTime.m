function y=GetCurrentTime(Year0,Year,Date)
%�ú��������Year0��1��1��0ʱ0��0�����㣬��
%Year��ĵ�Date�������.
%Year0��Year������λ����, ȡ��ݺ���λ.
%����������λ������50������Ϊ��19**��ģ�
%������Ϊ��20**���.
%Date, y�Ǵ�С����˫��������.

%������λ�������.
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

%�趨��������ĳ�ʼֵ.
y=0;
%�����Year0�꿪ʼ��Year���������������.
for k=Year0:1:(Year-1)
    if mod(k,4)==0  %�ж�Ϊ����.
        temp=366;
    else
        temp=365;
    end
    y=y+temp;
end
%�������ֵ, ��Year0��Year���Date�������.
y=y+Date;