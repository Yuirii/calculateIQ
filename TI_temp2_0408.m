    close all; clear all; clc;

%     fileFold = 'D:\softwares\matlab\workdata\TI packets\6月1日两两切换天线\A22\1&3&x\';
%     fileFold='D:\softwares\matlab\workdata\TI packets\5月29日固定为2号天线\自制天线板\正对1号天线\';
    fileFold='D:\softwares\matlab\workdata\TI packets\5月27日3x5格地标相位差及IQ\IQ值\A42IQ\3ant\';
    filename =  [fileFold sprintf('%d.log',3)];   
    
%     fileFold = 'D:\softwares\matlab\workdata\TI packets\5月29日固定为2号天线\自制天线板\正对1号天线\';
% %     fileFold='D:\softwares\matlab\workdata\TI packets\';
%     filename =  [fileFold sprintf('%d.txt',5)];

    formatSpec = '%*s%f%f%[^\n\r]';
    fileID = fopen(filename,'r');
    dataArray = textscan(fileID, formatSpec);%, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN, 'ReturnOnError', false);
    fclose(fileID);
    IVALUE = dataArray{:, 1};
    QVALUE = dataArray{:, 2};
%     IVALUE_DEC=IVALUE-mean(IVALUE);
%     QVALUE_DEC=QVALUE-mean(QVALUE);
    IVALUE_DEC=IVALUE;
    QVALUE_DEC=QVALUE;
    IQVALUE_DEC=IVALUE_DEC(1:512)-j*QVALUE_DEC(1:512);
    IQVALUE_DEC=IQVALUE_DEC./abs(IQVALUE_DEC);
    IQVALUE_DEC=IQVALUE_DEC';
    
    %%   
    figure('Name', 'Orig IQ Value','NumberTitle', 'off')
    hold on;
%     plot(real(IQVALUE_DEC),'b')
%     plot(imag(IQVALUE_DEC),'r')
    plot(IVALUE,'b')
    plot(QVALUE,'r')
    hold off;

     %% slot计算设置
     fsample=4e6;                                   %采样率 //4e6
     slot_pts=4*fsample/1e6;                         %每4us，采样率是4MHz，存在16个点 //4*fsample/1e6,32
     slot_num=28;                                     %采集512个点 //28,3
     pts_offset=17;                                   %每个solt从offset开始；//60,61
     pts_calc= slot_pts/2;                           %每个solt取的计算点数//slot_pts/2,120
     pointsbtwslots=48;                             %理论上16*3=48个点，所以存在漂移，48-50个点都有可能出现。
              %% 分slot提取IQ值和slot内相位
         for slot_index=1:slot_num
            if slot_index==1                
                IQVALUE_Slot=IQVALUE_DEC(pts_offset:pts_offset+pts_calc-1);
            else
                (slot_index-1)*slot_pts+pts_offset;
                tmp=IQVALUE_DEC((slot_index-1)*slot_pts+pts_offset:(slot_index-1)*slot_pts+pts_offset+pts_calc-1);
                IQVALUE_Slot=[IQVALUE_Slot;tmp];
            end           
         end

     calc_slot_num=slot_num;
     phase=0;
     figure('Name', 'Phase_Diff_Slot01','NumberTitle', 'off')
     hold on;
     for calc_slot_num=2:slot_num
        for slot_index=2:calc_slot_num
         if slot_index==2

            IQ_Diff_Slot=IQVALUE_Slot(slot_index,:).*conj(IQVALUE_Slot(slot_index-1,:));
            Phase_Diff_Slot=atan2d(imag(IQ_Diff_Slot),real(IQ_Diff_Slot));
            plot(Phase_Diff_Slot);
         else
             aaa = slot_index;
             bbb = slot_index-1;
             tmp=IQVALUE_Slot(slot_index,:).*conj(IQVALUE_Slot(slot_index-1,:));
             IQ_Diff_Slot=[IQ_Diff_Slot;tmp];
             
             if mod(slot_index,2)==1
                Phase_Diff_Slot=[Phase_Diff_Slot;-atan2d(imag(tmp),real(tmp))];
             else
                 Phase_Diff_Slot=[Phase_Diff_Slot;atan2d(imag(tmp),real(tmp))];
             end
             
             plot(Phase_Diff_Slot(slot_index-1,:));
         end
        end

        if calc_slot_num==2
            phase=mean2(Phase_Diff_Slot);
        else
            phase=[phase,mean2(Phase_Diff_Slot)];
        end
     end

    mean_phase = mean(phase)
     
%  figure('name', 'phasecomparation1_0')
%       plot(phase0)
%       hold on 
%       plot(phase1)
%       plot(phase2)
%       hold off
%       pha01=mean(phase0)  
%       pha12=mean(phase1)  
%       pha02=mean(phase2)
%       
%     phase_mean = (pha01+pha12+pha02)/3
%     
%     Angle_inc(1) = acos(4*pha01/360)*180/pi;
%     Angle_inc(2) = acos(4*pha12/360)*180/pi;
%     Angle_inc(3) = acos(4*pha02/360)*180/pi;
%     
%     Angle_inc
%     mean(Angle_inc)
    
    %% 排除是否是点数漂移导致的问题。
    period_p = 48;
    for i = 1 : 9
        if i == 1
            p1 = IVALUE(period_p*i+0:period_p*i+7);
            p2 = IVALUE(period_p*i+16:period_p*i+16+7);
            p3 = IVALUE(period_p*i+32:period_p*i++32+7);
        else
            p1 = [p1;IVALUE(period_p*i:period_p*i+7)];
            p2 = [p2;IVALUE(period_p*i+16:period_p*i+16+7)];
            p3 = [p3;IVALUE(period_p*i+32:period_p*i++32+7)];
        end        
    end
    p1 = mapminmax(p1');
    p2 = mapminmax(p2');
    p3 = mapminmax(p3');
    
    figure('name','pair0\1\2 iq')
        hold on
        plot(p1)
        plot(p2)
        plot(p3)
        legend('ANT0','ANT1','ANT2','location','northeast');
        hold off
    