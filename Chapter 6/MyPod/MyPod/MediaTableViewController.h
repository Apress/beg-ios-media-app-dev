//
//  MediaTableViewController.h
//  MyPod
//
//  Created by Ahmed Bakir on 8/22/14.
//  Copyright (c) 2014 devAtelier. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MediaTableDelegate <NSObject>

-(void)didFinishWithItem:(NSString *)item andType:(NSString *)type;
-(void)didCancel;

@end

@interface MediaTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *itemsArray;
@property (nonatomic, strong) NSString *mediaType;
@property (nonatomic, strong) id <MediaTableDelegate> delegate;

-(id)initWithItems:(NSArray *)array withType:(NSString *)type;

-(IBAction)closeView:(id)sender;

@end
