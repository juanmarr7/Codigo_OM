function Isochrones(TactMap, isochrones , imag1mov)
    if size(TactMap,1) > size(TactMap,2)
       cut = size(TactMap,2); 
       TactMap = TactMap(1:cut,:);
    elseif size(TactMap,2) > size(TactMap,1)
       cut = size(TactMap,1); 
       TactMap = TactMap(:,1:cut);
    else
       TactMap;
    end
    
    figure
    TactMap = medfilt2(TactMap, [3,3]);
    TactMap = (TactMap - min(min(TactMap)));
    
    I=ones(size(imag1mov,1),size(imag1mov,2),1);
    I= imresize(I,0.7);
    Irgb = cat(3,I,I,I);
    % Plot the image and some contours in color
    image(Irgb)
    hold all
           
    x = 1:size(TactMap,1);   
    y = size(TactMap,2):-1:1;
    [~,h] = contourf(x,x,TactMap,100); set(h,'edgecolor','none'); axis off;
    b = colorbar;
    colormap('JET'); 
    caxis([0,60]) %Tact 40 raton 200 monocapa
    %caxis([30 60]) %Trepo
    set(get(b,'label'),'string','Time (ms)')
    
    eventFcn = @(srcObj, e) updateTransparency(srcObj);
    addlistener(h, 'MarkedClean', eventFcn);
    % Elsewhere in script, a separate file, or another method of your class
    

   if isochrones == 1
%     Set isochrones
    hold on;
    [~,c] = contour(x,x,TactMap,'k');
    c.LineWidth = 1.2;
    c.LevelStep =2; %10 this level step refers to time (ms; eg. 2ms) it can change according how often we want the isochrones 
   end

    
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