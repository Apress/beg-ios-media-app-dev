//
//  PickerViewController.h
//  MyPicker
//
//  Created by Ahmed Bakir on 6/25/14.
//  Copyright (c) 2014 devAtelier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@protocol PickerDelegate <NSObject>

-(void)didSelectImages:(NSArray *)images;
-(void)cancel;

@end


@interface PickerViewController : UICollectionViewController

@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) NSMutableDictionary *selectedImages;
@property (nonatomic, strong) id <PickerDelegate> delegate;


-(IBAction)cancel:(id)sender;
-(IBAction)done:(id)sender;


@end
