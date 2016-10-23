//
//  ViewController.m
//  ImageSave
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
    
    self.originalImage = [UIImage imageNamed:@"CasaLoma.jpg"];
    self.imageView.image = self.originalImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)saveToDisk:(id)sender
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"image.jpg"];
    
    NSData *imageData = UIImageJPEGRepresentation(self.originalImage, 0.7f);
    NSError *error = nil;
    NSString *alertMessage = nil;
    
    //check if the file exists before trying to write it
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyyMMddHHmm"];
        
        NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
        
        NSString *fileName = [NSString stringWithFormat:@"image-%@.jpg", dateString];
        
        filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    }
    
    [imageData writeToFile:filePath options:NSDataWritingAtomic error:&error];
    
    if (error == nil) {
        alertMessage = @"Saved to 'Documents' folder successfully!";
    } else {
        alertMessage = @"Could not save image :(";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Status" message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

-(IBAction)saveToAlbum:(id)sender
{
    UIImageWriteToSavedPhotosAlbum(self.originalImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

#pragma mark - save completion handler

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *) error contextInfo:(void *)contextInfo
{
    NSString *alertMessage = nil;
    if (error == nil) {
        alertMessage = @"Saved to Camera Roll successfully!";
    } else {
        alertMessage = @"Could not save image :(";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Status" message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

@end
