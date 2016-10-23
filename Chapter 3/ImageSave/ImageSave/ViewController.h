//
//  ViewController.h
//  ImageSave
//
//  Created by Ahmed Bakir on 11/21/14.
//  Copyright (c) 2014 Ahmed Bakir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) UIImage *originalImage;

-(IBAction)saveToDisk:(id)sender;
-(IBAction)saveToAlbum:(id)sender;

@end

