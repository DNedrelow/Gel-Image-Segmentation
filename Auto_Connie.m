function [Contrast_Image, NormHist, ConvoHist]  = Auto_Connie(image, PeakParam)
%Written by David Nedrelow 9/23/15. 
%Purpose:  This is a function that returns contrast adjusted
%images and histograms based on the left and right PeakParam.

%Check to see if imported image is gray or rgb and convert as necessary
if (size(image, 3) == 3)
grayImage = rgb2gray(image);
elseif (size(image, 3) == 1)
    grayImage = image;
else
    fprintf('Somethin aint right about your passed image');
end

[pixelCount grayLevels] = imhist(grayImage);
pixelCount = pixelCount(2:end);     %there is noise in my first grayLevel
grayLevels = grayLevels(2:end);

%Normalize peaks to 100.
Countmin = min(pixelCount);
Countmax = max(pixelCount);
NormCount = (pixelCount - Countmin) ./ (Countmax - Countmin) .* 100;

NormHist = {grayLevels, NormCount};

%findmax = max(NormCount);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Set grayLevel of focus here%%%%%%%%%%
%indexmax = 100; find(NormCount == findmax);  ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Left_offset = PeakParam(1);
Right_offset = PeakParam(2);

%Norm_Low = grayLevels(indexmax(end) + Left_offset);
%Norm_High = grayLevels(indexmax(end) + Right_offset);

%The automated peak find was commented out.
%Here we use the raw user input as the peak offsets, eliminating auto
%peak-find.
Norm_Low = grayLevels(Left_offset);
Norm_High = grayLevels(Right_offset);

%give an output to erand inputs
if (Norm_Low >= Norm_High)
    ConvoHist = NormHist;
    Contrast_Image = image;
    fprintf('Dont ever cross the streams\n  (Your Left is right of your right)\n')
else
    R = [Norm_Low : Norm_High];
ConvoHist = {R, NormCount(R)};

    Low_in = Norm_Low / 255;
    High_in = Norm_High / 255;  
    Low_out = 0;
    High_out = 1;
    in = [Low_in; High_in];
    out = [Low_out; High_out];
    
  Contrast_Image = imadjust(grayImage, in, out);
end
end
