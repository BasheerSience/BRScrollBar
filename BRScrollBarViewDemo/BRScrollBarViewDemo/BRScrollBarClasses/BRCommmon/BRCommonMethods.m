//
//  BRCommonMethods.m
//  BRScrollBarDemo
//
//  Created by Basheer on 5/3/13.
//  Copyright (c) 2013 Basheer. All rights reserved.
//

#import "BRCommonMethods.h"
const int kIntBRLabelWidth        = 100;
const int kIntBRLabelHeight       = 25;
const int kIntBRScrollBarWidth    = 8;
const int kIntBRScrollLabelMargin = 40;


@implementation BRCommonMethods

+ (BOOL)isInterfaceOrientaionLandScape
{
    BOOL isLandscape  = NO;
    UIInterfaceOrientation currentOrientation = [[UIApplication sharedApplication]statusBarOrientation];
    
    if(currentOrientation == UIInterfaceOrientationLandscapeLeft ||
       currentOrientation == UIInterfaceOrientationLandscapeRight)
    {
        isLandscape = YES;
    }
    return isLandscape;
 
}
@end
