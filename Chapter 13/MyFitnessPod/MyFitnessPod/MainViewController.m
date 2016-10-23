//
//  ViewController.m
//  MyFitnessPod
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
    
    self.isWorkoutActive = NO;
    
    if ([HKHealthStore isHealthDataAvailable]) {
        NSSet *dataTypes = [NSSet setWithObject:HKQuantityTypeIdentifierStepCount];
        
        [self.healthStore requestAuthorizationToShareTypes:dataTypes readTypes:dataTypes completion:^(BOOL success, NSError *error) {
            if (success) {
                [self updateTotalStepCount];
                
                HKQuantityType *quantityType = [HKQuantityType quantityTypeForIdentifier:				 HKQuantityTypeIdentifierStepCount];
                
                self.observerQuery = [[HKObserverQuery alloc] initWithSampleType:quantityType predicate:nil updateHandler:^(HKObserverQuery *query, HKObserverQueryCompletionHandler completionHandler, NSError *error) {
                    if (!error) {
                        [self updateTotalStepCount];
                    }
                }];
                
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"MyFitnessPod requires step count access for total progress!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            
        }];
        
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.isWorkoutActive)  {//isactive
        [self.pedometer queryPedometerDataFromDate:self.startDate toDate:[NSDate date] withHandler:^(CMPedometerData *pedometerData, NSError *error) {
            
            NSLog(@"number of steps: %ld", [pedometerData.numberOfSteps integerValue]);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.workoutProgressLabel.text = [NSString stringWithFormat:@"%ld steps", [pedometerData.numberOfSteps integerValue]];
            });
        }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [self.healthStore stopQuery:self.observerQuery];
}

-(void)updateTotalStepCount
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDate *startDate = [calendar dateBySettingHour:0 minute:0 second:0 ofDate:now options:0];
    NSDate *endDate = [calendar dateBySettingHour:0 minute:0 second:0 ofDate:now options:0];
    NSPredicate *datePredicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:0];
    
    HKUnit *countUnit = [HKUnit unitFromString:@"count"];
    
    HKQuantityType *quantityType = [HKQuantityType quantityTypeForIdentifier:				 HKQuantityTypeIdentifierStepCount];
    
    HKStatisticsQuery *statisticsQuery = [[HKStatisticsQuery alloc] initWithQuantityType:quantityType quantitySamplePredicate:datePredicate options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
        
        HKQuantity *sumQuantity = result.sumQuantity;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.dailyProgressLabel.text = [NSString stringWithFormat:@"%f steps", [sumQuantity doubleValueForUnit:countUnit]];
        });
        
    }];
    [self.healthStore executeQuery:statisticsQuery];
}

-(IBAction)toggleWorkout:(id)sender
{
    if (self.isWorkoutActive) {
        //stop workout
        
        if (self.pedometer != nil) {
            [self.pedometer stopPedometerUpdates];
            
        }
        
        [self togglePlayback:nil];
        
        self.isWorkoutActive = NO;
        
        [self.workoutButton setTitle:@"Start Workout" forState:UIControlStateNormal];
        self.workoutButton.backgroundColor = [UIColor colorWithRed:29.0f/255.0f green:104.0f/255.0f blue:228.0f/255.0f alpha:1.0f];
        
        __block double stepCount = 0;
        [self.pedometer queryPedometerDataFromDate:self.startDate toDate:[NSDate date] withHandler:^(CMPedometerData *pedometerData, NSError *error) {
            
            NSLog(@"number of steps: %ld", [pedometerData.numberOfSteps integerValue]);
            dispatch_async(dispatch_get_main_queue(), ^{
                stepCount = [pedometerData.numberOfSteps doubleValue];
                
                HKUnit *countUnit = [HKUnit unitFromString:@"count"];
                HKQuantity *stepQuantity = [HKQuantity quantityWithUnit:countUnit doubleValue:stepCount];
                HKQuantityType *quantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
                HKQuantitySample *exerciseSample = [HKQuantitySample quantitySampleWithType:quantityType quantity:stepQuantity startDate:self.startDate endDate:[NSDate date]];
                
                [self.healthStore saveObject:exerciseSample  withCompletion:^(BOOL success, NSError *error){
                    if (success) {
                        [self updateTotalStepCount];
                    } else {
                        NSLog(@"error saving steps");
                    }
                }];
                
                
            });
        }];
        
        
    } else {
        //start workout
        
        if ([CMMotionActivityManager isActivityAvailable] && [CMPedometer isStepCountingAvailable]) {
            self.pedometer = [[CMPedometer alloc] init];
            
            self.isWorkoutActive = YES;
            self.startDate = [NSDate date];
            
            self.workoutProgressLabel.text = @"0 steps";
            [self.workoutButton setTitle:@"Stop Workout" forState:UIControlStateNormal];
            self.workoutButton.backgroundColor = [UIColor redColor];
            
            [self.pedometer startPedometerUpdatesFromDate:self.startDate withHandler:^(CMPedometerData *pedometerData, NSError *error) {
                
                NSLog(@"number of steps: %ld", [pedometerData.numberOfSteps integerValue]);
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.workoutProgressLabel.text = [NSString stringWithFormat:@"%ld steps", [pedometerData.numberOfSteps integerValue]];
                });
            }];
            
            [self togglePlayback:nil];
            
        } else {
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Motion permission required" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [errorAlert show];
        }
    }
    
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
}

-(void)didCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
