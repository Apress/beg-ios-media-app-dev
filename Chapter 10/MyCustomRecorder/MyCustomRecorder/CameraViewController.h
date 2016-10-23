//
//  CameraViewController.h
//  MyCamera
//
//  Created by Ahmed Bakir on 6/23/14.
//  Copyright (c) 2014 devAtelier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "VideoPlaybackController.h"

@protocol CameraDelegate <NSObject>

-(void)cancel;
-(void)didFinishWithUrl:(NSURL *)url;

@end

@interface CameraViewController : UIViewController <UIActionSheetDelegate, AVCaptureFileOutputRecordingDelegate, CustomPlayerDelegate>

@property (nonatomic, strong) IBOutlet UIView *previewView;

@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) NSTimer *recordingTimer;

@property (nonatomic, strong) IBOutlet UIButton *torchButton;
@property (nonatomic, strong) IBOutlet UIButton *focusButton;
@property (nonatomic, strong) IBOutlet UIButton *cameraButton;
@property (nonatomic, strong) IBOutlet UIButton *lowLightButton;
@property (nonatomic, strong) IBOutlet UIButton *recordingButton;

@property (nonatomic, assign) NSInteger duration;

@property (nonatomic, strong) IBOutlet UILabel *tapPosition;


@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureMovieFileOutput *movieFileOutput;

@property (nonatomic, strong) NSURL *outputFileURL;

@property (nonatomic, strong) id <CameraDelegate> delegate;

-(IBAction)cancel:(id)sender;
-(IBAction)toggleRecording:(id)sender;

-(IBAction)torchMode:(id)sender;
-(IBAction)focusMode:(id)sender;
-(IBAction)lowLightMode:(id)sender;
-(IBAction)switchCamera:(id)sender;

-(IBAction)didTapPreview:(UIGestureRecognizer *)gestureRecognizer;

@end
