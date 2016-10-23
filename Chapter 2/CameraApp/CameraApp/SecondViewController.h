//
//  SecondViewController.h
//  CameraApp
//
//  Created by Ahmed Bakir on 5/5/14.
//  Copyright (c) 2014 devAtelier. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SecondViewControllerDelegate <NSObject>

-(void)secondViewController:(UIViewController *)controller hasImage:(UIImage *)image;

@optional
-(void)secondViewController:(UIViewController *)controller didCancel:(BOOL)state;

@end

@interface SecondViewController : UIViewController

@property (nonatomic, weak) id <SecondViewControllerDelegate> delegate;

@end
