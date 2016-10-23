//
//  ViewController.m
//  ImageTilt
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
    
    UIInterpolatingMotionEffect *horizontalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    UIInterpolatingMotionEffect *verticalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    
    horizontalEffect.minimumRelativeValue  = [NSNumber numberWithInteger:-50];
    horizontalEffect.maximumRelativeValue  = [NSNumber numberWithInteger:50];
    
    verticalEffect.minimumRelativeValue  = [NSNumber numberWithInteger:-50];
    verticalEffect.maximumRelativeValue  = [NSNumber numberWithInteger:50];
    
    //set bg image effects
    [self.backgroundImageView addMotionEffect:horizontalEffect];
    [self.backgroundImageView addMotionEffect:verticalEffect];
    
    //set bg image
    [self.backgroundImageView setImage:[UIImage imageNamed:@"cn-tower.jpg"]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
