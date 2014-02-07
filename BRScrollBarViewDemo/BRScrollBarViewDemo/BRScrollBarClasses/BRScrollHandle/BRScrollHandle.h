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


@property (nonatomic, assign)  CGFloat handleWidth;
/** This property set the deference in size between MIN size and the
*   needed size. This value will be used in the
*   view did scroll and
*   in handleDragged.
*/
@property (nonatomic, assign, readonly) CGFloat sizeDeference;

- (id)initWithScrollBar:(BRScrollBarView*)scrollBar;
/**
 *
 * Dont call this to change the hight menually
 * DONT!
 */
- (void)setHandleHeight:(CGFloat )height;
@end


