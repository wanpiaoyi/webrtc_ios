#import <UIKit/UIKit.h>

//! Project version number for GPUImageFramework.
FOUNDATION_EXPORT double GPUImageFrameworkVersionNumber;

//! Project version string for GPUImageFramework.
FOUNDATION_EXPORT const unsigned char GPUImageFrameworkVersionString[];

#import <QKGPUImage/GLProgram.h>

// Base classes
#import <QKGPUImage/GPUImageContext.h>
#import <QKGPUImage/GPUImageOutput.h>
#import <QKGPUImage/GPUImageView.h>
#import <QKGPUImage/GPUImageVideoCamera.h>
#import <QKGPUImage/GPUImageStillCamera.h>
#import <QKGPUImage/GPUImageMovie.h>
#import <QKGPUImage/GPUImagePicture.h>
#import <QKGPUImage/GPUImageRawDataInput.h>
#import <QKGPUImage/GPUImageRawDataOutput.h>
#import <QKGPUImage/GPUImageMovieWriter.h>
#import <QKGPUImage/GPUImageFilterPipeline.h>
#import <QKGPUImage/GPUImageTextureOutput.h>
#import <QKGPUImage/GPUImageFilterGroup.h>
#import <QKGPUImage/GPUImageTextureInput.h>
#import <QKGPUImage/GPUImageUIElement.h>
#import <QKGPUImage/GPUImageBuffer.h>
#import <QKGPUImage/GPUImageFramebuffer.h>
#import <QKGPUImage/GPUImageFramebufferCache.h>

