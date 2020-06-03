close all; clear all; clc;

%% load file 
%     fileFold = 'D:\softwares\matlab\workdata\TI packets\6月1日两两切换天线\A22\2&1&x\';
%     fileFold='D:\softwares\matlab\workdata\TI packets\5月29日固定为2号天线\自制天线板\正对1号天线\';
    fileFold='D:\softwares\matlab\workdata\TI packets\5月27日3x5格地标相位差及IQ\IQ值\A32IQ\2ant\';
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
 %% 参数设置
    fsample=4e6;                               %FPGA采样频率
    %freq_LO=2e6;                                %FPGA采样数据中频
    smooth_num=3;                              %平滑滤波点数
    slot_length=4e-6;                           % Slot时间长度，默认4us
    slot_pts=slot_length*fsample;               %每个Slot的采样点数，采样率是32MHz，4us长度，默认每个Slot有128个点
    slot_num=24;                                 %需要拆分的Slot数目
    pts_offset=17;                              %slot拆分时，数据截取距离数据开始的偏移量
    pts_calc=slot_pts/2;                        %slot拆分时，每个slot从偏移量开始，截取的计算点数
        
        %% 移除直流分量
        figure_on=0
        IQVALUE_DEC=TIDataPre_Process(IVALUE,QVALUE,figure_on,1,128);
        
   %% 数据预处理：平滑、滤波等
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