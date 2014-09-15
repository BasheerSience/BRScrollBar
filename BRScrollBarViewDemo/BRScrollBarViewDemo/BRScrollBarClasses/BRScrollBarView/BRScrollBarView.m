//
//  BRScrollBar.m
//  BRScrollBarDemo
//
//  Created by Basheer on 5/3/13.
//  Copyright (c) 2013 Basheer. All rights reserved.
//

#import "BRScrollBarView.h"
#import  <QuartzCore/QuartzCore.h>
#import "BRCommonMethods.h"


#define SCROLL_BAR_TOUCHED_WIDTH 12
#define SCROLL_BAR_MARGIN_TOP    1
#define SCROL_BAR_MARGIN_BOTTOM  1
#define SCROLLBAR_MARGIN_RIGHT   1

@interface BRScrollBarView ()
{
    NSTimer *_fadingScrollBarTime;
    NSTimer *_animatingScrollBarWidthTimer;

    CGFloat _scrollBarNormalWidth;
    CGFloat _scrollBarMovingOffset;
    CGPoint _firstTouchLocation;
}
@property (nonatomic, weak) UIView *scrollBarView;
@end

@implementation BRScrollBarView
@synthesize hideScrollBar = _hideScrollBar;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIView *scrollBar = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                     SCROLL_BAR_MARGIN_TOP,
                                                                     frame.size.width,
                                                                     frame.size.height -    SCROLL_BAR_MARGIN_TOP*2)];
        _scrollBarView = scrollBar;
        [self doAdditionalSetup];
        
        _isDragging = NO;
        _showLabel = YES;
        _hideScrollBar = YES;
        _scrollBarNormalWidth = self.frame.size.width;
        
        _scrollHandle = [[BRScrollHandle alloc] initWithScrollBar:self];
        [self addSubview:_scrollHandle];
        [self initScrollLabel];
    }
    return self;
}

- (void) initScrollLabel
{
    CGFloat xPosForLabel = kIntBRLabelWidth + kIntBRScrollLabelMargin;
    if((self.frame.origin.x - xPosForLabel) > 0)
    {
        xPosForLabel *= -1;
    } else {
        xPosForLabel = kIntBRScrollLabelMargin + self.frame.size.width;
    }
    CGRect labelFrame = CGRectMake(xPosForLabel,
                                   0,
                                   0,
                                   kIntBRLabelHeight);
    
    _scrollLabel = [[BRScrollLabel alloc] initWithFrame:labelFrame];
    [self addSubview:self.scrollLabel];
    self.scrollLabel.text = @"";
    [self.scrollLabel hideLabel];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.delegate scrollBarDidLayoutSubviews:self];
}

- (void)doAdditionalSetup
{
    self.scrollBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.scrollBarView];
    
    _isScrollDirectionUp = NO;
    // set container view to transparent
    self.backgroundColor = [UIColor clearColor];
    self.scrollBarView.backgroundColor = [UIColor lightGrayColor];
    self.scrollBarView.alpha = 0.7;
    self.scrollBarView.layer.cornerRadius = 5;
}

#pragma mark - Public

- (void) viewDidScroll:(UIScrollView *)scrollView
{
    if(self.isDragging == NO)
    {
      
        [_fadingScrollBarTime invalidate];
        
        if(self.alpha != 0.5)
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.alpha = 0.5;
            }];
        }
        CGFloat scrollFactor = 0;
        CGFloat handlePosFactor = 0;
        
        if(scrollView.contentOffset.y == 0)
        {
            handlePosFactor = 0;
        } else {
            scrollFactor = (scrollView.contentSize.height ) / (scrollView.frame.size.height -
                                                               (self.scrollHandle.sizeDifference ));
            handlePosFactor = (scrollView.contentOffset.y ) / scrollFactor;
        }
        
        [self moveScrollHandleToPosition:CGPointMake(0, handlePosFactor)];
        if(self.hideScrollBar)
        {
            _fadingScrollBarTime = [NSTimer scheduledTimerWithTimeInterval:0.7
                                                                    target:self
                                                                  selector:@selector(fadeOutScrollBar)
                                                                  userInfo:nil repeats:NO];
        }
    }
}

