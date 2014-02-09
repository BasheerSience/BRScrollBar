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
/** This property set the difference in size between MIN size and the
*   needed size. This value will be used in the
*   viewDidScroll: and
*   in handleDragged methods.
*/
@property (nonatomic, assign, readonly) CGFloat sizeDifference;

- (id)initWithScrollBar:(BRScrollBarView*)scrollBar;
/**
 *
 * Dont call this method to change the hight menually
 * DONT!
 */
- (void)setHandleHeight:(CGFloat )height;
@end