// Filters
#import <QKGPUImage/GPUImageFilter.h>
#import <QKGPUImage/GPUImageTwoInputFilter.h>
#import <QKGPUImage/GPUImagePixellateFilter.h>
#import <QKGPUImage/GPUImagePixellatePositionFilter.h>
#import <QKGPUImage/GPUImageSepiaFilter.h>
#import <QKGPUImage/GPUImageColorInvertFilter.h>
#import <QKGPUImage/GPUImageSaturationFilter.h>
#import <QKGPUImage/GPUImageContrastFilter.h>
#import <QKGPUImage/GPUImageExposureFilter.h>
#import <QKGPUImage/GPUImageBrightnessFilter.h>
#import <QKGPUImage/GPUImageLevelsFilter.h>
#import <QKGPUImage/GPUImageSharpenFilter.h>
#import <QKGPUImage/GPUImageGammaFilter.h>
#import <QKGPUImage/GPUImageSobelEdgeDetectionFilter.h>
#import <QKGPUImage/GPUImageSketchFilter.h>
#import <QKGPUImage/GPUImageToonFilter.h>
#import <QKGPUImage/GPUImageSmoothToonFilter.h>
#import <QKGPUImage/GPUImageMultiplyBlendFilter.h>
#import <QKGPUImage/GPUImageDissolveBlendFilter.h>
#import <QKGPUImage/GPUImageKuwaharaFilter.h>
#import <QKGPUImage/GPUImageKuwaharaRadius3Filter.h>
#import <QKGPUImage/GPUImageVignetteFilter.h>
#import <QKGPUImage/GPUImageGaussianBlurFilter.h>
#import <QKGPUImage/GPUImageGaussianBlurPositionFilter.h>
#import <QKGPUImage/GPUImageGaussianSelectiveBlurFilter.h>
#import <QKGPUImage/GPUImageOverlayBlendFilter.h>
#import <QKGPUImage/GPUImageDarkenBlendFilter.h>
#import <QKGPUImage/GPUImageLightenBlendFilter.h>
#import <QKGPUImage/GPUImageSwirlFilter.h>
#import <QKGPUImage/GPUImageSourceOverBlendFilter.h>
#import <QKGPUImage/GPUImageColorBurnBlendFilter.h>
#import <QKGPUImage/GPUImageColorDodgeBlendFilter.h>
#import <QKGPUImage/GPUImageScreenBlendFilter.h>
#import <QKGPUImage/GPUImageExclusionBlendFilter.h>
#import <QKGPUImage/GPUImageDifferenceBlendFilter.h>
#import <QKGPUImage/GPUImageSubtractBlendFilter.h>
#import <QKGPUImage/GPUImageHardLightBlendFilter.h>
#import <QKGPUImage/GPUImageSoftLightBlendFilter.h>
#import <QKGPUImage/GPUImageColorBlendFilter.h>
#import <QKGPUImage/GPUImageHueBlendFilter.h>
#import <QKGPUImage/GPUImageSaturationBlendFilter.h>
#import <QKGPUImage/GPUImageLuminosityBlendFilter.h>
#import <QKGPUImage/GPUImageCropFilter.h>
#import <QKGPUImage/GPUImageGrayscaleFilter.h>
#import <QKGPUImage/GPUImageTransformFilter.h>
#import <QKGPUImage/GPUImageChromaKeyBlendFilter.h>
#import <QKGPUImage/GPUImageHazeFilter.h>
#import <QKGPUImage/GPUImageLuminanceThresholdFilter.h>
#import <QKGPUImage/GPUImagePosterizeFilter.h>
#import <QKGPUImage/GPUImageBoxBlurFilter.h>
#import <QKGPUImage/GPUImageAdaptiveThresholdFilter.h>
#import <QKGPUImage/GPUImageUnsharpMaskFilter.h>
#import <QKGPUImage/GPUImageBulgeDistortionFilter.h>
#import <QKGPUImage/GPUImagePinchDistortionFilter.h>
#import <QKGPUImage/GPUImageCrosshatchFilter.h>
#import <QKGPUImage/GPUImageCGAColorspaceFilter.h>
#import <QKGPUImage/GPUImagePolarPixellateFilter.h>
#import <QKGPUImage/GPUImageStretchDistortionFilter.h>
#import <QKGPUImage/GPUImagePerlinNoiseFilter.h>
#import <QKGPUImage/GPUImageJFAVoronoiFilter.h>
#import <QKGPUImage/GPUImageVoronoiConsumerFilter.h>
#import <QKGPUImage/GPUImageMosaicFilter.h>
#import <QKGPUImage/GPUImageTiltShiftFilter.h>
#import <QKGPUImage/GPUImage3x3ConvolutionFilter.h>
#import <QKGPUImage/GPUImageEmbossFilter.h>
#import <QKGPUImage/GPUImageCannyEdgeDetectionFilter.h>
#import <QKGPUImage/GPUImageThresholdEdgeDetectionFilter.h>
#import <QKGPUImage/GPUImageMaskFilter.h>
#import <QKGPUImage/GPUImageHistogramFilter.h>
#import <QKGPUImage/GPUImageHistogramGenerator.h>
#import <QKGPUImage/GPUImagePrewittEdgeDetectionFilter.h>
#import <QKGPUImage/GPUImageXYDerivativeFilter.h>
#import <QKGPUImage/GPUImageHarrisCornerDetectionFilter.h>
#import <QKGPUImage/GPUImageAlphaBlendFilter.h>
#import <QKGPUImage/GPUImageNormalBlendFilter.h>
#import <QKGPUImage/GPUImageNonMaximumSuppressionFilter.h>
#import <QKGPUImage/GPUImageRGBFilter.h>
#import <QKGPUImage/GPUImageMedianFilter.h>
#import <QKGPUImage/GPUImageBilateralFilter.h>
#import <QKGPUImage/GPUImageCrosshairGenerator.h>
#import <QKGPUImage/GPUImageToneCurveFilter.h>
#import <QKGPUImage/GPUImageNobleCornerDetectionFilter.h>
#import <QKGPUImage/GPUImageShiTomasiFeatureDetectionFilter.h>
#import <QKGPUImage/GPUImageErosionFilter.h>
#import <QKGPUImage/GPUImageRGBErosionFilter.h>
#import <QKGPUImage/GPUImageDilationFilter.h>
#import <QKGPUImage/GPUImageRGBDilationFilter.h>
#import <QKGPUImage/GPUImageOpeningFilter.h>
#import <QKGPUImage/GPUImageRGBOpeningFilter.h>
#import <QKGPUImage/GPUImageClosingFilter.h>
#import <QKGPUImage/GPUImageRGBClosingFilter.h>
#import <QKGPUImage/GPUImageColorPackingFilter.h>
#import <QKGPUImage/GPUImageSphereRefractionFilter.h>
#import <QKGPUImage/GPUImageMonochromeFilter.h>
#import <QKGPUImage/GPUImageOpacityFilter.h>
#import <QKGPUImage/GPUImageHighlightShadowFilter.h>
#import <QKGPUImage/GPUImageFalseColorFilter.h>
#import <QKGPUImage/GPUImageHSBFilter.h>
#import <QKGPUImage/GPUImageHueFilter.h>
#import <QKGPUImage/GPUImageGlassSphereFilter.h>
#import <QKGPUImage/GPUImageLookupFilter.h>
#import <QKGPUImage/GPUImageAmatorkaFilter.h>
#import <QKGPUImage/GPUImageMissEtikateFilter.h>
#import <QKGPUImage/GPUImageSoftEleganceFilter.h>
#import <QKGPUImage/GPUImageAddBlendFilter.h>
#import <QKGPUImage/GPUImageDivideBlendFilter.h>
#import <QKGPUImage/GPUImagePolkaDotFilter.h>
#import <QKGPUImage/GPUImageLocalBinaryPatternFilter.h>
#import <QKGPUImage/GPUImageColorLocalBinaryPatternFilter.h>
#import <QKGPUImage/GPUImageLanczosResamplingFilter.h>
#import <QKGPUImage/GPUImageAverageColor.h>
#import <QKGPUImage/GPUImageSolidColorGenerator.h>
#import <QKGPUImage/GPUImageLuminosity.h>
#import <QKGPUImage/GPUImageAverageLuminanceThresholdFilter.h>
#import <QKGPUImage/GPUImageWhiteBalanceFilter.h>
#import <QKGPUImage/GPUImageChromaKeyFilter.h>
#import <QKGPUImage/GPUImageLowPassFilter.h>
#import <QKGPUImage/GPUImageHighPassFilter.h>
#import <QKGPUImage/GPUImageMotionDetector.h>
#import <QKGPUImage/GPUImageHalftoneFilter.h>
#import <QKGPUImage/GPUImageThresholdedNonMaximumSuppressionFilter.h>
#import <QKGPUImage/GPUImageHoughTransformLineDetector.h>
#import <QKGPUImage/GPUImageParallelCoordinateLineTransformFilter.h>
#import <QKGPUImage/GPUImageThresholdSketchFilter.h>
#import <QKGPUImage/GPUImageLineGenerator.h>
#import <QKGPUImage/GPUImageLinearBurnBlendFilter.h>
#import <QKGPUImage/GPUImageGaussianBlurPositionFilter.h>
#import <QKGPUImage/GPUImagePixellatePositionFilter.h>
#import <QKGPUImage/GPUImageTwoInputCrossTextureSamplingFilter.h>
#import <QKGPUImage/GPUImagePoissonBlendFilter.h>
#import <QKGPUImage/GPUImageMotionBlurFilter.h>
#import <QKGPUImage/GPUImageZoomBlurFilter.h>
#import <QKGPUImage/GPUImageLaplacianFilter.h>
#import <QKGPUImage/GPUImageiOSBlurFilter.h>
#import <QKGPUImage/GPUImageLuminanceRangeFilter.h>
#import <QKGPUImage/GPUImageDirectionalNonMaximumSuppressionFilter.h>
#import <QKGPUImage/GPUImageDirectionalSobelEdgeDetectionFilter.h>
#import <QKGPUImage/GPUImageSingleComponentGaussianBlurFilter.h>
#import <QKGPUImage/GPUImageThreeInputFilter.h>
#import <QKGPUImage/GPUImageFourInputFilter.h>
#import <QKGPUImage/GPUImageWeakPixelInclusionFilter.h>
#import <QKGPUImage/GPUImageFASTCornerDetectionFilter.h>
#import <QKGPUImage/GPUImageMovieComposition.h>
#import <QKGPUImage/GPUImageColourFASTFeatureDetector.h>
#import <QKGPUImage/GPUImageColourFASTSamplingOperation.h>
#import <QKGPUImage/GPUImageSolarizeFilter.h>