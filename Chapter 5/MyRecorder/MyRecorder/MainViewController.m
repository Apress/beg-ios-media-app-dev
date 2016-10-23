//
//  ViewController.m
//  MyRecorder
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)record:(id)sender
{
    
    if ([self.audioRecorder isRecording]) {
        
        [self.audioRecorder stop];
        [self.recordButton setImage:[UIImage imageNamed:@"mic"] forState:UIControlStateNormal];
        
        self.timeLabel.text = @"Recording status: stopped";
        
    } else {
        
        NSError *error;
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
        
        if (error == nil) {
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            
            NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"recording.wav"];
            NSInteger count = 0;
            
            
            while ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                NSString *fileName = [NSString stringWithFormat:@"recording-%ld", (long)count];
                filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
                count++;
            }
            
            NSURL *fileURL = [NSURL fileURLWithPath:filePath];
            
            NSMutableDictionary *settingsDict = [NSMutableDictionary new];
            [settingsDict setObject:[NSNumber numberWithInt:44100.0] forKey:AVSampleRateKey];
            [settingsDict setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
            [settingsDict setObject:[NSNumber numberWithInt:AVAudioQualityMedium] forKey:AVEncoderAudioQualityKey];
            [settingsDict setObject:[NSNumber numberWithInt:16] forKey:AVEncoderBitRateKey];
            
            
            self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:fileURL settings:settingsDict error:&error];
            
            if (error == nil) {
                
                [self.audioRecorder record];
                [self.recordButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
                self.timeLabel.text = @"Recording status: active";

            } else {
                NSLog(@"error initializing audio recorder: %@", [error description]);
            }
            
        } else {
            NSLog(@"error initializing audio session: %@", [error description]);
        }
    }
    
}

-(IBAction)play:(id)sender
{
    NSError *error = nil;
    
    if ([self.audioRecorder isRecording]) {
        [self.audioRecorder stop];
    }
    
    if ([self.audioPlayer isPlaying]) {
        
        [self.audioPlayer stop];
        [self.playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        
        self.timeLabel.text = @"Audio file: stopped";
        
    } else {
        
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[self.audioRecorder url] error:&error];
        self.audioPlayer.delegate = self;
        
        if (error == nil) {
            
            [self.audioPlayer play];
            [self.playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
            
            self.timeLabel.text = @"Audio file: playing";
            
        } else {
            NSLog(@"error initializing audio player: %@", [error description]);
        }
        
    }
}

-(IBAction)reset:(id)sender
{
    if ([self.audioRecorder isRecording]) {
        [self.audioRecorder stop];
    }
    
    [self.audioRecorder deleteRecording];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    // set finish image
    [self.playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    
    self.timeLabel.text = @"Audio file: stopped";
}


@end
