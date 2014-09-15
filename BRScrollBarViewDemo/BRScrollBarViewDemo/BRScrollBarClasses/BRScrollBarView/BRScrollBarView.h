//
//  BRScrollBar.h
//  BRScrollBarDemo
//
//  Created by Basheer on 5/3/13.
//  Copyright (c) 2013 Basheer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRScrollHandle.h"
#import "BRScrollLabel.h"
#import "BRCommonMethods.h"

@protocol BRScrollBarProtocol;
@interface BRScrollBarView : UIView 

@property (strong, readonly) BRScrollHandle *scrollHandle;
@property (nonatomic, assign) BOOL showLabel;
@property (nonatomic, assign) BOOL hideScrollBar;
@property (nonatomic, weak)   id<BRScrollBarProtocol> delegate;

@property (nonatomic, readonly) BRScrollLabel *scrollLabel;
@property (nonatomic, readonly) BOOL isDragging;


/*! called form the the Controller */
- (void)viewDidScroll:(UIScrollView *)scrollView;
/*! called from the controller */
- (void)setBRScrollBarContentSizeForScrollView:(UIScrollView *)scrollView;

@end


//=========================protocol================================//
@protocol BRScrollBarProtocol <NSObject>
- (void)scrollBar:(BRScrollBarView*)scrollBar draggedToPosition:(CGPoint)position;
- (void)scrollBarDidLayoutSubviews:(BRScrollBarView *)scrollBarView;
@end
//===================================================================//

@protocol BRScrollBarViewPrivateProtocol <NSObject>
@property (nonatomic, assign) CGFloat sizeDifference;
- (void)setHandleHeight:(CGFloat)height;
@end
