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
        self.backgroundColor = [UIColor blueColor];//[UIColor colorWithRed:0 green:0 blue:0 alpha:1];//[UIColor blackColor];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|
                                UIViewAutoresizingFlexibleTopMargin;
        
        CGRect labelRect = CGRectMake( 4,3,
                                      kIntBRLabelWidth,
                                      kIntBRLabelHeight/2);
        _textLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin |
                                      UIViewAutoresizingFlexibleBottomMargin |
                                      UIViewAutoresizingFlexibleWidth;
        self.clipsToBounds = YES;
        _textLabel = [[UILabel alloc] initWithFrame:labelRect];
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

- (id) initWithPosition:(CGPoint)position
{
    CGRect viewRect = CGRectMake(position.x,
                                 position.y,
                                 kIntBRLabelWidth,
                                 kIntBRLabelHeight);
    self = [self initWithFrame:viewRect];
    if(self)
    {
        
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
    
    
    [_textLabel sizeToFit];
    [self showLabel];
}

- (NSString *)text
{
    return _textLabel.text;
}

- (void)showLabel
{
    // only show text if is it not empty or not nil
    if(self.text && ![self.text isEqualToString:@""])
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
        labelFrame.size.width = _textLabel.frame.size.width + 40;
    
        NSInteger labelPosiFactor  = (labelFrame.origin.x < 0)? -1:1;
        labelFrame.origin.x = ((labelFrame.size.width + 30) * labelPosiFactor);
    
        self.frame = labelFrame;
}


@end
