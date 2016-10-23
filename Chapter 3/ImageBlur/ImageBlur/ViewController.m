//
//  ViewController.m
//  ImageBlur
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
    
    self.originalImage = [UIImage imageNamed:@"cn-tower.jpg"];
    [self.backgroundImageView setImage:self.originalImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)blurDark:(id)sender
{
    UIImage *blurredImage = [self.originalImage applyDarkEffect];
    
    [self.backgroundImageView setImage:blurredImage];
}

-(IBAction)blurLight:(id)sender
{
    UIImage *blurredImage = [self.originalImage applyLightEffect];
    
    [self.backgroundImageView setImage:blurredImage];
}

-(IBAction)reset:(id)sender
{
    [self.backgroundImageView setImage:self.originalImage];
}

@end
