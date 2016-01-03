# Gel-Image-Segmentation
Written by David Nedrelow, 12/01/15
This is a custom matlab routine written to automate the measurement of gel diagmeters taken from experimental images.  
It was written and tested on Matlab_r2015a, a version downloaded on February 12, 2015.  There are known issues within the GUI when run on older versions of Matlab, but these may be resolved by updating Matlab.  This routine will not work without a .wav soundfile named "Domo.wav" contained in the same folder.  This can be obtained by contacting the corresponding author.

Procedure:
1.  Copy and paste all of these files into a folder along with the .tif image files you wish to analyze.
2.  open Master.m and assign to the variable "n" the number of objects you wish to analyze.
3.  Select all images from your experiment.
3.  Drag crop boxes over each of the objects of interest in the image.  It will work better if you give a large buffer to the crop box about the size of the object diameter on all sides.  Do not worry if your crop overflows into another object in the picture you wish to analyze because you will also mask this image.
4.  Now the last image in the series will appear (assumed swelling) for you to mask.  Drag a line enclosing the object of interest as close as possible.  When you release the click, it will advance to the next crop in your image.
5.  Now select only 3 images from your series.  This is a sample with which to test your image segmentation parameters.  Select one image from the beginning, one from the middle, and one from the end of your experiment.  (later to test your parameters have accurately segmented the image, run the routine again, but select three different images for your sample.  Then compare final results.)
6.  The UI should appear.  Click "low", "med", or "high" to introduce your images and to refresh after you have applied settings.  Left and Right offset sliders: assign graylevels for the 1st contrast,  Notice how the values selected will highlight the histogram in red.    Strel:  assigns a length to the structural element.  When you are satisfied that the segmentation has segmented the object you wish to measure, click on "Go".  It will make a noise.
7.  Select your calibration .tif image to set scale and follow the prompts.
8.  Select all of the images you wish to measure.
9.  Close all figures.  It will not prompt you to select parameters on the next crop in your image.  Please repeat procedures 5 through 8
10.  Finally you should have a .csv file in your folder with columns of diameters whose rows correspond ot the order of the images you input to the routine.
