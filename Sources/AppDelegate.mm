
#import "AppDelegate.h"
#import "RootController.h"
#import "LoginController.h"

#if defined(DEBUG) || defined(TEST)
@implementation NSURLRequest (IgnoreSSL)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
	return YES;
}
@end
#endif

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
	/*
     UIViewController *controller = DataLoader.accessToken ? [[RootController alloc] init] : [[LoginController alloc] init];
     UINavigationController *navigator = [[UINavigationController alloc] initWithRootViewController:controller];
     */
    
    if(DataLoader.accessToken
       //&& [LSDeviceInfo currentNetworkType]!=NotReachable
       ){
        [((SinriUIApplication *)application) setRootController:[[RootController alloc]init]];
        [((SinriUIApplication *)application) setLoginController:nil];
    }else{
        [((SinriUIApplication *)application) setLoginController:[[LoginController alloc]init]];
        [((SinriUIApplication *)application) setRootController:nil];
    }
    UIViewController *controller = DataLoader.accessToken ? [((SinriUIApplication *)application) rootController] : [((SinriUIApplication *)application) loginController];
    [((SinriUIApplication *)application) setNavController:[[UINavigationController alloc]initWithRootViewController:controller]];
    UINavigationController *navigator=[((SinriUIApplication *)application) navController];
    
    
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
    
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    
    [(SinriUIApplication *)application registerEndPRNotificationReceiver];
    
    //Report Device Information Regularly
    [LSRegularReporter report];
    [NSTimer scheduledTimerWithTimeInterval:60*2 target:self selector:@selector(regularDeviceInfoReport:) userInfo:nil repeats:YES];
    
    [(SinriUIApplication *)application resetIdleTimer];
    
    //_Log(@"LOG %@",[LSDeviceInfo check_all]);
    
    //_Log(@"UserDefaultsDic = [%@]", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
    /*
     NSString * uuid=NSUtil::UUID();
     NSString* sn = SystemUtil::SN();
     NSData * sn_data=[sn dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];
     NSMutableString *stringBuffer = [NSMutableString stringWithCapacity:([sn_data length] * 2)];
     const unsigned char *dataBuffer = (const unsigned char *)[sn_data bytes];
     int i;
     for (i = 0; i < [sn_data length]; ++i) {
     [stringBuffer appendFormat:@"%02lX", (unsigned long)dataBuffer[i]];
     }
     NSString* sn_string=[stringBuffer copy];
     
     
     _Log(@"uuid=%@ data as [%@] to hex [%@]",uuid,sn_data,sn_string);
     */
    //_Log(@"device_model_original=%@",[LSDeviceInfo deviceModelOriginal]);
    /*
    NSDate * now = [NSDate date];
    _Log(@"now is %@ = %lf",now, [now timeIntervalSince1970]);
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: now];
    NSDate *localeDate = [now  dateByAddingTimeInterval: interval];
    NSLog(@"to system zone = %@", localeDate);
    */
	return YES;
}

// The application is about to terminate.
- (void)applicationWillTerminate:(UIApplication *)application
{
    _Log(@"AppDelegate applicationWillTerminate");
}

// Tells the delegate that the application is about to become inactive.
- (void)applicationWillResignActive:(UIApplication *)application
{
    _Log(@"AppDelegate applicationWillResignActive");
}

// The application has become active.
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    _Log(@"AppDelegate applicationDidBecomeActive");
    [(SinriUIApplication *)application resetIdleTimer];
}

// Tells the delegate that the application is about to enter the foreground.
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    _Log(@"AppDelegate applicationWillEnterForeground");
    [SinriUIApplication setShouldMonitorIdle:YES];
    [(SinriUIApplication *)application resetIdleTimer];
}

// Tells the delegate that the application is now in the background.
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    _Log(@"AppDelegate applicationDidEnterBackground");
    [SinriUIApplication setShouldMonitorIdle:NO];
}


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
//    _Log(@"AppDelegate applicationSignificantTimeChange !");
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
