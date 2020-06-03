function IQData=TIDataPre_Process(IVALUE_DEC,QVALUE_DEC,figure_on,showdataoffset,showdatalength)
    
    %% �Ƴ�ֱ������
    IVALUE_DEC=IVALUE_DEC(64:length(IVALUE_DEC));
    QVALUE_DEC=QVALUE_DEC(64:length(QVALUE_DEC));
    IVALUE_DEC=IVALUE_DEC-mean(IVALUE_DEC);
    QVALUE_DEC=QVALUE_DEC-mean(QVALUE_DEC);

    %% �źŷ��ȹ�һ��
    IQVALUE_DEC=IVALUE_DEC+j*QVALUE_DEC;
    IQData=IQVALUE_DEC./abs(IQVALUE_DEC);
    
        %% �����źż�飬��ɫ��Ӧ��Ϊ2.25MHz���ң�32MHz����ʱ��32������Ӧ���������������ҵ��ź�
    if figure_on
        offset=showdataoffset;
        pts_num=showdatalength;
        fsample=4e6;
        x=[1:pts_num]/fsample*1e6;              %��λΪus
        figure('Name', 'Input Signal After Data Pre-Process IQ value','NumberTitle', 'off')
        plot(x,real(IQData(offset:offset+pts_num-1)),'b-.','LineWidth',2)
        hold on
        plot(x,imag(IQData(offset:offset+pts_num-1)),'r:.','LineWidth',2)
        hold off
        legend('I Value','Q Value');
        axis([-0.1 pts_num/fsample*1e6+0.1 -1.1 1.1]);
        xlabel('time(us)');
        ylabel('ampliture(V)');
        IQphase=atan2d(imag(IQData(offset:offset+pts_num-1)),real(IQData(offset:offset+pts_num-1)));
        figure('Name', 'Input Signal Phase After Data Pre-Process ATAN2D','NumberTitle', 'off')
        plot(IQphase,'b-.','LineWidth',2)
        legend('Phase');
        %axis([-0.1 pts_num/fsample*1e6+0.1 -1.1 1.1]);
        xlabel('time(us)');
        ylabel('degree');
        
        for index_i=2:length(IQphase)
           phase_diff(index_i-1)=IQphase(index_i)-IQphase(index_i-1);
            
        end
        
         figure('Name', 'Input Signal Phase Difference After Data Pre-Process PD','NumberTitle', 'off')
        plot(phase_diff,'b-.','LineWidth',2)
        legend('Phase');
        %axis([-0.1 pts_num/fsample*1e6+0.1 -1.1 1.1]);
        xlabel('time(us)');
        ylabel('degree');
    end
    
    
end