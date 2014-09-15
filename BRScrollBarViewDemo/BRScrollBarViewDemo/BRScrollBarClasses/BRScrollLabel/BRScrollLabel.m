//
//  BRScrollLabel.m
//  BRScrollBarDemo
//
//  Created by Basheer on 5/3/13.
//  Copyright (c) 2013 Basheer. All rights reserved.
//

#import "BRScrollLabel.h"
#import <QuartzCore/QuartzCore.h>
#import "BRCommonMethods.h"

const CGFloat kBRScrollBarLabelDistanceFromScrollBar = 44;
const CGFloat  kBRScrollBarLabelFonSize = 20;

@interface BRScrollLabel ()
@property (nonatomic, weak) UILabel *textLabel;
@end

@implementation BRScrollLabel

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        self.layer.cornerRadius = 10;
        self.backgroundColor = [UIColor blueColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|
                                UIViewAutoresizingFlexibleTopMargin;
        
        [self addTextLabel];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)resetText {
    _textLabel.text = @"";
}

- (void)addTextLabel {
    CGRect labelRect = CGRectMake(0,
                                  0,
                                  kIntBRLabelWidth,
                                  self.frame.size.height);
    UILabel *lbl = [[UILabel alloc] initWithFrame:labelRect];
    
    _textLabel = lbl;
    _textLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin  |
    UIViewAutoresizingFlexibleBottomMargin|
    UIViewAutoresizingFlexibleHeight      |
    UIViewAutoresizingFlexibleLeftMargin  |
    UIViewAutoresizingFlexibleRightMargin;
    
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.textColor = [UIColor whiteColor];
    
    _textLabel.shadowColor = [UIColor blackColor];
    _textLabel.shadowOffset = CGSizeMake(0, -1);
    
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.font = [UIFont fontWithName:@"CourierNewPS-BoldMT" size:kBRScrollBarLabelFonSize];
    [self addSubview:_textLabel];
}

- (void)setText:(NSString *)text {
    if(!text.length) {
        return;
    }
    self.textLabel.text = text;
    [self showLabel];
}

- (NSString *)text {
    return self.textLabel.text;
}

- (void)showLabel {
    // only show text if is it not empty or not nil
    if(self.text &&
       ![self.text isEqualToString:@""] &&
       self.text.length > 0) {
        
        [UIView animateWithDuration:0.2 animations:^{
            [self setLabelSizeToMatchText];
        }];
    }
}

- (void)hideLabel {
    CGRect zeroRect = self.frame;
    zeroRect.size.width = 0.0;
    
    [UIView animateWithDuration:0.1 animations:^{
        self.frame = zeroRect;
    }];
}

// makes the label bigger or smaller
- (void)setLabelSizeToMatchText {
    CGRect labelFrame = self.frame;
    labelFrame.size.width = self.textLabel.frame.size.width + 2;
    
    NSInteger labelPosiFactor  = (labelFrame.origin.x < 0)? -1:1;
    CGFloat   labelWidth       = (labelFrame.origin.x < 0)? labelFrame.size.width:0;
    labelFrame.origin.x =  (labelWidth + kBRScrollBarLabelDistanceFromScrollBar) * labelPosiFactor;
    self.frame = labelFrame;
}

- (CGFloat )labelWidth {
    return self.textLabel.bounds.size.width;
}

- (void)setLabelWidth:(CGFloat)labelWidth {
    
    CGRect textLabelRect = _textLabel.frame;
    textLabelRect.size.width = labelWidth;
    self.textLabel.frame = textLabelRect;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    // not implemented yet
}

@end
