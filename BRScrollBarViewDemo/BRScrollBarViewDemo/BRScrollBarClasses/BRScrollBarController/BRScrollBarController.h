//
//  BRScrollBarController.h
//  BRScrollBarDemo
//
//  Created by Basheer on 5/2/13.
//  Copyright (c) 2013 Basheer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRScrollBarView.h"
#import "BRCommonMethods.h"

@protocol BRScrollBarControllerDelegate ;
@interface BRScrollBarController : UIViewController  <BRScrollBarProtocol>

/*!
 *  Description - The potion of the scrollBar.
 * @code
 *     kIntBRScrollBarPositionLeft,
 *     kIntBRScrollBarPositionRight
 * @endcode
 */
@property (nonatomic, assign) BRScrollBarPostions scrollBarPostion;
@property (nonatomic, readonly) BRScrollBarView *scrollBar;
@property (nonatomic, weak) id<BRScrollBarControllerDelegate> delegate;

- (id)initForScrollView:(UIScrollView *)scrollView;
- (id)initForScrollView:(UIScrollView *)scrollView inPosition:(BRScrollBarPostions)position;
+ (id)initForScrollView:(UIScrollView *)scrollView inPosition:(BRScrollBarPostions)position
               delegate:(id<BRScrollBarControllerDelegate>)delegate;


@end

//=================================Protocol===============================================//
@protocol BRScrollBarControllerDelegate <NSObject>
@optional
/*!
 * Respond to BRScrollBarController delegate to add text to the label
 */
- (NSString *)brScrollBarController:(BRScrollBarController *)controller textForCurrentPosition:(CGPoint)position;

@end
//=========================================================================================//