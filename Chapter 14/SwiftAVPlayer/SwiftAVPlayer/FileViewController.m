//
//  FileViewController.m
//  MyPlayer
//
//  Created by Ahmed Bakir on 8/3/14.
//  Copyright (c) 2014 devAtelier. All rights reserved.
//

#import "FileViewController.h"

@interface FileViewController ()

@end

@implementation FileViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithFileArray:(NSArray *)fileArray
{
    self = [super init];
    if (self) {
        self.fileArray = fileArray;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.fileArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fileCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    NSString *filePath = [self.fileArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [filePath lastPathComponent];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *filePath = [self.fileArray objectAtIndex:indexPath.row];
    
    [self.delegate didFinishWithFile:filePath];
    
}



-(void)initializeFileArray
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSError *error = nil;
    
    NSArray *allFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    
    if (error == nil) {
        
        self.fileArray = [NSMutableArray new];
        
        for (NSString *file in allFiles) {
            if ([[file pathExtension] isEqualToString:@"mp4"] || [[file pathExtension] isEqualToString:@"mov"] || [[file pathExtension] isEqualToString:@"MOV"]) {
                [self.fileArray addObject:file];
            }
        }
        
    } else {
        NSLog(@"error looking up files: %@", [error description]);
    }
}

-(IBAction)closeView:(id)sender
{
    [self.delegate cancel];
}

@end
