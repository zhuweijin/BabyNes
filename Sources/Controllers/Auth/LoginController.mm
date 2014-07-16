
#import "LoginController.h"
#import "RootController.h"
#import "CartEntity.h"
#import "SinriUIApplication.h"

@implementation LoginController

#pragma mark Generic methods

// Constructor
- (id)init
{
	self = [super init];
    _msg=nil;
	return self;
}

-(id)initWithMessage:(NSString*)theMessage{
    self=[super init];
    _msg=theMessage;
    return self;
}

//
- (void)createSubviews
{
	
	CGRect bounds = self.view.bounds;
	
	{
		_logoView = [[UIImageView alloc] initWithImage:UIUtil::Image(@"LoginLogo")];
		_logoView.center = CGPointMake(bounds.size.width / 2, bounds.size.height / 2);
		_logoView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[self.view addSubview:_logoView];
	}
	{
		_footView = [[UIImageView alloc] initWithImage:UIUtil::Image(@"LoginFooter")];
		_footView.center = CGPointMake(bounds.size.width / 2, bounds.size.height - _footView.frame.size.height / 2);
		_footView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
		[self.view addSubview:_footView];
	}
	{
		_loginPane = [[UIImageView alloc] initWithImage:UIUtil::Image(@"LoginPane")];
		_loginPane.center = CGPointMake(bounds.size.width / 2, 60 + bounds.size.height / 2);
		_loginPane.userInteractionEnabled = YES;
		_loginPane.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
		[self.view addSubview:_loginPane];
		
		{
			UILabel *label = UIUtil::LabelWithFrame(CGRectMake(0, 40, _loginPane.frame.size.width, 30),
													NSLocalizedString(@"Sales Login", @"促销员登录"),
													[UIFont systemFontOfSize:20],
													UIUtil::Color(0x393939),
													NSTextAlignmentCenter);
			[_loginPane addSubview:label];
		}
		
		CGRect frame = {(_loginPane.frame.size.width - 273) / 2, 96, 273, 38};
		{
			_usernameField = [[InputBox alloc] initWithFrame:frame iconName:@"UserIcon"];
			_usernameField.text = Settings::Get(kUsername);
			[_usernameField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
			[_loginPane addSubview:_usernameField];
		}
		frame.origin.y = 160;
		{
			_passwordField = [[InputBox alloc] initWithFrame:frame iconName:@"PassIcon"];
			_passwordField.secureTextEntry = YES;
			[_passwordField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
			[_loginPane addSubview:_passwordField];
		}
		frame.origin.x -= 5;
		frame.origin.y = 220;
		{
			_rememberButton = [UIButton checkButtonWithTitle:NSLocalizedString(@"Remember Me", @"记住我") frame:frame];
			[_loginPane addSubview:_rememberButton];
		}
		{
			_doneButton = [UIButton buttonWithTitle:NSLocalizedString(@"Login", @"登录") width:85];
			_doneButton.enabled = NO;
			_doneButton.center = CGPointMake(CGRectGetMaxX(_passwordField.frame) - 85/2, _rememberButton.center.y);
			[_doneButton addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
			[_loginPane addSubview:_doneButton];
		}
		
		[_usernameField addTarget:_passwordField action:@selector(becomeFirstResponder) forControlEvents:UIControlEventEditingDidEndOnExit];
		[_passwordField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
		
		UIUtil::AddTapGesture(self.view, _loginPane, @selector(endEditing:));
	}
	_footView.alpha = 0;
	_loginPane.alpha = 0;
}

//
- (void)showSubviews
{
    //	if (Settings::Get(kAccessToken))
    //	{
    //		UIViewController *controller = [[RootController alloc] init];
    //		[self.navigationController setViewControllers:@[controller] animated:YES];
    //		return;
    //	}
	[UIView animateWithDuration:0.5 animations:^()
	 {
		 _logoView.center = CGPointMake(self.view.bounds.size.width / 2, _logoView.frame.size.height / 2);
         _loginPane.alpha = 1;
		 _footView.alpha = 1;
	 } completion:^(BOOL finished)
	 {
		 //[_usernameField.text.length ? _passwordField : _usernameField becomeFirstResponder];
	 }];
}

#pragma mark View methods

// Creates the view that the controller manages.
- (void)loadView
{
	UIImageView *view = [[UIImageView alloc] initWithImage:UIUtil::Image(@"Background")];
	view.userInteractionEnabled = YES;
	self.view = view;
}

// Do additional setup after loading the view.
- (void)viewDidLoad
{
	[super viewDidLoad];
	[self createSubviews];
    
    if(_msg){
    UIAlertView * uiav=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Identity Exception", @"身份认证异常") message:_msg delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"确认") otherButtonTitles: nil];
    [uiav show];
    }
    
}

// Called when the view is about to made visible.
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
//#ifndef _CustomHeader
	[self.navigationController setNavigationBarHidden:YES];
//#endif
    
    [self.view.window setUserInteractionEnabled:YES];
}

//
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillShow:)
												 name:UIKeyboardWillShowNotification
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHide:)
												 name:UIKeyboardWillHideNotification
											   object:nil];
	//#define _HAS_PENDING_OPERATION
