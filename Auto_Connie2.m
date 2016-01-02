function Contrasted_Image2 = Auto_Connie2(image, Param)
%This simply applies a very narrow grayLevel regime in the low, medium or
%high greylevel.  Low:  .2-.3, med:  .5-.6, High: .8-.9
%Written by David Nedrelow, 09/15/15

if (size(image, 3) == 3)
    grayImage = rgb2gray(image);
elseif (size(image, 3) == 1)
    grayImage = image;
else
    fprintf('Somethin aint right about your passed image');
end


if (Param == 1)
    Contrasted_Image2 = imadjust(grayImage, [0.01 0.02]);
elseif (Param == 2)
    Contrasted_Image2 = imadjust(grayImage, [0.4 0.6]);
elseif (Param == 3)
    Contrasted_Image2 = imadjust(grayImage, [0.98 0.99]);
else
    fprintf('uh oh better get Maco')
end

end
