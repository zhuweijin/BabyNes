
#import "PivotController.h"


@implementation PivotController

#pragma mark Generic methods

// Constructor
//- (id)init
//{
//	self = [super init];
//	return self;
//}


#pragma mark View methods

// Creates the view that the controller manages.
//- (void)loadView
//{
//}

// Do additional setup after loading the view.
#define kTabButonTag 12312
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.view.backgroundColor = UIUtil::Color(235, 238, 250);
	
	//
	CGRect bounds = self.view.bounds;
	CGFloat tabBarHeight = 44;
	
	CGRect frame = CGRectMake(0, (UIUtil::IsOS7() ? 22 : 0), 1024, tabBarHeight);
	_tabBar = [[UIView alloc] initWithFrame:frame];

	frame.origin.y += tabBarHeight;
	frame.size.height = bounds.size.height - frame.origin.y;
	_scrollView = [[PredictScrollView alloc] initWithFrame:frame];
	_scrollView.directionalLockEnabled = YES;
	//_scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_scrollView.delegate2 = self;
	_scrollView.backgroundColor = UIUtil::Color(241, 242, 245);
	[self.view addSubview:_scrollView];

	//
	_tabBar.userInteractionEnabled = YES;
	_tabBar.backgroundColor = UIUtil::Color(235, 238, 250);
	[self.view addSubview:_tabBar];

	//
	UIImage *tabHeaderImage = UIUtil::ImageWithColor(117, 114, 184, 1, CGSizeMake(125, 2));	//UIUtil::Image(@"TabHeader");
	frame = CGRectMake((1024 - tabHeaderImage.size.width * _viewControllers.count) / 2, tabBarHeight - tabHeaderImage.size.height - 6, tabHeaderImage.size.width, tabHeaderImage.size.height);
	_tabHeader = [[UIImageView alloc] initWithFrame:frame];
	_tabHeader.image = tabHeaderImage;//[tabHeaderImage stretchableImageWithLeftCapWidth:(tabHeaderImage.size.width / 2) topCapHeight:(tabHeaderImage.size.height / 2)];

	//
	frame.origin.y = 0;
	frame.size.height = 44;
	for (NSUInteger i = 0; i < _viewControllers.count; i++)
	{
		UIViewController *controller = [_viewControllers objectAtIndex:i];
		UIButton *button = [[UIButton alloc] initWithFrame:frame];
		button.titleLabel.font = [UIFont systemFontOfSize:18];
		button.titleLabel.adjustsFontSizeToFitWidth = YES;
		[button setTitle:controller.title forState:UIControlStateNormal];
		[button setTitleColor:UIUtil::Color(60,60,60) forState:UIControlStateNormal];
		[button setTitleColor:UIUtil::Color(117, 114, 184) forState:UIControlStateHighlighted];
		button.tag = kTabButonTag + i;
		[button addTarget:self action:@selector(onTabButton:) forControlEvents:UIControlEventTouchUpInside];
		[_tabBar addSubview:button];
	
		frame.origin.x += frame.size.width;

		//[self onTabButton:button];
	}
	
	[_tabBar addSubview:_tabHeader];
}

// Called when the view is about to made visible.
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	if (_scrollView.numberOfPages == 0)
	{
		_scrollView.numberOfPages = _viewControllers.count;
		_scrollView.currentPage = _selectedIndex;
	}

	[[_viewControllers objectAtIndex:_selectedIndex] viewWillAppear:animated];
}

// Called after the view was dismissed, covered or otherwise hidden.
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[[_viewControllers objectAtIndex:_selectedIndex] viewWillDisappear:animated];
}

// Notifies when rotation begins.
//- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{
//	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
//}

// Release any cached data, images, etc that aren't in use.
- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	[_viewControllers makeObjectsPerformSelector:@selector(didReceiveMemoryWarning)];

	[_scrollView freePages:YES];
}


#pragma mark Scroll view methods

//
- (UIView *)scrollView:(PredictScrollView *)scrollView viewForPage:(NSUInteger)index inFrame:(CGRect)frame
{
	UIViewController *controller = [_viewControllers objectAtIndex:index];
	controller.view.frame = frame;
	return controller.view;
}

//
- (void)scrollView:(PredictScrollView *)scrollView scrollToPage:(NSUInteger)index
{
	//
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.4];
	CGRect frame = _tabHeader.frame;
	frame.origin.x = (1024 - frame.size.width * _viewControllers.count) / 2 + index * frame.size.width;
	_tabHeader.frame = frame;
	[UIView commitAnimations];

	//
	UIViewController *controller = [_viewControllers objectAtIndex:_selectedIndex];
	[controller viewWillDisappear:YES];
	[controller viewDidDisappear:YES];

	[(UIButton *)[_tabBar viewWithTag:kTabButonTag + _selectedIndex] setTitleColor:UIUtil::Color(60,60,60) forState:UIControlStateNormal];
	
	_selectedIndex = index;
	
	[(UIButton *)[_tabBar viewWithTag:kTabButonTag + _selectedIndex] setTitleColor:UIUtil::Color(117, 114, 184) forState:UIControlStateNormal];
	
	controller = [_viewControllers objectAtIndex:_selectedIndex];
	[controller viewWillAppear:YES];
	[controller viewDidAppear:YES];
}


#pragma mark Event methods

//
- (void)onTabButton:(UIButton *)button
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.4];
	_scrollView.currentPage = button.tag - kTabButonTag;
	[UIView commitAnimations];
}

@end
