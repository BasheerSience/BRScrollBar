//
//  ViewController.h
//  BRScrollBarViewDemo
//
//  Created by Basheer Shamary on 5/19/13.
//  Copyright (c) 2013 Basheer Malaa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRScrollBarController.h"

@interface ViewController : UIViewController < UITableViewDataSource, UITableViewDelegate,BRScrollBarControllerDelegate>

@property (nonatomic, readonly, strong) BRScrollBarController *brScrollBarController;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end
