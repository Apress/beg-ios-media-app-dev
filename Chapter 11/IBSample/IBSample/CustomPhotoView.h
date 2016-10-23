//
//  CustomPhotoView.h
//  IBSample
//
//  Created by Ahmed Bakir on 10/16/14.
//  Copyright (c) 2014 devAtelier. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface CustomPhotoView : UIView

//@property (nonatomic) IBInspectable NSInteger lineWidth;
//@property (nonatomic) IBInspectable UIColor *fillColor;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) IBInspectable NSString *titleText;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) IBInspectable NSString *locationText;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) IBInspectable UIImage *titleImage;

@end
