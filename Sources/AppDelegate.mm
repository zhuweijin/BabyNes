
#import "AppDelegate.h"
#import "RootController.h"
#import "LoginController.h"
#import "PushHandler.h"
#import "LSOfflineTasks.h"

#define SINRI_TEST

#ifdef SINRI_TEST

#import "LSVersionManager.h"

#import "MobClick.h"

#endif

//#if defined(DEBUG) || defined(TEST)
@implementation NSURLRequest (IgnoreSSL)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
	return YES;
}
@end
//#endif

//
@implementation AppDelegate

#pragma mark Generic methods

#ifdef SINRI_TEST
- (void)SINRI_TEST_FUNCTIONS:(bool)cleanVersion{
    if(cleanVersion){
        NSInteger cv0=[LSVersionManager currentVerion];
        [LSVersionManager setCurrentVersion:1];
        NSInteger cv1=[LSVersionManager currentVerion];
        [LSVersionManager setCurrentVersion:0];
        NSInteger cv2=[LSVersionManager currentVerion];
        
        _Log(@"cv: %ld->%ld->%ld",(long)cv0,(long)cv1,(long)cv2);
        
        NSString * zipUrl=nil;
        BOOL r=[LSVersionManager isNeedUpdateVersion:&zipUrl];
        _Log(@"Check Version r=%d url=%@",r,zipUrl);
    }
}
#endif

#pragma mark Monitoring Application State Changes

// The application has launched and may have additional launch options to handle.
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [((SinriUIApplication*)application) setIsNeedRotatable:NO];
    
    // 通知设备需要接收推送通知 Let the device know we want to receive push notifications
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)
     ];
    /*
     UIAccessibilityRequestGuidedAccessSession(YES,^(BOOL didSucceed){
     NSLog(@"UIAccessibilityRequestGuidedAccessSession: didSucceed=%d",didSucceed);
     UIAlertView * av=[[UIAlertView alloc]initWithTitle:@"SINGLE MODE" message:[NSString stringWithFormat:@"UIAccessibilityRequestGuidedAccessSession: didSucceed=%d",didSucceed] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
     [av show];
     });
     */
    
    //友盟的统计
    //TEST CHECK
    /*
    Class cls = NSClassFromString(@"UMANUtil");
    SEL deviceIDSelector = @selector(openUDIDString);
    NSString *deviceID = nil;
    if(cls && [cls respondsToSelector:deviceIDSelector]){
        deviceID = [cls performSelector:deviceIDSelector];
    }
    NSLog(@"{\"oid\": \"%@\"}", deviceID);
    */
    //WORK
    [MobClick startWithAppkey:@"53f15855fd98c52c7705b4d5" reportPolicy:SEND_INTERVAL channelId:@"POS"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    //[MobClick setLogEnabled:YES];
    
	UIUtil::ShowStatusBar(YES/*, UIStatusBarAnimationSlide*/);
	
	// Create window
	_window = [[UIWindow alloc] initWithFrame:UIUtil::ScreenBounds()];
	
	// Create controller
	// TODO: Remove navigation controller
	DataLoader.accessToken = Settings::Get(kAccessToken);
    [DataLoader setUsername:Settings::Get(kUsername)];
    [DataLoader setPassword:Settings::Get(kPassword)];
    [DataLoader setStoreID:Settings::Get(kStoreId)];
    [DataLoader setStoreProvince:Settings::Get(kStoreProvince)];
    [DataLoader setStoreCity:Settings::Get(kStoreCity)];
    [DataLoader setStoreAddress:Settings::Get(kStoreAddress)];
	/*
     UIViewController *controller = DataLoader.accessToken ? [[RootController alloc] init] : [[LoginController alloc] init];
     UINavigationController *navigator = [[UINavigationController alloc] initWithRootViewController:controller];
     */
    
    if(DataLoader.accessToken){
        if([LSDeviceInfo currentNetworkType]!=NotReachable){
            [DataLoader refreshAccessToken];
            _Log(@"refreshAccessToken");
        }
        //_LogLine();
        [((SinriUIApplication *)application) setRootController:[[RootController alloc]init]];
        [((SinriUIApplication *)application) setLoginController:nil];
    }else{
        //_LogLine();
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
    [NSTimer scheduledTimerWithTimeInterval:60*5 target:self selector:@selector(regularDeviceInfoReport:) userInfo:nil repeats:YES];
    
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
    //[self performSelector:@selector(actIntoSingleMode) withObject:PushHandler afterDelay:3];
    /*
    [UIView animateWithDuration:3 animations:^{
        //
    } completion:^(BOOL finished) {
        [PushHandler actIntoSingleMode];
    }];
    */
    [PushHandler actIntoSingleMode];
    
    //点击了通知中心的离线推送消息条。
    NSDictionary* offline = [launchOptions valueForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    [self application:application didReceiveOfflineRemoteNotification:offline];
    
#ifdef SINRI_TEST
    //[self SINRI_TEST_FUNCTIONS:NO];
#endif
    
	return YES;
}

-(void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"我的设备ID(NSData): %@", deviceToken);
    //对deviceToken进行格式化
    NSString *strDev = [[[[deviceToken description]
                          stringByReplacingOccurrencesOfString: @"<" withString: @""]
                         stringByReplacingOccurrencesOfString: @">" withString: @""]
                        stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSLog(@"我的设备ID(NSString): %@", strDev);
    //可以在此获得设备的device token，以及其他信息，发送给服务器
    //const void  *devTokenBytes = [deviceToken bytes];
    //[self sendProviderDeviceToken:devTokenBytes];
    
    [PushHandler setPushToken:strDev];
}

-(void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"注册失败，无法获取设备ID, 具体错误: %@", error);
    [PushHandler setPushToken:nil];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"设备收到推送(正常向)：\n%@",userInfo);
    [self handleRemotePush:userInfo[@"aps"]];
}

