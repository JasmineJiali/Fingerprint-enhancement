# Fingerprint-enhancement

Enhancement of defective fingerprint images

Steps:
-----------
1) Image normalization
2) Image segmentation
3) Two dimensional DFT transform
4) Obtaining direction and frequency diagram
5) Judgement of Foreground and Background
6) Filtering through specific filter
7) Fourier inverse transform, image back to the original image.

Files:
-----------
Fingerprint.m : The image is segmented into blocks of 16*16 for processing.

bbpf.m : Butterworth bandpass filter

fingerprint2.m : The image is segmented into blocks of 32*32 for processing.

gbpf.m : Gauss bandpass filter

Hfilter.m : Homomorphic filter

ibpf.m : Ideal bandpass filter

myfilter.m : Angle filtering

