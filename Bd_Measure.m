function [BoundImage, Largest_Diameter] = Bd_Measure(image)
%Written by David Nedrelow, 09/24/15
%  This function finds inputes an image, converts to gray scale, measures
%  the blob diameters and keeps the largest blob for a final image to be
%  output upon which a green boundary is superimposed.

if (size(image, 3) == 3)
grayImage = rgb2gray(image);
elseif (size(image, 3) == 1)
    grayImage = image;
else
    fprintf('Somethin aint right about your passed image');
end

labeledImage = bwlabel(grayImage, 8);
blobMeasurements = regionprops(labeledImage, grayImage, 'all');
numberOfBlobs = size(blobMeasurements, 1);

blobECD = zeros(1, numberOfBlobs);
for k = 1 : numberOfBlobs           % Loop through all blobs.
    blobArea = blobMeasurements(k).Area;
	blobECD(k) = sqrt(4 * blobArea / pi);% Compute ECD - Equivalent Circular Diameter.
end
%Now sort the Blobs by the largest n diameters.
low_high_Diameters = sort(blobECD);
[Low_High_Diameter, index] = sort(blobECD);
keeperIndexes = index(end);
Largest_Diameter = Low_High_Diameter(end);
keeperBlobsImage = ismember(labeledImage, keeperIndexes);
BoundImage = bwlabel(keeperBlobsImage, 8); 
end

