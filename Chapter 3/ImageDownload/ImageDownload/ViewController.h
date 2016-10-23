//
//  ViewController.h
//  ImageDownload
//
//  Created by Ahmed Bakir on 11/21/14.
//  Copyright (c) 2014 Ahmed Bakir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIButton* startButton;
@property (nonatomic, strong) IBOutlet UIImageView* imageView;
@property (nonatomic, strong) UIActivityIndicatorView* activityView;

-(IBAction)start:(id)sender;

@end

