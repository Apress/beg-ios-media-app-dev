//
//  ViewController.m
//  MyPlayer
//
//  Created by Ahmed Bakir on 11/21/14.
//  Copyright (c) 2014 Ahmed Bakir. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    if (error == nil) {
        NSLog(@"audio session initialized successfully");
    } else {
        NSLog(@"error initializing audio session: %@", [error description]);
    }
    
    MPVolumeView *volumeView = [ [MPVolumeView alloc] init] ;

    [volumeView setFrame:self.airPlayView.bounds];
    [self.airPlayView addSubview:volumeView];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    [self becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(caughtInterruption:) name:AVAudioSessionInterruptionNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routeChanged:) name:AVAudioSessionRouteChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(void)dealloc
{
    [self resignFirstResponder];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionInterruptionNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showFilePicker"]) {
        UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
        FileViewController *fileViewController = (FileViewController *)navigationController.topViewController;
        fileViewController.delegate = self;
    }
}

#pragma mark - file picker delegate methods

-(void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didFinishWithFile:(NSString *)filePath
{
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    self.selectedFilePath = filePath;
    
    NSString *relativeFilePath = [documentsDirectory stringByAppendingPathComponent:filePath];
    
    NSURL *fileURL = [NSURL fileURLWithPath:relativeFilePath];
    
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];
    self.audioPlayer.delegate = self;
    
    if (error == nil) {
        NSLog(@"audio player initialized successfully");
        
        self.titleLabel.text = self.selectedFilePath;
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
        
        NSString *songTitle = [filePath lastPathComponent];
        NSString *artistName = @"MyPlayer";
        MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"placeholder"]];
        
        MPNowPlayingInfoCenter *infoCenter = [MPNowPlayingInfoCenter defaultCenter];
        NSDictionary *infoDict = [NSDictionary dictionaryWithObjects:@[songTitle, artistName, albumArt] forKeys:@[MPMediaItemPropertyTitle, MPMediaItemPropertyAlbumArtist, MPMediaItemPropertyArtwork]];
        [infoCenter setNowPlayingInfo:infoDict];
        
        [self play:nil];
        
        
    } else {
        NSLog(@"error initializing audio player: %@", [error description]);
    }
    
    
    //dismiss the file picker
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)play:(id)sender
{
    if ([self.audioPlayer isPlaying]) {
        [self.audioPlayer pause];
        [self.playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [self.timer invalidate];
        
    } else {
        [self.audioPlayer play];
        [self.playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    }
    self.playbackInterrupted = NO;
}

-(IBAction)skipForward:(id)sender
{
    if ([self.audioPlayer isPlaying]) {
        NSTimeInterval desiredTime = self.audioPlayer.currentTime + 15.0f;
        if (desiredTime < self.audioPlayer.duration) {
            self.audioPlayer.currentTime = desiredTime;
        }
    }
}

-(IBAction)skipBackward:(id)sender
{
    if ([self.audioPlayer isPlaying]) {
        NSTimeInterval desiredTime = self.audioPlayer.currentTime - 15.0f;
        if (desiredTime < 0) {
            self.audioPlayer.currentTime = 0.0f;
        } else {
            self.audioPlayer.currentTime = desiredTime;
        }
        
    }
}

#pragma mark - Timer delegate

-(void)updateProgress
{
    NSInteger durationMinutes = [self.audioPlayer duration] / 60;
    NSInteger durationSeconds = [self.audioPlayer duration]  - durationMinutes * 60;
    
    NSInteger currentTimeMinutes = [self.audioPlayer currentTime] / 60;
    NSInteger currentTimeSeconds = [self.audioPlayer currentTime]  - currentTimeMinutes * 60;
    NSString *progressString = [NSString stringWithFormat:@"%d:%02d / %d:%02d", currentTimeMinutes, currentTimeSeconds, durationMinutes, durationSeconds];
    self.timeLabel.text = progressString;
    
    self.progressBar.progress = [self.audioPlayer currentTime] / [self.audioPlayer duration];
    
    NSNumber *numCurrentTimeSeconds = [NSNumber numberWithInt:currentTimeSeconds];
    NSNumber *numDurationSeconds = [NSNumber numberWithInt:durationSeconds];
    
    NSString *songTitle = [self.selectedFilePath lastPathComponent];
    NSString *artistName = @"MyPlayer";
    MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"placeholder"]];
    
    
    MPNowPlayingInfoCenter *infoCenter = [MPNowPlayingInfoCenter defaultCenter];
    NSDictionary *infoDict = [NSDictionary dictionaryWithObjects:@[songTitle, artistName, albumArt, numDurationSeconds, numCurrentTimeSeconds] forKeys:@[MPMediaItemPropertyTitle, MPMediaItemPropertyAlbumArtist, MPMediaItemPropertyArtwork, MPMediaItemPropertyPlaybackDuration, MPNowPlayingInfoPropertyElapsedPlaybackTime]];
    [infoCenter setNowPlayingInfo:infoDict];
    
}

#pragma mark - AVAudioPlayer delegate methods

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (flag) {
        [self.playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [self.timer invalidate];
    }
}

#pragma mark - Remote control

-(void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
        case UIEventSubtypeRemoteControlPause:
        case UIEventSubtypeRemoteControlTogglePlayPause:
            [self play:nil];
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            [self skipForward:nil];
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
            [self skipBackward:nil];
            break;
        default:
            break;
    }
}

#pragma mark - audio interruption

-(void)caughtInterruption:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    
    NSNumber *type =[userInfo objectForKey:AVAudioSessionInterruptionTypeKey];
    if ([type integerValue] == AVAudioSessionInterruptionTypeBegan) {
        if (self.audioPlayer.playing) {
            [self.audioPlayer pause];
            self.playbackInterrupted = YES;
        }
    } else {
        if (self.audioPlayer.playing == NO && self.playbackInterrupted == YES) {
            [self.audioPlayer play];
            self.playbackInterrupted = NO;
        }
    }
}

#pragma mark - route changed

-(void)routeChanged:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    
    NSNumber *reason =[userInfo objectForKey:AVAudioSessionRouteChangeReasonKey];
    switch ([reason integerValue]) {
        case AVAudioSessionRouteChangeReasonNoSuitableRouteForCategory:
            [self.audioPlayer stop];
            break;
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
        case AVAudioSessionRouteChangeReasonWakeFromSleep:
            [self.audioPlayer pause];
            break;
        default:
            break;
    }
    
}


@end
