function Contrast_UI
%Written by David Nedrelow 09/25/15
%This is an image-segmentation UI to remove noise.  It
%generates and refreshes plots according to contrast parameters.
%User will adjusts how far to left or right of peak to include in the contrast
%adjustment i.e. determine where the signal is, by examining a preview and
%clicking the "Go" button.  Then the routine will take over by processing every image
%in the series with the selected parameters.

%Sliders:  1) Left of Peak, 2) Right of Peak.
%Buttons:  "Go", "Low", "Med", "High" -where the user sees noise in the low
%gray Levels, he/she would select High for the second pass of contrast
%adjustments.

%The subplot is to be 3 rows of:  original, hist, 1stContrast, 2nd
%Contrast, strel bound, final  (6)
%close all

fprintf('select ONLY 3 images from your series\n')
[im, fnm] = Image_Stacker;

%Left = -30;
%Right = 40;
global PeakParam;
%handles.PeakParam = 0;
global Parstrel;
global ParamO;
global Length;
if numel(PeakParam) == 0
    PeakParam(1) = 180;
    PeakParam(2) = 220;
end
if numel(Parstrel) == 0
    Parstrel(1) = 10;
    Parstrel(2) = 1;
end
Left = PeakParam(1);
Right = PeakParam(2);
Length = Parstrel(1);

Left = PeakParam(1);
Right = PeakParam(2);


%%%Enter the buttons etc...

set(gcf, 'units','normalized','outerposition',[0 0 0.95 0.95]);



sldLength = uicontrol('Style', 'slider',...  %Strel Length
        'Min',1,'Max',30,'Value',Parstrel(1),...
        'Position', [5 50 100 100],...
        'Callback', @sliderLength_Callback); 
					
    str1 = sprintf('Length = ');
    str2 = num2str(Length);
    str = [str1, str2];
    
    % Add a text uicontrol to label the slider.
    txt = uicontrol('Style','text',...
        'Position',[10 100 50 40],...
        'String','Length of Strel');

    f.Name = 'Length of Strel';

sldLeft = uicontrol('Style', 'slider',...  %Left Offset
        'Min',0,'Max',256,'Value',PeakParam(1),...
        'Position', [200 30 300 20],...
        'Callback', @sliderLeft_Callback); 
					
    str1 = sprintf('Left_Offset = ');
    str2 = num2str(Left);
    str = [str1, str2];
    
    % Add a text uicontrol to label the slider.
    txt = uicontrol('Style','text',...
        'Position',[200 10 120 20],...
        'String','Left Offset');

    f.Name = 'Left Offset Selector';

     sldRight = uicontrol('Style', 'slider',...  %Left Offset
        'Min',0,'Max',256,'Value',PeakParam(2),...
        'Position', [700 30 300 20],...
        'Callback', @sliderRight_Callback); 
					
    str1 = sprintf('Right_Offset = ');
    str2 = num2str(Right);
    str = [str1, str2];
    
    % Add a text uicontrol to label the slider.
    txt = uicontrol('Style','text',...
        'Position',[700 10 120 20],...  %[left bottom width height]
        'String','Right Offset');

    f.Name = 'Right Offset Selector';
    
    
     function sliderLength_Callback(source, ~)
         val = round(source.Value);
Parstrel(1) = val
 setappdata(0,'Parstrel',Parstrel);
     end
    
     function sliderLeft_Callback(source, eventdata, handles)
         val = round(source.Value)
PeakParam(1) = val
setappdata(0,'PeakParam',PeakParam); %h can be the handle of your gui or 0 to save in base (workspace)
     end
 
  function sliderRight_Callback(source, ~)
      val = round(source.Value);
      PeakParam(2) = val
setappdata(0,'PeakParam',PeakParam);

     end
    
 % Create push button
   btnGO = uicontrol('Style', 'pushbutton', 'String', 'GO!',...
        'Position', [50 500 50 30],...
        'Callback', @btnGO_Callback); 
 
    btnLow = uicontrol('Style', 'pushbutton', 'String', 'Low',...
        'Position', [50 10 50 30],...
        'Callback', @btnLow_Callback);   
    
 btnMed = uicontrol('Style', 'pushbutton', 'String', 'Med',...
        'Position', [100 10 50 30],...
        'Callback', @btnMed_Callback);   
    
 btnHigh = uicontrol('Style', 'pushbutton', 'String', 'High',...
        'Position', [150 10 50 30],...
        'Callback', @btnHigh_Callback); 
    
    function btnGO_Callback(hObject,eventdata,handles)
            button_state = get(hObject,'Value');
        if button_state == get(hObject,'Max')
            display('down');
            [y, Fs] = audioread('Domo.wav');
            sound(y, Fs);

         L = Connie_horse(PeakParam, ParamO, Parstrel);
         
            Diameter = L';
         output = mat2dataset(Diameter);
         export(output,'File', 'testicios.csv', 'Delimiter',',');
          
        elseif button_state == get(hObject,'Min')
            display('up');           
        end
  end
    
    
  function btnLow_Callback(hObject,eventdata,handles)
            button_state = get(hObject,'Value');
        if button_state == get(hObject,'Max')
            display('down');
            ParamO = 1
         setappdata(0,'ParamO',ParamO);  %makes it updated on workspace
          Con_Station(im, PeakParam, ParamO, Parstrel);
        elseif button_state == get(hObject,'Min')
            display('up');           
        end
  end

  function btnMed_Callback(hObject,eventdata,handles)
            button_state = get(hObject,'Value');
        if button_state == get(hObject,'Max')
            display('down');
            ParamO = 2
            setappdata(0,'ParamO',ParamO);
         Con_Station(im, PeakParam, ParamO, Parstrel);
        elseif button_state == get(hObject,'Min')
            display('up');           
        end
  end
        
  
  function btnHigh_Callback(hObject,eventdata,handles)
            button_state = get(hObject,'Value');
        if button_state == get(hObject,'Max')
            display('down');
            ParamO = 3
             setappdata(0,'ParamO',ParamO);
        Con_Station(im, PeakParam, ParamO, Parstrel);
        elseif button_state == get(hObject,'Min')
            display('up');
        end
  end
  

end
