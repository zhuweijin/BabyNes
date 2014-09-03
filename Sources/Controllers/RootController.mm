
#import "RootController.h"
#import <QuartzCore/QuartzCore.h>

#import "SinriUIApplication.h"

#import "SRReceiptSender.h"
#import "PushHandler.h"

@implementation RootController

#pragma mark Generic methods

// Constructor
- (id)init
{
	self = [super init];
    _shopVC=[[LSShopViewController alloc] init];
    _intrVC=[[IntroduceController alloc] init];
    _mateVC=[[MaterialController alloc] init];
    _srVC =[[MessageController alloc] init];
	/*
     self.viewControllers = @[
     [[LSShopViewController alloc] init],
     [[IntroduceController alloc] init],
     [[MaterialController alloc] init],
     [[MessageController alloc] init],
     ];
     */
    self.viewControllers=@[_shopVC,_intrVC,_mateVC,_srVC];
    
    newsBtn=[[UIButton alloc]init];
    [newsBtn setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
    [newsBtn setFrame:CGRectMake(0, -20, 1024, 20)];
    [newsBtn addTarget:self action:@selector(onNewsButton:) forControlEvents:(UIControlEventTouchDown)];
    newsBtn.titleLabel.adjustsFontSizeToFitWidth=YES;
    
    isNeedHideStatusBar=NO;
    
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
	
	//UIImageView *logoView = [[UIImageView alloc] initWithImage:UIUtil::Image(@"app/logo@2x.jpg")];
    //logoView.frame = CGRectMake(45, 0, 85, 45);
    UIImageView *logoView = [[UIImageView alloc] initWithImage:UIUtil::Image(@"HomeLogo")];
    //UIImageView *logoView = [[UIImageView alloc] initWithImage:UIUtil::Image(@"newlogo")];
	logoView.frame = CGRectMake(45, 0, logoView.frame.size.width, logoView.frame.size.height);
	[self.tabBar addSubview:logoView];
    
    UIButton *newCustomerButton=[UIButton minorButtonWithTitle:NSLocalizedString(@"New Customer", @"招募顾客") width:120];
	newCustomerButton.center = CGPointMake(self.tabBar.frame.size.width - 10 - 120/2, self.tabBar.frame.size.height / 2);
	[newCustomerButton addTarget:self action:@selector(newCustomerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[self.tabBar addSubview:newCustomerButton];
	/*
     UIButton *exitButton = [UIButton minorButtonWithTitle:NSLocalizedString(@"Exit", @"退出") width:85];
     exitButton.center = CGPointMake(self.tabBar.frame.size.width - 20 - 85/2, self.tabBar.frame.size.height / 2);
     [exitButton addTarget:self action:@selector(exitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
     [self.tabBar addSubview:exitButton];
     */
    
    [[self.tabBar layer] setShadowOffset:{0, 2}];
    [[self.tabBar layer] setShadowRadius:0.5];
    [[self.tabBar layer] setShadowOpacity:0.7];
    [[self.tabBar layer] setShadowColor:[UIColor grayColor].CGColor];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLogoutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sineToIwareta:) name:kLogoutNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SRSelected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSRurl:) name:@"SRSelected" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"CacheKilled" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCacheKilled:) name:@"CacheKilled" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ReceiveForceUpdateVersionPush" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveVerisonUpdatePush:) name:@"ReceiveForceUpdateVersionPush" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"NewSRMessage" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onNewSRNews:) name:@"NewSRMessage" object:nil];
    
    [self setUpForDismissKeyboard];
}

- (void)setUpForDismissKeyboard {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view removeGestureRecognizer:singleTapGR];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
    _LogLine();
}

// Called after the view controller's view is released and set to nil.
- (void)viewDidUnload
{
	[super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLogoutNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SRSelected" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"CacheKilled" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ReceiveForceUpdateVersionPush" object:nil];
}

// Called when the view is about to made visible.
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
#ifdef _CustomHeader
	[self.navigationController setNavigationBarHidden:YES animated:YES];
    _Log(@"RootController viewWillAppear setNavigationBarHidden:YES");
#else
	[self.navigationController setNavigationBarHidden:NO animated:YES];
    _Log(@"RootController viewWillAppear setNavigationBarHidden:NO");
#endif
    //[self onTabButtonWithOldTab];
    if(_shopVC){
        [_shopVC removeObservers];
        [_shopVC addObservers];
    }
    
    if(_srVC){
        [_srVC removeObservers];
        [_srVC addObservers];
        
        _Log(@"srVC offset.y=%f",[[_srVC getSRTable] contentOffset].y);
        [_srVC scrollViewDidEndDragging:[_srVC getSRTable] willDecelerate:NO];
        
    }
    
}

// Called after the view was dismissed, covered or otherwise hidden.
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
#ifdef _CustomHeader
	[self.navigationController setNavigationBarHidden:NO animated:YES];//OLD
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
    _Log(@"RootController viewWillDisappear setNavigationBarHidden:YES");
#endif
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if([PushHandler hasOutSingleModePermitted]){
        [PushHandler actOutSingleMode];
    }else{
        [PushHandler actIntoSingleMode];
    }
    
}
#pragma Event methods

