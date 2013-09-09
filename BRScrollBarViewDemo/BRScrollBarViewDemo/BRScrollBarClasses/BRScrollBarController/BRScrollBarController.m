//
//  BRScrollBarController.m
//  BRScrollBarDemo
//
//  Created by Basheer on 5/2/13.
//  Copyright (c) 2013 Basheer. All rights reserved.
//

#import "BRScrollBarController.h"
#import <QuartzCore/QuartzCore.h>
#import "BRCommonMethods.h"

#define SCROLLBAR_MARGIN_TOP 2
#define SCROLLBAR_MARGIN_RIGHT 1

static BRScrollBarController *_instance;

@interface BRScrollBarController ()
@property (nonatomic, weak) UIScrollView *scrollView;
@end



@implementation BRScrollBarController

+ (id)initForScrollView:(UIScrollView *)scrollView inPosition:(BRScrollBarPostions)position
               delegate:(id<BRScrollBarControllerDelegate>)delegate
{
    _instance = [[BRScrollBarController alloc] initForScrollView:scrollView
                                                      inPosition:position ];
    _instance.delegate = delegate;
    return _instance;
}

- (id) initForScrollView:(UIScrollView *)scrollView
{
    // init for the default position (right)
    self = [self initForScrollView:scrollView inPosition:kIntBRScrollBarPositionRight];
    return self;
}

- (id) initForScrollView:(UIScrollView *)scrollView inPosition:(BRScrollBarPostions)position
{
    self = [super init];
    if(self)
    {
        NSAssert([[scrollView class]isSubclassOfClass:[UIScrollView class]],
                 @"initForScrollView:. Must be UIScrollView class or subclass.");
        
        _scrollView = scrollView;
        _scrollView.showsVerticalScrollIndicator = NO;
        
        [self addObservers];
        [self initScrollBarViewForPostion:position];

    }
    return self;
}


- (void)initScrollBarViewForPostion:(BRScrollBarPostions)position
{
    CGPoint origin = [self scrollBarOriginForPosition:position];
    
    _scrollBar = [[BRScrollBarView alloc] initWithFrame:CGRectMake(origin.x,
                                                                   0.0,
                                                                   kIntBRScrollBarWidth,
                                                                   _scrollView.frame.size.height)];

    _scrollBar.autoresizingMask = [self autoResizingMaskForPosition:position];
    _scrollBar.delegate = self;
    
    // Asssert if the tableview has no superview
    NSAssert(_scrollView.superview != nil,
             @"BRScrollBar suppose that UIScrollView class (or subclass) has a superview."
             "Please add the tableView on a super view to initialize BRSrollBar.");
    
    [_scrollView.superview addSubview:_scrollBar];
    
}


#pragma mark - observing ContentSize, ContentOffset

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if([keyPath isEqualToString:@"contentSize"])
    {
        [self setContentSize];
    }
    else if([keyPath isEqualToString:@"contentOffset"])
    {
        [self viewDidScroll];
    }
    else if([keyPath isEqualToString:@"frame"])
    {
        [self scrollViewDidLayoutSubviews];
    }
    
}

- (void)setContentSize
{
    [self.scrollBar setBRScrollBarContentSizeForScrollView:self.scrollView];
}

- (void)viewDidScroll
{
    [self.scrollBar viewDidScroll:self.scrollView];
}

- (void)scrollViewDidLayoutSubviews
{
    CGRect scrollBarRect = self.scrollBar.frame;
    scrollBarRect.size.height = self.scrollView.frame.size.height;
    self.scrollBar.frame = scrollBarRect;
    [self.scrollBar setBRScrollBarContentSizeForScrollView:_scrollView];
}

#pragma mark - BRScrollBarProtocol

- (void)scrollBar:(BRScrollBarView *)scrollBar draggedToPosition:(CGPoint)position
{
    // set tableView contentoffset
    CGPoint newContentOffset = [self contentOffsetFromScrollBarPosition:position];
    // keep X but move by Y
    [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x, newContentOffset.y)];
    
    if(self.scrollBar.showLabel)
    {
        if([self.delegate respondsToSelector:@selector(brScrollBarController:textForCurrentPosition:)])
        {
            // now show the label
            CGPoint handlePosition = [_scrollView convertPoint:self.scrollBar.scrollLabel.center
                                                      fromView:self.scrollBar];
            NSString *strLabeltext = nil;
    
            // delegate should return string for this position
            strLabeltext = [self.delegate brScrollBarController:self textForCurrentPosition:handlePosition];
            self.scrollBar.scrollLabel.text = strLabeltext;    // set the label string
        }
    }
    

}

- (CGPoint) contentOffsetFromScrollBarPosition:(CGPoint)position
{
    CGPoint offsetToReturn = CGPointZero;
    CGFloat one = 0;
    CGFloat contentOffFactor = 0;
    
    one = _scrollView.contentSize.height / (_scrollView.frame.size.height) ;
    contentOffFactor = (position.y ) * one ;
    
    if(contentOffFactor >= _scrollView.contentSize.height)
    {
        contentOffFactor = _scrollView.contentSize.height;
    }
    
    offsetToReturn.y = contentOffFactor;
    
    return offsetToReturn;
}

- (void)scrollBarDidLayoutSubviews:(BRScrollBarView *)scrollBarView
{
    [self.scrollBar viewDidScroll:self.scrollView];
}

#pragma mark - Private

// the scroll bar postion (left or right)
- (CGPoint) scrollBarOriginForPosition:(BRScrollBarPostions)scrollBarPosition
{
    CGPoint pointToreturn = CGPointZero;
    
    if(scrollBarPosition == kIntBRScrollBarPositionRight)
    {
        pointToreturn.x = _scrollView.superview.frame.size.width - kIntBRScrollBarWidth;
        pointToreturn.x -= SCROLLBAR_MARGIN_RIGHT;
        pointToreturn.y += SCROLLBAR_MARGIN_TOP;
    }
    else
    {
        pointToreturn.x  = SCROLLBAR_MARGIN_RIGHT;
        pointToreturn.y += SCROLLBAR_MARGIN_TOP;
    }
    
    return pointToreturn;
}

- (UIViewAutoresizing)autoResizingMaskForPosition:(BRScrollBarPostions)scrollPosition
{
    UIViewAutoresizing autoresizeing = UIViewAutoresizingNone;
    if(scrollPosition == kIntBRScrollBarPositionRight)
    {
        autoresizeing = UIViewAutoresizingFlexibleHeight      |
                        UIViewAutoresizingFlexibleLeftMargin  |
                        UIViewAutoresizingFlexibleTopMargin   |
                        UIViewAutoresizingFlexibleBottomMargin;
        
    }
    else
    {
        autoresizeing = UIViewAutoresizingFlexibleRightMargin  |
                        UIViewAutoresizingFlexibleTopMargin    |
                        UIViewAutoresizingFlexibleBottomMargin |
                        UIViewAutoresizingFlexibleHeight;

    }
    return autoresizeing;
    
}


- (BOOL)isInterfaceLandscape
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


#pragma mark - Adding and removing observers

- (void)addObservers
{
    [self.scrollView addObserver:self forKeyPath:@"contentSize"   options:0 context:NULL];
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:0 context:NULL];
    [self.scrollView addObserver:self forKeyPath:@"frame"         options:0 context:NULL];
}

- (void)removeObservers
{
    [self.scrollView removeObserver:self forKeyPath:@"contentSize"];
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [self.scrollView removeObserver:self forKeyPath:@"frame"];
}


#pragma mark - dealloc 

- (void)dealloc
{
    [self removeObservers];
}
@end
