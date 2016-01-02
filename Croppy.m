function [Cropped_Image, recty] = Croppy(image, n)
%Written by David Nedrelow 9/24/15.
%Purpose:  crop image a specified number of times and return the cropped
%image and coordinates.
if (size(image, 3) == 3)
grayImage = rgb2gray(image);
elseif (size(image, 3) == 1)
    grayImage = image;
else
    fprintf('Somethin aint right about your passed image');
end

n_spheres = n;

for pick_frame = 1:n_spheres
      im1 = grayImage;
      s = num2str(n);
      s1 = ['Crop Original Image \n."right-click" and select "crop Image". \n Repeat ', s, ' times']
    fprintf(1,s1);
   
    [crop, rect]=imcrop(im1);
    Cropped_Image(pick_frame) = {crop};  %This contains the image info.
    recty(pick_frame) = {rect}; %and this has the crop coordinates.
 
    %Verify cropped image
    fprintf(1,'Cropped Image Preview \n');
    
    figure(1);
    imshow(crop);
   
end
clf;
close;
end

