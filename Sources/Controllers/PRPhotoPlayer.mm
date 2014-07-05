//
//  PRPhotoPlayer.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-5.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "PRPhotoPlayer.h"

@interface PRPhotoPlayer ()

@end

@implementation PRPhotoPlayer

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id) initWithImage:(UIImage*)image withTitle:(NSString*)title{
    _Log(@"PRPhotoPlayer init .....");
    self=[super init];
    _theImage=image;
    _theTitle=title;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self.view setFrame:CGRectMake(0, 0, 1024, 768)];
    [self.view setBackgroundColor:[UIColor grayColor]];
    
    _hugeImage=[[UIImageView alloc]initWithImage:_theImage];
    _hugeImageView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
    _hugeImageView.contentSize=_hugeImage.image.size;
    [_hugeImageView setBackgroundColor:[UIColor clearColor]];
    [_hugeImageView addSubview:_hugeImage];
    [self.view addSubview:_hugeImageView];
    [_hugeImage setCenter: _hugeImageView.center];
    _Log(@"PRPhotoPlayer hugeImage=%@",_hugeImage);
    
    
    // Do any additional setup after loading the view.
    //创建一个导航栏
    _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 1024, 50)];
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
    //[_navigationBar setHidden:YES];
    
    [self performSelector:@selector(hideNavBar:) withObject:self afterDelay:5];
    
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showNavBar:)];
    [self.view addGestureRecognizer:singleFingerTap];
    
    _Log(@"PRPhotoPlayer viewDidLoad final");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            [self performSelector:@selector(hideNavBar:) withObject:self afterDelay:5];
        }];
    }
}

-(void)hideNavBar:(id)sender{
    if(![_navigationBar isHidden]){
        CGRect show_frame = _navigationBar.frame;
        CGRect hide_frame=show_frame;
        hide_frame.origin.y-=hide_frame.size.height;
        [UIView animateWithDuration:0.4 animations:^{
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

- (BOOL)prefersStatusBarHidden
{
    return YES;
    //return [_navigationBar isHidden];//!is_show_status_bar;
    //return YES;//隐藏为YES，显示为NO
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)clickBackButton:(id)sender{
    //[self.navigationController popViewControllerAnimated:YES];
    //[self dismissModalViewController];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"PR_PHOTO_EXIT" object:nil];
}

@end
