//
//  ViewController.m
//  ImageGradient
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
    
    UIColor *darkestColor = [UIColor colorWithWhite:0.1f alpha:0.7f];
    UIColor *lightestColor = [UIColor colorWithWhite:0.7f alpha:0.1f];
    
    CAGradientLayer *headerGradient = [CAGradientLayer layer];
    headerGradient.colors = [NSArray arrayWithObjects:(id)darkestColor.CGColor, (id)lightestColor.CGColor, (id)darkestColor.CGColor,  nil];
    
    headerGradient.frame = self.headerImageView.bounds;
    [self.headerImageView.layer insertSublayer:headerGradient atIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
