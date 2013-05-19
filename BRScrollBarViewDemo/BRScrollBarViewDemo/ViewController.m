//
//  ViewController.m
//  BRScrollBarViewDemo
//
//  Created by Basheer Shamary on 5/19/13.
//  Copyright (c) 2013 Basheer Malaa. All rights reserved.
//

#import "ViewController.h"



@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    //BRScrollBarController *scrollBarController = [[BRScrollBarController alloc] initForTableView:self.tableView];
    //brScrollBar = scrollBarController;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    BRScrollBarController *brScrollBar1 = [[BRScrollBarController alloc] initForScrollView:self.tableView];
    brScrollBar = brScrollBar1;
    brScrollBar.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    // BRScrollBarController *scrollBarController = [[BRScrollBarController alloc] initForTableView:self.tableView];
    // brScrollBar = scrollBarController;
}


#pragma mark - BRScrollBarcontroller
- (NSString *)brScrollBarController:(BRScrollBarController *)controller textForCurrentPosition:(CGPoint)position
{
    NSIndexPath *index = [self.tableView indexPathForRowAtPoint:position];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:index];
    
    return cell.textLabel.text;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return 5;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    [self configureCell:cell forIndexPath:indexPath];
    return cell;
}

- (void) configureCell:(UITableViewCell*)cell forIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.text = [NSString stringWithFormat:@"cell %d",indexPath.row];
}



- (void)tableView:(UITableView*)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section
{
    
}

@end
