

#import "BaseController.h"


//
@interface PivotController : BaseController <PredictScrollViewDelegate>
{
@private
	UIView *_tabBar;
	UIImageView *_tabHeader;

	NSUInteger _selectedIndex;
	NSArray *_viewControllers;

	PredictScrollView *_scrollView;
}

@property(nonatomic,assign) NSUInteger selectedIndex;
@property(nonatomic,retain) NSArray *viewControllers;
@property(nonatomic,readonly) UIView *tabBar;
@property(nonatomic,readonly) PredictScrollView *scrollView;

@end
