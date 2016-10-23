//
//  ViewController.m
//  ImageDownload
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
    
    //calculate the mid-way point of the image view
    CGFloat indicatorWidth, indicatorHeight;
    indicatorWidth = indicatorHeight = 100.0f;
    
    CGFloat originX = (self.imageView.frame.size.width - indicatorWidth) / 2;
    CGFloat originY = (self.imageView.frame.size.height - indicatorHeight) / 2;
    
    CGRect activityFrame = CGRectMake(originX, originY, indicatorWidth, indicatorHeight);
    
    self.activityView = [[UIActivityIndicatorView alloc] initWithFrame:activityFrame];
    self.activityView.color = [UIColor blackColor];
    [self.imageView addSubview:self.activityView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)start:(id)sender
{
    NSURL *imageUrl = [NSURL URLWithString:@"http://nightmedia.net/gallery/Macworld/20130203/D8C_3522.JPG"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:imageUrl];
    
    [self.imageView setImage:nil];
    [self.imageView bringSubviewToFront:self.activityView];
    [self.activityView startAnimating];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        [self.activityView stopAnimating];
        
        if (connectionError == nil) {
            
            UIImage *newImage = [UIImage imageWithData:data];
            [self.imageView setImage:newImage];
            
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not load image :(" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }];
}

@end
