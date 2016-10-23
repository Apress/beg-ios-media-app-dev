//
//  ViewController.m
//  MyCustomVideoPlayer
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:@"customPlayerDidFinish" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadStateChanged:) name:@"customPlayerLoadStateChanged" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"customPlayerDidFinish" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"customPlayerLoadStateChanged" object:nil];
    
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
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *relativePath = [documentsDirectory stringByAppendingPathComponent:filePath];
    
    NSURL *fileURL = [NSURL fileURLWithPath:relativePath];
    self.moviePlayer = [[CustomPlayerController alloc] initWithContentURL:fileURL];
    
}

-(void)playbackFinished:(NSNotification *) notification
{
    
    NSDictionary *userInfo = notification.userInfo;
    NSString *finishReason = [userInfo objectForKey:@"reason"];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        if ([finishReason isEqualToString:@"error"]) {
            NSError *error = [userInfo objectForKey:@"error"];
            NSString *errorString = [error description];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
    }];
    
}

-(void)loadStateChanged:(NSNotification *) notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSString *status = [userInfo objectForKey:@"status"];
    
    if ([status isEqualToString:@"ready"]) {
        //dismiss the picker
        [self dismissViewControllerAnimated:YES completion:^{
            
            [self presentViewController:self.moviePlayer animated:NO
                             completion:^{
                                 [self.moviePlayer play];
                             }];
            
        }];
        
    } else {
        NSString *errorString = [userInfo objectForKey:@"error"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
}

@end
