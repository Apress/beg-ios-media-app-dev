//
//  CustomPlayerController.m
//  MyCustomVideoPlayer
//
//  Created by Ahmed Bakir on 10/7/14.
//  Copyright (c) 2014 Ahmed Bakir. All rights reserved.
//

#import "CustomPlayerController.h"

@interface CustomPlayerController ()

@end

@implementation CustomPlayerController

-(id)initWithContentURL:(NSURL *)contentURL
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CustomPlayerController *myViewController = [storyboard instantiateViewControllerWithIdentifier:@"CustomPlayerController"];
    
    self = myViewController;
    if (self) {
        
        self.playerItem = [[AVPlayerItem alloc] initWithURL:contentURL];
        self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
        [self.player addObserver:self forKeyPath:@"status" options:0 context:nil];

        self.isPlaying = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)togglePlayback:(id)sender
{
    if (self.isPlaying) {
        [self.player pause];
        
        [self.playbackButton setTitle:@"Play" forState:UIControlStateNormal];
        
        [self showControls:nil];
        
        [self.updateTimer invalidate];


    } else {
        [self.player play];
        
        [self.playbackButton setTitle:@"Pause" forState:UIControlStateNormal];
        
        self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    }
    self.isPlaying = !self.isPlaying;
}


-(IBAction)sliderChanged:(UISlider *)sender
{
    float progress = sender.value;
    NSInteger durationSeconds = CMTimeGetSeconds([self.playerItem duration]);
    float result = durationSeconds * progress;
    CMTime seekTime = CMTimeMakeWithSeconds(result, 1);
    
    
    [self.player seekToTime:seekTime];
    
}

-(IBAction)seekForward:(id)sender
{
    NSInteger duration = CMTimeGetSeconds([self.playerItem duration]);
    NSInteger currentTime = CMTimeGetSeconds([self.playerItem currentTime]);
    
    float desiredTime = currentTime + 5;
    if (desiredTime < duration) {
        CMTime seekTime = CMTimeMakeWithSeconds(desiredTime, 1);
        [self.player seekToTime:seekTime];
        
        [self updateProgress];
    }
}

-(IBAction)seekBackward:(id)sender
{
    NSInteger currentTime = CMTimeGetSeconds([self.playerItem currentTime]);
    
    float desiredTime = currentTime - 5;
    
    if (desiredTime < 0) {
        CMTime seekTime = CMTimeMakeWithSeconds(0.0f, 1);
        [self.player seekToTime:seekTime];
    } else {
        CMTime seekTime = CMTimeMakeWithSeconds(desiredTime, 1);
        [self.player seekToTime:seekTime];
    }
    
    [self updateProgress];
}

-(IBAction)done:(id)sender
{
    NSDictionary *userDict = [NSDictionary dictionaryWithObject:@"user finished" forKey:@"reason"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"customPlayerDidFinish" object:userDict];
    //[self.delegate done];
}


-(void)play
{
    [self togglePlayback:nil];
}

-(void)updateProgress
{
    
    NSInteger durationMinutes = CMTimeGetSeconds([self.playerItem duration]) / 60;
    NSInteger durationSeconds = CMTimeGetSeconds([self.playerItem duration])  - durationMinutes * 60;
    
    NSInteger currentTimeMinutes = CMTimeGetSeconds([self.playerItem currentTime]) / 60;
    NSInteger currentTimeSeconds = CMTimeGetSeconds([self.playerItem currentTime])  - currentTimeMinutes * 60;
    
    self.timeSlider.value = CMTimeGetSeconds([self.playerItem currentTime])/CMTimeGetSeconds([self.playerItem duration]) + 0.0f;
    
    self.progressLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", currentTimeMinutes, currentTimeSeconds];
    self.totalTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", durationMinutes, durationSeconds];
    
}

-(IBAction)hideControls:(id)sender
{
    if (self.controlsVisible) {
        [self.view sendSubviewToBack:self.controlView];
        self.controlView.userInteractionEnabled = NO;
        
        self.controlsVisible = NO;
    } else {
        [self showControls:nil];
    }
}

-(IBAction)showControls:(id)sender
{
    if (self.controlTimer != nil)
        [self.controlTimer invalidate];
    
    [self.view bringSubviewToFront:self.controlView];
    self.controlView.userInteractionEnabled = YES;
    
    self.controlTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(hideControls:) userInfo:nil repeats:NO];
    
    self.controlsVisible = YES;
    
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
            
            [self showControls:nil];
            self.controlTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(hideControls:) userInfo:nil repeats:NO];
            
            
            NSDictionary *userDict = [NSDictionary dictionaryWithObject:@"ready" forKey:@"status"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"customPlayerLoadStateChanged" object:self userInfo:userDict];
            
        } else {
            NSDictionary *userDict = [NSDictionary dictionaryWithObjects:@[@"error", @"Unable to load file"] forKeys:@[ @"status", @"reason"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"customPlayerLoadStateChanged" object:self userInfo:userDict];
        }
        
        [self.player removeObserver:self forKeyPath:@"status"];
    }
}


@end
