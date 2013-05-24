//
//  BRCommonMethods.h
//  BRScrollBarDemo
//
//  Created by Basheer on 5/3/13.
//  Copyright (c) 2013 Basheer. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum
{
    kIntBRScrollBarPositionLeft,
    kIntBRScrollBarPositionRight
}BRScrollBarPostions;

extern const int kIntBRLabelWidth;
extern const int kIntBRLabelHeight;
extern const int kIntBRScrollBarWidth;
extern const int kIntBRScrollLabelMargin;

@interface BRCommonMethods : NSObject

+ (BOOL) isInterfaceOrientaionLandScape;


@end

