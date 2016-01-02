function L = Connie_horse(PkParam, Param2, Prstrel)
%Written by David Nedrelow, 09/24/15
%  This function automatically applies the image-segmentation parameters to
%all images in the series and obtains blob diameters for output.
%Note:  you must have a calibration image to set the scale of your images 
%that will be measured.

fprintf('Select the images for Roboto\n')
%%%%%%%%GET Calibration
[fnmcal, pthcal] = uigetfile({'*.tif';'*.tiff';'*.png';'*.jpg'},'Select Calibration Image:');
if(fnmcal==0)
    disp('Cancelled ..');
    return;
end
calimage = imread((fullfile(pthcal,fnmcal)));

%perform calibration
redo_cal=1;
while redo_cal==1
    dlgprompt1 = {'How many calibration lengths do you have?'};
    dlgname1 = 'Performing Calibration:';
    dlgnumlines1 = 1;
    dlgdefault1 = {'1'};
    dlganswer1 = inputdlg(dlgprompt1,dlgname1,dlgnumlines1,dlgdefault1);
    num_cal = str2double(dlganswer1{1});
    
    %input actual lengths of calibration segments
    len_actual = zeros(num_cal);
    for m = 1:num_cal
        dlgtitle = strcat('Length of calibration ',num2str(m),' (in mm):');
        dlgprompt2 = {dlgtitle};
        dlgname2 = 'Performing Calibration:';
        dlgnumlines2 = 1;
        dlganswer2 = inputdlg(dlgprompt2,dlgname2,dlgnumlines2);
        len_actual(m) = str2double(dlganswer2{1});1
    end
                
    Hfig1 = figure;
    imshow(calimage);
    title({'Please click start and end of the 1st calibration segment you want to measure.';...
          '\Repeat for other calibration segments. (Keep to the same order as chosen before)'});
    [xcal,ycal] = ginput(2*num_cal);
    
    ButtonName1=questdlg('Are you happy with your selections?','Proceed?','Yes','No, I want to redo','Cancel','Yes');
    switch ButtonName1,
        case 'Yes',
            redo_cal = 0;
        case 'No, I want to redo',
            redo_cal = 1;
            clf(Hfig1)
        case 'Cancel',
            return
    end
end

close(Hfig1);

len_fig = zeros(num_cal,1);
cal_ratio = zeros(num_cal,1);
for i=1:num_cal
    len_fig(i)=sqrt((xcal(2*i)-xcal(2*i-1))^2 + (ycal(2*i)-ycal(2*i-1))^2);
    cal_ratio(i) = len_actual(i)/len_fig(i);    %units of mm per figure length
end

cal = mean(cal_ratio);  %ave
[im, fnm] = Image_Stacker;  %
PeakParam = PkParam; %left offset and right offset
Param = Param2;  %1, 2, 3
Length = Prstrel(1);  %Prstrel is 2 long
Resolution = 1;
Parstrel = [Length, Resolution];

    strname = sprintf('bound');
    str_folder = strname;

    mkdir(str_folder);
 
for idi = 1:numel(im)
    PeakParam
[a b c] = Auto_Connie(im{idi}, PeakParam);
Param
sndContrast = Auto_Connie2(a, Param) ;
Parstrel
StrImage = StrelImage(sndContrast,Parstrel);
[bound, Dia] = Bd_Measure(StrImage);
L(idi) = cal .* Dia;
  %Convert according to calibration

    oldFolder = cd(str_folder);
st = ['Bound'];
st2 = num2str(idi);
st3 = ['.png'];
s = [st, st2, st3];
  imwrite(bound, s);
cd(oldFolder);
end
end
