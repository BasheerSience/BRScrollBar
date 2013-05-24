//
//  BRScrollLabel.h
//  BRScrollBarDemo
//
//  Created by Basheer on 5/3/13.
//  Copyright (c) 2013 Basheer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRCommonMethods.h"

@interface BRScrollLabel : UIView
{
    UILabel *_textLabel;
}
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) CGFloat labelWidth;

- (void)setBackgroundImage:(UIImage*)backgroundImage;
- (void)resetText;
- (void)showLabel;
- (void)hideLabel;
@end
