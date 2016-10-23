//
//  ViewController.h
//  MyVideoRecorder
//
//  Created by Ahmed Bakir on 11/22/14.
//  Copyright (c) 2014 Ahmed Bakir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "FileViewController.h"

@interface MainViewController : UIViewController <FileControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) IBOutlet UIView *playerView;
@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
@property (nonatomic, strong) UIImagePickerController *videoRecorder;

-(IBAction)showImagePicker:(id)sender;

@end

