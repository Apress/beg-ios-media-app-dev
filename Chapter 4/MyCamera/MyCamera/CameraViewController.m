//
//  CameraViewController.m
//  MyCamera
//
//  Created by Ahmed Bakir on 11/21/14.
//  Copyright (c) 2014 Ahmed Bakir. All rights reserved.
//

#import "CameraViewController.h"

@interface CameraViewController ()

@property (nonatomic, strong) NSArray *cameraArray;
@property (nonatomic, strong) AVCaptureDeviceInput *rearCameraInput;
@property (nonatomic, strong) AVCaptureDeviceInput *frontCameraInput;

@property (nonatomic, strong) AVCaptureDevice *rearCamera;
@property (nonatomic, strong) AVCaptureDevice *frontCamera;
@property (nonatomic, strong) AVCaptureDevice *currentDevice;

@property (nonatomic, strong) AVCaptureConnection *connection;

@property (nonatomic, assign) CGPoint focusPoint;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;


@end

@implementation CameraViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.previewView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.session = [[AVCaptureSession alloc] init];
    
    //find the back-facing camera
    
    [self initializeCameras];
    
    NSError *error = nil;
    
    self.focusPoint = CGPointMake(0.5f, 0.5f);
   
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    
    NSMutableDictionary *configDict = [NSMutableDictionary new];
    [configDict setObject:AVVideoCodecJPEG forKey:AVVideoCodecKey];

    [self.stillImageOutput setOutputSettings:configDict];
    
    if (error == nil && [self.session canAddInput:self.rearCameraInput]) {
        [self.session addInput:self.rearCameraInput];
        
        //set up our preview layer
        
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        
        //CGRect layerRect = self.previewView.bounds;
        CGRect layerRect = self.view.bounds;
        CGPoint layerCenter = CGPointMake(CGRectGetMidX(layerRect), CGRectGetMidY(layerRect));
        
        [self.previewLayer setBounds:layerRect];
        [self.previewLayer setPosition:layerCenter];
        
        [self.previewLayer setVideoGravity:AVLayerVideoGravityResize];
        //[self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        
        [self.previewView.layer addSublayer:self.previewLayer];
        
        //set up our output
        
        if ([self.session canAddOutput:self.stillImageOutput]) {
            [self.session addOutput:self.stillImageOutput];
        }
        
        /*
        AVCaptureMovieFileOutput *movieOutput = [[AVCaptureMovieFileOutput alloc] init];
        
        if ([self.session canAddOutput:movieOutput]) {
            [self.session addOutput:movieOutput];
        }
        
        AVCaptureConnection *videoConnection = nil;
        for (AVCaptureConnection *connection in [movieOutput connections]) {
            for (AVCaptureInputPort *port in [connection inputPorts]) {
                if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                    videoConnection = connection;
                    break;
                }
            }
            if (videoConnection) {
                break;
            }
        }
        
        
        [videoConnection setVideoOrientation:(AVCaptureVideoOrientation)[[UIDevice currentDevice] orientation]];
         
        */
        
        [self.view bringSubviewToFront:self.tapPosition];
         
    }
    
    //don't do anything we can't add a camera
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.session startRunning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.session stopRunning];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    AVCaptureConnection *connection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    
    [connection setVideoOrientation:(AVCaptureVideoOrientation)toInterfaceOrientation];
    
    /*
    CGRect layerRect = self.previewView.bounds;
    CGPoint layerCenter = CGPointMake(CGRectGetMidX(layerRect), CGRectGetMidY(layerRect));
    
    [self.previewLayer setBounds:layerRect];
    [self.previewLayer setPosition:layerCenter];
     */
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)cancel:(id)sender
{
    [self.session stopRunning];
    
    [self.delegate cancel];
}

-(IBAction)finish:(id)sender
{
    
    AVCaptureConnection *connection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    
    //[[self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo] setVideoOrientation:[connection videoOrientation]];
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        if (imageDataSampleBuffer != nil) {
            
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            
            UIImage *image = [UIImage imageWithData:imageData];
            
            [self.delegate didFinishWithImage:image];
        } else {
            
            NSLog(@"error description: %@", [error description]);
            
            [self.delegate cancel];
        }
        
    }];
    
}

#pragma  mark - button handlers