#ifdef _HAS_PENDING_OPERATION
	[self.view toastWithLoading].center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height * 3 / 4);
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^()
				   {
					   // TODO: 如果有网络请求
					   [NSThread sleepForTimeInterval:1];
					   
					   dispatch_async(dispatch_get_main_queue(), ^()
									  {
										  [self.view dismissToast];
										  [self showSubviews];
									  });
				   });
#else
	[self showSubviews];
#endif
    [self.view.window setUserInteractionEnabled:YES];
}

//
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
#ifndef _CustomHeader
	[self.navigationController setNavigationBarHidden:NO animated:YES];
#endif
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark Keyboard methods

//
- (void)keyboardWillShow:(NSNotification *)notification
{
	CGRect rect;
	NSValue *value = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
	[value getValue:&rect];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
	[UIView setAnimationCurve:(UIViewAnimationCurve)[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue]];
	_loginPane.center = CGPointMake(self.view.bounds.size.width / 2, (self.view.bounds.size.height - rect.size.width) / 2);
	//	_logoView.center = CGPointMake(self.view.bounds.size.width / 2, -_logoView.frame.size.height / 2);
	//	_footView.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height + _footView.frame.size.height / 2);
	_logoView.alpha = 0;
	_footView.alpha = 0;
	[UIView commitAnimations];
}

//
- (void)keyboardWillHide:(NSNotification *)notification
{
	CGRect rect;
	NSValue *value = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
	[value getValue:&rect];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
	[UIView setAnimationCurve:(UIViewAnimationCurve)[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue]];
	_loginPane.center = CGPointMake(self.view.bounds.size.width / 2, 60 + (self.view.bounds.size.height) / 2);
	//_logoView.center = CGPointMake(self.view.bounds.size.width / 2, _logoView.frame.size.height / 2);
	//_footView.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height - _footView.frame.size.height / 2);
	_logoView.alpha = 1;
	_footView.alpha = 1;
	[UIView commitAnimations];
}

#pragma mark Event methods

//
- (void)textFieldChanged:(UITextField *)sender
{
	[self updateDoneButton];
}

//
- (void)textFieldDone:(UITextField *)sender
{
	if (_doneButton.enabled)
	{
		[self doneButtonClicked:nil];
	}
	else
	{
		[_usernameField becomeFirstResponder];
	}
}

//
- (void)updateDoneButton
{
	_doneButton.enabled = (_usernameField.text.length != 0) && (_passwordField.text.length != 0);
}

