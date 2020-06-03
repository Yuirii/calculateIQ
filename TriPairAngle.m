close all; clear all; clc;
%% ��ʼ��������
fileFold = 'D:\softwares\matlab\workdata\TI packets\3x5��ر���λ������\������\';
% Object = 4;
filename =  [fileFold sprintf('A41.log')];
delimiter = ' ';
formatSpec = '%f %f %f %f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN, 'ReturnOnError', false);

fclose(fileID);
%% ����������������б�������
% 
Pair01 = dataArray{:, 1};           %��һ������01���߶���λ��
Pair12 = dataArray{:, 2};           %�ڶ�������12���߶���λ��
Pair02 = dataArray{:, 3};           %����������02���߶���λ��
Pair_trimean = dataArray{:, 4};     %����������Ϊ������λ���ƽ��ֵ

%% ���ݴ���
angle_in01 = acos(3*Pair01/360)*180/pi;        %���ݹ�ʽ��������Ƕ�
angle_in12 = acos(3*Pair12/360)*180/pi;
angle_in02 = acos(1.5*Pair02/360)*180/pi;
angle_trimean = acos(2*Pair_trimean/360)*180/pi;

angle2_in01 = asin(4*Pair01/360)*180/pi;        %���ݹ�ʽ��������Ƕ�
angle2_in12 = asin(4*Pair12/360)*180/pi;
angle2_in02 = asin(2*Pair02/360)*180/pi;
angle2_trimean = asin(2*Pair_trimean/360)*180/pi;

%% ���ݿ��ӻ�
figure('name','PairAngle')
    hold on
    xlabel('packets'); ylabel('PairAngle(��)');
    plot(Pair01);
    plot(Pair12);
    plot(Pair02);
    plot(Pair_trimean);
    legend('Pair01','Pair12','Pair02','Pair_trimean','location','northeast');
    hold off
    
% figure('name','Angle_in')
%     hold on
%     xlabel('packets'); ylabel('Angle_in(��)');
%     plot(angle_in01);
%     plot(angle_in12);
%     plot(angle_in02);
%     plot(angle_trimean);
%     legend('angle_in01','angle_in12','angle_in02','angle_trimean','location','northeast');
%     hold off

%% ��������
    %����
    Pair01_mean = mean(Pair01);
    Pair12_mean = mean(Pair12);
    Pair02_mean = mean(Pair02);
    
    Angle01_mean = mean(angle_in01);
    Angle12_mean = mean(angle_in12);
    Angle02_mean = mean(angle_in02);
    Angle_trimean = mean(angle_trimean)
    Anglein012_mean = (Angle01_mean+Angle12_mean+Angle02_mean)/3
    
    %��׼��
    Pair01_std = std(Pair01);
    Pair12_std = std(Pair12);
    Pair02_std = std(Pair02);
    