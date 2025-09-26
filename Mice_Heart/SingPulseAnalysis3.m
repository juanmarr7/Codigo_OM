imag1mov = double(zeros(pixels,pixels,n));

for R = 1:pixels
    for C = 1:pixels
        trace1 = imag1(R,C,:);
        trace1 = reshape(trace1,1,n);
     
        trace1 = max(trace1) - trace1;
      
        trace1 = trace1/max(trace1);
        
        trace1 = smooth(trace1,5,'lowess'); % time series smoothing
        
        trace1 =  sgolayfilt(trace1,3,11);  % Time filtering
        
        imag1mov(R,C,:) = trace1;
    end
end

% Invert Fluorescent images