-(void)application:(UIApplication *)application didReceiveOfflineRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"点击了通知中心的离线推送消息项：\n%@",userInfo);
    NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
    if( [apsInfo objectForKey:@"alert"] != NULL)
    {
        [self handleRemotePush:userInfo[@"aps"]];
    }
}

-(void)handleRemotePush:(NSDictionary *)userInfo{
    /*
    UIAlertView * av=[[UIAlertView alloc]initWithTitle:userInfo[@"alert"] message:userInfo[@"addition"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [av show];
     */
    [PushHandler handlePush:userInfo];
}

// The application is about to terminate.
- (void)applicationWillTerminate:(UIApplication *)application
{
    _Log(@"AppDelegate applicationWillTerminate");
    [PushHandler actOutSingleMode];
}

// Tells the delegate that the application is about to become inactive.
- (void)applicationWillResignActive:(UIApplication *)application
{
    _Log(@"AppDelegate applicationWillResignActive");
    [PushHandler actOutSingleMode];
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
    [PushHandler actOutSingleMode];
}

// Tells the delegate that the application is now in the background.
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    _Log(@"AppDelegate applicationDidEnterBackground");
    [SinriUIApplication setShouldMonitorIdle:NO];
    [PushHandler actOutSingleMode];
}


#pragma mark Managing Status Bar Changes

//The interface orientation of the status bar is about to change.
//- (void)application:(UIApplication *)application willChangeStatusBarOrientation:(UIInterfaceOrientation)newStatusBarOrientation duration:(NSTimeInterval)duration
//{
//}

// The interface orientation of the status bar has changed.
- (void)application:(UIApplication *)application didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation
{
    //NSNotificationCenter
}

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
    if(![PushHandler getPushToken]){
        // 通知设备需要接收推送通知 Let the device know we want to receive push notifications
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)
         ];
    }
    [LSRegularReporter report];
    
    @try {
        [LSOfflineTasks attemptProcess];
    }
    @catch (NSException *exception) {
        NSLog(@"定时离线订单处理 最外层异常：%@",exception);
    }
    @finally {
        //
    }
    
}

/**
 以下两个方法是为了保证照片和相机的利用，因为其要求竖屏。。。但是我们用的是横屏。。。的兼容方法。
 **/

-(NSUInteger)application:(UIApplication*)application supportedInterfaceOrientationsForWindow:(UIWindow*)window{
    //_LogLine();
    if([((SinriUIApplication *)application) isNeedRotatable]){
        return UIInterfaceOrientationMaskAll;
    }else{
        return (UIInterfaceOrientationMaskLandscape);
    }
}
/*
-(BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeLeft;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}
*/

@end

@implementation UINavigationController (rotating)
/*
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationLandscapeRight|UIInterfaceOrientationLandscapeLeft;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}

-(BOOL)shouldAutorotate{
    return NO;
}
*/
/*
- (BOOL)shouldAutorotate {
    return [self.visibleViewController shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations {
    return [self.visibleViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.visibleViewController preferredInterfaceOrientationForPresentation];
}
 */
@end
