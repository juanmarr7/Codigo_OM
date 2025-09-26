%%% Phase maps - Arrhythmia analyisis 
%   January 2023   
%   By Lilian K. Gutierrez, MSc

Cl = out(:,10:end);      % out comes from MAfilter. Average signal of whole tissue
t = (1:length(Cl))*0.001;  %  t diveded by the camera exporsure (e.g. 1ms; 3.3ms*1000=s)

figure; subplot 211 ; plot(t,Cl);         

Ts = mean(diff(t));
Fs = 1/Ts;
Fn = Fs/2;
L = numel(t);
Clm = detrend(Cl);
% Clm = Cl-mean(Cl);                                  % Subtract Mean (Mean = 0 Hz)
FCl = fft(Clm)/L;
Fv = linspace(0, 1, fix(L/2)+1)*Fn;
Iv = 1:numel(Fv);
%[pks,locs] = findpeaks(abs(FCl(Iv))*2, 'MinPeakHeight',0.01);
[pks,locs] = findpeaks(abs(FCl(Iv))*2);
max_pks = max(pks);
max_locs = locs(find(pks==max_pks));

subplot 212
plot(Fv, abs(FCl(Iv))*2)
grid

text(Fv(max_locs), max_pks, sprintf('\\leftarrow Dominant Frequency = %.2f Hz', Fv(max_locs)), 'HorizontalAlignment','left')
