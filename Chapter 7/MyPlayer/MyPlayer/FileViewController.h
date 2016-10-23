//
//  FileViewController.h
//  MyPlayer
//
//  Created by Ahmed Bakir on 8/3/14.
//  Copyright (c) 2014 devAtelier. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FileControllerDelegate <NSObject>

-(void)cancel;
-(void)didFinishWithFile:(NSString *)filePath;

@end

@interface FileViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *fileArray;

@property (nonatomic, strong) id <FileControllerDelegate> delegate;

-(IBAction)closeView:(id)sender;

@end
