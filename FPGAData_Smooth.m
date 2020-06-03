function IQData=FPGAData_Smooth(IQDatain,SmoothLength,figure_on,showdataoffset,showdatalength)

    IDownconvert_avg=smooth(real(IQDatain),SmoothLength)';
    QDownconvert_avg=smooth(imag(IQDatain),SmoothLength)';
    IQDownconvert_avg=IDownconvert_avg+j*QDownconvert_avg;
    IQData=IQDownconvert_avg;

    if figure_on
        offset=showdataoffset;
        pts_num=showdatalength;
        fsample=4e6;
        x=[1:pts_num]/fsample*1e6;              %µ¥Î»Îªus
        figure('Name', 'Input Signal After Smooth Filter','NumberTitle', 'off')
        plot(x,real(IQData(offset:offset+pts_num-1)),'b-.','LineWidth',2)
        hold on
        plot(x,imag(IQData(offset:offset+pts_num-1)),'r:.','LineWidth',2)
        legend('I Value','Q Value');
        axis([-0.1 pts_num/fsample*1e6+0.1 -1.1 1.1]);
        xlabel('time(us)');
        ylabel('ampliture(V)');
        hold off
    end
    
    
end