- (void)setBRScrollBarContentSizeForScrollView:(UIScrollView *)scrollView
{
    CGRect superFrameRect = scrollView.frame;
    CGFloat scrollFactor = scrollView.contentSize.height / superFrameRect.size.height;
    CGFloat handleHeight = scrollView.frame.size.height  / scrollFactor;
    [self.scrollHandle setHandleHeight:handleHeight];
    if(self.hideScrollBar)
    {
        [NSTimer scheduledTimerWithTimeInterval:0.6
                                         target:self
                                       selector:@selector(fadeOutScrollBar)
                                       userInfo:nil repeats:NO];
    }
}

- (void)setBackgroundWithStretchableImage:(NSString *)imageName
{
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.scrollLabel.bounds];
    UIImage * overlay = [UIImage imageNamed:imageName];
    bg.image = [overlay stretchableImageWithLeftCapWidth:overlay.size.width/2.0
                                            topCapHeight:overlay.size.height/2.0];
    [self.scrollLabel addSubview:bg];
    [self.scrollLabel bringSubviewToFront:bg];
}

/*!
 * Overriding setBackgroundColor to set the bg color for
 * scrollBarView
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    self.layer.backgroundColor = [UIColor clearColor].CGColor;
    self.scrollBarView.backgroundColor = backgroundColor;
}

#pragma mark - Handling touhces

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.alpha <= 0)
    {
        [super touchesBegan:touches withEvent:event];
    } else {
        // - first cancel fading animation
        [_fadingScrollBarTime invalidate];
        
        // - make the scrollBar wider
        [self animateScrollBarWidthToWider];
        
        UITouch *touch = [touches anyObject];
        CGPoint locationOftouch = [touch locationInView:self];
        
        if(CGRectContainsPoint(self.scrollHandle.frame, locationOftouch))
        {
            _isDragging = YES;
            // the sequence here is important
            [self.scrollLabel hideLabel];
            [self.scrollLabel resetText];
            [self moveLabelToPoint:locationOftouch animated:YES];     // 1-
            [self moveContentOffsetOfTableViewWithHandle];            // 2-
            if(self.showLabel)
            {
                [self.scrollLabel showLabel];
            }
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.alpha <= 0)
    {
        [super touchesMoved:touches withEvent:event];
        return;
    } else {
        if(self.isDragging)
        {
            [_fadingScrollBarTime invalidate];
            
            UITouch *touch = [touches anyObject];
            CGPoint location2 = [touch locationInView:self];
            _firstTouchLocation = [touch previousLocationInView:self.scrollHandle];
            
            if(location2.y > _firstTouchLocation.y)
            {
                _isScrollDirectionUp = NO;
            }else {
                _isScrollDirectionUp = YES;
            }
            
            CGRect handleFrame = self.scrollHandle.frame;
            CGFloat yNewPos = location2.y - (_firstTouchLocation.y);
            [self moveLabelToPoint:CGPointMake(0, location2.y) animated:YES];
            
            if((yNewPos + handleFrame.size.height) > self.frame.size.height)
            {   
                yNewPos = self.frame.size.height - handleFrame.size.height;
                
            } else if ((yNewPos) < 0) {
                yNewPos = 0;
            }
            handleFrame.origin.y = yNewPos;
            self.scrollHandle.frame = handleFrame;
            [self moveContentOffsetOfTableViewWithHandle];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.frame.size.width >= SCROLL_BAR_TOUCHED_WIDTH)
    {
        _animatingScrollBarWidthTimer = [NSTimer scheduledTimerWithTimeInterval:0.9
                                                                         target:self
                                                                       selector:@selector(animateScrollBarWidthToNormal)
                                                                       userInfo:nil
                                                                        repeats:NO];
        
        [[NSRunLoop mainRunLoop] addTimer:_animatingScrollBarWidthTimer
                                  forMode:NSRunLoopCommonModes];
    } else {
       [super touchesEnded:touches withEvent:event]; 
    }
    _isDragging = NO;
}

#pragma mark - Animations methods

- (void)fadeOutScrollBar
{
    if(self.isDragging) return;
    
    [UIView animateWithDuration:0.6 animations:^{
        self.alpha = 0;
    }];
}



- (void)animateScrollBarWidthToNormal
{
    if(self.frame.size.width >= SCROLL_BAR_TOUCHED_WIDTH &&
       self.isDragging == NO)
    {
        CGRect scrollBarRect = self.frame;
        CGRect handleRect = self.scrollHandle.frame;
        
        scrollBarRect.size.width = _scrollBarNormalWidth;
        scrollBarRect.origin.x += _scrollBarMovingOffset;
        
        handleRect.size.width = self.scrollHandle.handleWidth;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = scrollBarRect;
            self.scrollHandle.frame = handleRect;
        }];
    }
    
    [self.scrollLabel hideLabel];
    if(self.hideScrollBar)
    {
        _fadingScrollBarTime = [NSTimer scheduledTimerWithTimeInterval:0.7
                                                                target:self
                                                              selector:@selector(fadeOutScrollBar)
                                                              userInfo:nil repeats:NO];
    }
}

/*! 
 * - Make the scrollBar bigger, so it can be easier to drag
 */
