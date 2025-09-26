%%%  Smoothing filter based on median 

    %box = [3,3,3];
    box = [5,5,5]
    %box = [7,7,7];
    imag1 = medfilt3(imag1,box);

    