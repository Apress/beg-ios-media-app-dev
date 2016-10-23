//
//  MediaTableViewController.m
//  MyPod
//
//  Created by Ahmed Bakir on 8/22/14.
//  Copyright (c) 2014 devAtelier. All rights reserved.
//

#import "MediaTableViewController.h"

@interface MediaTableViewController ()

@end

@implementation MediaTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithItems:(NSArray *)array withType:(NSString *)type
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.itemsArray = array;
        self.mediaType = type;
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    //initialize the navigation controller
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(closeView:)];
    self.navigationItem.title = @"Choose Media";
    
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
    return [self.itemsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"itemCell"];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"itemCell"];
    }

    
    cell.textLabel.text = [self.itemsArray objectAtIndex:indexPath.row];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedItem = [self.itemsArray objectAtIndex:indexPath.row];
    [self.delegate didFinishWithItem:selectedItem andType:self.mediaType];
}


-(IBAction)closeView:(id)sender
{
    [self.delegate didCancel];
}

@end
