
#import <UIKit/UIKit.h>

@class BRScrollBarView;
@interface BRScrollHandle : UIView
@property (nonatomic, assign)  CGFloat handleWidth;
- (instancetype)initWithScrollBarView:(BRScrollBarView *)scrollBarView;
@end


