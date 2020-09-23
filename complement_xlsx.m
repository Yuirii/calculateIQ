close all; clear all; clc;

%% ��������
[~, ~, raw] = xlsread('D:\softwares\matlab\workdata\zcy\IQ�˲�_����9.22.xlsx','-50dbm','A1:B5300');
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};

% ������ֵԪ���滻Ϊ NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % ���ҷ���ֵԪ��
raw(R) = {NaN}; % �滻����ֵԪ��

% �����������
AD_IQ = reshape([raw{:}],size(raw));

%% HANDLER
START_POINT = 1;
STOP_POINT = 128;
AD_I = AD_IQ(START_POINT:STOP_POINT,1);
AD_Q = AD_IQ(START_POINT:STOP_POINT,2);

POINTS = STOP_POINT-START_POINT+1;

AD_I_COMPL = zeros(POINTS,1);
AD_Q_COMPL = zeros(POINTS,1);
for index = 1 : POINTS 
    if AD_I(index) < 0
        AD_I_COMPL(index) = 256+AD_I(index);
        
    else
        AD_I_COMPL(index) = AD_I(index);
        
    end
    
    if AD_Q(index) < 0
        AD_Q_COMPL(index) = 256+AD_Q(index);
    else
        AD_Q_COMPL(index) = AD_Q(index);
    end
end

figure('name','ad_compl','NumberTitle','off')
    plot(AD_I_COMPL)
    hold on 
    plot(AD_Q_COMPL)
    hold off

figure('name','ad','NumberTitle','off')
    plot(AD_I)
    hold on 
    plot(AD_Q)
    hold off

%% �����ʱ����
clearvars raw R;