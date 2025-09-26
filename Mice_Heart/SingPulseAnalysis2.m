figure;

imshow( (imag1(:,:,1)-min(min(imag1(:,:,1))))./max(max(imag1(:,:,1))) );
axis equal

hold on;

frameperiod = 1.0;%3.3;  % camera frame period

% number of traces to show
ntraces = 4;   % max of 8
tracecolor = ['b','r','g','c','m','y','k','w'];

roi = 5;  % region of interest

% select points to plot
for c = 1:ntraces
    [x,y] = ginput(1);
    row(c) = round(y);
    col(c) = round(x);
    plot([col(c), col(c)+roi-1], [row(c), row(c)], [tracecolor(c)]);
    plot([col(c)+roi-1, col(c)+roi-1], [row(c), row(c)+roi-1], [tracecolor(c)]);
    plot([col(c)+roi-1, col(c)], [row(c)+roi-1, row(c)+roi-1], [tracecolor(c)]);
    plot([col(c), col(c)], [row(c)+roi-1, row(c)], [tracecolor(c)]);
end

for c = 1:ntraces
    area1 = imag1(row(c):row(c)+roi-1,col(c):col(c)+roi-1,:);
    trace1 = mean(mean(area1));
    trace1 = reshape(trace1,1,n);
    
    trace1 = smooth(trace1,5,'lowess'); % time series smoothing
    
    T1 = 0:frameperiod:(n-1)*frameperiod;
    figure;
    plot(T1, trace1, [tracecolor(c)]); xlim([0 T1(end)]);
end
