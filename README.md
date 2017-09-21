## CompressedFaceHallucination
IJCV 2017 paper Hallucinating Compressed Face Images

## Manuscript
[download link](https://drive.google.com/file/d/0B3BFPCczyQJnR2V2aU1zYnRyazA/view?usp=sharing)

## Experimental environment
The code is verified on Windows10 and Matlab2017a.

## Requirement
[CMU Multi-PIE face dataset](http://www.flintbox.com/public/project/4742/). We are unable to release this dataset because of its copyright. Please acquire a copy by yourself, and place the dataset in the Dataset/Multi-PIE folder.

[OpenCV library](http://opencv.org/). We use its five DLL files: opencv_core244.dll, opencv_ffmpeg244_64.dll, opencv_highgui244.dll, opencv_imgproc244.dll, and opencv_objdetect244.dll. They can be found in our released dataset package and need to be placed in the Code/Ours2 folder for Matlab access.

[IntraFace library](http://www.humansensing.cs.cmu.edu/intraface/). A copy of the IntraFace library v1.3 is included in our released dataset package.

[A+ Super-resolution method](http://www.vision.ee.ethz.ch/~timofter/ACCV2014_ID820_SUPPLEMENTARY/). The code is publicly available and a copy is included in our released dataset package.

[SA_DCT library]

## Dataset package
Please download it (162mb) from the Google Drive [(link)](https://drive.google.com/file/d/0B3BFPCczyQJnTFJjbTRHdGtPSDA/view?usp=sharing) or the Baidu Pan [(link)](https://pan.baidu.com/s/1ge9fKVh).

## Reproduce our experiments
Run the Test106_ExtraLandmarks_6p4.m and the results are generated in the folder Result/Test106_ExtraLandmarks_6p4.

## Citation
Please cite our paper if you use this repository in your research. BibTeX:
```
@article{Yang17_IJCV,
	title={Hallucianting Compressed Face Images,,
	author={Chih-Yuan Yang and Sifei Liu and Ming-Hsuan Yang},
	journal={International Journal of Computer Vision},
	year={2017}
}
```