- (void)animateScrollBarWidthToWider
{
    if(self.frame.size.width >= SCROLL_BAR_TOUCHED_WIDTH)
    {
        [_animatingScrollBarWidthTimer invalidate];
        [_fadingScrollBarTime invalidate];
        return;
        
    } else {
        
        
        CGRect scrollBarRect = self.frame;
        scrollBarRect.size.width = SCROLL_BAR_TOUCHED_WIDTH;
        
        _scrollBarMovingOffset = SCROLL_BAR_TOUCHED_WIDTH/2 - 2;
        if((scrollBarRect.origin.x - _scrollBarMovingOffset) < 0)
        {
            _scrollBarMovingOffset = 0;
        }
        scrollBarRect.origin.x -= _scrollBarMovingOffset;
        
        CGRect handleRect = self.scrollHandle.frame;
        handleRect.size.width = SCROLL_BAR_TOUCHED_WIDTH - 2;
    
        [UIView animateWithDuration:0.15 animations:^{
            self.frame = scrollBarRect;
            self.scrollHandle.frame = handleRect;
        }];
    }
}

#pragma mark - Private

/*! 
 * - Changing the handle position by the user's manual scrolling
 */
- (void) moveScrollHandleToPosition:(CGPoint)position
{
    CGRect brHandleRect = self.scrollHandle.frame;
    if( (position.y + brHandleRect.size.height)  > self.frame.size.height)
    {
        position.y = self.frame.size.height - brHandleRect.size.height ;
        
    } else if ((position.y) < SCROLL_BAR_MARGIN_TOP) {
        position.y = SCROLL_BAR_MARGIN_TOP;
    }
    
    brHandleRect.origin.y = position.y;
    self.scrollHandle.frame = brHandleRect;
}

- (void)moveContentOffsetOfTableViewWithHandle
{
    CGPoint scrollHandlePos = self.scrollHandle.frame.origin;
    
    CGFloat sizeDiffirence = self.scrollHandle.sizeDifference;
    sizeDiffirence = (self.isScrollDirectionUp)?0:sizeDiffirence;
    scrollHandlePos.y += sizeDiffirence;
    
    [self.delegate scrollBar:self draggedToPosition:scrollHandlePos];
}

- (void) moveLabelToPoint:(CGPoint)point animated:(BOOL)animated
{
    CGRect labelRect = [self.scrollLabel frame];
    point = [self convertPoint:point fromView:self];
    
    if((point.y + labelRect.size.height + 4) > self.frame.size.height)
    {
        labelRect.origin.y = self.frame.size.height - (labelRect.size.height + 4);
    } else {
        labelRect.origin.y = point.y;
    }
    
    if(animated)
    {
        //[UIView animateWithDuration:0.1 animations:^{
            self.scrollLabel.frame = labelRect;
        //}];
    } else {
        self.scrollLabel.frame = labelRect;
    }
}

@end
