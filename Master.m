%Master Contrast
%Written by David Nedrelow, 09/25/15
clear all
close all

n = 1;  %number of crops

global PeakParam;
global ParamO;
global Parstrel;
global Diameters;
global Length;

if numel(PeakParam) == 0
    PeakParam(1) = 180;
    PeakParam(2) = 220;
end
if numel(Parstrel) == 0
    Parstrel(1) = 5;
    Parstrel(2) = 1;
end
Left = PeakParam(1);
Right = PeakParam(2);
Length = Parstrel(1);

ParamO = 1;
 %slider? or buttons
Resolution = 1;  %Buttons.
Parstrel = [Length, Resolution];

%%1.  Collect Stack of Images

[image_stack, fname] = Image_Stacker;

%%2.  Crop the images


[Crop, rect] = Croppy(image_stack{end}, n);  %rect is an n element cell with coordinates
%to apply to other images.
for idi = 1:numel(image_stack)
for idr = 1:numel(rect)
    rectO = rect{idr};
    cropo = imcrop(image_stack{idi}, rectO);
    cropped_stack{idi, idr} = cropo; % {image in rows, crops in columns}
%note that the last column is empty because idi not equal idr
%use row index for end...
end
end

%%3 Mask outside the spheres
%start with last image, get all the maskings (1 for each crop)

for idc = 1:n %num crops
    
     strname = sprintf('Cropped and Masked ');
    strnum = num2str(idc);
    str_folder = [strname, strnum];
    mkdir(str_folder);
    oldFolder = cd(str_folder);  
    cd(oldFolder);
    
    masking = Mask_Coords(cropped_stack{end,idc});
    for idi = 1:numel(cropped_stack(:,1))  %now for each image
        blackMaskedImage = cropped_stack{idi,idc};
    blackMaskedImage(~masking) = 0;  %blackened outside ROI
    Crop_n_Mask{idi, idc} = blackMaskedImage; 
    end
end

%Now write cropped and masked images to n folders, one for each crop
for idf = 1:length(fname)
for idc = 1:n
    
    strname = sprintf('Cropped and Masked ');
    strnum = num2str(idc);
    str_folder = [strname, strnum];
    oldFolder = cd(str_folder);  
    
        CnM_out = Crop_n_Mask{idf,idc};
        fnm = char(fname{idf});
        imwrite(CnM_out, fnm);
    
    cd(oldFolder);
end
end


%%4Select Contrast Filtering and Strel Settings
%lets go one at a time.  We will need to ask the user to hit GO when they
%are ready for roboto to work.  (ie run the horse function)  %simply create
%a new function horse and then run it in the callback function on
%Contrast_UI.  So now, alls you really have to do is write the parameter 
%assignment routine and call the UI
close all;
for idc = 1:n
  
    strname = sprintf('Cropped and Masked ');
    strnum = num2str(idc);
    str_folder = [strname, strnum];
    
    movefile('Contrast_UI.m', str_folder);
    movefile('Image_Stacker.m', str_folder);
    movefile('Connie_horse.m', str_folder);
    movefile('Auto_Connie.m', str_folder);
    movefile('Auto_Connie2.m', str_folder);
    movefile('Bd_Measure.m', str_folder);
    movefile('StrelImage.m', str_folder);
    movefile('Con_Station.m', str_folder);
    movefile('Domo.wav', str_folder);


    oldFolder = cd(str_folder);  

        Contrast_UI;
        fprintf('\nYou must close the UI window for the program to advance\n')
          uiwait(gcf);
          
     movefile('Contrast_UI.m', oldFolder);
    movefile('Image_Stacker.m',oldFolder);
     movefile('Connie_horse.m', oldFolder);
      movefile('Auto_Connie.m', oldFolder);
    movefile('Auto_Connie2.m', oldFolder);
    movefile('Bd_Measure.m', oldFolder);
  movefile('StrelImage.m', oldFolder);
    movefile('Con_Station.m', oldFolder);
    movefile('Domo.wav', oldFolder);

     cd(oldFolder);
end

uiwait(gcf);   %attempt to wait until UI has been closed before retreiving diameters
fprintf('You waited you darling\n')
Dia = [];
for idc = 1:n
  
    strname = sprintf('Cropped and Masked ');
    strnum = num2str(idc);
    str_folder = [strname, strnum];

    oldFolder = cd(str_folder);  

        d=dir('testicios.csv');   % return the list of csv files 
        m = textread(d.name,'','headerlines',1); 
        Dia = cat(2, Dia, m);
     cd(oldFolder);
end
%fname
output = mat2dataset(Dia);

%output with filename similar to input .csv
[pathstr,name,ext] = fileparts(fname{1}) ;
str = ['.csv'];
s = [name, str];
export(output,'File', s, 'Delimiter',',');
output = mat2dataset(Dia);

%output with similar filename as .csv
[pathstr,name,ext] = fileparts(fname{1}) ;
str = ['.csv'];
s = [name, str];
export(output,'File', s, 'Delimiter',',');
