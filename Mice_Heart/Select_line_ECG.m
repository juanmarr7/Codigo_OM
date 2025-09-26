testimag = imag1(:,:,1);

figure;
h_im = imshow((testimag - min(testimag(:))) / max(testimag(:)));
title('Dibuja una línea (click y arrastra)');
hold on;

% Permite dibujar una línea
h_line = drawline(gca);

% Espera a que el usuario termine de dibujar
wait(h_line);

% Obtener las coordenadas de los extremos
pos = h_line.Position;
x1 = pos(1,1);
y1 = pos(1,2);
x2 = pos(2,1);
y2 = pos(2,2);

% Mostrar los puntos
plot([x1 x2], [y1 y2], 'r-', 'LineWidth', 2);


