    close all; clear all; clc;

%     fileFold = 'D:\softwares\matlab\workdata\';
%     filename =  [fileFold sprintf('%dus 1MHz %d°.log',4,90)];
% %     filename = [fileFold '1.log'];
    
    fileFold = 'D:\softwares\matlab\workdata\E4438C packets\';
%     fileFold='D:\softwares\matlab\workdata\TI packets\';
    filename =  [fileFold sprintf('%d.log',2)];

    formatSpec = '%*s%f%f%[^\n\r]';
    fileID = fopen(filename,'r');
    dataArray = textscan(fileID, formatSpec,512);%, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN, 'ReturnOnError', false);
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
     slot_num=7;                                     %采集512个点 //28,3
     pts_offset=61;                                   %每个solt从offset开始；//60,61
     pts_calc= slot_pts/2;                           %每个solt取的计算点数//slot_pts/2,120
     pointsbtwslots=48;                             %理论上16*3=48个点，所以存在漂移，48-50个点都有可能出现。
    %% 分slot提取IQ值和slot内相位
    for slot_index=1:slot_num
        for ant_num = 0:2
            if ant_num == 0 
                IQVALUE_Slot0(slot_index,:)=IQVALUE_DEC(pts_offset+ant_num*slot_pts+(slot_index-1)*pointsbtwslots:pts_offset+pts_calc-1+ant_num*slot_pts+(slot_index-1)*pointsbtwslots);
            elseif ant_num ==1
                IQVALUE_Slot1(slot_index,:) = IQVALUE_DEC(pts_offset+ant_num*slot_pts+(slot_index-1)*pointsbtwslots:pts_offset+pts_calc-1+ant_num*slot_pts+(slot_index-1)*pointsbtwslots);
%                 IQVALUE_Slot(slot_index,:) = [IQVALUE_Slot;temp];
            else ant_num == 2
                IQVALUE_Slot2(slot_index,:) = IQVALUE_DEC(pts_offset+ant_num*slot_pts+(slot_index-1)*pointsbtwslots:pts_offset+pts_calc-1+ant_num*slot_pts+(slot_index-1)*pointsbtwslots);
            end
        end
    end
    IQVALUE_Slot0;
    IQVALUE_Slot1;
    IQVALUE_Slot2;
    ndims(IQVALUE_Slot0);

     calc_slot_num=slot_num;
     phase=0;
     figure('Name', 'Phase_Diff_Slot01','NumberTitle', 'off')
     hold on;
     
     %no.0
     for calc_slot_num=2:slot_num

        for slot_index=2:calc_slot_num
         if slot_index==2
            IQ_Diff_Slot0=IQVALUE_Slot0(slot_index,:).*conj(IQVALUE_Slot1(slot_index-1,:));
            Phase_Diff_Slot0=atan2d(imag(IQ_Diff_Slot0),real(IQ_Diff_Slot0));
            plot(Phase_Diff_Slot0);

         else
             tmp=IQVALUE_Slot0(slot_index,:).*conj(IQVALUE_Slot1(slot_index-1,:));
             IQ_Diff_Slot0=[IQ_Diff_Slot0;tmp];
             if mod(slot_index,2)==1
                Phase_Diff_Slot0=[Phase_Diff_Slot0;-atan2d(imag(tmp),real(tmp))];
             else
                 Phase_Diff_Slot0=[Phase_Diff_Slot0;atan2d(imag(tmp),real(tmp))];
             end
             plot(Phase_Diff_Slot0(slot_index-1,:));

         end

        end

        if calc_slot_num==2
            phase0=mean2(Phase_Diff_Slot0);
        else
            phase0=[phase0,mean2(Phase_Diff_Slot0)];
        end

     end
     hold off
     figure('Name', 'Phase_Diff_Slot12','NumberTitle', 'off')
     hold on;
     %no.1
     for calc_slot_num=2:slot_num

        for slot_index=2:calc_slot_num
         if slot_index==2
            IQ_Diff_Slot1=IQVALUE_Slot1(slot_index,:).*conj(IQVALUE_Slot2(slot_index-1,:));
            Phase_Diff_Slot1=atan2d(imag(IQ_Diff_Slot1),real(IQ_Diff_Slot1));
            plot(Phase_Diff_Slot1);

         else
             tmp=IQVALUE_Slot1(slot_index,:).*conj(IQVALUE_Slot2(slot_index-1,:));
             IQ_Diff_Slot1=[IQ_Diff_Slot1;tmp];
             if mod(slot_index,2)==1
                Phase_Diff_Slot1=[Phase_Diff_Slot1;-atan2d(imag(tmp),real(tmp))];
             else
                 Phase_Diff_Slot1=[Phase_Diff_Slot1;atan2d(imag(tmp),real(tmp))];
             end
             plot(Phase_Diff_Slot1(slot_index-1,:));

         end

        end

        if calc_slot_num==2
            phase1=mean2(Phase_Diff_Slot1);
        else
            phase1=[phase1,mean2(Phase_Diff_Slot1)];
        end

     end
     hold off
     figure('Name', 'Phase_Diff_Slot02','NumberTitle', 'off')
     hold on;
     %no.2
     for calc_slot_num=2:slot_num

        for slot_index=2:calc_slot_num
         if slot_index==2
            IQ_Diff_Slot2=IQVALUE_Slot0(slot_index,:).*conj(IQVALUE_Slot2(slot_index-1,:));
            Phase_Diff_Slot2=atan2d(imag(IQ_Diff_Slot2),real(IQ_Diff_Slot2));
            plot(Phase_Diff_Slot2);

         else
             tmp=IQVALUE_Slot0(slot_index,:).*conj(IQVALUE_Slot2(slot_index-1,:));
             IQ_Diff_Slot2=[IQ_Diff_Slot2;tmp];
             if mod(slot_index,2)==1
                Phase_Diff_Slot2=[Phase_Diff_Slot2;-atan2d(imag(tmp),real(tmp))];
             else
                 Phase_Diff_Slot2=[Phase_Diff_Slot2;atan2d(imag(tmp),real(tmp))];
             end
             plot(Phase_Diff_Slot2(slot_index-1,:));

         end

        end

        if calc_slot_num==2
            phase2=mean2(Phase_Diff_Slot2);
        else
            phase2=[phase2,mean2(Phase_Diff_Slot2)];
        end

     end
     hold off
     
 figure('name', 'phasecomparation1_0')
      plot(phase0)
      hold on 
      plot(phase1)
      plot(phase2)
      hold off
      pha01=mean(phase0)  
      pha12=mean(phase1)  
      pha02=mean(phase2)