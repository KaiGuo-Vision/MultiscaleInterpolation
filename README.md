# Multiscale Semilocal Interpolation With Antialiasing

This is a code (new implementation) of the algorithm described in "Multiscale Semilocal Interpolation With Antialiasing, K. Guo, X. Yang, H. Zha, W. Lin and S. Yu, IEEE Trans. Image Processing, 2012". If you use this code for academic purposes, please consider citing:

```
@injournal{TIP2012,
 	 title={Multiscale Semilocal Interpolation With Antialiasing},
 	 author={Kai Guo, Xiaokang Yang, Hongyuan Zha, Weiyao Lin and Songyu Yu},
 	 booktitle={IEEE Transactions on Image Processing},
 	 year={2012}}
```

## Multiscale semilocal interpolation demo:
- Run the code 
    ```
    demo.m
    ```
    it calls multiscale semilocal interpolation algorithm "MSI_factor2" on the grayscale input and generates 2x interpolation output.
    
- This demo also includes the comparison with other state-of-the-art interpolation algorithms:
     - Bicubic interpolation
        ```
        bicubicInter4()
        ```
        "Cubic convolution interpolation for digital image processing", R. Keys, IEEE Trans. Acoustics, Speech, and Signal Processing, 1981.
     
     - Edge-directed interpolation
        ```
        inediInterpolation()
        ```
        X. Li and M. T. Orchard, “New edge-directed interpolation,” IEEE Trans. Image Processing, vol. 10, no. 10, pp. 1521–1527, Oct. 2001.
     
     - Edge-guided image interpolation via directional filtering and data fusion
        ```
        esintpInterpolation()
        ```
        L. Zhang and X. Wu, “An edge-guided image interpolation algorithm via directional filtering and data fusion,” IEEE Trans. Image Processing, vol. 15, no. 8, pp. 2226–2238, Aug. 2006.
     
     - Image interpolation by adaptive 2-D autoregressive modeling and soft-decision estimation
        ```
        AIinterpolation()
        ```
        X. Zhang and X. Wu, “Image interpolation by adaptive 2-D autoregressive modeling and soft-decision estimation,” IEEE Trans. Image Processing, vol. 17, no. 6, pp. 887–896, Jun. 2008.
     
## Multiscale semilocal interpolation on any grayscale image or any channel of image:
- Call the function:
  ```
  output_interp = MSI_factor2(input_image)
  ```
  it generates 2x interpolation output.
