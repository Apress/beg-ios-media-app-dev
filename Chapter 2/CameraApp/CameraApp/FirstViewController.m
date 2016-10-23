//
//  ViewController.m
//  CameraApp
//
//  Created by Ahmed Bakir on 11/21/14.
//  Copyright (c) 2014 Ahmed Bakir. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - User interface action handlers

-(IBAction)showPickerActionSheet:(id)sender
{
    UIActionSheet *pickerActionSheet = nil;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        pickerActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select a source type" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Use Photo Albums", @"Take Photo", nil];
    } else {
        pickerActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select a source type" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Use Photo Albums", nil];
    }
    
    [pickerActionSheet showInView:self.view];
}

/*
 * Note: This action handler is not used, it only serves as an example for initializing a picker controller.
 */
-(IBAction)showPicker:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    }
    
    [self presentViewController:imagePicker animated:YES completion:^{
        NSLog(@"Image picker presented!");
    }];
}

#pragma mark - UIActionSheetDelegate delegate methods

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePicker  = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    switch (buttonIndex) {
        case 0:
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
        case 1:
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        default:
            break;
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && imagePicker.sourceType != UIImagePickerControllerSourceTypeCamera) {
        //iPad
        
        self.popover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        
        [self.popover presentPopoverFromRect:self.actionButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        
    } else {
        //iPhone
        
        [self presentViewController:imagePicker animated:YES completion:^{
            NSLog(@"Image picker presented!");
        }];
    }
    
}

#pragma mark - UIPopoverControllerDelegate delegate methods

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    popoverController = nil;
}

#pragma mark - UIImagePickerDelegate delegate methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.imageView setImage:selectedImage];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Image selected!");
    }];
    
    if (self.popover != nil) {
        [self.popover dismissPopoverAnimated:YES];
        self.popover = nil;
    }
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Picker cancelled without doing anything");
    }];
    
    if (self.popover != nil) {
        [self.popover dismissPopoverAnimated:YES];
        self.popover = nil;
    }
}

#pragma mark - SecondViewControllerDelegate delegate methods

/*
 * Note: These are not used, they only serves as an example of a simple delegate.
 */

-(void)secondViewController:(UIViewController *)controller hasImage:(UIImage *)image
{
    self.selectedImage = image;
    [controller dismissViewControllerAnimated:YES completion:nil];
}

-(void)secondViewController:(UIViewController *)controller didCancel:(BOOL)state
{
    if (state == YES) {
        [controller dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
