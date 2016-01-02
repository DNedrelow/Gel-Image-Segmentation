function StrImage = StrelImage(image, Param)
%Written by David Nedrelow, 09/25/15.  
%This function converts the image to a collection of linear structural
%elements.  The resolution of the lines is determined by input Param(2) 
%-see below.  The output is an image made up of structural elements that 
%fills in gaps between signals on the image to be measured and thus allows
%a diameter to be measured.
Length = Param(1);
Resolution = Param(2);
if (size(image, 3) == 3)
grayImage = rgb2gray(image);
elseif (size(image, 3) == 1)
    grayImage = image;
else
    fprintf('Somethin aint right about your passed image');
end


if Resolution == 1
    n = 10;
elseif Resolution == 2
    n = 5;
elseif Resolution == 3
    n = 1;
end

angle = [1:n:360];
for ida = 1:length(angle)
se = strel('line',Length, angle(ida));
fillGrayImage = imclose(grayImage,se);
grayImage = imfill(fillGrayImage, 'holes');
end

StrImage = grayImage;
end
