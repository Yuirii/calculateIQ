close all; clear all; clc;

%% 导入数据
[~, ~, raw] = xlsread('D:\softwares\matlab\workdata\zcy\IQ滤波_线连9.22.xlsx','-50dbm','A1:B5300');
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};

% 将非数值元胞替换为 NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % 查找非数值元胞
raw(R) = {NaN}; % 替换非数值元胞

% 创建输出变量
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

%% 清除临时变量
clearvars raw R;