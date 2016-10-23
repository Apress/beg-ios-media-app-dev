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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *relativeFilePath = [documentsDirectory stringByAppendingPathComponent:filePath];
    
    self.selectedFilePath = filePath;
    
    NSError *error = nil;
    NSURL *fileURL = [NSURL fileURLWithPath:relativeFilePath];
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];
    self.audioPlayer.delegate = self;
    
    if (error == nil) {
        NSLog(@"audio player initialized successfully");
        
        self.titleLabel.text = self.selectedFilePath;
        
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
        self.playButton.imageView.image = [UIImage imageNamed:@"play"];
        [self.timer invalidate];
        
    } else {
        [self.audioPlayer play];
        self.playButton.imageView.image = [UIImage imageNamed:@"pause"];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    }
    
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
    
}

#pragma mark - AVAudioPlayer delegate methods

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (flag) {
        self.playButton.imageView.image = [UIImage imageNamed:@"play"];
        [self.timer invalidate];
        
    }
}


@end
