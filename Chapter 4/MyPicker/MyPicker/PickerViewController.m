//
//  PickerViewController.m
//  MyPicker
//
//  Created by Ahmed Bakir on 6/25/14.
//  Copyright (c) 2014 devAtelier. All rights reserved.
//

#import "PickerViewController.h"
#import "PickerCell.h"

@interface PickerViewController ()

@end

@implementation PickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.assetsLibrary = [[ALAssetsLibrary alloc] init];
    self.selectedImages = [NSMutableDictionary new];
    
    self.images = [NSMutableArray new];
    
    [self.collectionView setAllowsMultipleSelection:YES];
    
    NSInteger photoFilters = ALAssetsGroupPhotoStream | ALAssetsGroupSavedPhotos;
    
    [self.assetsLibrary enumerateGroupsWithTypes:photoFilters usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result != nil) {
                [self.images addObject:result];
                
            }
        }];
        
        [self.collectionView reloadData];
    } failureBlock:^(NSError *error) {
        NSLog(@"error! %@", [error description]);
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return [self.images count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PickerCell *cell = (PickerCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PickerCell" forIndexPath:indexPath];
    
    ALAsset *asset = [self.images objectAtIndex:indexPath.row];
    
    cell.imageView.image =  [UIImage imageWithCGImage:asset.aspectRatioThumbnail];
    
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PickerCell *cell = (PickerCell *)[collectionView cellForItemAtIndexPath:indexPath];

    cell.overlayView.image = [UIImage imageNamed:@"check-selected"];
    cell.imageView.backgroundColor = [UIColor whiteColor];
    
    [self.selectedImages setObject:[self.images objectAtIndex:indexPath.row] forKey:[NSNumber numberWithInteger:indexPath.row]];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PickerCell *cell = (PickerCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    cell.overlayView.image = [UIImage imageNamed:@"check-notselected"];
    cell.imageView.backgroundColor = [UIColor purpleColor];
    
    if ([self.selectedImages objectForKey:[NSNumber numberWithInteger:indexPath.row]] != nil) {
        [self.selectedImages removeObjectForKey:[NSNumber numberWithInteger:indexPath.row]];
    }
    
}

-(IBAction)done:(id)sender
{
    //[self dismissViewControllerAnimated:YES completion:nil];
    
    NSMutableArray *imageArray = [NSMutableArray new];
    for (id key in self.selectedImages.allKeys) {
        if ([self.selectedImages objectForKey:key] != nil) {
            [imageArray addObject:[self.selectedImages objectForKey:key]];
        }
    }
    
    [self.delegate didSelectImages:imageArray];
}

-(IBAction)cancel:(id)sender
{
    //[self dismissViewControllerAnimated:YES completion:nil];
    
    [self.delegate cancel];
}

@end
