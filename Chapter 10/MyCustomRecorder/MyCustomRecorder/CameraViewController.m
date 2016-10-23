//
//  CameraViewController.m
//  MyCamera
//
//  Created by Ahmed Bakir on 6/23/14.
//  Copyright (c) 2014 devAtelier. All rights reserved.
//

#import "CameraViewController.h"

@interface CameraViewController ()

@property (nonatomic, strong) NSArray *cameraArray;
@property (nonatomic, strong) AVCaptureDeviceInput *rearCameraInput;
@property (nonatomic, strong) AVCaptureDeviceInput *frontCameraInput;
@property (nonatomic, strong) AVCaptureDeviceInput *audioInput;

@property (nonatomic, strong) AVCaptureDevice *rearCamera;
@property (nonatomic, strong) AVCaptureDevice *frontCamera;
@property (nonatomic, strong) AVCaptureDevice *microphone;
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
        
        self.movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
        self.movieFileOutput.minFreeDiskSpaceLimit = 200 * 1024; //200MB
        self.movieFileOutput.maxRecordedDuration = CMTimeMakeWithSeconds(180, 1); //3 mins max
        
        if ([self.session canAddOutput:self.movieFileOutput] && [self.session canSetSessionPreset:AVCaptureSessionPreset1920x1080]) {
            [self.session setSessionPreset:AVCaptureSessionPreset1920x1080];
            [self.session addOutput:self.movieFileOutput];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Not enough disk space" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
        
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
    AVCaptureConnection *connection = [self.movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    
    [connection setVideoOrientation:(AVCaptureVideoOrientation)toInterfaceOrientation];

}



-(IBAction)cancel:(id)sender
{
    [self.session stopRunning];
    
    [self.delegate cancel];
}

-(IBAction)toggleRecording:(id)sender
{
    if ([self.movieFileOutput isRecording]) {
        
        [self.movieFileOutput stopRecording];
        
        self.torchButton.hidden = NO;
        self.focusButton.hidden = NO;
        self.cameraButton.hidden = NO;
        self.lowLightButton.hidden = NO;
        
        self.timeLabel.hidden = YES;
        
        [self.recordingTimer invalidate];
        
        self.duration = 0;
        
    } else {
        
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *relativePath = [documentsDirectory stringByAppendingPathComponent:@"movie.mov"];
        
        NSURL *fileURL = [NSURL fileURLWithPath:relativePath];
        
        self.torchButton.hidden = YES;
        self.focusButton.hidden = YES;
        self.cameraButton.hidden = YES;
        self.lowLightButton.hidden = YES;
        
        self.timeLabel.hidden = NO;
        
        [self.movieFileOutput startRecordingToOutputFileURL:fileURL recordingDelegate:self];
        
        self.recordingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
        
        self.duration = 0;
        
        [self.recordingButton setTitle:@"Stop Recording" forState:UIControlStateNormal];
        [self.recordingButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        
    }
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

-(IBAction)torchMode:(id)sender {
    if ([self.currentDevice isTorchAvailable]) {
        //
        UIActionSheet *cameraSheet = [[UIActionSheet alloc] initWithTitle:@"Torch Mode" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Auto", @"On" , @"Off", nil];
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

-(IBAction)lowLightMode:(id)sender {
    if ([self.currentDevice isLowLightBoostSupported]) {
        //
        UIActionSheet *exposureSheet = [[UIActionSheet alloc] initWithTitle:@"Low Light Boost Mode" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"On" , @"Off", nil];
        exposureSheet.tag = 103;
        [exposureSheet showInView:self.view];
    } else {
        //
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Low Light Boost not supported" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
    
    self.microphone = nil;
    
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
    
    self.microphone = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
    self.audioInput = [AVCaptureDeviceInput deviceInputWithDevice:self.microphone error:&error];
    
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

-(void)switchToTorchWithIndex:(NSInteger)buttonIndex
{
    NSError *error = nil;
    
    AVCaptureTorchMode torchMode = 0;
    
    switch (buttonIndex) {
        case 0: {
            torchMode = AVCaptureTorchModeAuto;
            self.torchButton.titleLabel.text = @"Torch: Auto";
            break;
        }
        case 1: {
            torchMode = AVCaptureTorchModeOn;
            self.torchButton.titleLabel.text = @"Torch: On";
            break;
        }
        case 2: {
            torchMode = AVCaptureTorchModeOff;
            self.torchButton.titleLabel.text = @"Torch: Off";
            break;
        }
        default:
            break;
    }
    
    if ([self.currentDevice lockForConfiguration:&error]) {
        
        self.currentDevice.torchMode = torchMode;
        
        [self.currentDevice unlockForConfiguration];
    } else {
        NSLog(@"could not set torch mode");
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
    
    BOOL boostOn;
    switch (buttonIndex) {
        case 0: {
            boostOn = YES;
            self.lowLightButton.titleLabel.text = @"LL Boost: On";
            break;
        }
        case 1: {
            boostOn = NO;
            self.lowLightButton.titleLabel.text = @"LLBoostOff: Off";
            break;
        }
        default:
            break;
    }
    
    if ([self.currentDevice lockForConfiguration:&error] && [self.currentDevice isLowLightBoostSupported]) {
        
        self.currentDevice.automaticallyEnablesLowLightBoostWhenAvailable = boostOn;
        
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
            [self switchToTorchWithIndex:buttonIndex];
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

#pragma mark - Timer delegate

-(void)updateProgress
{
    NSInteger durationMinutes = self.duration / 60;
    NSInteger durationSeconds = self.duration  - durationMinutes * 60;
    NSString *progressString = [NSString stringWithFormat:@"0:%02ld:%02ld", durationMinutes, (long)durationSeconds];
    self.timeLabel.text = progressString;
    self.duration++;
}

#pragma mark - AVCaptureFileOutputRecording delgate

-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    if (error != nil)  {
        NSString *errorString = [error description];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
    } else {
        VideoPlaybackController *playbackVC = [[VideoPlaybackController alloc] initWithContentURL:outputFileURL];
        playbackVC.delegate = self;
        
        self.outputFileURL = outputFileURL;
        
        [self presentViewController:playbackVC animated:NO completion:^{
            [playbackVC prepareToPlay];
        }];
    }
}

#pragma mark - CustomPlayerDelegate

-(void)didFinishWithSuccess:(BOOL)success
{
    
    if (success) {
        
        [self.delegate didFinishWithUrl:self.outputFileURL];
        
        [self dismissViewControllerAnimated:NO completion:nil];
        
    } else {
        
        [self dismissViewControllerAnimated:NO completion:^{
            //delete old movie file
            
            [[NSFileManager defaultManager] removeItemAtPath:[self.outputFileURL path] error:NULL];
            
        }];
        
    }
}

@end
