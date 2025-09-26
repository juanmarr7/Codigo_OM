%%%  Moving fiter. Treating movement artifact

function out = MAfilter(BW1, imag1mov)

om = BW1.*imag1mov;
maxDim3 = max(om(:,:,1:end),[],3);
temp = ((double(om)-double(maxDim3))); % normalize movie

mean_multiMeasure = mean(mean(temp(:,:,1:end)));
y = reshape(mean_multiMeasure,[1,size(mean_multiMeasure,3)]);

% Moving filter ; Window size = wn
wn = 3
% wn = 5 parece un buen valor 
% a partir de wn = 8 la forma del upstroke se pierde bastante.
B = 1/wn*ones(wn,1);
out = filter(B,1,y(1:end));
%x = (1:length(y))*3.3;
x = (1:length(y));

%figure; subplot 211; plot(y(20:end));hold on; plot(out(20:end),'r'); 
%subplot 212; plot(out(20:end),'r')

figure; subplot 211; plot(x(20:end),y(20:end));hold on; plot(x(20:end),out(20:end),'r'); 
subplot 212; plot(x(20:end),out(20:end),'r')

end

