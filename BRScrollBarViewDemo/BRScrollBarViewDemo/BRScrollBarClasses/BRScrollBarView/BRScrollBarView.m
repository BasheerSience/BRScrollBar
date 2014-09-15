
#import "BRScrollBarView.h"
#import  <QuartzCore/QuartzCore.h>
#import "BRCommonMethods.h"

const CGFloat kBRScrollBarWidthInTouchedState = 12;
const CGFloat kBRScrollBarMarginFromTop       = 1;

@interface BRScrollBarView ()
@property (nonatomic, weak) id<BRScrollBarViewPrivateProtocol> privateDelegate;
@property (nonatomic, strong) NSTimer *fadingScrollBarTime;
@property (nonatomic, strong) NSTimer *animatingScrollBarWidthTimer;
@property (nonatomic, assign) CGFloat scrollBarNormalWidth;
@property (nonatomic, assign) CGFloat scrollBarMovingOffset;
@property (nonatomic, assign) CGPoint beginningTouchLocation;
@property (nonatomic, assign) BOOL isScrollDirectionUp;
@property (nonatomic, weak)   UIView *scrollBarView;

@end


@implementation BRScrollBarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *scrollBar = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                     kBRScrollBarMarginFromTop,
                                                                     frame.size.width,
                                                                     frame.size.height -    kBRScrollBarMarginFromTop * 2)];
        _scrollBarView = scrollBar;
        [self doAdditionalSetup];
        
        _isDragging = NO;
        self.showLabel = YES;
        self.hideScrollBar = YES;
        self.scrollBarNormalWidth = self.frame.size.width;
        
        BRScrollHandle *scrollHandle = [[BRScrollHandle alloc] initWithScrollBarView:self];
        [self addSubview:scrollHandle];
        _scrollHandle = scrollHandle;
        self.privateDelegate = (id<BRScrollBarViewPrivateProtocol>)self.scrollHandle;
        [self initScrollLabel];
    }
    return self;
}

