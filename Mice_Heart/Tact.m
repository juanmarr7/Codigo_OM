%% Mouse optical mapping 

% Activation map taking a single AP 
%
% Cardiac Arrhythmia Lab, October 2020
% By: Lilian K. Guitierrez, MSc
function TactMap = Tact(imag1mov, BW1, tmwn1, tmwn2,signal_site)
    
   % imag1mov = imgaussfilt(imag1mov,1.5); with previous filters (Median & Ma is not neccesary)
    TactMap = zeros(size(BW1));
    roi_temp = zeros(size(BW1));

    for x = 1:size(BW1,1)
        for y = 1:size(BW1,2) 
            if BW1(x,y) == 1
                roi_temp(x,y) = 1;  
                yy = reshape(imag1mov(x,y,:),[1,size(imag1mov,3)]);
                zz = sgolayfilt((yy),3,11);
                %zz = sgolayfilt(medfilt1(yy),3,11);
                TactMap(x,y) = actCalc(zz, tmwn1, tmwn2);
            else
                TactMap(x,y) = NaN;
            end
            roi_temp = zeros(size(BW1));
        end
    end   
    
%     TactMap = (TactMap - min(min(TactMap)));
    TactMap = medfilt2(TactMap, [3 3]);
    TactMap = (TactMap - min(min(TactMap)));
    figure; plot(signal_site(tmwn1:tmwn2));xlim([0 300]) % 200
    %figure; imshow(TactMap,'InitialMagnification',1000);

end
%%
% Subfunction to calculate TactMap
function TactMap = actCalc(zz,timewn1,timewn2)
    OAP_upstroke = zz(timewn1:timewn2);    
    dF = diff(OAP_upstroke);
    [~, upstroke] = max(dF);
    if isempty(upstroke) 
        TactMap = NaN;
    else
        TactMap = upstroke;  % Time conversion num of Frames -> Time (ms)
    end
end
