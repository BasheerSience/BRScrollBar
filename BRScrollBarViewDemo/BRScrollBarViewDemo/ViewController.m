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
    _brScrollBarController = [BRScrollBarController initForScrollView:self.tableView
                                                inPosition:kIntBRScrollBarPositionRight
                                                  delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*!
 * return title for cell at this point
 * to show in the BrScrollBarLabel
 */
#pragma mark - BRScrollBarcontroller

- (NSString *)brScrollBarController:(BRScrollBarController *)controller textForCurrentPosition:(CGPoint)position
{
    NSIndexPath *index = [self.tableView indexPathForRowAtPoint:position];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:index];
    
    return cell.textLabel.text;
}


#pragma mark - TableViewDataSource/Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return 50;
    
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

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

#pragma mark - Private 

- (void) configureCell:(UITableViewCell*)cell forIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.text = [NSString stringWithFormat:@"cell %d",indexPath.row];
}


@end
