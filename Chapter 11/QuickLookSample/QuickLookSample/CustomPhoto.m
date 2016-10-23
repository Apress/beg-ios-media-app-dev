//
//  CustomPhoto.m
//  QuickLookSample
//
//  Created by Ahmed Bakir on 10/18/14.
//  Copyright (c) 2014 Ahmed Bakir. All rights reserved.
//

#import "CustomPhoto.h"

@implementation CustomPhoto

-(id)debugQuickLookObject {
    UIView *quickLookView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 400, 400)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:quickLookView.frame];
    
    if (self.image == nil) {
        imageView.image = [UIImage imageNamed:@"placeholder.jpg"];
    } else {
        imageView.image = self.image;
    }
    
    CGFloat originX = CGRectGetMinX(quickLookView.frame) + 10;
    CGFloat originY = CGRectGetMaxY(quickLookView.frame) - 40;
    CGFloat width = quickLookView.frame.size.width;
    
    CGRect titleLabelFrame = CGRectMake(originX, originY, width, 20);
    CGRect locationLabelFrame = CGRectMake(originX, originY + 20, width, 20);
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleLabelFrame];
    UILabel *locationLabel = [[UILabel alloc] initWithFrame:locationLabelFrame];
    
    titleLabel.text = (self.title == nil) ? @"No title" : self.title;
    locationLabel.text = (self.location == nil) ? @"No location" : self.location;
    
    [quickLookView addSubview:imageView];
    [quickLookView addSubview:titleLabel];
    [quickLookView addSubview:locationLabel];
    
    return quickLookView;
}

@end
