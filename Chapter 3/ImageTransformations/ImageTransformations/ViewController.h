//
//  ViewController.h
//  ImageTransformations
//
//  Created by Ahmed Bakir on 11/21/14.
//  Copyright (c) 2014 Ahmed Bakir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UIButton *resetButton;
@property (strong, nonatomic) IBOutlet UIButton *cropButton;
@property (strong, nonatomic) IBOutlet UIButton *shrinkButton;

@property (nonatomic, strong) UIImage *originalImage;


-(IBAction)reset:(id)sender;
-(IBAction)crop:(id)sender;
-(IBAction)shrink:(id)sender;

@end

