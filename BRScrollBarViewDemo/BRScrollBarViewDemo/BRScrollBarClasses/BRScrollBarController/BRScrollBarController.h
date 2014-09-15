
#import <Foundation/Foundation.h>
#import "BRScrollBarView.h"
#import "BRCommonMethods.h"

typedef NS_ENUM(NSUInteger, BRScrollBarPostion) {
    BRScrollBarPostionLeft,
    BRScrollBarPostionRight
};

@protocol BRScrollBarControllerDelegate ;

@interface BRScrollBarController : UIViewController  <BRScrollBarProtocol>

@property (nonatomic, assign) BRScrollBarPostion scrollBarPostion;
@property (nonatomic, weak, readonly) BRScrollBarView *scrollBar;
@property (nonatomic, weak) id<BRScrollBarControllerDelegate> delegate;

- (instancetype)initWithScrollView:(UIScrollView *)scrollView;
- (instancetype)initWithScrollView:(UIScrollView *)scrollView
              inPosition:(BRScrollBarPostion)position;

/*!
 * You should retain a refrence to the returned instance or otherwise 
 * the instance will be destroyed when this method called again later
 */
+ (instancetype)setupScrollBarWithScrollView:(UIScrollView *)scrollView
                        inPosition:(BRScrollBarPostion)position
                          delegate:(id<BRScrollBarControllerDelegate>)delegate;


@end

//===========Protocol==========//
@protocol BRScrollBarControllerDelegate <NSObject>

@optional
/*!
 * Respond to BRScrollBarController delegate to set the label's text
 */
- (NSString *)brScrollBarController:(BRScrollBarController *)controller     textForCurrentPosition:(CGPoint)position;

@end