//
- (void)menuButtonClicked:(UIButton *)sender
{
	UIViewController *controller = [[SettingController alloc] init];
	[self.navigationController pushViewController:controller animated:YES];//OLD
    /*
     [controller setModalTransitionStyle:(UIModalTransitionStyleFlipHorizontal)];
     [controller setModalPresentationStyle:(UIModalPresentationFullScreen)];
     [self.navigationController presentViewController:controller animated:YES completion:^{
     //DONE
     }];
     */
}

//
- (void)exitButtonClicked:(UIButton *)sender
{
	Settings::Save(kAccessToken);
	UIViewController *controller = [[LoginController alloc] init];
	[self.navigationController setViewControllers:@[controller] animated:NO];
}

-(void)newCustomerButtonClicked:(UIButton*)sender{
    _Log(@"ROOT newCustomerButtonClicked called");
    
    //[self onNewsShow:@"NEWS"];
    //return;
    
    NewCustomerYController * nc=[[NewCustomerYController alloc]init];
    //[nc setModalPresentationStyle:(UIModalPresentationPageSheet)];
    [nc setModalPresentationStyle:(UIModalPresentationFormSheet)];
    //[nc setModalPresentationStyle:(UIModalPresentationCurrentContext)];
    [nc setModalTransitionStyle:(UIModalTransitionStyleFlipHorizontal)];
    //[nc setModalTransitionStyle:(UIModalTransitionStyleCrossDissolve)];
    
    
    //UIViewController* controller = self.view.window.rootViewController;
    //controller.modalPresentationStyle = UIModalPresentationCurrentContext;
    //[self setModalPresentationStyle:(UIModalPresentationCurrentContext)];
    
    [self presentViewController:nc animated:YES completion:^{
        _Log(@"ROOT NewCustomerVC presented");
        [nc.view.superview setBackgroundColor:[UIColor clearColor]];
    }];
    /*
    // iOS6まではこれでよかった。
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        nc.view.superview.frame = CGRectMake(0, 0, 810, 610);
        nc.view.superview.center = CGPointMake(384, 512);
    }else{ //iOS7ではview.supserViewではなくviewに対して指定する。
        CGRect superViewFrame = nc.view.superview.frame;
        nc.view.frame = CGRectMake(0, 0, 810, 610);
        nc.view.center  = CGPointMake(superViewFrame.size.width/2, superViewFrame.size.height/2);
        //nc.view.center  = CGPointMake(0,0);
        nc.view.superview.backgroundColor = [UIColor clearColor];
        nc.view.superview.bounds = CGRectMake(0, 0, 810, 610);
    }
    */
    
    CGRect frame=nc.view.frame;
    //_Log(@"PAGE WIDTH=%f",frame.size.width);//768//540
    frame.size.height=500;
    //frame.size.width+=100;
    [nc.view.superview setFrame:frame];
    
    [MobClick event:@"NewCustomerTop" acc:1];
    
}

-(void)sineToIwareta:(id)sender{
    _Log(@"RootController sineToIwareta");
    //DialogUIAlertView * logout_dialog=[[DialogUIAlertView alloc]initWithTitle:NSLocalizedString(@"Logout", @"注销") message:NSLocalizedString(@"Are you forced to log out for the incorrect token.", @"因为当前账户有错，您将被退出。") cancelButtonTitle:NSLocalizedString(@"Cancel", @"取消") otherButtonTitles:NSLocalizedString(@"OK", @"确定")];
    DialogUIAlertView * logout_dialog=[[DialogUIAlertView alloc]initWithTitle:NSLocalizedString(@"Logout", @"注销") message:NSLocalizedString(@"Are you forced to log out for the incorrect token.", @"因为当前账户有错，您将被退出。") cancelButtonTitle:NSLocalizedString(@"OK", @"确定") otherButtonTitles:nil];
    int result=[logout_dialog showDialog];
    
    if(result==1 || result==0){
        Settings::Save(kAccessToken);
        [self.view.window setUserInteractionEnabled:YES];
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

#pragma mark Event methods

//
- (void)onTabButtonWithOldTab
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.4];
	//_scrollView.currentPage = button.tag - kTabButonTag;
    if(self.scrollView.currentPage){
        self.scrollView.currentPage=self.scrollView.currentPage;
    }
	[UIView commitAnimations];
}

-(void)showSRurl:(NSNotification*)notification{
    SRMessage* srm=notification.object;
    _Log(@"MessageController showSRurl : %@",[srm logAbstract]);
    WebController * controller=[[WebController alloc]initWithUrl:[srm url]];
    
    [MobClick event:@"OpenMessage" acc:1];
    
    controller.navigationItem.title = [srm title];
    [self.navigationController pushViewController:controller animated:YES];
    
    if(![srm read]){
        [SRReceiptSender report_have_read:[srm srid]];
        _Log(@"已读！ srm=%d",srm.srid);
    }
    
    /*
     [self presentViewController:controller animated:YES completion:^{
     _Log(@"showSRurl over");
     }];
     */
}

