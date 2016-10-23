//
//  ViewController.h
//  MyCamera
//
//  Created by Ahmed Bakir on 11/21/14.
//  Copyright (c) 2014 Ahmed Bakir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraViewController.h"

@interface ViewController : UIViewController <CameraDelegate>

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIButton *button;

@end

