# Video Acceleration Magnification

Matlab source code rewritten by Dr. Seyran Khademi (S.khademi@tudelft.nl) starting from the source code of Yichao Zhang.
If you find any bugs or improvements, feel free to contact Dr. Seyran Khademi. 
If you find the code useful, please cite the paper: Video Acceleration Magnification (Proceedings CVPR 2017).

The paper and example videos can be found on the project web page: https://acceleration-magnification.github.io

The code was written in MATLAB R2017b, and tested on Mac OSX and Linux. 
It uses the pyramid toolbox by Eero Simoncelli (matlabPyrTools), available at http://www.cns.nyu.edu/~eero/software.php. and the Phase Correction Code from the paper “Phase-Based Frame Interpolation for Video (CVPR 2015)” at https://github.com/owang/PhaseBasedInterpolation. 
For convenience, we have included the toolboxes.

### Requirements:
- MATLAB R2017b
- gcc or lcc

### Organization:
This package is organized as follows.

	data/                                     # data directory
		raw_vid/                          # directory storing the original videos
		result_vid/                       # directory storing the result videos	   
		result_vid/[video_name]/im_write/ # directory storing the result videos frames	   
	third/                                    # third party libs 
		matlabPyrTools/                   # directory containing the pyramid toolbox by Eero Simoncelli 	
		phaseCorrection/                  # directory containing	 	
	motionamp.m                               # script that performs the actual motion magnification
	setparameters.m                           # scripts defining the method parameters
	tempkernel.m                              # script defining the temporal kernel (‘INT’ or ‘DOG’) 
						  # for obtaining the second order derivative of the video temporally 
	make.m			                  # script for (re)compiling the mex files for matlabPyrTools 
	demo.m                                    # script that will run the magnification over a given input video example
	main.m                                    # script that will replicate the paper results 
	README.md                                 # this file

### Input and output:

The included example consists of sub-folders. The minimum input requirements are:

	data/
	    raw_vid/[your_video_name] # the input original video

The output will be saved in:

	data/
   		result_vid/[your_video_name]/im_write/fr*.png # the output motion-magnified video frames
    		result_vid/[your_video_name.avi]              # the output motion-magnified video file

### Usage: demo.m

1) Run "make.m" to build pyramid toolbox libraries.
2) Run: "demo.m [your_video_name] [.video_extension]" (example: "demo cat_toy .avi").


*NOTE* that the best results are achieved with stable videos without shaking ( tripods-recorded rather than hand-recorded) since the acceleration magnification, magnifies any nonlinear movement once it falls within the bandpass of the second-derivative (high-pass) filter. 

Please refer to the Matlab code for more details. 

Generating each of the results may take hours, this inefficiency is due to the serial filtering implementation in time domain which removes the dependency on fully available video and enables the processing for large videos without encountering the memory issues.  
