#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import "GPUImageContext.h"
#import "GPUImageOutput.h"
#import "GPUImageColorConversion.h"

//Optionally override the YUV to RGB matrices
//void setColorConversion601( GLfloat conversionMatrix[9] );
//void setColorConversion601FullRange( GLfloat conversionMatrix[9] );
//void setColorConversion709( GLfloat conversionMatrix[9] );

typedef NS_ENUM(NSInteger,QKGPUImageMultiType){
    QKGPUImageMultiType640x480,
    QKGPUImageMultiType1280x720,
    QKGPUImageMultiType1920x1080,
};

typedef void (^getImgAddress)(NSString *img_address,NSString *img_name,NSData *img);


//Delegate Protocal for Face Detection.
@protocol QKGPUImageMultiVideoCameraDelegate <NSObject>

@optional
- (void)willOutputAudioSampleBuffer:(CMSampleBufferRef)sampleBuffer;
- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer;
@end


/**
 A GPUImageOutput that provides frames from either camera
*/
API_AVAILABLE(ios(13.0))
@interface QKGPUImageMultiVideoCamera : GPUImageOutput <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate>
{
    NSUInteger numberOfFramesCaptured;
    CGFloat totalFrameTimeDuringCapture;
    
    AVCaptureDevice *_microphone;
    AVCaptureDeviceInput *videoInputFront;
    AVCaptureDeviceInput *videoInputBack;
    AVCaptureVideoDataOutput *videoOutputFront;
    AVCaptureVideoDataOutput *videoOutputBack;
    AVCaptureStillImageOutput *_stillImageOutput;
    BOOL capturePaused;
    GPUImageRotationMode outputRotation, internalRotation;
    dispatch_semaphore_t frameRenderingSemaphore;
        
    BOOL captureAsYUV;
    GLuint luminanceTexture, chrominanceTexture;

    __unsafe_unretained id<QKGPUImageMultiVideoCameraDelegate> _delegate;
}

/// Whether or not the underlying AVCaptureSession is running
@property(readonly, nonatomic) BOOL isRunning;

/// The AVCaptureSession used to capture from the camera
@property(strong, nonatomic) AVCaptureMultiCamSession *captureSession;



/// Easy way to tell which cameras are present on device
@property (readonly, getter = isFrontFacingCameraPresent) BOOL frontFacingCameraPresent;
@property (readonly, getter = isBackFacingCameraPresent) BOOL backFacingCameraPresent;

/// This enables the benchmarking mode, which logs out instantaneous and average frame times to the console
@property(readwrite, nonatomic) BOOL runBenchmark;

/// Use this property to manage camera settings. Focus point, exposure point, etc.
@property(strong,nonatomic) AVCaptureDevice *frontCamera;

@property(strong,nonatomic) AVCaptureDevice *backCamera;

/// This determines the rotation applied to the output image, based on the source material
@property(readwrite, nonatomic) UIInterfaceOrientation outputImageOrientation;

/// These properties determine whether or not the two camera orientations should be mirrored. By default, both are NO.
@property(readwrite, nonatomic) BOOL horizontallyMirrorFrontFacingCamera, horizontallyMirrorRearFacingCamera;

@property(nonatomic, assign) id<QKGPUImageMultiVideoCameraDelegate> delegate;
@property (readwrite) int32_t frameRate;

/// @name Initialization and teardown

/** Begin a capture session
 
 See AVCaptureSession for acceptable values
 
 @param sessionPreset Session preset to use
 @param cameraPosition Camera to capture from
 */
- (id)initWithSessionPreset:(QKGPUImageMultiType)frontType backType:(QKGPUImageMultiType)backType front:(BOOL)front;

/** Add audio capture to the session. Adding inputs and outputs freezes the capture session momentarily, so you
    can use this method to add the audio inputs and outputs early, if you're going to set the audioEncodingTarget
    later. Returns YES is the audio inputs and outputs were added, or NO if they had already been added.
 */
- (BOOL)addAudioInputsAndOutputs;

/** Remove the audio capture inputs and outputs from this session. Returns YES if the audio inputs and outputs
    were removed, or NO is they hadn't already been added.
 */
- (BOOL)removeAudioInputsAndOutputs;

/** Tear down the capture session
 */
- (void)removeInputsAndOutputs;

/// @name Manage the camera video stream

/** Start camera capturing
 */
- (void)startCameraCapture;

/** Stop camera capturing
 */
- (void)stopCameraCapture;

/** Pause camera capturing
 */
- (void)pauseCameraCapture;

/** Resume camera capturing
 */
- (void)resumeCameraCapture;

/** Process a video sample
 @param sampleBuffer Buffer to process
 */
- (void)processVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer;

/** Process an audio sample
 @param sampleBuffer Buffer to process
 */
- (void)processAudioSampleBuffer:(CMSampleBufferRef)sampleBuffer;



/// @name Benchmarking

/** When benchmarking is enabled, this will keep a running average of the time from uploading, processing, and final recording or display
 */
- (CGFloat)averageFrameDurationDuringCapture;

- (void)resetBenchmarkAverage;

+ (BOOL)isBackFacingCameraPresent;
+ (BOOL)isFrontFacingCameraPresent;


-(AVCaptureDevice*)inputCamera;

//设置防抖
-(void)setStabilization:(BOOL)stabilization;
-(void) videoSetScale : (float) scale;
-(void) videoSetFoucs:(CGPoint) touchPoint  TouchView:(UIView *)view;
//设置手动聚焦
-(BOOL)setNoAutoFocus;
//设置自动聚焦
-(BOOL)setAutoFocus;
-(void) videoSetOneLockedFoucs:(CGPoint) touchPoint  TouchView:(UIView *)view;
-(BOOL) videoChangeFlash :(int) flashValue;
//拍照
-(void)takePhoto:(getImgAddress)getaddress addresspath:(NSString*)addresspath;
-(void)changeVideoOrientation:(AVCaptureVideoOrientation)orientation;


+(BOOL)isSupportMultiCamera;
@end
