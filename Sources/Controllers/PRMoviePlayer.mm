//
//  PRMoviePlayer.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-3.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "PRMoviePlayer.h"
#import "MobClick.h"

@interface PRMoviePlayer ()
@property UINavigationBar *navigationBar;
@property UINavigationItem *theNavigationItem;
@property UIBarButtonItem *leftButton;
//@property UIBarButtonItem *rightButton;

@end

@implementation PRMoviePlayer

- (id)initWithURL:(NSURL *)URL
{
	_URL = URL;
    _theTitle=NSLocalizedString(@"About BabyNes", @"关于惠氏");
	return self = [super init];
}

-(id)initWithPath:(NSString *)path withTitle:(NSString*)title{
    if([path hasPrefix:@"http"]){
        _URL=[[NSURL alloc]initWithString:path];
    }else{
        _URL=[[NSURL alloc]initFileURLWithPath:path];
    }
    if(title==nil){
        _theTitle=NSLocalizedString(@"About BabyNes", @"关于惠氏");
    }else{
        _theTitle=title;
    }
    return self=[super init];
    
    
}
- (void)loadView
{
	[super loadView];
    
	self.view.backgroundColor = [UIColor blackColor];
	
	//[self RemoveCacheInTemp];
	
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
	
	_player = [[MPMoviePlayerController alloc] initWithContentURL:_URL];
    
    [_player setControlStyle:(MPMovieControlStyleDefault)];
	if (UIUtil::SystemVersion() >= 3.2)
	{
		[self.view addSubview:_player.view];
		_player.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
		_player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	}
    
    //创建一个导航栏
    _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, -60, 1024, 60)];
    //创建一个导航栏集合
    _theNavigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    //创建一个左边按钮
    //_leftButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"返回")  style:(UIBarButtonItemStylePlain) target:self action:@selector(clickBackButton:)];
    UIImage * back_icon = UIUtil::Image(@"app/goback@2x.png");
    _leftButton = [[UIBarButtonItem alloc] initWithImage:back_icon style:(UIBarButtonItemStyleBordered) target:self action:@selector(clickBackButton:)];
    
    //创建一个右边按钮
    //_rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Full Screen", @"全屏幕") style:UIBarButtonItemStyleDone target:self action:@selector(clickFullScreenButton:)];
    //设置导航栏内容
    [_theNavigationItem setTitle:_theTitle];
    //[_navigationBar setAlpha:0.7];
    [_navigationBar pushNavigationItem:_theNavigationItem animated:YES];
    
    //把左右两个按钮添加入导航栏集合中
    //[_theNavigationItem setBackBarButtonItem:_leftButton];
    [_theNavigationItem setLeftBarButtonItem:_leftButton];
    //[_theNavigationItem setRightBarButtonItem:_rightButton];
    //把导航栏添加到视图中
    [self.view addSubview:_navigationBar];
    [_navigationBar setHidden:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MovieController"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MovieController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_player setRepeatMode:(MPMovieRepeatModeOne)];
    [_player setFullscreen:YES animated:YES];
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self showNavBar:self];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self performSelector:@selector(hideNavBar:) withObject:self afterDelay:5];
}

-(void)showNavBar:(id)sender{
    if([_navigationBar isHidden]){
        CGRect toFrame = _navigationBar.frame;
        toFrame.origin.y=0;
        [_navigationBar setHidden:NO];
        [UIView animateWithDuration:0.4 animations:^{
            [_navigationBar setFrame:toFrame];
        } completion:^(BOOL finished) {
            if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
                // iOS 7
                [self prefersStatusBarHidden];
                [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
            }
        }];
    }
}

-(void)hideNavBar:(id)sender{
    if(![_navigationBar isHidden]){
        CGRect show_frame = _navigationBar.frame;
        CGRect hide_frame=show_frame;
        hide_frame.origin.y-=hide_frame.size.height;
        [UIView animateWithDuration:1 animations:^{
            [_navigationBar setFrame:hide_frame];
        } completion:^(BOOL finished) {
            [_navigationBar setHidden:YES];
            [_navigationBar setFrame:show_frame];
            if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
                // iOS 7
                [self prefersStatusBarHidden];
                [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
            }
        }];
    }
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exit_fullscreen_notified:) name:MPMoviePlayerWillExitFullscreenNotification object:nil];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerWillExitFullscreenNotification object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)prefersStatusBarHidden
{
    return [_navigationBar isHidden];//!is_show_status_bar;
    //return YES;//隐藏为YES，显示为NO
}


-(void)exit_fullscreen_notified:(NSNotification*)notification{
    _Log(@"exit_fullscreen_notified called");
    //if(!isClickedFullScreenButton){
    [self showNavBar:self];
    //}
}

-(void)clickBackButton:(id)sender{
    _Log(@"PRMoviePlayer clickBackButton called");
    [_player stop];
    _player=nil;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"PR_EXIT" object:nil];
}
-(void)clickFullScreenButton:(id)sender{
    _Log(@"PRMoviePlayer clickFullScreenButton called");
    //isClickedFullScreenButton=NO;
    if([_player isFullscreen]){
        [_player setFullscreen:NO animated:YES];
    }else{
        [_player setFullscreen:YES animated:YES];
    }
    
}
@end
