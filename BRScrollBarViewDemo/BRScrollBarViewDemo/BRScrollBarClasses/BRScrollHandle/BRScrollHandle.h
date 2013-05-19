//
//  BRScrollHandle.h
//  BRScrollBarDemo
//
//  Created by Basheer on 5/2/13.
//  Copyright (c) 2013 Basheer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRScrollLabel.h"

@class BRScrollBarView;
@interface BRScrollHandle : UIView
{
    BRScrollBarView *_scrollBarParent;
    CGFloat _scrollBarNormalWidth;
    CGFloat _scrollBarNormalXPos;
}

@property (nonatomic, assign) CGFloat handleWidth;
@property (nonatomic,readonly) CGFloat sizeDeference; // this property has the deference in size between MIN size and the
                                                      // needed size. This value will be used in the view did scroll and
                                                      // in handleDragged.

- (id)initWithScrollBar:(BRScrollBarView*)scrollBar;
- (void)setHandleHeight:(CGFloat )height;


@end


