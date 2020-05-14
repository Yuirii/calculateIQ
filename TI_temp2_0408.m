
    close all; clear all; clc;
% 
%     fileFold = 'D:\softwares\matlab\workdata\';
% %     filename =  [fileFold sprintf('%dus 1MHz %d°.log',4,90)];
%     filename = [fileFold '1.log'];
    
    fileFold = 'D:\softwares\matlab\workdata\E4438C packets\';
%     fileFold='D:\softwares\matlab\workdata\TI packets\';
    filename =  [fileFold sprintf('%d.log',6)];

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


    %%   
    phase_init=atan2d(imag(IQVALUE_DEC),real(IQVALUE_DEC));
%     figure('Name', 'Orig atan Value','NumberTitle', 'off')
%     plot(phase_init)


    %%
         for index_i=2:length(IQVALUE_DEC)
             IQdiff(index_i-1)=IQVALUE_DEC(index_i)*conj(IQVALUE_DEC(index_i-1));

         end
     phase_diff=atan2d(imag(IQdiff),real(IQdiff));

%     figure('Name', 'Orig atan Value after Diff','NumberTitle', 'off')
%     plot(phase_diff)

    %%
    phase_comp(1)=phase_init(1);
    pi_comp=0;
    for index_i=2:length(IQVALUE_DEC)

        if phase_init(index_i)-phase_init(index_i-1)<-90
            pi_comp=pi_comp+360;
        end
        phase_comp(index_i)=phase_init(index_i)+pi_comp;
    end
%          figure('Name', 'Orig phase after comp','NumberTitle', 'off')
%     plot(phase_comp)


    for index_i=2:length(phase_comp)
             freq(index_i-1)=phase_comp(index_i)-phase_comp(index_i-1);

         end
%         figure('Name', 'Orig phase diff after comp','NumberTitle', 'off')
%     plot(freq)

         %% slot计算设置
         fsample=4e6;                                   %采样率 //4e6
         slot_pts=4*fsample/1e6;                         %每4us，采样率是32MHz，存在128个点 //4*fsample/1e6,32
         slot_num=7;                                     %采集512个点，可以考虑切换6次 //28,3
         pts_offset=61;                                   %每个solt从offset开始；//60,61
         pts_calc= slot_pts/2;                           %每个solt取的计算点数，即8个点；//slot_pts/2,120

              %% 分slot提取IQ值和slot内相位
         for slot_index=1:slot_num
            if slot_index==1
                IQVALUE_Slot=IQVALUE_DEC(pts_offset:pts_offset+pts_calc-1);
            else
                tmp=IQVALUE_DEC((slot_index-1)*slot_pts+pts_offset:(slot_index-1)*slot_pts+pts_offset+pts_calc-1);
                IQVALUE_Slot=[IQVALUE_Slot;tmp];
            end           
        end

         calc_slot_num=slot_num;
         phase=0;
         figure('Name', 'Phase_Diff_Slot','NumberTitle', 'off')
        hold on;
         for calc_slot_num=2:slot_num

            for slot_index=2:calc_slot_num
             if slot_index==2
                IQ_Diff_Slot=IQVALUE_Slot(slot_index,:).*conj(IQVALUE_Slot(slot_index-1,:));
                Phase_Diff_Slot=atan2d(imag(IQ_Diff_Slot),real(IQ_Diff_Slot));
                plot(Phase_Diff_Slot);

             else
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
         mean(phase)
         phase_TEST=mean2(Phase_Diff_Slot)

         Phase_Diff_Slot_circle = Phase_Diff_Slot(:);
                 figure('name', 'sort_circle')
                      plot(Phase_Diff_Slot_circle)
            
        Phase_Diff_Slot_sort = sort(Phase_Diff_Slot_circle);
%         figure('name', 'sort')
%             plot(Phase_Diff_Slot_sort)
        
%         % 测试设定相邻两个点跳动误差阈值的方法
%         temp = 0;
%         for num = 1:215
%             Phase_Diff_Slot_circle_diff = abs(abs(Phase_Diff_Slot_circle(num+1)) - abs(Phase_Diff_Slot_circle(num)));
%             if Phase_Diff_Slot_circle_diff < 40
%                 temp = temp + 1;
%                 Phase_Diff_Slot_circle_new(temp) = Phase_Diff_Slot_circle(num);
%             end
%         end
%         temp
%         figure('name', 'Phase_Diff_Slot_circle_new')
%             plot(Phase_Diff_Slot_circle_new)
%             mean(Phase_Diff_Slot_circle_new)
