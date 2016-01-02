function [Mask_coord_image] = Mask_Coords(image)
%Written by David Nedrelow, 09/24/15
% This function creates a mask and outputs the coordinates so the same mask
%can be applied to every image in a stack.
%Check to see if imported image is gray or rgb and convert as necessary
if (size(image, 3) == 3)
grayImage = rgb2gray(image);
elseif (size(image, 3) == 1)
    grayImage = image;
else
    fprintf('Somethin aint right about your passed image');
end
figure
imshow(grayImage);
hFH = imfreehand();
% Create a binary image ("mask") from the ROI object.
Mask_coord_image = hFH.createMask();
end