-(IBAction)switchCamera:(id)sender {
    
    if ([self.cameraArray count] > 1) {
        
        //present an action sheet
        
        UIActionSheet *cameraSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Camera" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Front Camera", @"Rear Camera", nil];
        cameraSheet.tag = 100;
        [cameraSheet showInView:self.view];
        
    } else {
        //we only have one camera, show an error message
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You only have one camera" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
}

-(IBAction)flashMode:(id)sender {
    if ([self.currentDevice isFlashAvailable]) {
        //
        UIActionSheet *cameraSheet = [[UIActionSheet alloc] initWithTitle:@"Flash Mode" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Auto", @"On" , @"Off", nil];
        cameraSheet.tag = 101;
        [cameraSheet showInView:self.view];
    } else {
        //
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Flash not supported" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(IBAction)focusMode:(id)sender {
    if ([self.currentDevice isFocusPointOfInterestSupported]) {
        //
        UIActionSheet *focusSheet = [[UIActionSheet alloc] initWithTitle:@"Focus Mode" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Auto", @"Continuous Auto" , @"Fixed", nil];
        focusSheet.tag = 102;
        [focusSheet showInView:self.view];
    } else {
        //
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Autofocus not supported" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(IBAction)exposureMode:(id)sender {
    if ([self.currentDevice isExposurePointOfInterestSupported]) {
        //
        UIActionSheet *exposureSheet = [[UIActionSheet alloc] initWithTitle:@"Exposure Mode" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Continuous Auto" , @"Fixed", nil];
        exposureSheet.tag = 103;
        [exposureSheet showInView:self.view];
    } else {
        //
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Flash not supported" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - device management

-(void)initializeCameras
{
    self.cameraArray = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    NSError *error = nil;
    
    self.rearCamera = nil;
    self.frontCamera = nil;
    
    if ([self.cameraArray count] > 1) {
        
        for (AVCaptureDevice *camera in self.cameraArray) {
            if (camera.position == AVCaptureDevicePositionBack) {
                self.rearCamera = camera;
            } else if (camera.position == AVCaptureDevicePositionFront) {
                self.frontCamera = camera;
            }
        }
        
        self.rearCameraInput = [AVCaptureDeviceInput deviceInputWithDevice:self.rearCamera error:&error];
        self.frontCameraInput = [AVCaptureDeviceInput deviceInputWithDevice:self.frontCamera error:&error];
        
    } else {
        self.rearCamera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        self.rearCameraInput = [AVCaptureDeviceInput deviceInputWithDevice:self.rearCamera error:&error];
    }
    
    self.currentDevice = self.rearCamera;
}

-(void)switchToCameraWithIndex:(NSInteger)buttonIndex
{
    [self.session beginConfiguration];
    
    if (buttonIndex == 0) {
        
        [self.session removeInput:self.rearCameraInput];
        
        if ([self.session canAddInput:self.frontCameraInput]) {
            [self.session addInput:self.frontCameraInput];
        }
        
        self.cameraButton.titleLabel.text = @"Camera: Front";
        self.currentDevice = self.frontCamera;
        
    } else if (buttonIndex == 1) {
        
        [self.session removeInput:self.frontCameraInput];
        
        if ([self.session canAddInput:self.rearCameraInput]) {
            [self.session addInput:self.rearCameraInput];
        }
        
        self.cameraButton.titleLabel.text = @"Camera: Rear";
        self.currentDevice = self.frontCamera;
    }
    
    [self.session commitConfiguration];
}

-(void)switchToFlashWithIndex:(NSInteger)buttonIndex
{
    NSError *error = nil;
    
    AVCaptureFlashMode flashMode = 0;
    
    switch (buttonIndex) {
        case 0: {
            flashMode = AVCaptureFlashModeAuto;
            self.flashButton.titleLabel.text = @"Flash: Auto";
            break;
        }
        case 1: {
            flashMode = AVCaptureFlashModeOn;
            self.flashButton.titleLabel.text = @"Flash: On";
            break;
        }
        case 2: {
            flashMode = AVCaptureFlashModeOff;
            self.flashButton.titleLabel.text = @"Flash: Off";
            break;
        }
        default:
            break;
    }
    
    if ([self.currentDevice lockForConfiguration:&error]) {
        
        self.currentDevice.flashMode = flashMode;
        
        [self.currentDevice unlockForConfiguration];
    } else {
        NSLog(@"could not set flash mode");
    }
    
}

-(void)switchToFocusWithIndex:(NSInteger)buttonIndex
{
    NSError *error = nil;
    
    AVCaptureFocusMode focusMode = 0;
    
    switch (buttonIndex) {
        case 0: {
            focusMode = AVCaptureFocusModeAutoFocus;
            self.focusButton.titleLabel.text = @"Focus: Auto";
            break;
        }
        case 1: {
            focusMode = AVCaptureFocusModeContinuousAutoFocus;
            self.focusButton.titleLabel.text = @"Focus: Cont";
            break;
        }
        case 2: {
            focusMode = AVCaptureFocusModeLocked;
            self.focusButton.titleLabel.text = @"Focus: Fixed";
            break;
        }
        default:
            break;
    }
    
    if ([self.currentDevice lockForConfiguration:&error] && [self.currentDevice isFocusModeSupported:focusMode]) {
        
        self.currentDevice.focusMode = focusMode;
        
        [self.currentDevice unlockForConfiguration];
    } else {
        NSLog(@"could not set focus mode");
    }
    
}


-(void)switchToExposureWithIndex:(NSInteger)buttonIndex
{
    NSError *error = nil;
    
    AVCaptureExposureMode exposureMode = 0;
    
    switch (buttonIndex) {
        case 0: {
            exposureMode = AVCaptureExposureModeContinuousAutoExposure;
            self.exposureButton.titleLabel.text = @"Exposure: Cont";
            break;
        }
        case 1: {
            exposureMode = AVCaptureExposureModeLocked;
            self.exposureButton.titleLabel.text = @"Exposure: Fixed";
            break;
        }
        default:
            break;
    }
    
    if ([self.currentDevice lockForConfiguration:&error] && [self.currentDevice isExposureModeSupported:exposureMode]) {
        
        self.currentDevice.exposureMode = exposureMode;
        
        [self.currentDevice unlockForConfiguration];
    } else {
        NSLog(@"could not set exposure mode");
    }
    
}

#pragma mark - Tap gesture recognizer

-(void)didTapPreview:(UIGestureRecognizer *)gestureRecognizer
{
    //CGPoint devicePoint = [(AVCaptureVideoPreviewLayer *)[[self previewView] layer] captureDevicePointOfInterestForPoint:[gestureRecognizer locationInView:[gestureRecognizer view]]];
    
    CGPoint tapPoint = [gestureRecognizer locationInView:gestureRecognizer.view];
    CGFloat relativeX = tapPoint.x / self.previewView.frame.size.width;
    CGFloat relativeY = tapPoint.y / self.previewView.frame.size.height;
    CGPoint focusPoint = CGPointMake(relativeX, relativeY);
    
    AVCaptureExposureMode exposureMode = self.currentDevice.exposureMode;
    AVCaptureFocusMode focusMode = self.currentDevice.focusMode;
    
    NSError *error = nil;
    
    if ([self.currentDevice lockForConfiguration:&error])
    {
        if ([self.currentDevice isFocusPointOfInterestSupported] && [self.currentDevice isFocusModeSupported:focusMode])
        {
            [self.currentDevice setFocusMode:focusMode];
            [self.currentDevice setFocusPointOfInterest:focusPoint];
        }
        if ([self.currentDevice isExposurePointOfInterestSupported] && [self.currentDevice isExposureModeSupported:exposureMode])
        {
            [self.currentDevice setExposureMode:exposureMode];
            [self.currentDevice setExposurePointOfInterest:focusPoint];
        }
        [self.currentDevice unlockForConfiguration];
    }
    
    self.tapPosition.text = [NSString stringWithFormat:@"Tap Position: (%0.f, %0.f)", tapPoint.x, tapPoint.y];
}

#pragma mark - UIActionSheet delegate methods

-(void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag) {
        case 100:
            [self switchToCameraWithIndex:buttonIndex];
            break;
        case 101:
            [self switchToFlashWithIndex:buttonIndex];
            break;
        case 102:
            [self switchToFocusWithIndex:buttonIndex];
            break;
        case 103:
            [self switchToExposureWithIndex:buttonIndex];
            break;
        default:
            break;
    }
}

@end
