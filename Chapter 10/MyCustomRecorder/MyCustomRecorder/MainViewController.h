//
//  ViewController.h
//  MyCustomRecorder
//
//  Created by Ahmed Bakir on 11/22/14.
//  Copyright (c) 2014 Ahmed Bakir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "FileViewController.h"
#import "CameraViewController.h"

@interface MainViewController : UIViewController <FileControllerDelegate, UINavigationControllerDelegate, CameraDelegate>

@property (nonatomic, strong) IBOutlet UIView *playerView;
@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;

-(IBAction)showImagePicker:(id)sender;

@end

