//
//  ViewController.m
//  MyVideoPlayer
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadStateChanged:) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showFilePicker"]) {
        NSMutableArray *videoArray = [NSMutableArray new];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSError *error = nil;
        
        NSArray *allFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
        
        if (error == nil) {
            
            for (NSString *file in allFiles) {
                NSString *fileExtension = [[file pathExtension] lowercaseString];
                
                if ([fileExtension isEqualToString:@"m4v"] || [fileExtension isEqualToString:@"mov"]) {
                    [videoArray addObject:file];
                }
            }
            
        } else {
            NSLog(@"error looking up files: %@", [error description]);
        }
        
        UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
        FileViewController *fileVC = (FileViewController *)navigationController.topViewController;
        fileVC.delegate = self;
        fileVC.fileArray = videoArray;
    }
}

#pragma mark - FileController delegate methods

-(void)cancel
{
    //Dismisses the file picker
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didFinishWithFile:(NSString *)filePath
{
    self.moviePlayer = nil;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *relativePath = [documentsDirectory stringByAppendingPathComponent:filePath];
    
    NSURL *fileURL = [NSURL fileURLWithPath:relativePath];
    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:fileURL];
    self.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    self.moviePlayer.allowsAirPlay = YES;
    self.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
    self.moviePlayer.controlStyle = MPMovieControlStyleEmbedded;
    
    self.moviePlayer.view.frame = self.playerView.bounds;
    [self.playerView addSubview:self.moviePlayer.view];
    
    [self.moviePlayer prepareToPlay];
    
    //Dismisses the file picker
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)playbackFinished:(NSNotification *) notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSNumber *finishReason = [userInfo objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    
    if ([finishReason integerValue] == MPMovieFinishReasonPlaybackError) {
        NSError *error = [userInfo objectForKey:@"error"];
        NSString *errorString = [error description];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
}

-(void)loadStateChanged:(NSNotification *) notification
{
    if (self.moviePlayer.loadState == MPMovieLoadStatePlayable) {
        [self.moviePlayer play];
    }
    
}

@end
