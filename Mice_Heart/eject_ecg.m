figure;
imshow((imag1(:,:,1) - min(imag1(:,:,1),[],'all')) / max(imag1(:,:,1),[],'all'));
title('Dibuja una línea entre dos puntos');
h_line = drawline(gca);
wait(h_line);  % <- Esto pausa hasta que completes la línea


pos = h_line.Position;
x1 = pos(1,1); y1 = pos(1,2);
x2 = pos(2,1); y2 = pos(2,2);

% Llama a la función con vecindario de 5x5 (ajustable)
[pseudoECG, signal1, signal2] = compute_pseudoelectrode(imag1mov, x1, y1, x2, y2, 11);


figure;
plot(signal1*1.2, 'b', 'DisplayName', 'Spot 1');
hold on;
plot(signal2*1.2, 'r', 'DisplayName', 'Spot 2');
plot(pseudoECG*4, 'k', 'LineWidth', 1.5, 'DisplayName', 'Pseudo-ECG');
xlabel('Time (frames)');
ylabel('Fluorescence (a.u.)');
legend;
title('Derivative signal');
grid on;
