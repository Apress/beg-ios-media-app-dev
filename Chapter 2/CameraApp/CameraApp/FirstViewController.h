//
//  ViewController.h
//  CameraApp
//
//  Created by Ahmed Bakir on 11/21/14.
//  Copyright (c) 2014 Ahmed Bakir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondViewController.h"

@interface FirstViewController : UIViewController  <UIActionSheetDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIButton *actionButton;
@property (nonatomic, strong) UIPopoverController *popover;

@property (nonatomic, strong) UIImage *selectedImage;

@end

