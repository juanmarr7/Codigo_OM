function [APDmap,AP_newarray] = APDcode(imag1mov, BW1, P)
    
    imag1mov = medfilt3(imresize(imag1mov,.5,'bicubic'),[3 3 3]);
    BW1 = imresize(BW1,.5,'bicubic');
    APDmap = zeros(size(BW1));
    %figure; imshow(imag1mov(:,:,1))
    for x = 1:size(BW1,1)
        
        for y = 1:size(BW1,2) 
            
            if BW1(x,y) == 1
                yy = reshape(imag1mov(x,y,:),[1,size(imag1mov,3)]);
                B = 1/8*ones(8,1);
                out = filter(B,1,yy(1:end));
                %%% drift removal + averaging module 
                [new,AP]= driftremoval(out);
                AP_newarray(x,y,:) = AP;
                APDmap(x,y) = APDcalculate(AP,P);
            else
                APDmap(x,y) = NaN;
            end
        end
    end   
    
%     APDmap = medfilt2(APDmap, [2 2]);
    APDIsochrones(APDmap , imag1mov)
    figure; hist(APDmap);
end
%%%
% Drift removal
function [new,mean_aps] = driftremoval(y)
    x =(1:1999);
    fps = 2;% 3.3; Do not move
    freq =40;   %% ¡OJO! Change accrodingly. M
    % easure peak to peak distance and rest -10 or -20 to input here. locs
    % have to be an array of 1x12 so adjust freq until it doesnt complain. 
    [pks, locs] = findpeaks(y,'MinPeakDistance',freq);
    cycles = diff(locs); meanFrequency = mean(cycles)*fps; 
    s = strcat('Cycle Length', ' :  ', num2str(meanFrequency,3), ' ms');
    f = strcat('Frequency',' : ', num2str(1/meanFrequency*1000,3), ' Hz');
    [valleys, locsv] = findpeaks(-y,'MinPeakDistance',50); 
    poly = polyfit(x(locsv),-valleys,4); warning('off');
    ypoly =polyval(poly,x); pkspoly = polyval(poly, x(locs)) ; 
    new = y-ypoly;

    %%% Selection of ten action potentials
    freqstim = 100/fps;  % ¡OJO! freq must change accordingly to the one the heart is being paced
    ten_aps = new(locs(2)-(freqstim/fps):locs(12)-(freqstim/fps));
    overlay_aps(1,1:freqstim) = ten_aps(:,1:freqstim);
    
    for i=2:6
        if freqstim*i > length(ten_aps)
                temp = ten_aps(:,freqstim*(i-1):length(ten_aps));
                overlay_aps(i,1:length(temp)) = temp;
        else
                overlay_aps(i,1:freqstim+1) = ten_aps(:,freqstim*(i-1):(freqstim*i));
        end
    end
    
    for i=1:6
        [pks, locs] = findpeaks(overlay_aps(i,:));
        peaks_vector(i) = locs(find(pks == max(pks)));
    end
    
    average_aps = overlay_aps;
    for i=2:6
        average_aps(i,:) = ten_aps(:,freqstim*(i-1)+(peaks_vector(i)-peaks_vector(1)):(freqstim*i)+(peaks_vector(i)-peaks_vector(1)));
    end
    mean_aps = mean(average_aps);

end

%%% APD calculation module
function apd=APDcalculate(mean_aps,P)

    dsigav = diff(mean_aps);
    [~, upstroke] = max(dsigav);
    
    % start of depol
    dpol=mean_aps(1:upstroke);
    ds=diff(dpol);
    d2s=diff(ds);
    [~,sdstart] = max(d2s);
    
    % peak
    [maxval,maxi] = max(mean_aps);
    % baseline 
    baseline = min(mean_aps(1:upstroke));
    
    APD = P/100;
    APD = (maxval-baseline)*(1-APD)+baseline;
    
    mini=mean_aps(sdstart);  
    if isempty(mini) == 1
    mini=min(mean_aps(1:upstroke));  
    end
    
    checkSignal = mean_aps(maxi:end); %checkSignal(26)=190;
    [~,min2]=min(checkSignal);
    checkSignal=checkSignal(1:min2); %ignore 2nd beat if present
    minInd = find(checkSignal<APD,1);
%     if isempty(minInd)
%         minInd = APD;
%     end
    % Locates points above and below APD
        highVal = checkSignal(minInd-1);
        lowVal = checkSignal(minInd);
    % Solution for detecting a slight positive gradient next to APD region
    if (highVal - lowVal)<0
        lowVal = find(checkSignal<APD,2);
    end

    if isempty(highVal)
        apd = nan;
    else
    % Determines points for line equations
    y1 = highVal;
    y2 = lowVal;
    
    x1 = maxi+minInd;
    x2 = maxi+minInd-1;
    % If encountering a flat region gradient becomes inf so only takes the
    % section of the flat part closest to the APD point
    x1=x1(end);
    x2=x2(1);
    % Gradient of line y=mx+c
    m = (y2-y1)/(x2-x1); 
    % Line constant, should be same for both c1 and c2
    c1 = y1-(m.*x1);
    c2 = y2-(m.*x2);
    
    % Time and APD70
    Ti = (APD-c1)/m;
    
    apd = Ti-(upstroke);
    end
end
