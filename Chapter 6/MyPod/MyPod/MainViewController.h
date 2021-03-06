//
//  ViewController.h
//  MyPod
//
//  Created by Ahmed Bakir on 11/22/14.
//  Copyright (c) 2014 Ahmed Bakir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "MediaTableViewController.h"

@interface MainViewController : UIViewController <MediaTableDelegate>

@property (nonatomic, strong) MPMusicPlayerController *musicPlayer;

@property (nonatomic, strong) IBOutlet UIButton *playButton;
@property (nonatomic, strong) IBOutlet UIButton *rewindButton;
@property (nonatomic, strong) IBOutlet UIButton *forwardButton;
@property (nonatomic, strong) IBOutlet UIButton *prevButton;
@property (nonatomic, strong) IBOutlet UIButton *nextButton;

@property (nonatomic, strong) IBOutlet UIButton *chooseTrackButton;
@property (nonatomic, strong) IBOutlet UIButton *chooseAlbumButton;

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *albumLabel;
@property (nonatomic, strong) IBOutlet UIImageView *albumImageView;

-(IBAction)togglePlayback:(id)sender;
-(IBAction)nextTrack:(id)sender;
-(IBAction)prevTrack:(id)sender;

-(IBAction)seekForward:(id)sender;
-(IBAction)startFastForward:(id)sender;
-(IBAction)startRewind:(id)sender;
-(IBAction)stopSeeking:(id)sender;

-(IBAction)chooseTrack:(id)sender;
-(IBAction)chooseAlbum:(id)sender;

@end

