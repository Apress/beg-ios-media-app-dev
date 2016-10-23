//
//  ViewController.m
//  QuickLookSample
//
//  Created by Ahmed Bakir on 10/18/14.
//  Copyright (c) 2014 Ahmed Bakir. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.sampleString = @"Hello";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeValue:(id)sender
{
    UIImage *coolImage = [UIImage imageNamed:@"logo.jpg"];
    
    NSString *newString = @"Our newest string ever";
    
    CustomPhoto *samplePhoto = [[CustomPhoto alloc] init];
    
    samplePhoto.title = @"This is the coolest image";
    
    samplePhoto.image = coolImage;
    
    self.sampleString = newString;
}

@end
