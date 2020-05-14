function main
    close all; clear all; clc;


%     fileFold = 'D:\softwares\matlab\workdata\';
% %     filename =  [fileFold sprintf('%dus 1MHz %d¡ã.log',4,90)];
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
    IQVALUE=IVALUE(1:512)-j*QVALUE(1:512);

    figure(1)
        plot(IVALUE, 'r')
        hold on
        plot(QVALUE, 'b')
        hold off
     %% Calc
    offset = 60;
    sum_phase = 0; %¼ì²é²ÎÊý
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

        angle = fix(iatan2sc(Zim, Zre));

        phase = fix(angle * 180 / 128);
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