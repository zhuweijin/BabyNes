
#import "AppDelegate.h"
#import "RootController.h"
#import "LoginController.h"

//
@implementation AppDelegate

#pragma mark Generic methods

#pragma mark Monitoring Application State Changes

// The application has launched and may have additional launch options to handle.
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	UIUtil::ShowStatusBar(YES/*, UIStatusBarAnimationSlide*/);
	
	// Create window
	_window = [[UIWindow alloc] initWithFrame:UIUtil::ScreenBounds()];
	
	// Create controller
	// TODO: Remove navigation controller
	DataLoader.accessToken = Settings::Get(kAccessToken);
	UIViewController *controller = DataLoader.accessToken ? [[RootController alloc] init] : [[LoginController alloc] init];
	UINavigationController *navigator = [[UINavigationController alloc] initWithRootViewController:controller];
#ifdef _CustomHeader
	navigator.navigationBarHidden = YES;
#else
	//navigator.navigationBar.translucent = NO;
	[navigator.navigationBar setBackgroundImage:UIUtil::ImageWithColor(235, 238, 250) forBarMetrics:UIBarMetricsDefault];
	if (!UIUtil::IsOS7())
	{
		navigator.navigationBar.shadowImage = UIUtil::ImageWithColor(163, 163, 163, 1, CGSizeMake(0.5, 0.5));//UIUtil::Image(@"NaviBar_");
		navigator.navigationBar.titleTextAttributes = @
		{
		UITextAttributeFont: [UIFont systemFontOfSize:18],
		UITextAttributeTextColor: UIUtil::Color(49, 49, 49),
		UITextAttributeTextShadowColor: [UIColor clearColor],
		UITextAttributeTextShadowOffset: [NSValue valueWithCGSize:CGSizeZero],
		};
	}
#endif

	// Show main view
	_window.rootViewController = navigator;
	[_window makeKeyAndVisible];
	
	//UIUtil::ShowSplashView(navigator.view);
	
	StatStart();
    
    //Report Device Information Regularly
    [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(regularDeviceInfoReport:) userInfo:nil repeats:YES];

	return YES;
}

// The application is about to terminate.
//- (void)applicationWillTerminate:(UIApplication *)application
//{
//}

// Tells the delegate that the application is about to become inactive.
//- (void)applicationWillResignActive:(UIApplication *)application
//{
//}

// The application has become active.
//- (void)applicationDidBecomeActive:(UIApplication *)application
//{
//}

// Tells the delegate that the application is about to enter the foreground.
//- (void)applicationWillEnterForeground:(UIApplication *)application
//{
//}

// Tells the delegate that the application is now in the background.
//- (void)applicationDidEnterBackground:(UIApplication *)application
//{
//}


#pragma mark Managing Status Bar Changes

//The interface orientation of the status bar is about to change.
//- (void)application:(UIApplication *)application willChangeStatusBarOrientation:(UIInterfaceOrientation)newStatusBarOrientation duration:(NSTimeInterval)duration
//{
//}

// The interface orientation of the status bar has changed.
//- (void)application:(UIApplication *)application didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation
//{
//}

// The frame of the status bar is about to change.
//- (void)application:(UIApplication *)application willChangeStatusBarFrame:(CGRect)newStatusBarFrame
//{
//}

// The frame of the status bar has changed.
//- (void)application:(UIApplication *)application didChangeStatusBarFrame:(CGRect)oldStatusBarFrame
//{
//}


#pragma mark Responding to System Notifications

// There is a significant change in the time.
//- (void)applicationSignificantTimeChange:(UIApplication *)application
//{
//}

// The application receives a memory warning from the system.
//- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
//{
//}

// Open a resource identified by URL.
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//	return NO;
//}

-(void)regularDeviceInfoReport:(NSTimer *)theTimer{
    [LSRegularReporter report];
}

@end
