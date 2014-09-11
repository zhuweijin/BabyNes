

#import "BaseController.h"
#define kTabButonTag 12312
//
@interface PivotController : BaseController <PredictScrollViewDelegate>
{
@private
	UIView *_tabBar;
	UIView *_tabHeader;

	NSUInteger _selectedIndex;
	NSArray *_viewControllers;

	PredictScrollView *_scrollView;
}

@property(nonatomic,assign) NSUInteger selectedIndex;
@property(nonatomic,retain) NSArray *viewControllers;
@property(nonatomic,readonly) UIView *tabBar;
@property(nonatomic,readonly) PredictScrollView *scrollView;

- (void)onTabButton:(UIButton *)button;

@end
