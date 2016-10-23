//
//  ViewController.m
//  MyCamera
//
//  Created by Ahmed Bakir on 11/21/14.
//  Copyright (c) 2014 Ahmed Bakir. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"presentCameraSegue"]) {
        CameraViewController *cameraViewController = (CameraViewController *)segue.destinationViewController;
        cameraViewController.delegate = self;
    }
}

#pragma mark - camera delegate methods

-(void)cancel
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)didFinishWithImage:(UIImage *)image
{
    self.imageView.image = image;
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
