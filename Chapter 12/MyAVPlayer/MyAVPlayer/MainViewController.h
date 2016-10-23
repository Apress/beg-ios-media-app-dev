//
//  ViewController.h
//  MyAVPlayer
//
//  Created by Ahmed Bakir on 9/27/14.
//  Copyright (c) 2014 Ahmed Bakir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "FileViewController.h"

@interface MainViewController : UIViewController <FileControllerDelegate>

@property (nonatomic, strong) IBOutlet UIView *playerViewContainer;
@property (nonatomic, strong) IBOutlet UIButton *chooseFileButton;
@property (nonatomic, strong) IBOutlet UIButton *playAllButton;
@property (nonatomic, strong) AVPlayerViewController *moviePlayer;

-(IBAction)playAll:(id)sender;

@end

