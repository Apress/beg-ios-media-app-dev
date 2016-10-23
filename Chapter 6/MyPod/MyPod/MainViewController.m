//
//  ViewController.m
//  MyPod
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
    
    self.musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
    
    [self.musicPlayer beginGeneratingPlaybackNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"MPMusicPlayerControllerNowPlayingItemDidChangeNotification" object:self.musicPlayer queue:nil usingBlock:^(NSNotification *note) {
        
        MPMediaItem *currentItem = self.musicPlayer.nowPlayingItem;
        
        if (currentItem != nil) {
            MPMediaItemArtwork *albumArt = [currentItem valueForProperty:MPMediaItemPropertyArtwork];
            CGSize imageFrameSize = self.albumImageView.frame.size;
            UIImage *albumImage = [albumArt imageWithSize:imageFrameSize];
            self.albumImageView.image = albumImage;
            
            NSString *artistName = [currentItem valueForProperty:MPMediaItemPropertyArtist];
            NSString *albumName = [currentItem valueForProperty:MPMediaItemPropertyAlbumTitle];
            NSString *songTitle = [currentItem valueForProperty:MPMediaItemPropertyTitle];
            
            self.titleLabel.text = [NSString stringWithFormat:@"Now Playing: %@", songTitle];
            self.albumLabel.text = [NSString stringWithFormat:@"%@ / %@", artistName, albumName];
        }
    }];
    
    
    
    /*
     MPMediaQuery *pinkFloydQuery = [MPMediaQuery songsQuery];
     MPMediaPropertyPredicate *artistPredicate = [MPMediaPropertyPredicate 							predicateWithValue:@"Pink Floyd" forProperty:MPMediaItemPropertyArtist comparisonType:MPMediaPredicateComparisonEqualTo];
     [pinkFloydQuery addFilterPredicate:artistPredicate];
     
     [self.musicPlayer setQueueWithQuery:pinkFloydQuery];
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)togglePlayback:(id)sender
{
    if ([self.musicPlayer playbackState] == MPMusicPlaybackStatePlaying) {
        [self.musicPlayer pause];
        [self.playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    } else {
        [self.musicPlayer play];
        [self.playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    }
}

-(IBAction)chooseTrack:(id)sender
{
    NSMutableArray *items = [NSMutableArray new];
    
    MPMediaQuery *query = [MPMediaQuery songsQuery];
    
    for (MPMediaItem *item in query.items) {
        NSString *trackName = [item valueForProperty:MPMediaItemPropertyTitle];
        [items addObject:trackName];
    }
    
    MediaTableViewController *mediaTableVC = [[MediaTableViewController alloc] initWithItems:items withType:@"songs"];
    mediaTableVC.delegate = self;
    
    UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:mediaTableVC];
    
    [self presentViewController:navigationVC animated:YES completion:nil];
    
}

-(IBAction)chooseAlbum:(id)sender
{
    NSMutableArray *items = [NSMutableArray new];
    
    MPMediaQuery *query = [MPMediaQuery albumsQuery];
    
    for (MPMediaItem *item in query.items) {
        NSString *albumName = [item valueForProperty:MPMediaItemPropertyAlbumTitle];
        
        if (![items containsObject:albumName]) {
            [items addObject:albumName];
        }
    }
    
    MediaTableViewController *mediaTableVC = [[MediaTableViewController alloc] initWithItems:items withType:@"albums"];
    mediaTableVC.delegate = self;
    
    UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:mediaTableVC];
    
    [self presentViewController:navigationVC animated:YES completion:nil];
}

-(IBAction)startFastForward:(id)sender
{
    [self.musicPlayer beginSeekingForward];
}

-(IBAction)startRewind:(id)sender
{
    [self.musicPlayer beginSeekingBackward];
}

-(IBAction)seekForward:(id)sender
{
    if ([self.musicPlayer playbackState] == MPMusicPlaybackStatePlaying) {
        NSTimeInterval desiredTime = self.musicPlayer.currentPlaybackTime + 15.0f;
        if (desiredTime < self.musicPlayer.nowPlayingItem.playbackDuration) {
            self.musicPlayer.currentPlaybackTime = desiredTime;
        }
    }
}

-(IBAction)stopSeeking:(id)sender
{
    [self.musicPlayer endSeeking];
}

-(IBAction)nextTrack:(id)sender
{
    [self.musicPlayer skipToNextItem];
}

-(IBAction)prevTrack:(id)sender
{
    [self.musicPlayer skipToPreviousItem];
}

#pragma mark - MediaTableDelegate methods

-(void)didFinishWithItem:(NSString *)item andType:(NSString *)type
{
    
    if ([type isEqualToString:@"songs"]) {
        MPMediaQuery *query = [MPMediaQuery songsQuery];
        MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue:item forProperty:MPMediaItemPropertyTitle comparisonType:MPMediaPredicateComparisonEqualTo];
        [query addFilterPredicate:predicate];
        [self.musicPlayer setQueueWithQuery:query];
        
    } else if ([type isEqualToString:@"albums"]) {
        
        MPMediaQuery *query = [MPMediaQuery albumsQuery];
        MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue:item forProperty:MPMediaItemPropertyAlbumTitle comparisonType:MPMediaPredicateComparisonContains];
        [query addFilterPredicate:predicate];
        [self.musicPlayer setQueueWithQuery:query];
        
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self togglePlayback:nil];
}

-(void)didCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
