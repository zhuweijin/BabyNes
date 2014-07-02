
#import "RootController.h"
#import "LoginController.h"
#import "SettingController.h"
#import "LSShopViewController.h"
#import "IntroduceController.h"
#import "MaterialController.h"
#import "MessageController.h"

@implementation RootController

#pragma mark Generic methods

// Constructor
- (id)init
{
	self = [super init];
	
	self.viewControllers = @[
							 [[LSShopViewController alloc] init],
							 [[IntroduceController alloc] init],
							 [[MaterialController alloc] init],
							 [[MessageController alloc] init],
							 ];
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
#ifndef _CustomHeader
	self.navigationItem.hidesBackButton = YES;
#endif
	//self.view.backgroundColor = UIUtil::Color(239, 239, 244);
	
	UIButton *menuButton = [UIButton buttonWithTitle:nil name:@"Menu" width:45];
	[menuButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[self.tabBar addSubview:menuButton];
	
	UIImageView *logoView = [[UIImageView alloc] initWithImage:UIUtil::Image(@"HomeLogo")];
	logoView.frame = CGRectMake(45, 0, logoView.frame.size.width, logoView.frame.size.height);
	[self.tabBar addSubview:logoView];
	
	UIButton *exitButton = [UIButton minorButtonWithTitle:NSLocalizedString(@"Exit", @"退出") width:85];
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
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
#ifdef _CustomHeader
	[self.navigationController setNavigationBarHidden:YES animated:YES];
#else
	[self.navigationController setNavigationBarHidden:NO animated:YES];
#endif
}

// Called after the view was dismissed, covered or otherwise hidden.
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
#ifdef _CustomHeader
	[self.navigationController setNavigationBarHidden:NO animated:YES];
#endif
}

#pragma Event methods

//
- (void)menuButtonClicked:(UIButton *)sender
{
	UIViewController *controller = [[SettingController alloc] init];
	[self.navigationController pushViewController:controller animated:YES];
}

//
- (void)exitButtonClicked:(UIButton *)sender
{
	Settings::Save(kAccessToken);
	UIViewController *controller = [[LoginController alloc] init];
	[self.navigationController setViewControllers:@[controller] animated:NO];
}

@end
