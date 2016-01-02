function L = Con_Station(image, PkParam, Param2, Prstrel)
%Generates the figure window composed of plots when a "low", "med", or "high"
%button is pressed in the GUI called Image_Contrast_UI. 
im = image;  %3 images in this variable of class cell
PeakParam = PkParam; %left offset and right offset
Param = Param2;  %1, 2, 3
Length = Prstrel(1);  %Prstrel is 2 elements long. 
Resolution = 1;
Parstrel = [Length, Resolution]; %the first defines the length of the strel,
%while the second determines how many angles between 0 and 360 will be
%converted to a linear "strel"  (see file "strelimage" for details)

for idi = 1:numel(im)
    
    if (idi == 1)
        plotPos = [1:6];
    elseif (idi == 2)
        plotPos = [7:12];
    else 
        plotPos = [13:18];
    end
    
[a b c] = Auto_Connie(im{idi}, PeakParam);
sndContrast = Auto_Connie2(a, Param) ;
StrImage = StrelImage(sndContrast,Parstrel);
[bound, Dia] = Bd_Measure(StrImage);
L(idi) = Dia;  %output from this function
%%For plotting boundaries measured.  Make sure bwboundaries works on same
%%thing entered into Bd_Measure

boundaries = bwboundaries(StrImage);
numberOfBoundaries = size(boundaries, 1);

subplot(3,6,plotPos(1));
imshow(im{idi})
title 'Original'
set(gcf, 'units','normalized','outerposition',[0 0 0.99 0.99]);
hold on;
for k = 1 : numberOfBoundaries
	thisBoundary = boundaries{k};
	plot(thisBoundary(:,2), thisBoundary(:,1), 'g', 'LineWidth', 2);
end
hold off;

normhist = b;
convohist = c;

subplot(3,6,plotPos(2));
plot(normhist{1}, normhist{2}, 'k')
title 'Histogram'
hold on

plot(convohist{1}, convohist{2}, 'r--o')
grid on;
h = legend('Original', 'Contrasted');%, 'Location', 'Best');
pos = get(h,'position');
set(h, 'position',[0.28 0.96 pos(3:4)])
hold off;

subplot(3,6,plotPos(3))
imshow(a);
title 'Contrasted'

if (Param == 1)
    str = ['Low'];
elseif (Param == 2)
    str =  ['Med'];
elseif (Param == 3)
    str = ['High'];
end
str2 = [' Second Pass Contrasted'];
s = {str2, str};
subplot(3,6,plotPos(4))
imshow(sndContrast)
title(s)

subplot(3,6,plotPos(5))
imshow(StrImage)
str3 = ['Structural Element Length: '];
str4 = num2str(Length);
s = [str3, str4];
title(s)

subplot(3,6,plotPos(6))
imshow(bound)
title 'Keeper'
hold off;
end


end
