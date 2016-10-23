//
//  ViewController.h
//  MyPlayer
//
//  Created by Ahmed Bakir on 11/21/14.
//  Copyright (c) 2014 Ahmed Bakir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "FileViewController.h"

@interface MainViewController : UIViewController <FileControllerDelegate, AVAudioPlayerDelegate>

@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) IBOutlet UIButton *chooseButton;
@property (nonatomic, strong) IBOutlet UIButton *playButton;
@property (nonatomic, strong) IBOutlet UIButton *skipForwardButton;
@property (nonatomic, strong) IBOutlet UIButton *skipBackwardButton;

@property (nonatomic, strong) IBOutlet UIProgressView *progressBar;

@property (nonatomic, strong) NSString *selectedFilePath;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) BOOL playbackInterrupted;
@property (nonatomic, strong) IBOutlet UIView *airPlayView;

-(IBAction)play:(id)sender;
-(IBAction)skipForward:(id)sender;
-(IBAction)skipBackward:(id)sender;


@end

