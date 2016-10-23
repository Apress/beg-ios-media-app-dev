//
//  ViewController.m
//  MyAVPlayer
//
//  Created by Ahmed Bakir on 9/27/14.
//  Copyright (c) 2014 Ahmed Bakir. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"setPlayerContent"]) {
        AVPlayerViewController *playerVC = (AVPlayerViewController *) segue.destinationViewController;
        self.moviePlayer = playerVC;
        
    } else if ([segue.identifier isEqualToString:@"showFilePicker"]) {
        NSMutableArray *videoArray = [NSMutableArray new];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSError *error = nil;
        
        NSArray *allFiles = [[NSFileManager defaultManager]	contentsOfDirectoryAtPath:documentsDirectory error:&error];
        
        if (error == nil) {
            
            for (NSString *file in allFiles) {
                
                NSString *fileExtention = [[file pathExtension] lowercaseString];
                
                if ([fileExtention isEqualToString:@"mp4"] || [fileExtention isEqualToString:@"mov"]) {
                    [videoArray addObject:file];
                }
            }
            
        } else {
            NSLog(@"error looking up files: %@", [error description]);
        }
        
        UINavigationController *navigationController = (UINavigationController *) segue.destinationViewController;
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
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *relativePath = [documentsDirectory stringByAppendingPathComponent:filePath];
    
    NSURL *fileURL = [NSURL fileURLWithPath:relativePath];
    
    self.moviePlayer.player = [AVPlayer playerWithURL:fileURL];
    [self.moviePlayer.player addObserver:self forKeyPath:@"status" options:0 context:nil];

    
    [self dismissViewControllerAnimated:YES completion:^{

        [self.moviePlayer.player play];
    }];
    
}

-(IBAction)playAll:(id)sender
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSError *error = nil;
    
    NSArray *allFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    
    NSMutableArray *playerItemArray = [NSMutableArray new];
    
    for (NSString *file in allFiles) {
        
        NSString *fileExtention = [[file pathExtension] lowercaseString];
        
        if ([fileExtention isEqualToString:@"mp4"] || [fileExtention isEqualToString:@"mov"]) {
            
            NSString *relativePath = [documentsDirectory stringByAppendingPathComponent:file];
            
            NSURL *fileURL = [NSURL fileURLWithPath:relativePath];
            
            AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:fileURL];
            
            [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
            
            [playerItemArray addObject:playerItem];
        }
        
    }
    
    self.moviePlayer.player = [[AVQueuePlayer alloc] initWithItems:playerItemArray];

    [self.moviePlayer.player addObserver:self forKeyPath:@"status" options:0 context:nil];
    
    [self.moviePlayer.player play];

}

    

-(void)playbackFinished:(NSNotification *) notification
{
    NSDictionary *userInfo = notification.userInfo;

    if ([self.moviePlayer.player isKindOfClass:[AVPlayer class]]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        //do nothing
    }
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ((object == self.moviePlayer.player) && [keyPath isEqualToString:@"status"] ) {
        
        UIImage *image = [UIImage imageNamed:@"logo.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = self.moviePlayer.videoBounds;
        imageView.contentMode = UIViewContentModeBottomRight;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight |					     UIViewAutoresizingFlexibleWidth;
        
        if ([self.moviePlayer.contentOverlayView.subviews count] == 0) {
            [self.moviePlayer.contentOverlayView addSubview:imageView];
        }
        
        [object removeObserver:self forKeyPath:@"status"];
        
    } else if ([object isKindOfClass:[AVPlayerItem class]]) {
        
        AVPlayerItem *currentItem = (AVPlayerItem *)object;
        
        if (currentItem.status == AVPlayerItemStatusFailed) {
            NSString *errorString = [currentItem.error description];
            NSLog(@"item failed: %@", errorString);
            
            if ([self.moviePlayer.player isKindOfClass:[AVQueuePlayer class]]) {
                AVQueuePlayer *queuePlayer = (AVQueuePlayer *)self.moviePlayer.player;
                [queuePlayer advanceToNextItem];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        } else {
            [object removeObserver:self forKeyPath:@"status"];
        }
    }
}


@end
