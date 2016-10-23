//
//  ViewController.m
//  ImageTransformations
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
    
    self.originalImage = [UIImage imageNamed:@"buster.jpg"];
    [self.imageView setImage:self.originalImage];
    self.statusLabel.text = @"Effect: None";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)reset:(id)sender
{
    [self.imageView setImage:self.originalImage];
    self.statusLabel.text = @"Effect: None";
}

-(IBAction)crop:(id)sender
{
    UIImage *resizedImage = nil;
    CGSize originalImageSize = self.originalImage.size;
    CGSize targetImageSize = CGSizeMake(150.0f, 150.0f);
    float scaleFactor, tempImageHeight, tempImageWidth;
    CGRect croppingRect;
    
    BOOL favorsX = NO;
    
    if (originalImageSize.width > originalImageSize.height) {
        scaleFactor = targetImageSize.height / originalImageSize.height;
        favorsX = YES;
    } else {
        scaleFactor = targetImageSize.width / originalImageSize.width;
        favorsX = NO;
    }
    
    tempImageHeight = originalImageSize.height * scaleFactor;
    tempImageWidth = originalImageSize.width * scaleFactor;
    
    if (favorsX) {
        float delta = (tempImageWidth - targetImageSize.width) / 2;
        croppingRect = CGRectMake(-1.0f * delta, 0, tempImageWidth, tempImageHeight);
    } else {
        float delta = (tempImageHeight - targetImageSize.height) / 2;
        croppingRect = CGRectMake(0, -1.0f * delta, tempImageWidth, tempImageHeight);
    }
    
    UIGraphicsBeginImageContext(targetImageSize);
    
    [self.originalImage drawInRect:croppingRect];
    
    resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    [self.imageView setImage:resizedImage];
    
    self.statusLabel.text = @"Effect: Crop";
    
}

-(IBAction)shrink:(id)sender
{
    UIImage *resizedImage = nil;
    
    CGSize originalImageSize = self.originalImage.size;
    float targetHeight = 150.0f;
    float scaleFactor = targetHeight / originalImageSize.height;
    float targetWidth = originalImageSize.width * scaleFactor;
    
    CGRect targetFrame = CGRectMake(0, 0, targetWidth, targetHeight);
    
    UIGraphicsBeginImageContext(targetFrame.size);
    
    [self.originalImage drawInRect:targetFrame];
    
    resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    [self.imageView setImage:resizedImage];
    
    self.statusLabel.text = @"Effect: Shrink";
}

@end
