function [image_stack, fname_out] = Image_Stacker
%Written by David Nedrelow, 09/23/15.  
%Get all image files (which should be in the same folder) and assigns them
%to a variable called image_stack.  -Very useful to the master file.
[fnm, pth] = uigetfile({'*.tif';'*.tiff';'*.png'},'Select First Image:');

if(fnm==0)
    disp('Cancelled ..');
    return;
end

%Get the file and directory information
[pth,fname,ext]=fileparts(fullfile(pth,fnm));
Din = dir(fullfile(pth,['*',ext]));
Ns = length(Din);

%User chooses images for processing
sr_v = listdlg('PromptString', 'Choose each image you would like to track','SelectionMode', 'Multiple', ...
                'Name', 'MANUAL Image Selection', ...
                'InitialValue', 1:Ns,'ListString', {Din.name},'Listsize',[400 500]);
        
%Cancel if no images are selected
if(sr_v==0)
    disp('Canceling ...');
    return;
end

for i=1:length(sr_v) %loop through all image files
    
    fname = char(Din(sr_v(i)).name);
    image = imread((fullfile(pth,fname)));
    if (size(image, 3) == 3)
    grayImage = rgb2gray(image);
    elseif (size(image, 3) == 1)
    grayImage = image;
    else
    fprintf('Somethin aint right about your passed image');
    end
    image_stack{i} = grayImage;
    fname_out{i} = fname; 
end
end

