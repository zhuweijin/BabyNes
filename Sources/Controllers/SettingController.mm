
#import "SettingController.h"
#import "SinriUIApplication.h"
#import "LSVersionManager.h"

#import "PushHandler.h"

@implementation SettingController

#pragma mark Generic methods

// Constructor
- (id)init
{
	self = [super init];
	self.title = NSLocalizedString(@"Settings", @"设置");
	return self;
}

#pragma mark View methods

// Creates the view that the controller manages.
//- (void)loadView
//{
//	[super loadView];
//}

// Do additional setup after loading the view.
//- (void)viewDidLoad
//{
//	[super viewDidLoad];
//}

//
- (void)loadPage
{
	BOOL iPhone5 = UIUtil::IsPhone5();
	UIImage *image = [UIImage imageNamed:@"Icon"];
	_logoButton = [UIButton buttonWithImage:image];
	_logoButton.layer.cornerRadius = 8;
	_logoButton.clipsToBounds = YES;
	[_logoButton addTarget:self action:@selector(logoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
	_logoButton.center = CGPointMake(1024/2, (iPhone5 ? 20 : 6) + image.size.height / 2);
	[self addView:_logoButton];
	
	UILabel *label = UIUtil::LabelWithFrame(CGRectMake((1024-300)/2, _contentHeight + 4, 300, iPhone5 ? 40 : 20)
											, [NSString stringWithFormat:NSLocalizedString(@"Version %@ %@© %@", @"版本 %@ %@© %@"), NSUtil::BundleVersion(), (iPhone5 ? @"\n" : @" "), NSUtil::BundleDisplayName()]
											, [UIFont systemFontOfSize:15]
											, [UIColor darkGrayColor]
											, NSTextAlignmentCenter);
	[self addView:label];
	if (iPhone5)
	{
		label.numberOfLines = 2;
		[self spaceWithHeight:24];
	}
	else
	{
		[self spaceWithHeight:14];
	}
	
	{
		[self cellButtonWithName:NSLocalizedString(@"Network Cache", @"网络缓存")
						  detail:[NSString stringWithFormat:@"%.2f MB", float(NSUtil::CacheSize() / 1024.0 / 1024.0)]
						   title:NSLocalizedString(@"Clean", @"清除")
						  action:@selector(clearButtonClicked:)
						   width:56];
	}
	
		
	[self spaceWithHeight:kDefaultHeaderHeight];
	{
		//[self cellWithName:NSLocalizedString(@"Rate Me", @"给个好评") detail:nil action:@selector(starButtonClicked:)];
		[self cellWithName:NSLocalizedString(@"Single Mode", @"单应用限制") detail:nil action:@selector(onSingleMode:)];
	}
    [self spaceWithHeight:kDefaultHeaderHeight];
	{
		//[self cellWithName:NSLocalizedString(@"Rate Me", @"给个好评") detail:nil action:@selector(starButtonClicked:)];
		[self cellWithName:NSLocalizedString(@"Force Execute Offline Tasks", @"尝试执行离线任务") detail:nil action:@selector(onSendOfflineTasks:)];
	}
    
    //SINRI TEST
    [self spaceWithHeight:kDefaultHeaderHeight];
	{
		//[self cellWithName:NSLocalizedString(@"Rate Me", @"给个好评") detail:nil action:@selector(starButtonClicked:)];
		[self cellWithName:NSLocalizedString(@"About", @"关于") detail:nil action:@selector(logoButtonClicked:)];
	}
    
    [self spaceWithHeight:kDefaultHeaderHeight];
	
    if (DataLoader.isLogon)
	{
		//self.navigationItem.rightBarButtonItem = [UIBarButtonItem _buttonItemWithTitle: target:self action:@selector(logoutButtonClicked:)];
		UIButton* logout_btn= [self majorButtonWithTitle:NSLocalizedString(@"Logout", @"安全退出") action:@selector(logoutButtonClicked:)];
		[logout_btn setBackgroundImage:UIUtil::ImageWithColor(UIUtil::Color(156,153,190)) forState:(UIControlStateNormal)];
		if (!iPhone5) [self spaceWithHeight:-3];
	}

    
	if (!iPhone5) [self spaceWithHeight:-10];
}

#pragma mark Event methods

//
#define kCleanCacheAlertViewTag 12517
- (void)clearButtonClicked:(UIButton *)sender
{
	UIAlertView *alertView = UIUtil::ShowAlert(NSLocalizedString(@"Clean Cache", @"清除缓存"),
											   NSLocalizedString(@"Are you sure to clear cache? This action would abort and delete the record about cart, local SR messages and so on.", @"你确定要清除缓存吗？这将会同时中止购物车、业务消息等任务并删除本地记录。"),
											   self,
											   NSLocalizedString(@"Cancel", @"取消"),
											   NSLocalizedString(@"Clean", @"清除"));
	objc_setAssociatedObject(alertView, (__bridge void *)@"SENDER", sender, OBJC_ASSOCIATION_ASSIGN);
	alertView.tag = kCleanCacheAlertViewTag;
}

//
- (void)starButtonClicked:(WizardCell *)sender
{
	UIUtil::OpenUrl(kAppStoreUrl);
}

//
- (void)logoutButtonClicked:(id)sender
{
	//UIUtil::ShowAlert(NSLocalizedString(@"Logout", @"注销"), NSLocalizedString(@"Are you sure to logout?", @"你要退出当前账户吗?"), self, NSLocalizedString(@"Cancel", @"取消"), NSLocalizedString(@"OK", @"确定"));
    
    DialogUIAlertView * logout_dialog=[[DialogUIAlertView alloc]initWithTitle:NSLocalizedString(@"Logout", @"注销") message:NSLocalizedString(@"Are you sure to logout?", @"你要退出当前账户吗?") cancelButtonTitle:NSLocalizedString(@"Cancel", @"取消") otherButtonTitles:NSLocalizedString(@"OK", @"确定")];
    //[logout_dialog setAlert_view_type:NCDialogAlertViewTypeBigger];
    int result=[logout_dialog showDialog];
    
    if(result==1){
        Settings::Save(kAccessToken);
        //UIViewController *controller = [[LoginController alloc] init];
        
        [[(SinriUIApplication *)([UIApplication sharedApplication]) loginController] dismissViewControllerAnimated:NO completion:^{
            _Log(@"RootController dismiss login controoler");
        }];
        
        [(SinriUIApplication *)([UIApplication sharedApplication]) setLoginController:nil];
        [(SinriUIApplication *)([UIApplication sharedApplication]) setLoginController:[[LoginController alloc] init]];
        UIViewController *controller=[(SinriUIApplication *)([UIApplication sharedApplication]) loginController];
        
        [self.navigationController setViewControllers:@[controller] animated:NO];
    }
}

//
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == alertView.cancelButtonIndex) return;
	
	if (alertView.tag == kCleanCacheAlertViewTag)
	{
        /*
        //无差别消灭缓存
		NSUtil::CleanCache();
        //只消灭自己的Token对应的本地消息记录
        [LocalSRMessageTool cleanMyLocalSR];
        //消灭版本
        [LSVersionManager setCurrentVersion:0];
        NSUtil::RemovePath(NSUtil::DocumentPath([LSVersionManager allZipFilePath]));
        NSUtil::RemovePath(NSUtil::DocumentPath([LSVersionManager allZipToJsonPath]));
        //消灭购物车
        //[ProductEntity resetProductsAsEmpty];
        [[CartEntity getDefaultCartEntity]resetCart];
        //顺便昭告天下
        [[NSNotificationCenter defaultCenter]postNotificationName:@"CacheKilled" object:nil];
        
         //Log time for cleaning cache
         long time;
         NSDate *fromdate=[NSDate date];
         time=(long)[fromdate timeIntervalSince1970];
         [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithLong:time] forKey:@"BabyNesPOS_LastCleanCache_UnixTime"];
         */
        [PushHandler actCleanCache];
         
         
		WizardCell *cell = (WizardCell *)[objc_getAssociatedObject(alertView, (__bridge void *)@"SENDER") superview];
		cell.detail = nil;
		UIButton *button = (UIButton *)cell.accessoryView;
		[button setTitle:NSLocalizedString(@"Cleaned", @"已清除") forState:UIControlStateNormal];
		button.enabled = NO;
        
        
        
		return;
	}
	
	[DataLoader logout];
	[self.navigationController popViewControllerAnimated:YES];
}

