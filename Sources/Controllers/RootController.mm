
#import "RootController.h"

#import "SinriUIApplication.h"

#import "SRReceiptSender.h"

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
	newCustomerButton.center = CGPointMake(self.tabBar.frame.size.width - 20 - 120/2, self.tabBar.frame.size.height / 2);
	[newCustomerButton addTarget:self action:@selector(newCustomerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[self.tabBar addSubview:newCustomerButton];
	/*
     UIButton *exitButton = [UIButton minorButtonWithTitle:NSLocalizedString(@"Exit", @"退出") width:85];
     exitButton.center = CGPointMake(self.tabBar.frame.size.width - 20 - 85/2, self.tabBar.frame.size.height / 2);
     [exitButton addTarget:self action:@selector(exitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
     [self.tabBar addSubview:exitButton];
     */
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLogoutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sineToIwareta:) name:kLogoutNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SRSelected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSRurl:) name:@"SRSelected" object:nil];
}

// Called after the view controller's view is released and set to nil.
- (void)viewDidUnload
{
	[super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLogoutNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SRSelected" object:nil];
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
    NewCustomerController * nc=[[NewCustomerController alloc]init];
    //[nc setModalPresentationStyle:(UIModalPresentationPageSheet)];
    [nc setModalPresentationStyle:(UIModalPresentationFormSheet)];
    [nc setModalTransitionStyle:(UIModalTransitionStyleFlipHorizontal)];
    [self presentViewController:nc animated:YES completion:^{
        _Log(@"ROOT NewCustomerVC presented");
    }];
    CGRect frame=nc.view.frame;
    //_Log(@"PAGE WIDTH=%f",frame.size.width);//768//540
    frame.size.height=500;
    //frame.size.width+=100;
    [nc.view.superview setFrame:frame];
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
    
    controller.navigationItem.title = [srm title];
    [self.navigationController pushViewController:controller animated:YES];
    
    [SRReceiptSender report_have_read:[srm srid]];
    
    /*
     [self presentViewController:controller animated:YES completion:^{
     _Log(@"showSRurl over");
     }];
     */
}

@end
