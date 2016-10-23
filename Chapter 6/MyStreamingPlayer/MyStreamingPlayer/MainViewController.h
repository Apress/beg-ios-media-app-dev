//
//  ViewController.h
//  MyStreamingPlayer
//
//  Created by Ahmed Bakir on 11/22/14.
//  Copyright (c) 2014 Ahmed Bakir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface MainViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) IBOutlet UIButton *chooseButton;
@property (nonatomic, strong) IBOutlet UIButton *playButton;

@property (nonatomic, strong) NSURL *selectedURL;

@property (nonatomic, strong) AVPlayer *audioPlayer;

-(IBAction)play:(id)sender;
-(IBAction)chooseStream:(id)sender;


@end

