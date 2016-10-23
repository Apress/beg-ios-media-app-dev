//
//  ViewController.m
//  ImageChanger
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
    
     self.isActive = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)changeImage:(id)sender
{
    if (self.isActive) {
        self.imageView.image = [UIImage imageNamed:@"alpaca-vision.png"];
    } else {
        self.imageView.image = [UIImage imageNamed:@"alpaca-plain.png"];
    }
    self.isActive = !self.isActive;
}

@end
