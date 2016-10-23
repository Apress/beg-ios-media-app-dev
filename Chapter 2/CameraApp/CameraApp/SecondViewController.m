//
//  SecondViewController.m
//  CameraApp
//
//  Created by Ahmed Bakir on 5/5/14.
//  Copyright (c) 2014 devAtelier. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@property (nonatomic, strong) UIImage *capturedImage;

@end

@implementation SecondViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action handlers

-(IBAction)takePictureButtonPressed:(id)sender
{
    [self.delegate secondViewController:self hasImage:self.capturedImage];
}

-(IBAction)cancelButtonPressed:(id)sender
{
    [self.delegate secondViewController:self didCancel:YES];
}

@end
