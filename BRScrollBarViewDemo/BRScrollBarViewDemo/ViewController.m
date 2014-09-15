//
//  ViewController.m
//  BRScrollBarViewDemo
//
//  Created by Basheer Shamary on 5/19/13.
//  Copyright (c) 2013 Basheer Malaa. All rights reserved.
//

#import "ViewController.h"



@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _brScrollBarController = [BRScrollBarController setupScrollBarWithScrollView:self.tableView
                                                                      inPosition:BRScrollBarPostionLeft
                                                                        delegate:self];
}


#pragma mark - BRScrollBarcontroller

/*!
 * return title for cell at this point
 * to show in the BrScrollBarLabel
 */
- (NSString *)brScrollBarController:(BRScrollBarController *)controller
             textForCurrentPosition:(CGPoint)position {
    NSIndexPath *index = [self.tableView indexPathForRowAtPoint:position];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:index];
    
    return cell.textLabel.text;
}

#pragma mark - TableViewDataSource/Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [self configureCell:cell forIndexPath:indexPath];
    return cell;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

#pragma mark - Private 

- (void) configureCell:(UITableViewCell*)cell forIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.text = [NSString stringWithFormat:@"cell %ld",(long)indexPath.row];
}


@end
