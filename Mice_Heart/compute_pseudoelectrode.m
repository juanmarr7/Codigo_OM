function [pseudoECG, signal1, signal2] = compute_pseudoelectrode(imag1mov, x1, y1, x2, y2, windowSize)
    if mod(windowSize,2)==0
        error('windowSize debe ser impar');
    end

    halfWin = floor(windowSize/2);
    [dx, dy] = meshgrid(-halfWin:halfWin, -halfWin:halfWin);
    dx = dx(:); dy = dy(:);

    signal1 = zeros(1, size(imag1mov, 3));
    signal2 = zeros(1, size(imag1mov, 3));

    for t = 1:size(imag1mov, 3)
        frame = imag1mov(:,:,t);
        vals1 = zeros(length(dx), 1);
        vals2 = zeros(length(dx), 1);
        for k = 1:length(dx)
            xi1 = x1 + dx(k); yi1 = y1 + dy(k);
            xi2 = x2 + dx(k); yi2 = y2 + dy(k);
            vals1(k) = interp2(frame, xi1, yi1, 'linear', 0);
            vals2(k) = interp2(frame, xi2, yi2, 'linear', 0);
        end
        signal1(t) = mean(vals1);
        signal2(t) = mean(vals2);
    end

    pseudoECG = signal2 - signal1;
end