//
- (void)doneAction
{
	Settings::Set(kUsername, _usernameField.text);
	[UIView animateWithDuration:0.3 animations:^()
	 {
		 _loginPane.center = CGPointMake(-_loginPane.frame.size.width / 2, _loginPane.center.y);
	 } completion:^(BOOL finished)
	 {
		 NSDictionary *params = @
		 {
			 @"username": _usernameField.text,
			 @"password": _passwordField.text,
			 @"uuid": [LSDeviceInfo device_sn],/*SystemUtil::SN()*//*@"7A626E32-D9F8-4BEF-859F-852071CE0001",*/
		 };
         
		 //[DataLoader loadWithService:@"login" params:params completion:^(DataLoader *loader)
         [DataLoader loadWithService:@"login" params:params success:^(DataLoader *loader) {
             DataLoader.accessToken = loader.dict[@"token"];
             if (_rememberButton.selected)
             {
                 Settings::Save(kAccessToken, DataLoader.accessToken);
             }
             
             //DO REGISTER
             
             if([_usernameField.text isEqualToString:@"admin"]){
                 BOOL registered_device=[LSDeviceRegister doDeviceRegister];
                 if(!registered_device){
                     UIUtil::ShowAlert(NSLocalizedString(@"Register or update device information failed!", @"登记或更新设备失败！"));
                     _Log(@"Register or update device information failed!");
                 }else{
                     _Log(@"registered_device");
                 }
             }
             
             [[CartEntity getDefaultCartEntity]resetCart];
             
             //UIViewController *controller = [[RootController alloc] init];
             
             [(SinriUIApplication *)([UIApplication sharedApplication]) setRootController:nil];
             [(SinriUIApplication *)([UIApplication sharedApplication]) setRootController:[[RootController alloc] init]];
             UIViewController *controller=[(SinriUIApplication *)([UIApplication sharedApplication]) rootController];
             
             [self.navigationController setViewControllers:@[controller] animated:YES];
         } failure:^BOOL(DataLoader *loader, NSString *error) {
             Settings::Save(kAccessToken);
             [UIView animateWithDuration:0.3 animations:^()
              {
                  _loginPane.center = CGPointMake(self.view.bounds.size.width / 2, _loginPane.center.y);
              } completion:^(BOOL finished)
              {
                  _Log(@"LoginController login ERROR[%d]=[%@]",loader.error,loader.errorString);
                  NSString * info=nil;
                  if (loader.error == DataLoaderIdentificationError)
                  {
                      info=NSLocalizedString(@"The identification information is not correct, please use the correct pair.", @"认证信息错误，请重新输入。");
                  }else if(loader.error==DataLoaderNotFound){
                      info=NSLocalizedString(@"There is no user with this ID.", @"不存在此用户。");
                  }else if(loader.error==DataLoaderIllegalDevice) {
                      info=NSLocalizedString(@"This device is not in the permitted list.", @"当前设备未获使用许可。");
                  }
                  //else if(loader.error==DataLoaderEmpty){}
                  else{
                      info=NSLocalizedString(@"Unknown Error", @"未知错误");
                  }
                  UIUtil::ShowAlert(info);
                  _passwordField.text = nil;
                  [self updateDoneButton];
                  [_passwordField becomeFirstResponder];
              }];
             return NO;
         }];
     }];
}

- (void)doneAction_bak
{
	Settings::Set(kUsername, _usernameField.text);
	[UIView animateWithDuration:0.3 animations:^()
	 {
		 _loginPane.center = CGPointMake(-_loginPane.frame.size.width / 2, _loginPane.center.y);
	 } completion:^(BOOL finished)
	 {
		 NSDictionary *params = @
		 {
			 @"username": _usernameField.text,
			 @"password": _passwordField.text,
			 @"uuid": [LSDeviceInfo device_sn],/*SystemUtil::SN()*//*@"7A626E32-D9F8-4BEF-859F-852071CE0001",*/
		 };
         
		 [DataLoader loadWithService:@"login" params:params completion:^(DataLoader *loader)
		  {
			  if (loader.error != DataLoaderNoError)
			  {
				  Settings::Save(kAccessToken);
				  [UIView animateWithDuration:0.3 animations:^()
				   {
					   _loginPane.center = CGPointMake(self.view.bounds.size.width / 2, _loginPane.center.y);
				   } completion:^(BOOL finished)
				   {
                       _Log(@"LoginController login ERROR[%d]=[%@]",loader.error,loader.errorString);
                       NSString * info=nil;
					   if (loader.error == DataLoaderIdentificationError)
					   {
						   info=NSLocalizedString(@"The identification information is not correct, please use the correct pair.", @"认证信息错误，请重新输入。");
					   }else if(loader.error==DataLoaderNotFound){
                           info=NSLocalizedString(@"There is no user with this ID.", @"不存在此用户。");
                       }else if(loader.error==DataLoaderIllegalDevice) {
                           info=NSLocalizedString(@"This device is not in the permitted list.", @"当前设备未获使用许可。");
                       }
                       //else if(loader.error==DataLoaderEmpty){}
                       else{
                           info=NSLocalizedString(@"Unknown Error", @"未知错误");
                       }
                       //UIUtil::ShowAlert(info);
                       _passwordField.text = nil;
                       [self updateDoneButton];
                       [_passwordField becomeFirstResponder];
                       
				   }];
				  return;
			  }
			  
              
			  DataLoader.accessToken = loader.dict[@"token"];
			  if (_rememberButton.selected)
			  {
				  Settings::Save(kAccessToken, DataLoader.accessToken);
			  }
              
              //DO REGISTER
              
              if([_usernameField.text isEqualToString:@"admin"]){
                  BOOL registered_device=[LSDeviceRegister doDeviceRegister];
                  if(!registered_device){
                      UIUtil::ShowAlert(NSLocalizedString(@"Register or update device information failed!", @"登记或更新设备失败！"));
                      _Log(@"Register or update device information failed!");
                  }else{
                      _Log(@"registered_device");
                  }
              }
              
			  UIViewController *controller = [[RootController alloc] init];
			  [self.navigationController setViewControllers:@[controller] animated:YES];
		  }];
		 
	 }];
}


@end
