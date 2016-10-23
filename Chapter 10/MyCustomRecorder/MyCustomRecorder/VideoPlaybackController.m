//
//  VideoPlaybackController.m
//  MyCustomRecorder
//
//  Created by Ahmed Bakir on 9/22/14.
//  Copyright (c) 2014 Ahmed Bakir. All rights reserved.
//

#import "VideoPlaybackController.h"

@implementation VideoPlaybackController

-(id)initWithContentURL:(NSURL *)contentURL
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    VideoPlaybackController *myViewController = [storyboard instantiateViewControllerWithIdentifier:@"VideoPlaybackController"];
    
    self = myViewController;
    if (self) {
        
        self.playerItem = [[AVPlayerItem alloc] initWithURL:contentURL];
        self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
        [self.player addObserver:self forKeyPath:@"status" options:0 context:nil];
        
        self.isPlaying = NO;
    }
    return self;
}

-(IBAction)togglePlayback:(id)sender
{
    if (self.isPlaying) {
        [self.player pause];
        
        [self.playbackButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        
        [self.updateTimer invalidate];
        
        
    } else {
        [self.player play];
        
        [self.playbackButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        
        self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    }
    self.isPlaying = !self.isPlaying;
}


-(IBAction)accept:(id)sender
{
    [self.player pause];
    
    [self dismissViewControllerAnimated:NO
                             completion:^{
                                 [self.delegate didFinishWithSuccess:YES];
                             }];
}

-(IBAction)reject:(id)sender
{
    [self.player pause];
    
    [self dismissViewControllerAnimated:NO
                            completion:^{
                                 [self.delegate didFinishWithSuccess:NO];
                             }];
}

-(void)prepareToPlay
{
    [self togglePlayback:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.player && [keyPath isEqualToString:@"status"]) {
        
        if (self.player.status == AVPlayerStatusReadyToPlay) {
            
            AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
            playerLayer.frame = self.view.bounds;
            playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
            //playerLayer.needsDisplayOnBoundsChange =
            [self.view.layer addSublayer:playerLayer];
            
            playerLayer.needsDisplayOnBoundsChange = YES;
            self.view.layer.needsDisplayOnBoundsChange = YES;
            
            [self.view bringSubviewToFront:self.buttonBar];
            [self.view bringSubviewToFront:self.controlBar];
            
            
            NSDictionary *userDict = [NSDictionary dictionaryWithObject:@"ready" forKey:@"status"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"customPlayerLoadStateChanged" object:self userInfo:userDict];
            
        } else {
            NSDictionary *userDict = [NSDictionary dictionaryWithObjects:@[@"error", @"Unable to load file"] forKeys:@[ @"status", @"reason"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"customPlayerLoadStateChanged" object:self userInfo:userDict];
        }
        
        [self.player removeObserver:self forKeyPath:@"status"];
    }
}

-(void)updateProgress
{
    
    NSInteger currentTimeMinutes = CMTimeGetSeconds([self.playerItem currentTime]) / 60;
    NSInteger currentTimeSeconds = CMTimeGetSeconds([self.playerItem currentTime])  - currentTimeMinutes * 60;
    
    self.timeSlider.value = CMTimeGetSeconds([self.playerItem currentTime])/CMTimeGetSeconds([self.playerItem duration]) + 0.0f;
    
    self.progressLabel.text = [NSString stringWithFormat:@"0:%02ld:%02ld", currentTimeMinutes, currentTimeSeconds];
    
}

@end
