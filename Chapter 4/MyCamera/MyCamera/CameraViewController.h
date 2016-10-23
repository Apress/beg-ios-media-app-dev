//
//  CameraViewController.h
//  MyCamera
//
//  Created by Ahmed Bakir on 11/21/14.
//  Copyright (c) 2014 Ahmed Bakir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol CameraDelegate <NSObject>

-(void)cancel;
-(void)didFinishWithImage:(UIImage *)image;

@end

@interface CameraViewController : UIViewController <UIActionSheetDelegate>

@property (nonatomic, strong) IBOutlet UIView *previewView;
@property (nonatomic, strong) IBOutlet UIButton *cancelButton;
@property (nonatomic, strong) IBOutlet UIButton *pictureButton;

@property (nonatomic, strong) IBOutlet UIButton *flashButton;
@property (nonatomic, strong) IBOutlet UIButton *focusButton;
@property (nonatomic, strong) IBOutlet UIButton *cameraButton;
@property (nonatomic, strong) IBOutlet UIButton *exposureButton;

@property (nonatomic, strong) IBOutlet UILabel *tapPosition;


@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;

@property (nonatomic, strong) id <CameraDelegate> delegate;

-(IBAction)cancel:(id)sender;
-(IBAction)finish:(id)sender;

-(IBAction)flashMode:(id)sender;
-(IBAction)focusMode:(id)sender;
-(IBAction)exposureMode:(id)sender;
-(IBAction)switchCamera:(id)sender;

-(IBAction)didTapPreview:(UIGestureRecognizer *)gestureRecognizer;

@end
