//
//  ViewController.h
//  SystemSounds
//
//  Created by Ahmed Bakir on 11/22/14.
//  Copyright (c) 2014 Ahmed Bakir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface ViewController : UIViewController

-(IBAction)playSound:(id)sender;
-(IBAction)playSoundAndVibrate:(id)sender;
-(IBAction)vibrate:(id)sender;

@end

