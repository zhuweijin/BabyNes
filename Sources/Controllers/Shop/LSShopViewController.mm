//
//  LSShopViewController.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-6-26.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "LSShopViewController.h"

@interface LSShopViewController ()

@property MonoTable * monoTableView;
@property CartTable * cartTableView;

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

//@property CacheImageView * civ;

@end

static CGFloat reloadHeaderHeight=30;

@implementation LSShopViewController

// Constructor
- (id)init
{
    self = [super initWithService:@"pdt_classify"];
    self.title = NSLocalizedString(@"Shop", @"网上商店");
    self.thePullReloadDelegate=self;
    return self;
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

-(void)addObservers{
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealCartChanged:) name:@"CartChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealMonoCellSelected:) name:@"MonoCellSelected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UserRegistered:) name:@"UserRegistered" object:nil];
    
    _Log(@"LSShopVC addObservers");
}
-(void)removeObservers{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CartChanged" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MonoCellSelected" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UserRegistered" object:nil];
    
    _Log(@"LSShopVC removeObservers");
}

- (void)viewDidLoad
{
    _Log(@"LSShopViewController viewDidLoad");
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self.view setFrame:CGRectMake(0, 60,1024, 708)];
    //[self.view setBackgroundColor:[UIColor redColor]];
    //[self.view setUserInteractionEnabled:YES];
    
    self.list_icon_image=UIUtil::Image(@"app/cart@2x.png");//[UIImage imageNamed:@"cart@2x.png"];
    self.list_icon_image_view=[[UIImageView alloc]initWithFrame:CGRectMake(580, 15, 30, 30)];
    [self.list_icon_image_view setImage:self.list_icon_image];
    [self.view addSubview:self.list_icon_image_view];
    
    self.list_caption= [[UILabel alloc]initWithFrame:CGRectMake(630, 15, 200, 30)];
    self.list_caption.text=NSLocalizedString(@"Shopping Cart", @"购物车");
    [self.list_caption setFont: [UIFont systemFontOfSize:20]];
    [self.view addSubview:self.list_caption];
    
    self.list_header= [[UILabel alloc]initWithFrame:CGRectMake(660, 50, 380, 30)];
    self.list_header.text=NSLocalizedString(@"Product                     Price         Quantity", @"产品                              价格           数量");
    [self.list_header setFont: [UIFont systemFontOfSize:18]];
    [self.view addSubview:self.list_header];
    
    self.sum_label= [[UILabel alloc]initWithFrame:CGRectMake(590, 405, 400, 30)];
    self.sum_label.text=[NSString stringWithFormat: NSLocalizedString(@"Sum $%.2f     Quantity %d", @"总计：￥%.2f       数量：%d"),0/100.0,0];
    [self.sum_label setFont: [UIFont systemFontOfSize:20]];
    [self.sum_label setTextAlignment:(NSTextAlignmentCenter)];
    [self.view addSubview:self.sum_label];
    
    
    self.the_customer_icon=UIUtil::Image(@"app/icon-search@2x.png");//[UIImage imageNamed:@"app/icon-search@2x.png"];
    self.the_customer_icon_view=[[UIImageView alloc] initWithFrame:CGRectMake(580, 460, 30, 30)];
    [self.the_customer_icon_view setImage:self.the_customer_icon];
    [self.view addSubview:self.the_customer_icon_view];
    
    self.the_customer_seeking_label=[[UILabel alloc]initWithFrame:CGRectMake(620, 460,100, 30)];
    [self.the_customer_seeking_label setFont: [UIFont systemFontOfSize:20]];
    [self.the_customer_seeking_label setText:NSLocalizedString(@"Add Buyer", @"添加顾客")];
    //[self.the_customer_seeking_label setText:@"Add Buyer"];
    [self.the_customer_seeking_label setTextAlignment:(NSTextAlignmentCenter)];
    [self.view addSubview:self.the_customer_seeking_label];
    
    self.the_customer_mobile_textfield = [[UITextField alloc]initWithFrame:CGRectMake(750, 460, 150, 30)];
    [self.the_customer_mobile_textfield setPlaceholder:NSLocalizedString(@"Mobile", @"手机号")];
    [self.the_customer_mobile_textfield setTextAlignment:(NSTextAlignmentLeft)];
    [self.the_customer_mobile_textfield setKeyboardType:(UIKeyboardTypeNumberPad)];
    [self.the_customer_mobile_textfield setBorderStyle:(UITextBorderStyleLine)];
    [self.the_customer_mobile_textfield setBackgroundColor:[UIColor whiteColor]];
    [self.the_customer_mobile_textfield setDelegate:self];
    [self.the_customer_mobile_textfield setReturnKeyType:(UIReturnKeySearch)];
    [self.view addSubview:self.the_customer_mobile_textfield];
    
    self.the_customer_search_result=[[UILabel alloc]initWithFrame:CGRectMake(590, 490, 400, 100)];
    [self.the_customer_search_result setText:@""
     //NSLocalizedString(@"Not sought yet\nMaybe you can invite one.", @"没有找到\n可以新建顾客账户")
     ];
    [self.the_customer_search_result setLineBreakMode:(NSLineBreakByWordWrapping)];
    [self.the_customer_search_result setNumberOfLines:0];
    [self.view addSubview:self.the_customer_search_result];
    
    self.the_customer_seek_button =[UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.the_customer_seek_button setFrame:CGRectMake(920, 460, 80, 30)];
    [self.the_customer_seek_button setTitle:NSLocalizedString(@"Seek", @"搜索")  forState:(UIControlStateNormal)];
    self.the_customer_seek_button.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    self.the_customer_seek_button.titleLabel.textColor=[UIColor whiteColor];
    self.the_customer_seek_button.backgroundColor = [UIColor colorWithRed:157/255.0 green:153/255.0 blue:190/255.0 alpha:1];
    [self.the_customer_seek_button setBackgroundImage:UIUtil::ImageWithColor(117, 114, 184) forState:UIControlStateHighlighted];
    [self.the_customer_seek_button addTarget:self action:@selector(seek_customer:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.the_customer_seek_button];
    
    self.the_customer_new_button =[UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.the_customer_new_button setFrame:CGRectMake(850, 600, 150, 30)];
    self.the_customer_new_button.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    self.the_customer_new_button.titleLabel.textColor=[UIColor whiteColor];
    self.the_customer_new_button.backgroundColor = [UIColor colorWithRed:157/255.0 green:153/255.0 blue:190/255.0 alpha:1];
    [self.the_customer_new_button setBackgroundImage:UIUtil::ImageWithColor(117, 114, 184) forState:UIControlStateHighlighted];
    [self.the_customer_new_button setTitle:NSLocalizedString(@"New Customer", @"招募顾客")  forState:(UIControlStateNormal)];
    [self.the_customer_new_button addTarget:self action:@selector(show_new_customer_VC:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.the_customer_new_button];
    
    self.the_order_confirm_button=[UIButton buttonWithType:UIButtonTypeCustom];
    self.the_order_confirm_button.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    self.the_order_confirm_button.titleLabel.textColor=[UIColor whiteColor];
    self.the_order_confirm_button.backgroundColor = [UIColor colorWithRed:157/255.0 green:153/255.0 blue:190/255.0 alpha:1];
    [self.the_order_confirm_button setBackgroundImage:UIUtil::ImageWithColor(117, 114, 184) forState:UIControlStateHighlighted];
    self.the_order_confirm_button.frame=CGRectMake(850, 600, 150, 30);
    [self.the_order_confirm_button setTitle:NSLocalizedString(@"Order Confirm", @"确认订单")  forState:(UIControlStateNormal)];
    [self.the_order_confirm_button addTarget:self action:@selector(order_confirm:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.the_order_confirm_button];
    [self.the_order_confirm_button setHidden:YES];
    
    self.cartTableView=[[CartTable alloc]initWithFrame:(CGRectMake(570, 85, 450, 300))  style:(UITableViewStylePlain)];//in view directly CGRectMake(570, 75, 450, 300)
    [self.cartTableView setDelegate:self.cartTableView];
    [self.cartTableView setDataSource:self.cartTableView];
    [self.cartTableView setRowHeight:50];
    [self.cartTableView setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
    [self.cartTableView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.cartTableView];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self removeObservers];
    [self addObservers];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeObservers];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadContentView:(UIView *)contentView withDict:(NSDictionary *)dict{
    _Log(@"LSShopViewcController loadContentView[%@] withDict[%@]",contentView,dict);
    
    is_reloading=false;
    [self responseForReloadWork];
    
    if(self.monoTableView){
        [self.monoTableView removeFromSuperview];
        self.monoTableView = nil;
    }
    
    [contentView setFrame:(CGRectMake(0, 0, 560, 680))];
    
    [ProductEntity updateProductDictionaryWithJSON:dict];
    
    self.monoTableView=[[MonoTable alloc]initWithFrame:(CGRectMake(5, 15, 550, 670))  style:(UITableViewStylePlain)];
    //[self.monoTableView setBackgroundColor:[UIColor greenColor]];
    //[self.monoTableView setPdtArrayWithNSDic:dict];
    [self.monoTableView setDelegate:self.monoTableView];
    [self.monoTableView setDataSource:self.monoTableView];
    [self.monoTableView setRowHeight:70];
    [self.monoTableView setSeparatorStyle:(UITableViewCellSeparatorStyleSingleLine)];
    [contentView addSubview:self.monoTableView];
    
    reloadLabel=[[UILabel alloc]initWithFrame:{0,0,self.monoTableView.frame.size.width,reloadHeaderHeight}];
    [reloadLabel setTextColor:[UIColor grayColor]];
    [reloadLabel setText:NSLocalizedString(@"Pull to reload", @"下拉以刷新")];
    [reloadLabel setTextAlignment:(NSTextAlignmentCenter)];
    //[self.monoTableView addSubview:reloadLabel];
    [self.monoTableView setTableHeaderView:reloadLabel];
    [self.monoTableView setContentSize:{self.monoTableView.frame.size.width,self.monoTableView.frame.size.height+reloadHeaderHeight}];
    [self.monoTableView scrollRectToVisible:{0,reloadHeaderHeight,self.monoTableView.frame.size.width,self.monoTableView.frame.size.height} animated:YES];
    
    [self.monoTableView setTheSVDelegate:self];
    
    [self.monoTableView reloadData];
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
    _Log(@"SHOP VC keyboardWillShow");
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
    _Log(@"SHOP VC keyboardWillHide");
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
    [self resetShopView];
}

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)alertViewCancel:(UIAlertView *)alertView{
    _Log(@"alertViewCancel");
    [self resetShopView];
}

-(void)dealCartChanged:(NSNotification*) notification{
    _Log(@"SHOP VC dealCartChanged !");
    self.sum_label.text=[NSString stringWithFormat: NSLocalizedString(@"Sum $%.2f     Quantity %d", @"总计：￥%.2f       数量：%d"),[[CartEntity getDefaultCartEntity]getTotalCents]/100.0,[[CartEntity getDefaultCartEntity]getTotalQuantity]];
}

-(void)dealMonoCellSelected:(NSNotification *)notification{
    _Log(@"SHOP VC dealMonoCellSelected ! with obj=[%@]",notification.object);
    if([CartEntity getChangeState]){
        _Log(@"Cart doing");
    }else{
        [CartEntity setChangeState:YES];
    }
    
    double whole_animation_duration=0.4;
    
    CacheImageView * civ= [notification.object objectForKey:@"civ"];
    CGRect originalCIVFrame=civ.frame;
    ProductEntity* pe= [notification.object objectForKey:@"pe"];
    
    if([[CartEntity getDefaultCartEntity] currentQuantityOfProductID:[pe product_id]]==0){
        _Log(@"Should do CartItem Insert Animation");
        CGRect cartItemFromFrame=originalCIVFrame;
        
        cartItemFromFrame.size.width=450;
        cartItemFromFrame.size.height=50;
        
        CGRect cartItemToFrame=cartItemFromFrame;
        
        cartItemFromFrame.origin.x+=80;
        
        int row_count=[self.cartTableView tableView:self.cartTableView numberOfRowsInSection:0];
        _Log(@"dealMonoCellSelected row_count in cart tale is %d",row_count);
        CGFloat offset=5*50;
        if(row_count<6){
            offset=row_count*50;
        }
        
        cartItemToFrame.origin.x=self.cartTableView.frame.origin.x;
        cartItemToFrame.origin.y=self.cartTableView.frame.origin.y+offset;
        LSShopCartTableViewCell * cell=[[LSShopCartTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"CartCell"];
        [cell loadCartMonoWithName:pe.product_title andPrice:pe.product_price_cents andQuantity:pe.quantity andID:pe.product_id];
        cell.frame=cartItemFromFrame;
        [cell setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:cell];
        [UIView animateWithDuration:whole_animation_duration animations:^{
            if(row_count>=6){
                [self.cartTableView setContentOffset:CGPointMake(0, 50*(row_count-5))];
            }
            cell.frame=cartItemToFrame;
            cell.backgroundColor = UIUtil::Color(235,238,250);//[UIColor yellowColor];
        } completion:^(BOOL finished) {
            [cell removeFromSuperview];
            [[CartEntity getDefaultCartEntity]addToCart:[pe product_id] withQuantity:1];
        }];
    }else{
        NSNumber *index_NS=[notification.object objectForKey:@"inCart"];
        int index=[index_NS intValue];
        _Log(@"Seek existed index:[%d]",index);
        if(index>=0){
            if(self.cartTableView.contentOffset.y>=50*(index-5) && self.cartTableView.contentOffset.y<=50*(index)){
                _Log(@"SHOULD BE VISIBLE self.cartTableView.contentOffset.y=%f",self.cartTableView.contentOffset.y);
                UITableViewCell * cell=[self.cartTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
                _Log(@"Seek existed cell:[%@]",cell);
                cell.backgroundColor=UIUtil::Color(235,238,250);//[UIColor yellowColor];
                [UIView animateWithDuration:whole_animation_duration animations:^{
                    
                    if(index>5){
                        [self.cartTableView setContentOffset:CGPointMake(0, 50*(index-5))];
                    }else{
                        [self.cartTableView setContentOffset:CGPointMake(0, 0)];
                    }
                    
                    cell.backgroundColor=[UIColor whiteColor];
                } completion:^(BOOL finished) {
                    [[CartEntity getDefaultCartEntity]addToCart:[pe product_id] withQuantity:1];
                }];
            }else{
                _Log(@"SHOULD NOT BE VISIBLE self.cartTableView.contentOffset.y=%f",self.cartTableView.contentOffset.y);
                [UIView animateWithDuration:whole_animation_duration/2 animations:^{
                    
                    if(index>5){
                        [self.cartTableView setContentOffset:CGPointMake(0, 50*(index-5))];
                    }else{
                        [self.cartTableView setContentOffset:CGPointMake(0, 0)];
                    }
                } completion:^(BOOL finished) {
                    UITableViewCell * cell=[self.cartTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
                    _Log(@"Seek existed cell:[%@]",cell);
                    cell.backgroundColor=UIUtil::Color(235,238,250);//[UIColor yellowColor];
                    [UIView animateWithDuration:whole_animation_duration/2 animations:^{
                        
                        if(index>5){
                            [self.cartTableView setContentOffset:CGPointMake(0, 50*(index-5))];
                        }else{
                            [self.cartTableView setContentOffset:CGPointMake(0, 0)];
                        }
                        
                        cell.backgroundColor=[UIColor whiteColor];
                    } completion:^(BOOL finished) {
                        [[CartEntity getDefaultCartEntity]addToCart:[pe product_id] withQuantity:1];
                    }];
                }];
            }
        }
    }
    
}

-(void)UserRegistered:(NSNotification *) notification{
    LSCustomer * cc=[LSCustomer getCurrentCustomer];
    NSString * baby_info=NSLocalizedString(@"Never registered", @"没有记录");
    if(cc && cc.theBabies && [cc.theBabies count]>0){
        LSBaby*baby=[cc.theBabies objectAtIndex:0];
        baby_info=[NSString stringWithFormat:@"%d-%d-%d",baby.the_birth_year,baby.the_birth_month,baby.the_birth_day];
    }
    NSString* customer_namae=@"Unknown";
    if([NSLocalizedString(@"EN", @"CN") isEqualToString:@"EN"]){
        customer_namae=[NSString stringWithFormat:@"%@ %@",cc.theTitle,cc.theName];
    }else{
        customer_namae=[NSString stringWithFormat:@"%@ %@",cc.theName,cc.theTitle];
    }
    [self.the_customer_search_result setText:
     [NSString stringWithFormat:
      NSLocalizedString(@"Customer Information:\n%@ Mobile: %@\nBaby Birthday: %@", @"顾客信息：\n%@ 手机号：%@\n宝宝生日：%@"),
      customer_namae,
      cc.theMobile,
      baby_info
      ]];
}

-(void)resetShopView{
    [[CartEntity getDefaultCartEntity]  resetCart];
    [self.the_customer_search_result setText:@""];
    [self.the_customer_mobile_textfield setText:@""];
    [self.the_customer_new_button setHidden:NO];
    [self.the_order_confirm_button setHidden:YES];
}

#pragma UIViewScrollerDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!is_reloading) { // 判断是否处于刷新状态，刷新中就不执行
        if(-scrollView.contentOffset.y>reloadHeaderHeight*2){
            _Log(@"ShopController scrollViewDidEndDragging to response");
            is_reloading=true;
            [self responseForReloadWork];
            return;
        }
    }
    _Log(@"ShopController scrollViewDidEndDragging not response as %f - %d",scrollView.contentOffset.y,decelerate);
    [scrollView setContentOffset:{0,reloadHeaderHeight} animated:YES];
    //[scrollView scrollRectToVisible:{0,reloadHeaderHeight,scrollView.frame.size.width,scrollView.frame.size.height} animated:YES];
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    @try {
        _Log(@"ShopController scrollViewDidEndDecelerating sV=[%@]",scrollView);
        if(!is_reloading && scrollView.contentOffset.y<reloadHeaderHeight){
            [scrollView scrollRectToVisible:{0,reloadHeaderHeight,scrollView.frame.size.width,scrollView.frame.size.height} animated:YES];
        }
    }
    @catch (NSException *exception) {
        _Log(@"~");
    }
    @finally {
        _Log(@"~~");
    }
}

-(void)responseForReloadWork{
    _Log(@"ShopController responseForReloadWork isWithError=%@ is_reloading=%d",_loader.errorString,is_reloading);
    if(is_reloading){
        [_loader loadBegin];
        [reloadLabel setText:NSLocalizedString(@"Loading...", @"加载中...")];
        [self.view.window setUserInteractionEnabled:NO];
        [self.monoTableView scrollRectToVisible:{0,0,self.monoTableView.frame.size.width,self.monoTableView.frame.size.height} animated:YES];
        
        //转转 开始
        UIViewController *controller = [self respondsToSelector:@selector(view)] ? (UIViewController *)self : UIUtil::VisibleViewController();
		[controller.view toastWithLoading];
		_LogLine();
        
        _Log(@"ShopController responseForReloadWork to 0,0");
        _Log(@"ShopController responseForReloadWork begin reload done");
    }else{
        [reloadLabel setText:NSLocalizedString(@"Pull to reload", @"下拉以刷新")];
        
        [self.monoTableView scrollRectToVisible:{0,reloadHeaderHeight,self.monoTableView.frame.size.width,self.monoTableView.frame.size.height} animated:YES];
        _Log(@"ShopController responseForReloadWork to 0,reloadHeaderHeight");
        [self.view.window setUserInteractionEnabled:YES];
        
        //转转 消失
        UIViewController *controller = [self respondsToSelector:@selector(view)] ? (UIViewController *)self : UIUtil::VisibleViewController();
		[controller.view dismissToast];
		_LogLine();
        
        _Log(@"ShopController responseForReloadWork end reload done");
    }
}

@end
