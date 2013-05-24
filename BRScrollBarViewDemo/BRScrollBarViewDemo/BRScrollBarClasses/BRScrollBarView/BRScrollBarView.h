//
//  BRScrollBar.h
//  BRScrollBarDemo
//
//  Created by Basheer on 5/3/13.
//  Copyright (c) 2013 Basheer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRScrollHandle.h"
#import "BRCommonMethods.h"

@protocol BRScrollBarProtocol;
@interface BRScrollBarView : UIView 
{
    UIView *_scrollBarView;
    NSTimer *_fadingScrollBarTime;
    NSTimer *_animatingScrollBarWidthTimer;
    
    CGFloat _scrollBarNormalWidth;
    CGFloat _scrollBarMovingOffset;
    CGPoint _firstTouchLocation;
}

@property (nonatomic, readonly) BRScrollHandle *scrollHandle;              // The scrollHandle View
@property (nonatomic, assign) BOOL showLabel;                              // should scrollView shows label with the handle
@property (nonatomic, assign) BOOL hideScrollBar;
@property (nonatomic, assign) id<BRScrollBarProtocol> delegate;

@property (nonatomic, readonly) BRScrollLabel *scrollLabel;

@property (nonatomic, readonly) BOOL isDragging;                           // if the user moving the handle
@property (nonatomic, readonly) BOOL isScrollDirectionUp;

- (void)viewDidScroll:(UIScrollView *)scrollView;                               // called form the the Controller
- (void)setBRScrollBarContentSizeForScrollView:(UIScrollView *)scrollView;      // called from the controller

@end


//=========================protocol================================//
@protocol BRScrollBarProtocol <NSObject>
- (void)scrollBar:(BRScrollBarView*)scrollBar draggedToPosition:(CGPoint)position;
- (void)scrollBarDidLayoutSubviews:(BRScrollBarView *)scrollBarView;
@end
//===================================================================//