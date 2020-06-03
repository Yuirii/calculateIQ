close all; clear all; clc;

%% load file 
%     fileFold = 'D:\softwares\matlab\workdata\TI packets\6��1�������л�����\A22\2&1&x\';
%     fileFold='D:\softwares\matlab\workdata\TI packets\5��29�չ̶�Ϊ2������\�������߰�\����1������\';
    fileFold='D:\softwares\matlab\workdata\TI packets\5��27��3x5��ر���λ�IQ\IQֵ\A32IQ\2ant\';
    filename =  [fileFold sprintf('%dsw2.LOG',2)];    
    formatSpec = '%*s%f%f%[^\n\r]';
    fileID = fopen(filename,'r');
    dataArray = textscan(fileID, formatSpec,512);%, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN, 'ReturnOnError', false);
    fclose(fileID);
% read value
    IVALUE = dataArray{:, 1};
    QVALUE = dataArray{:, 2};
    IQVALUE=IVALUE(1:512)-j*QVALUE(1:512);
% draw picture
%     figure(1)
%         plot(IVALUE, 'r')
%         hold on
%         plot(QVALUE, 'b')
%         hold off
 %% ��������
    fsample=4e6;                               %FPGA����Ƶ��
    %freq_LO=2e6;                                %FPGA����������Ƶ
    smooth_num=3;                              %ƽ���˲�����
    slot_length=4e-6;                           % Slotʱ�䳤�ȣ�Ĭ��4us
    slot_pts=slot_length*fsample;               %ÿ��Slot�Ĳ�����������������32MHz��4us���ȣ�Ĭ��ÿ��Slot��128����
    slot_num=24;                                 %��Ҫ��ֵ�Slot��Ŀ
    pts_offset=17;                              %slot���ʱ�����ݽ�ȡ�������ݿ�ʼ��ƫ����
    pts_calc=slot_pts/2;                        %slot���ʱ��ÿ��slot��ƫ������ʼ����ȡ�ļ������
        
        %% �Ƴ�ֱ������
        figure_on=0
        IQVALUE_DEC=TIDataPre_Process(IVALUE,QVALUE,figure_on,1,128);
        
   %% ����Ԥ����ƽ�����˲���
   IQVALUE_DEC=FPGAData_Smooth(IQVALUE_DEC, smooth_num, figure_on, 1, 128);
   
   [IQ_Solt, phase_Solt, phase_Solt_comp,Freq_Comp]=TIData_to_Slot(IQVALUE_DEC, slot_num,pts_offset,pts_calc,slot_pts,fsample,figure_on);
   
   'Antenna=Slot1&2'
   for i=1:2:slot_num-1
       i
       deltaphase=IQ_Solt(i+1,:).*conj(IQ_Solt(i,:));
       IQphase=atan2d(imag(deltaphase),real(deltaphase));
       PD=[i+1,i,mean(IQphase)];
   end
   
%     'Antenna=Slot2&3'
%    for i=2:3:slot_num-1
%        deltaphase=IQ_Solt(i+1,:).*conj(IQ_Solt(i,:));
%        IQphase=atan2d(imag(deltaphase),real(deltaphase));
%        PD=[i+1,i,mean(IQphase)];
%    end
%    
%        'Antenna=Slot3&1'
%    for i=3:3:slot_num-1
%        deltaphase=IQ_Solt(i+1,:).*conj(IQ_Solt(i,:));
%        IQphase=atan2d(imag(deltaphase),real(deltaphase));
%        PD=[i+1,i,mean(IQphase)];
%    end
   figure('Name', 'phase_Solt_comp 1 2','NumberTitle', 'off')
   plot(phase_Solt_comp(1,:),'b-.','LineWidth',2)
   hold on;
   plot(phase_Solt_comp(2,:),'r-.','LineWidth',2)
    hold off;
    
   figure('Name', 'phase_Solt_comp 2 3','NumberTitle', 'off')
   plot(phase_Solt_comp(2,:),'b-.','LineWidth',2)
   hold on;
   plot(phase_Solt_comp(3,:),'r-.','LineWidth',2)
    hold off;
    
   figure('Name', 'phase_Solt_comp 3 4','NumberTitle', 'off')
   plot(phase_Solt_comp(3,:),'b-.','LineWidth',2)
   hold on;
   plot(phase_Solt_comp(4,:),'r-.','LineWidth',2)
    hold off;
    
    
    
%        figure('Name', 'phase_Solt_comp 4 5','NumberTitle', 'off')
%    plot(phase_Solt_comp(4,:),'b-.','LineWidth',2)
%    hold on;
%    plot(phase_Solt_comp(5,:),'r-.','LineWidth',2)
%     hold off;
%            figure('Name', 'phase_Solt_comp 5 6','NumberTitle', 'off')
%    plot(phase_Solt_comp(5,:),'b-.','LineWidth',2)
%    hold on;
%    plot(phase_Solt_comp(6,:),'r-.','LineWidth',2)
%     hold off;
%                figure('Name', 'phase_Solt_comp 7 6','NumberTitle', 'off')
%    plot(phase_Solt_comp(7,:),'b-.','LineWidth',2)
%    hold on;
%    plot(phase_Solt_comp(6,:),'r-.','LineWidth',2)
%     hold off;
%     
%            figure('Name', 'phase_Solt_comp 7 8','NumberTitle', 'off')
%    plot(phase_Solt_comp(7,:),'b-.','LineWidth',2)
%    hold on;
%    plot(phase_Solt_comp(8,:),'r-.','LineWidth',2)
%     hold off;
%            figure('Name', 'phase_Solt_comp 8 9','NumberTitle', 'off')
%    plot(phase_Solt_comp(8,:),'b-.','LineWidth',2)
%    hold on;
%    plot(phase_Solt_comp(9,:),'r-.','LineWidth',2)
%     hold off;
%                figure('Name', 'phase_Solt_comp 10 9','NumberTitle', 'off')
%    plot(phase_Solt_comp(10,:),'b-.','LineWidth',2)
%    hold on;
%    plot(phase_Solt_comp(9,:),'r-.','LineWidth',2)
%     hold off;