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


@implementation BRScrollLabel
@synthesize text = _text;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        self.layer.cornerRadius = 10;
        self.backgroundColor = [UIColor blueColor];
     
        
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|
                                UIViewAutoresizingFlexibleTopMargin;
        
        
        CGRect labelRect = CGRectMake(0,
                                      0,
                                      kIntBRLabelWidth,
                                      self.frame.size.height);
        _textLabel = [[UILabel alloc] initWithFrame:labelRect];
        
        _textLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin  |
                                      UIViewAutoresizingFlexibleBottomMargin|
                                      UIViewAutoresizingFlexibleHeight      |
                                      UIViewAutoresizingFlexibleLeftMargin  |
                                      UIViewAutoresizingFlexibleRightMargin;
        
        self.clipsToBounds = YES;
        
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textColor = [UIColor whiteColor];
        
        _textLabel.shadowColor = [UIColor blackColor];
        _textLabel.shadowOffset = CGSizeMake(0, -1);
        
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [_textLabel setFont:[UIFont systemFontOfSize:14]];
        
        [self addSubview:_textLabel];
    }
    return self;
}


- (void)resetText
{
    _textLabel.text = @"";
    
}

- (void)setText:(NSString *)text
{

    if(!text || text.length <= 0)
    {
        return;
    }
    
    _textLabel.text = text;
    
    
    //[_textLabel sizeToFit];
    [self showLabel];
}

- (NSString *)text
{
    return _textLabel.text;
}

- (void)showLabel
{
    // only show text if is it not empty or not nil
    if(self.text && ![self.text isEqualToString:@""] && self.text.length > 0)
    {
        [UIView animateWithDuration:0.2 animations:^{
            [self setLabelSizeToMatchText];
        }];
    }
}

- (void)hideLabel
{
    CGRect zeroRect = self.frame;
    zeroRect.size.width = 0.0;
    //zeroRect.size.height = 0.0;
    
    [UIView animateWithDuration:0.1 animations:^{
        self.frame = zeroRect;
    }];
    
}

// makes the label bigger or smaller
- (void)setLabelSizeToMatchText
{
    CGRect labelFrame = self.frame;
    labelFrame.size.width = _textLabel.frame.size.width ;
    
   // NSInteger labelPosiFactor  = (labelFrame.origin.x < 0)? -1:1;
    //labelFrame.origin.x = 0;//((labelFrame.size.width/2) * labelPosiFactor);
    
    
    self.frame = labelFrame;
}

- (CGFloat ) labelWidth
{
    return _textLabel.bounds.size.width;
}

- (void) setLabelWidth:(CGFloat)labelWidth
{
    CGRect textLabelRect = _textLabel.frame;
    textLabelRect.size.width = labelWidth;
    _textLabel.frame = textLabelRect;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    
}

@end
