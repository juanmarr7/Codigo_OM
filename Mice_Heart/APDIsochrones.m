function APDIsochrones(APDmap , imag1mov)
    if size(APDmap,1) > size(APDmap,2)
       cut = size(APDmap,2); 
       APDmap = APDmap(1:cut,:);
    elseif size(APDmap,2) > size(APDmap,1)
       cut = size(APDmap,1); 
       APDmap = APDmap(:,1:cut);
    else
       APDmap;
    end
    
    figure
    %APDmap = medfilt2(APDmap, [3,3]);    
   % I = omNorm(:,:,2);
    %Irgb = cat(3,I,I,I);
    I=ones(size(imag1mov,1),size(imag1mov,2),1);
    Irgb = cat(3,I,I,I);
    % Plot the image and some contours in color
    image(Irgb)
    hold all
           
    x = 1:size(APDmap,1);   
    y = size(APDmap,2):-1:1;
    [~,h] = contourf(x,x,APDmap,100); set(h,'edgecolor','none'); axis off;
    b = colorbar;
    colormap('jet'); 
    caxis([0,80]) % Fix values of colorbar to max-top normal APD value (~40-50ms)
    set(get(b,'label'),'string','Time (ms)')
    
    eventFcn = @(srcObj, e) updateTransparency(srcObj);
    addlistener(h, 'MarkedClean', eventFcn);
%mediaAPD = mean(APDmap(~isnan(APDmap)))
%disp(mediaAPD)
 
end

function updateTransparency(h)
    contourFillObjs = h.FacePrims;
    for i = 1:length(contourFillObjs)
        % Have to set this. The default is 'truecolor' which ignores alpha.
        contourFillObjs(i).ColorType = 'truecoloralpha';
        % The 4th element is the 'alpha' value. First 3 are RGB. Note, the
        % values expected are in range 0-255. 
        contourFillObjs(i).ColorData(4) = 300; %100
    end
end