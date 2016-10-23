//
//  ViewController.m
//  SystemSounds
//
//  Created by Ahmed Bakir on 11/22/14.
//  Copyright (c) 2014 Ahmed Bakir. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

SystemSoundID clickSoundId;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initializeSystemSound];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeSystemSound
{
    CFBundleRef mainBundle = CFBundleGetMainBundle();
    CFURLRef clickUrlRef = CFBundleCopyResourceURL(mainBundle, CFSTR("beep"), CFSTR("wav"), nil);
    
    AudioServicesCreateSystemSoundID (clickUrlRef, &clickSoundId);
    
}

-(IBAction)playSound:(id)sender
{
    AudioServicesPlaySystemSound(clickSoundId);
}

-(IBAction)playSoundAndVibrate:(id)sender
{
    AudioServicesPlayAlertSound(clickSoundId);
}


-(IBAction)vibrate:(id)sender
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}


@end
