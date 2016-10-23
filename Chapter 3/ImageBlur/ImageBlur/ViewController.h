//
//  ViewController.h
//  ImageBlur
//
//  Created by Ahmed Bakir on 11/21/14.
//  Copyright (c) 2014 Ahmed Bakir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+ImageEffects.h"

@interface ViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImage *originalImage;

-(IBAction)blurDark:(id)sender;
-(IBAction)blurLight:(id)sender;
-(IBAction)reset:(id)sender;

@end

