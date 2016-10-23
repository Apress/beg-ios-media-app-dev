//
//  ViewController.m
//  MyPicker
//
//  Created by Ahmed Bakir on 11/22/14.
//  Copyright (c) 2014 Ahmed Bakir. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Button Handler

-(IBAction)presentPicker:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    PickerViewController *pickerViewController = [storyboard instantiateViewControllerWithIdentifier:@"PickerViewController"];
    
    pickerViewController.delegate = self;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:pickerViewController];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - UITableView delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.imageArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *imageCell = [tableView dequeueReusableCellWithIdentifier:@"ImageCell" forIndexPath:indexPath];
    
    ALAsset *asset = [self.imageArray objectAtIndex:indexPath.row];
    ALAssetRepresentation *defaultRepresentation = [asset defaultRepresentation];
    CGImageRef imagePtr = [defaultRepresentation fullResolutionImage];
    
    UIImageOrientation imageOrientation = UIImageOrientationUp;
    NSNumber *orientation = [asset valueForProperty:@"ALAssetPropertyOrientation"];
    if (orientation != nil) {
        imageOrientation = [orientation integerValue];
    }
    
    UIImage *image = [UIImage imageWithCGImage:imagePtr scale:1.0f orientation:imageOrientation];
    
    imageCell.imageView.image = image;
    
    imageCell.textLabel.text = [NSString stringWithFormat:@"Image %d", indexPath.row];
    
    return imageCell;
}


#pragma mark - Picker Delegate methods

-(void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didSelectImages:(NSArray *)images
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    self.imageArray = [images copy];
    
    [self.tableView reloadData];
}

@end
