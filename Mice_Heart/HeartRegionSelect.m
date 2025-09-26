clear h_im;
clear e1 
clear BW1
clear testimag

testimag = imag1(:,:,1);
figure
h_im = imshow((testimag-min(min(testimag)))/max(max(testimag)));
e1 = imfreehand(gca);
%e1 = imellipse(gca);

BW1 = createMask(e1,h_im);

testimag = BW1.*testimag;
figure; imshow((testimag-min(min(testimag)))/max(max(testimag)));


