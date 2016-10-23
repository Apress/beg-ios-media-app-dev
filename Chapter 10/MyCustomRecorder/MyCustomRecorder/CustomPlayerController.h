//
//  CustomPlayerController.h
//  MyCustomVideoPlayer
//
//  Created by Ahmed Bakir on 10/7/14.
//  Copyright (c) 2014 Ahmed Bakir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface CustomPlayerController : UIViewController

@property (nonatomic, strong) IBOutlet UIView *controlView;
@property (nonatomic, strong) IBOutlet UIButton *playbackButton;
@property (nonatomic, strong) IBOutlet UIButton *seekFwdButton;
@property (nonatomic, strong) IBOutlet UIButton *seekBackButton;
@property (nonatomic, strong) IBOutlet UIButton *doneButton;

@property (nonatomic, strong) IBOutlet UISlider *timeSlider;
@property (nonatomic, strong) IBOutlet UILabel *progressLabel;
@property (nonatomic, strong) IBOutlet UILabel *totalTimeLabel;
@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, strong) NSTimer *controlTimer;
@property (nonatomic, strong) NSTimer *updateTimer;

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;

@property (nonatomic, assign) BOOL controlsVisible;

-(IBAction)seekBackward:(id)sender;
-(IBAction)seekForward:(id)sender;
-(IBAction)sliderChanged:(UISlider *)sender;
-(IBAction)togglePlayback:(id)sender;
-(IBAction)done:(id)sender;

-(void)play;

-(id)initWithContentURL:(NSURL *)contentURL;

@end
