
%v = VideoWriter('PUIG_mut_rotor2.avi', 'Uncompressed AVI');
%v.FrameRate = 30;
%open(v)
fh = figure;
imh = imshow(BW1.*imag1mov(:,:,1), 'Colormap', hot); % original code
%imh = imshow(bin(:,:,1), 'Colormap', hot);
truesize(fh,[500 500]);


for fr = 1:1:500  % inicio:salto:final
   %set(imh,'CData',bin(:,:,fr)); drawnow();
   set(imh,'CData',BW1.*(imag1mov(:,:,fr))); drawnow(); % original code
    %title('Voltage Optical Mapping')
    pause(0.01);fr
  %  frame = getframe(fh);
  %  writeVideo(v,frame);

end
%close(v);