//
- (void)logoButtonClicked:(UIView *)sender
{
	UIUtil::ShowStatusBar(NO, UIStatusBarAnimationSlide);
	
	UIImage *image = [UIImage imageNamed:UIUtil::IsPad() ? @"DefaultPad" : (UIUtil::IsPhone5() ? @"Default-568h" : @"Default")];
    UIButton *button = [UIButton buttonWithImage:image];
    /*
    UIImage *image =  UIUtil::Image(@"DefaultPadLogoShow");
    UIButton *button=[UIButton buttonWithType:(UIButtonTypeCustom)];
    CGRect turned_frame= self.view.window.frame;
    turned_frame.size.width=self.view.window.frame.size.height;
    turned_frame.size.height=self.view.window.frame.size.width;
    [button setFrame:turned_frame];
    [button setBackgroundImage:image forState:(UIControlStateNormal)];
    */
	[button setImage:image forState:UIControlStateHighlighted];
	[button addTarget:self action:@selector(sloganButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
	objc_setAssociatedObject(button, (__bridge void *)@"SENDER", sender, OBJC_ASSOCIATION_ASSIGN);
	[self.view.window addSubview:button];
    
    _Log(@"logo button = %@ %d",button,[[UIDevice currentDevice] orientation]);

    
	if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight)
	{
        _Log(@"logoButtonClicked UIDeviceOrientationLandscapeRight Turn around the image");
		button.layer.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180, 0, 0, 1);
	}else if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft)
	{
        _Log(@"logoButtonClicked UIDeviceOrientationLandscapeLeft");
		//button.layer.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180, 0, 0, 1);
	}
    
	
	CGRect frame = button.frame;
	button.frame = [self.view.window convertRect:sender.frame fromView:sender.superview];
	button.alpha = 0;
	[UIView animateWithDuration:0.4 animations:^()
	 {
		 button.alpha = 1;
		 button.frame = frame;
	 }];
    
    //[self check_cache_files];
    //FOR TEST
    UIAlertView * uiav=[[UIAlertView alloc]initWithTitle:@"STATUS" message:[LSDeviceInfo check_all] delegate:nil cancelButtonTitle:@"I SEE" otherButtonTitles: nil];
    [uiav show];
}

