
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
	if (UIUtil::IsOS7())
	{
		self.automaticallyAdjustsScrollViewInsets = NO;
	}
	
	//
	CGFloat tabBarHeight = 44;
	
	CGRect frame = CGRectMake(0, (
#ifdef _CustomHeader
								  UIUtil::IsOS7() ? 22 :
#endif
								  0), 1024, tabBarHeight);
	_tabBar = [[UIView alloc] initWithFrame:frame];
	
#ifdef _CustomHeader
	frame.origin.y += tabBarHeight;
    _Log(@"PivotController viewDidLoaded frame.origin.y += tabBarHeight(%f);",tabBarHeight);
#endif
	frame.size.height = 768 - 66;
	_scrollView = [[PredictScrollView alloc] initWithFrame:frame];
	_scrollView.directionalLockEnabled = YES;
	_scrollView.bounces = NO;
	_scrollView.scrollEnabled = NO;
	//_scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_scrollView.delegate2 = self;
	_scrollView.backgroundColor = UIUtil::Color(241, 242, 245);
	[self.view addSubview:_scrollView];
	
	//
	_tabBar.userInteractionEnabled = YES;
#ifdef _CustomHeader
	_tabBar.backgroundColor = UIUtil::Color(235, 238, 250);
	[self.view addSubview:_tabBar];
#else
	self.navigationItem.titleView = _tabBar;
#endif
	
	//
	//UIImage *tabHeaderImage = UIUtil::ImageWithColor(117, 114, 184, 1, CGSizeMake(125, 2));	//UIUtil::Image(@"TabHeader");
	//frame = CGRectMake((1024 - tabHeaderImage.size.width * _viewControllers.count) / 2, tabBarHeight - tabHeaderImage.size.height - 6, tabHeaderImage.size.width, tabHeaderImage.size.height);
	//_tabHeader = [[UIImageView alloc] initWithFrame:frame];
	//_tabHeader.image = tabHeaderImage;//[tabHeaderImage stretchableImageWithLeftCapWidth:(tabHeaderImage.size.width / 2) topCapHeight:(tabHeaderImage.size.height / 2)];
	
	//
	frame.size.width = 126;
	frame.origin.x = (1024 - frame.size.width * _viewControllers.count) / 2;
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
	
	_tabHeader = [[UIView alloc] initWithFrame:CGRectZero];
	_tabHeader.backgroundColor = UIUtil::Color(117, 114, 184);
	[_tabBar addSubview:_tabHeader];
	_selectedIndex = -1;
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
	if (_selectedIndex != -1)
	{
		UIButton *oldButton = (UIButton *)[_tabBar viewWithTag:kTabButonTag + _selectedIndex];
		[oldButton setTitleColor:UIUtil::Color(60,60,60) forState:UIControlStateNormal];
		
		UIViewController *controller = [_viewControllers objectAtIndex:_selectedIndex];
		[controller viewWillDisappear:YES];
		[controller viewDidDisappear:YES];
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.4];
	}
	
	UIButton *curButton = (UIButton *)[_tabBar viewWithTag:kTabButonTag + index];
	[curButton setTitleColor:UIUtil::Color(117, 114, 184) forState:UIControlStateNormal];
	
	//
	CGRect frame, buttonFrame = curButton.frame;
	frame.size = [curButton.currentTitle sizeWithFont:curButton.titleLabel.font];
	frame.origin.y = (buttonFrame.size.height - frame.size.height) / 2 + frame.size.height + 2;
	frame.size.height = 2;
	frame.origin.x = buttonFrame.origin.x + (buttonFrame.size.width - frame.size.width) / 2;
	_tabHeader.frame = frame;
	
	if (_selectedIndex != -1)
	{
		[UIView commitAnimations];
	}
	
	//
	_selectedIndex = index;
	UIViewController *controller = [_viewControllers objectAtIndex:_selectedIndex];
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
