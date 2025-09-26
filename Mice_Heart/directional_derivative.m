function pseudoECG = directional_derivative(imag1mov, x1, y1, x2, y2)
    % Interpolar la señal temporal en el punto 1
    signal1 = zeros(1, size(imag1mov, 3));
    signal2 = zeros(1, size(imag1mov, 3));
    
    for t = 1:size(imag1mov, 3)
        frame = imag1mov(:,:,t);
        signal1(t) = interp2(frame, x1, y1, 'linear', 0);
        signal2(t) = interp2(frame, x2, y2, 'linear', 0);
    end

    % Diferencia entre ambos puntos (derivada espacial direccional)
    pseudoECG = signal2 - signal1;
end