//
- (void)sloganButtonClicked:(UIButton *)sender
{
	UIUtil::ShowStatusBar(YES, UIStatusBarAnimationSlide);
	[UIView animateWithDuration:0.4 animations:^()
	 {
		 sender.alpha = 0;
		 UIView *to = objc_getAssociatedObject(sender, (__bridge void *)@"SENDER");
		 sender.frame = [self.view.window convertRect:to.frame fromView:to.superview];;
	 } completion:^(BOOL finished)
	 {
		 [sender removeFromSuperview];
	 }];
}

-(void)onSingleMode:(id)sender{
    DialogUIAlertView * dav=[[DialogUIAlertView alloc]initWithTitle:@"Single Mode" message:@"It is a switch for tester to turn off the Single Mode... Do you want to quit Single Mode?" cancelButtonTitle:@"Into" otherButtonTitles:@"Quit",nil];
    int r=[dav showDialog];
    if(r>0){
        [PushHandler actOutSingleMode];
    }else{
        [PushHandler actIntoSingleMode];
    }
}

-(void)onSendOfflineTasks:(id)sender{
    @try {
        NSLog(@"手动开始离线任务处理。。。。");
        [LSOfflineTasks attemptProcess];
    }
    @catch (NSException *exception) {
        NSLog(@"定时离线订单处理 最外层异常：%@",exception);
    }
    @finally {
        //
    }
}

/*
-(void) check_cache_files{
    _Log(@"check_cache_files");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);//NSCachesDirectory//NSDocumentDirectory
    NSString *documentsDirectory = [paths objectAtIndex:0];
    _Log(@"documentsDirectory%@",documentsDirectory);
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSString *myDirectory = documentsDirectory;//[documentsDirectory stringByAppendingPathComponent:@"Caches"];
    NSArray *file = [fileManage subpathsOfDirectoryAtPath: myDirectory error:nil];
    _Log(@"file in [%@] %@", myDirectory,file);
    NSArray *files = [fileManage subpathsAtPath: myDirectory ];
    _Log(@"%@",files);
}
*/
@end
