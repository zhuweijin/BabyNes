//
//  LSShopViewController.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-6-26.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "LSShopViewController.h"

@interface LSShopViewController ()

//@property LSShopMonoTableViewController * monoTable;
@property MonoTable * monoTableView;
//@property LSShopCartTableViewController * cartTable;
@property CartTable * cartTableView;
//@property LSCustomerSearchViewController * customerVC;

@property UIImage * list_icon_image;
@property UIImageView * list_icon_image_view;
@property UILabel * list_caption;
@property UILabel * list_header;

@property UILabel * sum_label;

@property UIImage * the_customer_icon;
@property UIImageView * the_customer_icon_view;
@property UILabel * the_customer_seeking_label;
@property UITextField * the_customer_mobile_textfield;
@property UILabel * the_customer_search_result;
@property UIButton * the_customer_seek_button;
@property UIButton * the_customer_new_button;
@property UIButton * the_order_confirm_button;



@property UIView * container;
@property UIView * container_2;

@end

@implementation LSShopViewController

- (void)design_customer_search_area
{
    self.container_2=[[UIView alloc]initWithFrame:CGRectMake(570, 5, 450, 200)];
    [self.container_2 setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.container_2];
    
    self.list_icon_image=UIUtil::Image(@"app/cart@2x.png");//[UIImage imageNamed:@"cart@2x.png"];
    self.list_icon_image_view=[[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 30, 30)];
    [self.list_icon_image_view setImage:self.list_icon_image];
    [self.container_2 addSubview:self.list_icon_image_view];
    
    self.list_caption= [[UILabel alloc]initWithFrame:CGRectMake(60, 0, 200, 30)];
    self.list_caption.text=NSLocalizedString(@"Shopping Cart", @"购物车");
    [self.list_caption setFont: [UIFont systemFontOfSize:20]];
    [self.container_2 addSubview:self.list_caption];
    
    self.list_header= [[UILabel alloc]initWithFrame:CGRectMake(90, 30, 380, 30)];
    self.list_header.text=NSLocalizedString(@"Product                     Price         Quantity", @"产品                              价格           数量");
    [self.list_header setFont: [UIFont systemFontOfSize:18]];
    [self.container_2 addSubview:self.list_header];
    
    self.sum_label= [[UILabel alloc]initWithFrame:CGRectMake(20, 400, 400, 30)];
    self.sum_label.text=[NSString stringWithFormat: NSLocalizedString(@"Sum $%.2f Quantity %d", @"总计：￥%.2f   数量：%d"),1111/100.0,3];
    [self.sum_label setFont: [UIFont systemFontOfSize:20]];
    [self.sum_label setTextAlignment:(NSTextAlignmentCenter)];
    [self.container_2 addSubview:self.sum_label];
    
    
    // Do any additional setup after loading the view.
    self.container=[[UIView alloc]initWithFrame:CGRectMake(570, 450, 450, 400)];
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.container];
    
    self.the_customer_icon=UIUtil::Image(@"app/icon-search@2x.png");//[UIImage imageNamed:@"app/icon-search@2x.png"];
    self.the_customer_icon_view=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    [self.the_customer_icon_view setImage:self.the_customer_icon];
    [self.container addSubview:self.the_customer_icon_view];
    
    self.the_customer_seeking_label=[[UILabel alloc]initWithFrame:CGRectMake(50, 10,100, 30)];
    [self.the_customer_seeking_label setFont: [UIFont systemFontOfSize:20]];
    [self.the_customer_seeking_label setText:NSLocalizedString(@"Add Buyer", @"添加顾客")];
    //[self.the_customer_seeking_label setText:@"Add Buyer"];
    [self.the_customer_seeking_label setTextAlignment:(NSTextAlignmentCenter)];
    [self.container addSubview:self.the_customer_seeking_label];
    
    self.the_customer_mobile_textfield = [[UITextField alloc]initWithFrame:CGRectMake(180, 10, 150, 30)];
    [self.the_customer_mobile_textfield setPlaceholder:NSLocalizedString(@"Mobile", @"手机号")];
    [self.the_customer_mobile_textfield setTextAlignment:(NSTextAlignmentLeft)];
    [self.the_customer_mobile_textfield setKeyboardType:(UIKeyboardTypeNumberPad)];
    [self.the_customer_mobile_textfield setBorderStyle:(UITextBorderStyleLine)];
    [self.the_customer_mobile_textfield setDelegate:self];
    [self.the_customer_mobile_textfield setReturnKeyType:(UIReturnKeySearch)];
    [self.container addSubview:self.the_customer_mobile_textfield];
    
    self.the_customer_search_result=[[UILabel alloc]initWithFrame:CGRectMake(20, 40, 400, 100)];
    [self.the_customer_search_result setText:@""
     //NSLocalizedString(@"Not sought yet\nMaybe you can invite one.", @"没有找到\n可以新建顾客账户")
     ];
    [self.the_customer_search_result setLineBreakMode:(NSLineBreakByWordWrapping)];
    [self.the_customer_search_result setNumberOfLines:0];
    [self.container addSubview:self.the_customer_search_result];
    
    self.the_customer_seek_button =[UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.the_customer_seek_button setFrame:CGRectMake(350, 10, 80, 30)];
    [self.the_customer_seek_button setTitle:NSLocalizedString(@"Seek", @"搜索")  forState:(UIControlStateNormal)];
    self.the_customer_seek_button.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    self.the_customer_seek_button.titleLabel.textColor=[UIColor whiteColor];
    self.the_customer_seek_button.backgroundColor = [UIColor colorWithRed:157/255.0 green:153/255.0 blue:190/255.0 alpha:1];
    [self.the_customer_seek_button addTarget:self action:@selector(seek_customer:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.container addSubview:self.the_customer_seek_button];
    
    self.the_customer_new_button =[UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.the_customer_new_button setFrame:CGRectMake(280, 150, 150, 30)];
    self.the_customer_new_button.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    self.the_customer_new_button.titleLabel.textColor=[UIColor whiteColor];
    self.the_customer_new_button.backgroundColor = [UIColor colorWithRed:157/255.0 green:153/255.0 blue:190/255.0 alpha:1];
    [self.the_customer_new_button setTitle:NSLocalizedString(@"New Customer", @"招募顾客")  forState:(UIControlStateNormal)];
    [self.the_customer_new_button addTarget:self action:@selector(show_new_customer_VC:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.container addSubview:self.the_customer_new_button];
   
    self.the_order_confirm_button=[UIButton buttonWithType:UIButtonTypeCustom];
    self.the_order_confirm_button.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    self.the_order_confirm_button.titleLabel.textColor=[UIColor whiteColor];
    self.the_order_confirm_button.backgroundColor = [UIColor colorWithRed:157/255.0 green:153/255.0 blue:190/255.0 alpha:1];
    self.the_order_confirm_button.frame=CGRectMake(280, 150, 150, 30);
    [self.the_order_confirm_button setTitle:NSLocalizedString(@"Order Confirm", @"确认订单")  forState:(UIControlStateNormal)];
    [self.the_order_confirm_button addTarget:self action:@selector(order_confirm:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.container addSubview:self.the_order_confirm_button];
    [self.the_order_confirm_button setHidden:YES];
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView{
    [super loadView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self.view setFrame:CGRectMake(0, 60,1024, 708)];
    [self.view setBackgroundColor:[UIColor redColor]];
    
    self.monoTableView=[[MonoTable alloc]initWithFrame:(CGRectMake(5, 5, 550, 670))  style:(UITableViewStylePlain)];
    [self.monoTableView setDelegate:self.monoTableView];
    [self.monoTableView setDataSource:self.monoTableView];
    [self.monoTableView setRowHeight:70];
    [self.monoTableView setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
    [self.view addSubview:self.monoTableView];
    
    self.cartTableView=[[CartTable alloc]initWithFrame:(CGRectMake(570, 75, 450, 300))  style:(UITableViewStylePlain)];
    [self.cartTableView setDelegate:self.cartTableView];
    [self.cartTableView setDataSource:self.cartTableView];
    [self.cartTableView setRowHeight:50];
    [self.cartTableView setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
    [self.view addSubview:self.cartTableView];
    
    [self design_customer_search_area];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillShow:)
												 name:UIKeyboardWillShowNotification
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHide:)
												 name:UIKeyboardWillHideNotification
											   object:nil];
    // 键盘高度变化通知，ios5.0新增的
#ifdef __IPHONE_5_0
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
#endif
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)seek_customer:(id)sender{
    _Log(@"seek_customer called");
    [self.the_customer_mobile_textfield resignFirstResponder];
    //mock
    BOOL found=NO;
    if([self.the_customer_mobile_textfield.text longLongValue]>13500000000){
        found=YES;
        [self.the_customer_search_result setText:[NSString stringWithFormat:
         NSLocalizedString(@"Customer Information:\n%@ Mobile: %@\nBaby Birthday: %@", @"顾客信息：\n%@ 手机号：%@\n宝宝生日：%@"),
                                                  @"Mr Wakayama",
                                                  self.the_customer_mobile_textfield.text,
                                                  @"2014-01-01"
                                                  ]
         ];
        [self.the_customer_new_button setHidden:YES];
        [self.the_order_confirm_button setHidden:NO];
    }else{
        [self.the_customer_search_result setText:NSLocalizedString(@"Not found",  @"没有找到该顾客")];
        [self.the_customer_new_button setHidden:NO];
        [self.the_order_confirm_button setHidden:YES];
    }
    
}

-(void)show_new_customer_VC:(id)sender{
    _Log(@"show_new_customer_VC called");
    NewCustomerController * nc=[[NewCustomerController alloc]init];
    //[nc setModalPresentationStyle:(UIModalPresentationPageSheet)];
    [nc setModalPresentationStyle:(UIModalPresentationFormSheet)];
    [nc setModalTransitionStyle:(UIModalTransitionStyleFlipHorizontal)];
    [self presentViewController:nc animated:YES completion:^{
        _Log(@"NewCustomerVC presented");
    }];
    CGRect frame=nc.view.frame;
    //_Log(@"PAGE WIDTH=%f",frame.size.width);//768//540
    frame.size.height=500;
    //frame.size.width+=100;
    [nc.view.superview setFrame:frame];
}

-(void)order_confirm:(id)sender{
    _Log(@"order_confirm called");
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Order Confirmed", @"订单确认")  message:NSLocalizedString(@"Your order has been confirmed.", @"您的订单已经确认。") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"好") otherButtonTitles: nil];
    [alertView show];
}

//
- (void)keyboardWillShow:(NSNotification *)notification
{
	CGRect rect;
	NSValue *value = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
	[value getValue:&rect];
    rect=[self.view convertRect:rect fromView:nil];
    //_Log(@"rect=[%f] value rect=[%f]",rect.origin.y,[value CGRectValue].origin.y);
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
	[UIView setAnimationCurve:(UIViewAnimationCurve)[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue]];
    
    [self.view setFrame:CGRectMake(0, 0-rect.size.height,1024, 708)];
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
    
    [self.view setFrame:CGRectMake(0, 0,1024, 708)];
    [UIView commitAnimations];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    _Log(@"Search Custeomer textFieldShouldReturn");
    [self seek_customer:textField];
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![self.the_customer_mobile_textfield isExclusiveTouch]) {
        [self.the_customer_mobile_textfield  resignFirstResponder];
    }
}

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    _Log(@"alertView clickedButtonAtIndex %d",buttonIndex);
}

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)alertViewCancel:(UIAlertView *)alertView{
    _Log(@"alertViewCancel");
}

@end
