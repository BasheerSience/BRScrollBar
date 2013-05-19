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

{
    BRScrollBarController *brScrollBar;
}

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end
