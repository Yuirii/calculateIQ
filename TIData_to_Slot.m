function [IQData_Slot, PhaseData_Slot, PhaseData_Slot_comp, Freq_Comp]=TIData_to_Slot(IQDatain,slot_num,pts_offset,pts_calc,slot_pts,fsample,figure_on)

    for slot_index=1:slot_num
        if slot_index==1
            aaa = pts_offset
            IQ_Solt=IQDatain(pts_offset:pts_offset+pts_calc-1);
            phase_Solt=atan2d(imag(IQ_Solt),real(IQ_Solt));
        else
            aaaa = (slot_index-1)*slot_pts+pts_offset
            tmp=IQDatain((slot_index-1)*slot_pts+pts_offset:(slot_index-1)*slot_pts+pts_offset+pts_calc-1);
            IQ_Solt=[IQ_Solt;tmp]
            phase_Solt=[phase_Solt;atan2d(imag(tmp),real(tmp))];
        end           
           
    end
    
    IQData_Slot=IQ_Solt;
    PhaseData_Slot=phase_Solt
    
    for slot_index=1:slot_num
        comp=0;
        PhaseData_comp=phase_Solt(slot_index,1)
       
       for index_i=2: length(phase_Solt(slot_index,:))
           if phase_Solt(slot_index,index_i)-phase_Solt(slot_index,index_i-1)<-270
                comp=comp+360;
           end
           PhaseData_comp=[PhaseData_comp, phase_Solt(slot_index,index_i)+comp];
       end
       x=[1:length(PhaseData_comp)]/fsample*1e6; 
       p=polyfit(x,PhaseData_comp,1); 
       if slot_index==1
           PhaseData_Slot_comp=PhaseData_comp;
           Freq_Comp=p(1)*1e3/360;
       else
           PhaseData_Slot_comp=[PhaseData_Slot_comp;PhaseData_comp];
           Freq_Comp=[Freq_Comp;p(1)*1e3/360];
       end
       
       
        
    end
    
    
    if figure_on
        figure('Name', 'Slot IQ Value','NumberTitle', 'off')
        
        for slot_index=1:slot_num
            subplot(slot_num,1,slot_index)
            x=[1:length(IQ_Solt(slot_index,:))]/fsample*1e6; 
            hold on
            plot(x,real(IQ_Solt(slot_index,:)),'b-.','LineWidth',2)
            plot(x,imag(IQ_Solt(slot_index,:)),'r:.','LineWidth',2)
            legend('I Value','Q Value');
           %axis([1 length(IQ_Solt(slot_index,:))/fsample*1e6+0.1 min([real(IQ_Solt(slot_index,:)) imag(IQ_Solt(slot_index,:))]) max([real(IQ_Solt(slot_index,:)) imag(IQ_Solt(slot_index,:))])]);
            xlabel('time(us)');
            ylabel('ampliture(V)');
            hold off
         end
        
         figure('Name', 'Slot Phase Value','NumberTitle', 'off')
        for slot_index=1:slot_num
            subplot(slot_num,1,slot_index)
            x=[1:length(phase_Solt(slot_index,:))]/fsample*1e6; 
            plot(x,phase_Solt(slot_index,:),'b-.','LineWidth',2)
            xlabel('time(us)');
            ylabel('phase');
        end
        
         figure('Name', 'Slot Phase Value After Comp','NumberTitle', 'off')
        for slot_index=1:slot_num
            subplot(slot_num,1,slot_index)
            x=[1:length(phase_Solt(slot_index,:))]/fsample*1e6; 
            plot(x,PhaseData_Slot_comp(slot_index,:),'b-.','LineWidth',2)
            xlabel('time(us)');
            ylabel('phase');
        end
        
    end

end