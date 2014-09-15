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

const CGFloat kBRScrollBarScrollHandleMinWidth = 36;
const CGFloat kBRScrollBarScrollHandleMargin   = 2;

@interface BRScrollHandle ()<BRScrollBarViewPrivateProtocol>
@end

@implementation BRScrollHandle
@synthesize sizeDifference = _sizeDifference;

- (instancetype)initWithScrollBarView:(BRScrollBarView *)scrollBarView {
    self = [super init];
    if(self) {
        CGRect mainScrollBarRect = [scrollBarView frame];
        _handleWidth = mainScrollBarRect.size.width - kBRScrollBarScrollHandleMargin;
        CGFloat xPos = 1;
        CGFloat yPos = 0;
        self.alpha = 1;
        self.frame = CGRectMake(xPos, yPos, _handleWidth, kBRScrollBarScrollHandleMinWidth);
        self.layer.cornerRadius = 5;
        self.backgroundColor    = [UIColor blackColor];
        self.autoresizingMask   = UIViewAutoresizingFlexibleRightMargin |
                                  UIViewAutoresizingFlexibleLeftMargin;
    }
    return self;
}

- (void)setsizeDifference:(CGFloat)sizeDifference {
    _sizeDifference = sizeDifference;
}


#pragma mark - BRScrollBarViewPrivateProtocol

- (CGFloat)sizeDifference {
    return _sizeDifference;
}

- (void)setHandleHeight:(CGFloat )height {
    CGRect myRect = self.frame;
    UIView *scrollBArParent = self.superview;
    _sizeDifference = 0;
    
    if(height > kBRScrollBarScrollHandleMinWidth) {
        if(height > scrollBArParent.frame.size.height) {
            myRect.size.height = scrollBArParent.frame.size.height;
        } else {
            myRect.size.height = height;
        }
    } else {
        CGFloat delta = kBRScrollBarScrollHandleMinWidth - height;
        _sizeDifference = delta;
        myRect.size.height = kBRScrollBarScrollHandleMinWidth;
    }
    self.frame = myRect;
}


@end
