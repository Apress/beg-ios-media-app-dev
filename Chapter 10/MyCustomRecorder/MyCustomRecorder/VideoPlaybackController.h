//
//  VideoPlaybackController.h
//  MyCustomRecorder
//
//  Created by Ahmed Bakir on 9/22/14.
//  Copyright (c) 2014 Ahmed Bakir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPlayerController.h"

@protocol CustomPlayerDelegate <NSObject>

-(void)didFinishWithSuccess:(BOOL)success;

@end


@interface VideoPlaybackController : CustomPlayerController

@property (nonatomic, strong) id <CustomPlayerDelegate> delegate;
@property (nonatomic, strong) IBOutlet UIView *buttonBar;
@property (nonatomic, strong) IBOutlet UIView *controlBar;

-(IBAction)accept:(id)sender;
-(IBAction)reject:(id)sender;
-(void)prepareToPlay;

-(id)initWithContentURL:(NSURL *)contentURL;

@end

