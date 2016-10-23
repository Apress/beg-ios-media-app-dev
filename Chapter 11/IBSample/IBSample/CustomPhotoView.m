//
//  CustomPhotoView.m
//  IBSample
//
//  Created by Ahmed Bakir on 10/16/14.
//  Copyright (c) 2014 devAtelier. All rights reserved.
//

#import "CustomPhotoView.h"

@implementation CustomPhotoView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

/*
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect myFrame = self.bounds;
    CGContextSetLineWidth(context, _lineWidth);
    //CGRectInset(myFrame, 5, 5);
    [_fillColor set];
    UIRectFrame(myFrame);
}
 */

//
//-(void)setInsideColor:(UIColor *)color
//{
//    self.insideColor = color;
//    self.backgroundColor = color;
//}

/*
-(void)setTitleText:(NSString *)titleText
{
    self.titleText = titleText;
    self.titleLabel.text = self.titleText;
}
 */

//

-(void)layoutSubviews
{
    [super layoutSubviews];
    /*
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect myFrame = self.bounds;
    CGContextSetLineWidth(context, _lineWidth);
    CGRectInset(myFrame, 5, 5);
    [_fillColor set];
    UIRectFrame(myFrame);
     */

    
    /*
    CGRect insideFrame = CGRectMake(_lineWidth, _lineWidth, self.frame.size.width - _lineWidth *2, self.frame.size.height - _lineWidth * 2);
    CGRect label1Frame = CGRectMake(_lineWidth, CGRectGetMaxY(self.frame) - 40, CGRectGetWidth(self.frame), 20);
    CGRect label2Frame = CGRectMake(_lineWidth, CGRectGetMinY(label1Frame) + 20,  CGRectGetWidth(self.frame), 20);
     */
    
    CGFloat padding = 10.0f;
    CGFloat labelHeight = 20.0f;
    CGFloat viewWidth = self.frame.size.width;
    CGFloat viewHeight = self.frame.size.height;
    
    CGRect insideFrame = CGRectMake(padding, padding, viewWidth - padding * 2, viewHeight - padding * 2);
    CGRect label1Frame = CGRectMake(padding, CGRectGetMaxY(insideFrame) - 40, viewWidth, labelHeight);
    CGRect label2Frame = CGRectMake(padding, CGRectGetMinY(label1Frame) + 20,  viewWidth, labelHeight);
    
    self.imageView = [[UIImageView alloc] initWithFrame:insideFrame];
    self.imageView.image = self.titleImage;

    [self addSubview:self.imageView];
    
    
    self.titleLabel = [[UILabel alloc] initWithFrame:label1Frame];
    [self addSubview:self.titleLabel];
    self.titleLabel.text = self.titleText;
    
    self.locationLabel = [[UILabel alloc] initWithFrame:label2Frame];
    [self addSubview:self.locationLabel];
    self.locationLabel.text = self.locationText;
    
}

/*
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = self.insideColor;
        self.titleLabel = [[UILabel alloc] initWithFrame:frame];
        self.titleLabel.text = @"blah";
        [self addSubview:self.titleLabel];
    }
    return self;
 }*/




@end
