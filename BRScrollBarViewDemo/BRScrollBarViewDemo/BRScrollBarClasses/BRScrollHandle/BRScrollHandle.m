//
//  BRScrollHandle.m
//  BRScrollBarDemo
//
//  Created by Basheer on 5/2/13.
//  Copyright (c) 2013 Basheer. All rights reserved.
//

#import "BRScrollHandle.h"
#import  <QuartzCore/QuartzCore.h>
#import "BRCommonMethods.h"
#import "BRScrollBarView.h"


#define HANDLE_MIN_HEIGHT 36
#define HANDLE_MARGIN 2

@interface BRScrollBarView ()
{
    CGFloat _scrollBarNormalWidth;
    CGFloat _scrollBarNormalXPos;
}
@end

@implementation BRScrollHandle

- (id) initWithScrollBar:(UIView *)scrollBar;
{
    self = [super init];
    if(self)
    {
        CGRect mainScrollBarRect = [scrollBar frame];
        _handleWidth = mainScrollBarRect.size.width - HANDLE_MARGIN;
        CGFloat xPos = 1;
        CGFloat yPos = 0;
        self.alpha = 1;
        self.frame = CGRectMake(xPos, yPos, _handleWidth, HANDLE_MIN_HEIGHT);
        self.layer.cornerRadius = 5;
        self.backgroundColor = [UIColor blackColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleRightMargin  |
                                UIViewAutoresizingFlexibleLeftMargin;
    }
    return self;
}

#pragma mark - Public

- (void)setHandleHeight:(CGFloat )height
{
    CGRect myRect = self.frame;
    UIView *scrollBArParent = self.superview;
    _sizeDeference = 0;
    
    if(height > HANDLE_MIN_HEIGHT)
    {
        if(height > scrollBArParent.frame.size.height)
        {
            myRect.size.height = scrollBArParent.frame.size.height;
        }
        else
        {
            myRect.size.height = height;
        }
    }
    else
    {
        CGFloat deference = HANDLE_MIN_HEIGHT - height;
        _sizeDeference = deference;
        
        myRect.size.height = HANDLE_MIN_HEIGHT;
    }
    
    self.frame = myRect;
}

@end
