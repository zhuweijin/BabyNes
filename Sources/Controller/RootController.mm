
#import "RootController.h"
#import "LoginController.h"

@implementation RootController

#pragma mark Generic methods

// Constructor
- (id)init
{
	self = [super init];
	UIViewController *controller2 = [[BaseController alloc] init];
	UIViewController *controller1 = [[BaseController alloc] init];
	UIViewController *controller3 = [[BaseController alloc] init];
	UIViewController *controller4 = [[BaseController alloc] init];
	controller1.title = NSLocalizedString(@"Products", @"产品介绍");
	controller2.title = NSLocalizedString(@"Sale", @"购买产品");
	controller3.title = NSLocalizedString(@"Media", @"媒体中心");
	controller4.title = NSLocalizedString(@"SR Center", @"SR管理");
	controller1.view.backgroundColor = UIColor.lightGrayColor;
	controller2.view.backgroundColor = UIColor.greenColor;
	controller3.view.backgroundColor = UIColor.blueColor;
	controller4.view.backgroundColor = UIColor.yellowColor;

	self.viewControllers = @[controller1, controller2, controller3, controller4];
	return self;
}

#pragma mark View methods

// Creates the view that the controller manages.
//- (void)loadView
//{
//	[super loadView];
//}

// Do additional setup after loading the view.
- (void)viewDidLoad
{
	[super viewDidLoad];
	//self.view.backgroundColor = UIUtil::Color(239, 239, 244);
	
	UIButton *menuButton = [UIButton buttonWithTitle:nil name:@"Menu" width:45];
	[self.tabBar addSubview:menuButton];
	
	UIImageView *logoView = [[UIImageView alloc] initWithImage:UIUtil::Image(@"HomeLogo")];
	logoView.frame = CGRectMake(45, 0, logoView.frame.size.width, logoView.frame.size.height);
	[self.tabBar addSubview:logoView];

	UIButton *exitButton = [UIButton buttonWithTitle:NSLocalizedString(@"Exit", @"退出") name:@"Push" width:85];
	exitButton.center = CGPointMake(self.tabBar.frame.size.width - 20 - 85/2, self.tabBar.frame.size.height / 2);
	[exitButton addTarget:self action:@selector(exitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[self.tabBar addSubview:exitButton];
}

// Called after the view controller's view is released and set to nil.
//- (void)viewDidUnload
//{
//	[super viewDidUnload];
//}

// Called when the view is about to made visible.
//- (void)viewWillAppear:(BOOL)animated
//{
//	[super viewWillAppear:animated];
//}

// Called after the view was dismissed, covered or otherwise hidden.
//- (void)viewWillDisappear:(BOOL)animated
//{
//	[super viewWillDisappear:animated];
//}

#pragma Event methods

//
- (void)exitButtonClicked:(UIButton *)sender
{
	UIViewController *controller = [[LoginController alloc] init];
	[self.navigationController setViewControllers:@[controller] animated:NO];
}

@end
