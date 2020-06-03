function main
    close all; clear all; clc;
    
    fileFold = 'D:\softwares\matlab\workdata\TI packets\6月1日两两切换天线\A22\2&1&x\';
%     fileFold='D:\softwares\matlab\workdata\TI packets\';
    filename =  [fileFold sprintf('%d.txt',1)];   
    
    formatSpec = '%*s%f%f%[^\n\r]';
    fileID = fopen(filename,'r');
    dataArray = textscan(fileID, formatSpec,512);%, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN, 'ReturnOnError', false);
    fclose(fileID);

    IVALUE = dataArray{:, 1};
    QVALUE = dataArray{:, 2};
    IQVALUE=IVALUE(1:512)-j*QVALUE(1:512);

    figure(1)
        plot(IVALUE, 'r')
        hold on
        plot(QVALUE, 'b')
        hold off
         %% 排除是否是点数漂移导致的问题。
%     slot_p = 48;
%     for i = 1 : 9
%         slot_p*i+0:slot_p*i+7;
%         if i == 1
%             p1 = IVALUE(slot_p*i+0:slot_p*i+7);
%             p2 = IVALUE(slot_p*i+16:slot_p*i+16+7);
%             p3 = IVALUE(slot_p*i+32:slot_p*i++32+7);
%         else
%             p1 = [p1;IVALUE(slot_p*i:slot_p*i+7)];
%             p2 = [p2;IVALUE(slot_p*i+16:slot_p*i+16+7)];
%             p3 = [p3;IVALUE(slot_p*i+32:slot_p*i++32+7)];
%         end        
%     end
%     figure('name','pair0\1\2 iq')
%         hold on
%         plot(p1)
%         plot(p2)
%         plot(p3)
%         legend('ANT0','ANT1','ANT2','location','northeast');
%         hold off
%      %% Calc
%     offset = 12;
%     Sample_block = 16;
%     Zab_rel_sum = zeros(3,1);
%     Zab_ima_sum = zeros(3,1);
%     Zab_rel_mean = zeros(3,1);
%     Zab_ima_mean = zeros(3,1);
%     sum_phase = 0; %检查参数
%     for r = 1 : 9
%         for i = 0 : 7
%             for idx = 0 : 2
%                 switch idx
%                     case 0
%                         a = 0;
%                         b = 1;
%                         offset + r * 3 * Sample_block + a * Sample_block +i;
%                         offset + r * 3 * Sample_block + b * Sample_block +i;
%                         Zab_rel_sum(1) = Zab_rel_sum(1) + ZreComplexProductComp(IVALUE(offset + r * 3 * Sample_block + a * Sample_block +i),QVALUE(offset + r * 3 * Sample_block + a * Sample_block +i),IVALUE(offset + r * 3 * Sample_block + b * Sample_block +i),QVALUE(offset + r * 3 * Sample_block + b * Sample_block +i));
%                         Zab_ima_sum(1) = Zab_ima_sum(1) + ZimComplexProductComp(IVALUE(offset + r * 3 * Sample_block + a * Sample_block +i),QVALUE(offset + r * 3 * Sample_block + a * Sample_block +i),IVALUE(offset + r * 3 * Sample_block + b * Sample_block +i),QVALUE(offset + r * 3 * Sample_block + b * Sample_block +i));                                                                      
%                     case 1
%                         a = 1;
%                         b = 2;
%                         offset + r * 3 * Sample_block + a * Sample_block +i;
%                         offset + r * 3 * Sample_block + b * Sample_block +i;
%                         Zab_rel_sum(2) = Zab_rel_sum(2) + ZreComplexProductComp(IVALUE(offset + r * 3 * Sample_block + a * Sample_block +i),QVALUE(offset + r * 3 * Sample_block + a * Sample_block +i),IVALUE(offset + r * 3 * Sample_block + b * Sample_block +i),QVALUE(offset + r * 3 * Sample_block + b * Sample_block +i));
%                         Zab_ima_sum(2) = Zab_ima_sum(2) + ZimComplexProductComp(IVALUE(offset + r * 3 * Sample_block + a * Sample_block +i),QVALUE(offset + r * 3 * Sample_block + a * Sample_block +i),IVALUE(offset + r * 3 * Sample_block + b * Sample_block +i),QVALUE(offset + r * 3 * Sample_block + b * Sample_block +i));   
%                     case 2
%                         a = 0;
%                         b = 2;
%                         offset + r * 3 * Sample_block + a * Sample_block +i;
%                         offset + r * 3 * Sample_block + b * Sample_block +i;
%                         Zab_rel_sum(3) = Zab_rel_sum(3) + ZreComplexProductComp(IVALUE(offset + r * 3 * Sample_block + b * Sample_block +i),QVALUE(offset + r * 3 * Sample_block + b * Sample_block +i),IVALUE(offset + r * 3 * Sample_block + a * Sample_block +i),QVALUE(offset + r * 3 * Sample_block + a * Sample_block +i));
%                         Zab_ima_sum(3) = Zab_ima_sum(3) + ZimComplexProductComp(IVALUE(offset + r * 3 * Sample_block + b * Sample_block +i),QVALUE(offset + r * 3 * Sample_block + b * Sample_block +i),IVALUE(offset + r * 3 * Sample_block + a * Sample_block +i),QVALUE(offset + r * 3 * Sample_block + a * Sample_block +i));   
%                 end                        
%             end
%         end
%     end
%     
%     for i = 1:3
%         Zab_rel_mean(i) = Zab_rel_sum(i)/72;
%         Zab_ima_mean(i) = Zab_ima_sum(i)/72;
%         Pab_rel(i) = (iatan2sc(Zab_ima_mean(i),Zab_rel_mean(i)) * 180 /128);
%         switch i
%             case 1
%                 Angle_inc(i) = acos(4*Pab_rel(i)/360)*180/pi;
%             case 2
%                 Angle_inc(i) = acos(4*Pab_rel(i)/360)*180/pi;
%             case 3
%                 Angle_inc(i) = acos(2*Pab_rel(i)/360)*180/pi;
%         end
%     end
%     Pab_rel
% %     mean(Pab_rel)
%     Angle_inc
%     mean(Angle_inc)
%     angle(mean(Angle_inc))*180/pi
         %% Calc
    offset = 48;
    sum_phase = 0; %?ì?é????
    for ant = 0 : 2
        for r = 1 : 14
            for i = 0 : 7
                phase_diff(1,(r-1)*8+i+1)= (AngleComplexProductComp(IVALUE(16*(2*r-1)+offset+i),QVALUE(16*(2*r-1)+offset+i),IVALUE(16*(2*r-2)+offset+i),QVALUE(16*(2*r-2)+offset+i)));
                sum_phase = sum_phase+phase_diff(1,(r-1)*8+i+1);        
                16*(2*r-1)+offset+i;%check
                16*(2*r-2)+offset+i;
            end
        end
    end
    phase_diff;
    mean_phase_diff = mean(phase_diff)
    %% FUNCTION DEFINE
    function phase = AngleComplexProductComp(Xre, Xim, Yre, Yim)
        Zre = Xre * Yre + Xim * Yim;
        Zim = Xim * Yre - Xre * Yim;

        angle1 = fix(iatan2sc(Zim, Zre));

        phase = fix(angle1 * 180 / 128);
    end

    function conj_Zre = ZreComplexProductComp(Xre,Xim,Yre,Yim)
        conj_Zre = Xre * Yre + Xim * Yim;
    end

    function conj_Zim = ZimComplexProductComp(Xre,Xim,Yre,Yim)
        conj_Zim = Xim * Yre - Xre * Yim;
    end
        

    function angle = iatan2sc(y, x)
        if y >= 0
            if x>=0
                if x>y
                    angle = iat2(-y, -x) / 2 + 0 * 32;
                else
                    if y == 0
                        angle = 0;
                    end
                    angle = -iat2(-x, -y) / 2 + 2 * 32;
                end
            else
                if x>=-y
                    angle = iat2(x, -y) / 2 + 2 * 32;
                else
                    angle = -iat2(-y, x) / 2 + 4 * 32;
                end
            end

        else
            if x<0
                if x<y
                    angle = iat2(y, x) / 2 + -4 * 32;
                else
                    angle = -iat2(x, y) / 2 + -2 * 32;
                end
            else
                if -x>=y
                    angle = iat2(-x, y) / 2 + -2 * 32;
                else
                    angle = -iat2(y, -x) / 2 + -0 * 32;
                end
            end
        end
    end

    function mxdiff=iat2(y, x)
        mxdiff = fix(((y * 32 + (x / 2)) / x) * 2);
    end

end