-(void)onCacheKilled:(NSNotification*)notification{
    _Log(@"RootController onCacheKilled - -");
    [[CartEntity getDefaultCartEntity]resetCart];
    [_shopVC onCacheKilled:notification];
    [_srVC onCacheKilled:notification];
}
-(void)receiveVerisonUpdatePush:(NSNotification*)notification{
    _Log(@"Root ReceiveForceUpdateVersionPush");
    
    _shopVC.is_expired=YES;
    _intrVC.is_expired=YES;
    _mateVC.is_expired=YES;
    _srVC.is_expired=YES;
    
    if([self.presentingViewController respondsToSelector:@selector(receiveVerisonUpdatePush)]){
        [self.presentingViewController performSelector:@selector(receiveVerisonUpdatePush) withObject:nil];
    }
    /*
    @try {
        [_shopVC receiveVerisonUpdatePush];
        [_intrVC receiveVerisonUpdatePush];
        [_mateVC receiveVerisonUpdatePush];
        [_srVC receiveVerisonUpdatePush];
    }
    @catch (NSException *exception) {
        _Log(@"root ReceiveForceUpdateVersionPush exception:%@",exception);
    }
    @finally {
        //
    }
    */
}

-(BOOL)prefersStatusBarHidden{
    _Log(@"prefersStatusBarHidden=%hhd",isNeedHideStatusBar);
    return isNeedHideStatusBar;
}

-(void)onNewsShow:(NSString*)alert{
    /*
    UIButton * newsBtn=[[UIButton alloc]init];
    [newsBtn setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
    [newsBtn setFrame:CGRectMake(0, -20, 1024, 20)];
    [newsBtn addTarget:self action:@selector(onNewsButton:) forControlEvents:(UIControlEventTouchDown)];
    newsBtn.titleLabel.adjustsFontSizeToFitWidth=YES;
     */
    [newsBtn setTitle:alert forState:(UIControlStateNormal)];

    [self.view addSubview:newsBtn];
    [UIView animateWithDuration:1 animations:^{
        //[[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        isNeedHideStatusBar=YES;
        if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
            // iOS 7
            [self prefersStatusBarHidden];
            [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        }
       [newsBtn setFrame:CGRectMake(0, 0, 1024, 20)];
    } completion:^(BOOL finished) {
        [self performSelector:@selector(onNewsHide) withObject:nil afterDelay:3];
        /*
        [UIView animateWithDuration:3 animations:^{
            //[newsBtn setFrame:CGRectMake(0, 0, 1024, 70)];
            [newsBtn setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:1 animations:^{
                [newsBtn setFrame:CGRectMake(0, -20, 1024, 20)];
            } completion:^(BOOL finished) {
                //[newsBtn removeFromSuperview];
                //[[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
                isNeedHideStatusBar=NO;
                if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
                    // iOS 7
                    [self prefersStatusBarHidden];
                    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
                }
            }];
        }];
         */
    }];
}
-(void)onNewsHide{
    [UIView animateWithDuration:1 animations:^{
        [newsBtn setFrame:CGRectMake(0, -20, 1024, 20)];
    } completion:^(BOOL finished) {
        //[newsBtn removeFromSuperview];
        //[[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        isNeedHideStatusBar=NO;
        if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
            // iOS 7
            [self prefersStatusBarHidden];
            [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        }
    }];
}

-(void)onNewsButton:(id)sender{
    [_srVC setIsNeedRefresh:YES];
    UIButton * btn=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [btn setTag:(kTabButonTag+3)];
    [self onTabButton:btn];
    _LogLine();
}

-(void)onNewSRNews:(NSNotification*)notification{
    @try {
        NSDictionary*msgUnit=notification.object;
        NSString*title=[msgUnit objectForKey:@"title"];
        //NSString*url=[msgUnit objectForKey:@"url"];
        [self onNewsShow:[NSString stringWithFormat:NSLocalizedString(@"A new SR message released: %@!", @"新的业务消息已发布：%@"),title]];
        /*
         //方案2，POPOVER
        UIViewController * vc=[[UIViewController alloc]init];
        [vc.view setFrame:(CGRectMake(0, 0, 310, 30))];
        UIButton * newsBtn=[[UIButton alloc]init];
        [newsBtn setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
        [newsBtn setFrame:CGRectMake(5, 5, 300, 20)];
        [newsBtn setTitle:title forState:(UIControlStateNormal)];
        [[newsBtn titleLabel] setAdjustsFontSizeToFitWidth:YES];
        [newsBtn addTarget:self action:@selector(onNewsButton:) forControlEvents:(UIControlEventTouchUpInside)];
        [vc.view addSubview:newsBtn];
        UIPopoverController * popVC= [[UIPopoverController alloc]initWithContentViewController:vc];
        [popVC setPopoverContentSize:(CGSizeMake(310, 30))];
        [popVC presentPopoverFromRect:(CGRectMake(638, 0, 126, 44)) inView:self.view permittedArrowDirections:(UIPopoverArrowDirectionDown) animated:YES];
        */
    }
    @catch (NSException *exception) {
        NSLog(@"RootVC onNewSRNews : %@",notification);
    }
    @finally {
        //
    }
    
}

@end