- (void)initScrollLabel {
    
    CGFloat xPosForLabel = kIntBRLabelWidth + kIntBRScrollLabelMargin;
    
    if((self.frame.origin.x - xPosForLabel) > 0) {
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

-(void)layoutSubviews {
    [super layoutSubviews];
    [self.delegate scrollBarDidLayoutSubviews:self];
}

- (void)doAdditionalSetup {
    
    self.scrollBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.scrollBarView];
    
    self.isScrollDirectionUp = NO;
    // set container view to transparent
    self.backgroundColor = [UIColor clearColor];
    self.scrollBarView.backgroundColor = [UIColor lightGrayColor];
    self.scrollBarView.alpha = 0.7;
    self.scrollBarView.layer.cornerRadius = 5;
}

#pragma mark - Public

- (void)viewDidScroll:(UIScrollView *)scrollView {
    
    if(self.isDragging == NO) {
        [self.fadingScrollBarTime invalidate];
        
        if(self.alpha != 0.5) {
            [UIView animateWithDuration:0.3 animations:^{
                self.alpha = 0.5;
            }];
        }
        CGFloat scrollFactor = 0;
        CGFloat handlePosFactor = 0;
        
        if(scrollView.contentOffset.y == 0) {
            handlePosFactor = 0;
        } else {
            scrollFactor = (scrollView.contentSize.height ) / (scrollView.frame.size.height -
                                                               (self.privateDelegate.sizeDifference ));
            handlePosFactor = (scrollView.contentOffset.y ) / scrollFactor;
        }
        
        [self moveScrollHandleToPosition:CGPointMake(0, handlePosFactor)];
        if(self.hideScrollBar) {
            self.fadingScrollBarTime = [NSTimer scheduledTimerWithTimeInterval:0.7
                                                                    target:self
                                                                  selector:@selector(fadeOutScrollBar)
                                                                  userInfo:nil repeats:NO];
        }
    }
}

- (void)setBRScrollBarContentSizeForScrollView:(UIScrollView *)scrollView {
    CGRect superFrameRect = scrollView.frame;
    CGFloat scrollFactor = scrollView.contentSize.height / superFrameRect.size.height;
    CGFloat handleHeight = scrollView.frame.size.height  / scrollFactor;
    [self.privateDelegate setHandleHeight:handleHeight];
    
    if(self.hideScrollBar) {
        [NSTimer scheduledTimerWithTimeInterval:0.6
                                         target:self
                                       selector:@selector(fadeOutScrollBar)
                                       userInfo:nil repeats:NO];
    }
}

- (void)setBackgroundWithStretchableImage:(NSString *)imageName {
    
    UIImageView *bg = [[UIImageView alloc] initWithFrame:self.scrollLabel.bounds];
    UIImage *overlay = [UIImage imageNamed:imageName];
    bg.image = [overlay stretchableImageWithLeftCapWidth:overlay.size.width/2.0
                                            topCapHeight:overlay.size.height/2.0];
    [self.scrollLabel addSubview:bg];
    [self.scrollLabel bringSubviewToFront:bg];
}

/*!
 * Overriding setBackgroundColor to set the bg color for
 * scrollBarView
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor {
    self.layer.backgroundColor = [UIColor clearColor].CGColor;
    self.scrollBarView.backgroundColor = backgroundColor;
}

#pragma mark - Handling touhces

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(self.alpha <= 0) {
        [super touchesBegan:touches withEvent:event];
    } else {
        // - first cancel fading animation
        [self.fadingScrollBarTime invalidate];
        
        // - make the scrollBar wider
        [self animateScrollBarWidthToWider];
        
        UITouch *touch = [touches anyObject];
        CGPoint locationOftouch = [touch locationInView:self];
        
        if(CGRectContainsPoint(self.scrollHandle.frame, locationOftouch)) {
            _isDragging = YES;
            // the sequence here is important
            [self.scrollLabel hideLabel];
            [self.scrollLabel resetText];
            [self moveLabelToPoint:locationOftouch animated:YES];     // 1-
            [self moveContentOffsetOfTableViewWithHandle];            // 2-
            if(self.showLabel) {
                [self.scrollLabel showLabel];
            }
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(self.alpha <= 0) {
        [super touchesMoved:touches withEvent:event];
        return;
    } else {
        
        if(self.isDragging) {
            [self.fadingScrollBarTime invalidate];
            
            UITouch *touch = [touches anyObject];
            CGPoint location2 = [touch locationInView:self];
            self.beginningTouchLocation = [touch previousLocationInView:self.scrollHandle];
            
            if(location2.y > self.beginningTouchLocation.y) {
                self.isScrollDirectionUp = NO;
            }else {
                self.isScrollDirectionUp = YES;
            }
            
            CGRect handleFrame = self.scrollHandle.frame;
            CGFloat yNewPos = location2.y - (self.beginningTouchLocation.y);
            [self moveLabelToPoint:CGPointMake(0, location2.y) animated:YES];
            
            if((yNewPos + handleFrame.size.height) > self.frame.size.height) {
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

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if(self.frame.size.width >= kBRScrollBarWidthInTouchedState) {
        self.animatingScrollBarWidthTimer = [NSTimer scheduledTimerWithTimeInterval:0.9
                                                                         target:self
                                                                       selector:@selector(animateScrollBarWidthToNormal)
                                                                       userInfo:nil
                                                                        repeats:NO];
        
        [[NSRunLoop mainRunLoop] addTimer:self.animatingScrollBarWidthTimer
                                  forMode:NSRunLoopCommonModes];
    } else {
       [super touchesEnded:touches withEvent:event]; 
    }
    _isDragging = NO;
}

#pragma mark - Animations methods

- (void)fadeOutScrollBar {
    if(!self.isDragging) {
        [UIView animateWithDuration:0.6 animations:^{
            self.alpha = 0;
        }];
    }
}

- (void)animateScrollBarWidthToNormal {
    
    if(self.frame.size.width >= kBRScrollBarWidthInTouchedState &&
       self.isDragging == NO) {
        
        CGRect scrollBarRect = self.frame;
        CGRect handleRect = self.scrollHandle.frame;
        
        scrollBarRect.size.width = self.scrollBarNormalWidth;
        scrollBarRect.origin.x += self.scrollBarMovingOffset;
        
        handleRect.size.width = self.scrollHandle.handleWidth;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = scrollBarRect;
            self.scrollHandle.frame = handleRect;
        }];
    }
    
    [self.scrollLabel hideLabel];
    if(self.hideScrollBar) {
        self.fadingScrollBarTime = [NSTimer scheduledTimerWithTimeInterval:0.7
                                                                target:self
                                                              selector:@selector(fadeOutScrollBar)
                                                              userInfo:nil repeats:NO];
    }
}

/*! 
 * - Make the scrollBar bigger, so it can be easier to drag
 */
- (void)animateScrollBarWidthToWider {
    if(self.frame.size.width >= kBRScrollBarWidthInTouchedState)
    {
        [self.animatingScrollBarWidthTimer invalidate];
        [self.fadingScrollBarTime invalidate];
        return;
        
    } else {
        CGRect scrollBarRect = self.frame;
        scrollBarRect.size.width = kBRScrollBarWidthInTouchedState;
        self.scrollBarMovingOffset = kBRScrollBarWidthInTouchedState/2 - 2;
        
        if((scrollBarRect.origin.x - self.scrollBarMovingOffset) < 0) {
            self.scrollBarMovingOffset = 0;
        }
        
        scrollBarRect.origin.x -= self.scrollBarMovingOffset;
        CGRect handleRect = self.scrollHandle.frame;
        handleRect.size.width = kBRScrollBarWidthInTouchedState - 2;
    
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
- (void) moveScrollHandleToPosition:(CGPoint)position {
    
    CGRect brHandleRect = self.scrollHandle.frame;
    if( (position.y + brHandleRect.size.height)  > self.frame.size.height) {
        position.y = self.frame.size.height - brHandleRect.size.height ;
    } else if (position.y < kBRScrollBarMarginFromTop) {
        position.y = kBRScrollBarMarginFromTop;
    }
    
    brHandleRect.origin.y = position.y;
    self.scrollHandle.frame = brHandleRect;
}

- (void)moveContentOffsetOfTableViewWithHandle {
    
    CGPoint scrollHandlePos = self.scrollHandle.frame.origin;
    CGFloat sizeDiffirence = self.privateDelegate.sizeDifference;
    sizeDiffirence = (self.isScrollDirectionUp)?0:sizeDiffirence;
    scrollHandlePos.y += sizeDiffirence;
    [self.delegate scrollBar:self draggedToPosition:scrollHandlePos];
}

- (void)moveLabelToPoint:(CGPoint)point animated:(BOOL)animated {
    
    CGRect labelRect = [self.scrollLabel frame];
    point = [self convertPoint:point fromView:self];
    
    if((point.y + labelRect.size.height + 4) > self.frame.size.height) {
        labelRect.origin.y = self.frame.size.height - (labelRect.size.height + 4);
    } else {
        labelRect.origin.y = point.y;
    }
    
    if(animated) {
        [UIView animateWithDuration:0.0 animations:^{
            self.scrollLabel.frame = labelRect;
        }];
    } else {
        self.scrollLabel.frame = labelRect;
    }
}

@end
