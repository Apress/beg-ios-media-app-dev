//
//  ViewController.m
//  MyStreamingPlayer
//
//  Created by Ahmed Bakir on 11/22/14.
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

-(IBAction)chooseStream:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Enter streaming URL" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alertView show];
}

-(IBAction)play:(id)sender
{
    //make sure audio player is "ready"
    if (self.audioPlayer.error != nil && [self.audioPlayer status] != AVPlayerStatusReadyToPlay) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[self.audioPlayer.error description] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        
        //check if audio player is playing
        if (self.audioPlayer.rate > 0.0f) {
            [self.audioPlayer pause];
            [self.playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        } else {
            [self.audioPlayer play];
            [self.playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - AlertView delegate

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *selectedUrlString = [alertView textFieldAtIndex:0].text;
        NSString *pathExtension = [[selectedUrlString pathExtension] lowercaseString];
        
        NSURL *url = [NSURL URLWithString:selectedUrlString];
        //make sure url
        if (url != nil && [pathExtension isEqualToString:@"pls"]) {
            
            self.selectedURL = [NSURL URLWithString:selectedUrlString];
            self.titleLabel.text = selectedUrlString;
            self.audioPlayer = [[AVPlayer alloc] initWithURL:self.selectedURL];
        } else {
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a valid streaming URL" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [errorAlert show];
        }
        
    }
}

#pragma mark - AVAudioPlayer delegate methods

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (flag) {
        [self.playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
}

@end
