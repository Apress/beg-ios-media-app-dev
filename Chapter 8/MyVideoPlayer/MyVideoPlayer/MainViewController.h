//
//  ViewController.h
//  MyVideoPlayer
//
//  Created by Ahmed Bakir on 11/22/14.
//  Copyright (c) 2014 Ahmed Bakir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "FileViewController.h"

@interface MainViewController : UIViewController <FileControllerDelegate>

@property (nonatomic, strong) IBOutlet UIView *playerView;
@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;

@end

