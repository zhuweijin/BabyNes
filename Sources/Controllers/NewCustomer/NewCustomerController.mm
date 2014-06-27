//
//  NewCustomerController.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-6-27.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "NewCustomerController.h"

@interface NewCustomerController ()

@property NSArray * provinces_array;
@property NSArray * cities_array;

@end

@implementation NewCustomerController

-(void)designView{
    self.baby_cells=[[NSMutableArray alloc]init];
    LSNewCustomer_BabyCell * first=[[LSNewCustomer_BabyCell alloc]initWithFrame:CGRectMake(0, 0, 500, 140) withinController:self];
    //[first initDate];
    [self.baby_cells addObject:first];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.theExitButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.theExitButton.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    self.theExitButton.titleLabel.textColor=[UIColor whiteColor];
    self.theExitButton.backgroundColor = [UIColor colorWithRed:157/255.0 green:153/255.0 blue:190/255.0 alpha:1];
    self.theExitButton.frame=CGRectMake(430, 20, 100, 30);
    [self.theExitButton setTitle:NSLocalizedString(@"Close", @"取消创建") forState:UIControlStateNormal];
    [self.theExitButton addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.theExitButton];
    
    self.theTopLineView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 540, 8)];
    self.theTopLineView.backgroundColor =[UIColor colorWithRed:157/255.0 green:153/255.0 blue:190/255.0 alpha:1];
    [self.view addSubview:self.theTopLineView];
    
    self.theTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(160, 20, 200, 30)];
    [self.theTitleLabel setText:NSLocalizedString(@"New Customer", @"招募顾客")];
    [self.theTitleLabel setFont:[UIFont systemFontOfSize:20]];
    [self.theTitleLabel setTextColor:[UIColor colorWithRed:157/255.0 green:153/255.0 blue:190/255.0 alpha:1]];
    [self.theTitleLabel setTextAlignment:(NSTextAlignmentCenter)];
    [self.view addSubview:self.theTitleLabel];
    
    self.InfoScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(10, 60, 580, 350)];
    [self.InfoScrollView setContentSize: CGSizeMake(580, 500)];
    //[self.InfoScrollView setBackgroundColor:[UIColor redColor]];
    [self.InfoScrollView setScrollEnabled:YES];
    [self.InfoScrollView setScrollsToTop:NO];
    [self.InfoScrollView setBounces:NO];
    [self.InfoScrollView setPagingEnabled:NO];
    //[self.InfoScrollView setScrollIndicatorInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
    [self.view addSubview:self.InfoScrollView];
    
    self.theCustomerLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, 120, 30)];
    [self.theCustomerLabel setText:NSLocalizedString(@"About Customer:", @"顾客信息：")];
    [self.theCustomerLabel setFont:[UIFont systemFontOfSize:19]];
    //[self.theCustomerLabel setTextColor:[UIColor colorWithRed:157/255.0 green:153/255.0 blue:190/255.0 alpha:1]];
    //[self.theCustomerLabel setTextAlignment:(NSTextAlignmentCenter)];
    [self.InfoScrollView addSubview:self.theCustomerLabel];
    
    self.theCustomerTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, 30, 80, 30)];
    [self.theCustomerTitleLabel setText:NSLocalizedString(@"* Title:", @"* 称呼：")];
    [self.theCustomerTitleLabel setFont:[UIFont systemFontOfSize:18]];
    //[self.theCustomerTitleLabel setTextColor:[UIColor colorWithRed:157/255.0 green:153/255.0 blue:190/255.0 alpha:1]];
    //[self.theCustomerTitleLabel setTextAlignment:(NSTextAlignmentCenter)];
    [self.InfoScrollView addSubview:self.theCustomerTitleLabel];
    
    self.theCustomerNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(250, 30, 150, 30)];
    [self.theCustomerNameLabel setText:NSLocalizedString(@"* Name:", @"* 姓名：")];
    [self.theCustomerNameLabel setFont:[UIFont systemFontOfSize:18]];
    //[self.theCustomerNameLabel setTextColor:[UIColor colorWithRed:157/255.0 green:153/255.0 blue:190/255.0 alpha:1]];
    //[self.theCustomerNameLabel setTextAlignment:(NSTextAlignmentCenter)];
    [self.InfoScrollView addSubview:self.theCustomerNameLabel];
    
    self.theCustomerLocationLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, 70, 80, 30)];
    [self.theCustomerLocationLabel setText:NSLocalizedString(@"* City:", @"* 城市：")];
    [self.theCustomerLocationLabel setFont:[UIFont systemFontOfSize:18]];
    //[self.theCustomerLocationLabel setTextColor:[UIColor colorWithRed:157/255.0 green:153/255.0 blue:190/255.0 alpha:1]];
    //[self.theCustomerLocationLabel setTextAlignment:(NSTextAlignmentCenter)];
    [self.InfoScrollView addSubview:self.theCustomerLocationLabel];
    
    self.theCustomerMobileLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, 110, 120, 30)];
    [self.theCustomerMobileLabel setText:NSLocalizedString(@"* Mobile:", @"* 手机号：")];
    [self.theCustomerMobileLabel setFont:[UIFont systemFontOfSize:18]];
    //[self.theCustomerMobileLabel setTextColor:[UIColor colorWithRed:157/255.0 green:153/255.0 blue:190/255.0 alpha:1]];
    //[self.theCustomerMobileLabel setTextAlignment:(NSTextAlignmentCenter)];
    [self.InfoScrollView addSubview:self.theCustomerMobileLabel];
    
    self.theTitleCB=[[LSComboBox alloc]initWithFrame:CGRectMake(120, 30, 100, 30) withinController:self withData:@[NSLocalizedString(@"Mr", @"先生"),NSLocalizedString(@"Ms", @"女士")] withSetsumei:NSLocalizedString(@"Title", @"称呼")];
    [self.InfoScrollView addSubview:self.theTitleCB];
    
    self.theUserNameTextfield=[[UITextField alloc]initWithFrame:CGRectMake(320, 30, 120, 30)];
    [self.theUserNameTextfield setBackgroundColor:[UIColor colorWithRed:242/255.0 green:242/255.0 blue:244/255.0 alpha:0.9]];
    [self.theUserNameTextfield setTextAlignment:(NSTextAlignmentCenter)];
    [self.theUserNameTextfield setPlaceholder:NSLocalizedString(@"Name", @"姓名")];
    [self.InfoScrollView addSubview: self.theUserNameTextfield];
    
    self.theProvinceCB=[[LSComboBox alloc]initWithFrame:CGRectMake(120, 70, 100, 30) withinController:self withData:
                        self.provinces_array
                        //                        [LSLocations getProvinceArray]
                                           withSetsumei:NSLocalizedString(@"Province", @"省份")];
    [self.theProvinceCB addTarget:self action:@selector(provinceChanged:) forControlEvents:UIControlEventEditingDidEnd];
    [self.InfoScrollView addSubview:self.theProvinceCB];
    
    self.theCityCB=[[LSComboBox alloc]initWithFrame:CGRectMake(240, 70, 100, 30) withinController:self withData:
                    self.cities_array
                    //                    [LSLocations getCityArray:self.theProvinceCB.value_string]
                                       withSetsumei:NSLocalizedString(@"City", @"城市")];
    [self.InfoScrollView addSubview:self.theCityCB];
    
    self.theAddressTextfield=[[UITextField alloc]initWithFrame:CGRectMake(350, 70, 160, 30)];
    [self.theAddressTextfield setBackgroundColor:[UIColor colorWithRed:242/255.0 green:242/255.0 blue:244/255.0 alpha:0.9]];
    [self.theAddressTextfield setTextAlignment:(NSTextAlignmentCenter)];
    [self.theAddressTextfield setPlaceholder:NSLocalizedString(@"Address", @"地址")];
    [self.InfoScrollView addSubview: self.theAddressTextfield];
    
    self.theMobileTextfield=[[UITextField alloc]initWithFrame:CGRectMake(120, 110, 150,30)];
    [self.theMobileTextfield setBackgroundColor:[UIColor colorWithRed:242/255.0 green:242/255.0 blue:244/255.0 alpha:0.9]];
    [self.theMobileTextfield setPlaceholder:NSLocalizedString(@"Mobile", @"手机号")];
    [self.theMobileTextfield setKeyboardType:(UIKeyboardTypePhonePad)];
    [self.theMobileTextfield setTextAlignment:(NSTextAlignmentCenter)];
    [self.InfoScrollView addSubview:self.theMobileTextfield];
    
    self.theCustomerEmailLabel=[[UILabel alloc]initWithFrame:CGRectMake(280, 110, 90, 30)];
    [self.theCustomerEmailLabel setText:NSLocalizedString(@"Email:", @"电子邮箱：")];
    [self.theCustomerEmailLabel setFont:[UIFont systemFontOfSize:18]];
    [self.InfoScrollView addSubview:self.theCustomerEmailLabel];
    
    self.theEmailTextfield=[[UITextField alloc]initWithFrame:CGRectMake(390, 110, 120, 30)];
    [self.theEmailTextfield setBackgroundColor:[UIColor colorWithRed:242/255.0 green:242/255.0 blue:244/255.0 alpha:0.9]];
    [self.theEmailTextfield setTextAlignment:(NSTextAlignmentCenter)];
    [self.theEmailTextfield setPlaceholder:NSLocalizedString(@"Email", @"电子邮件")];
    [self.theEmailTextfield setKeyboardType:(UIKeyboardTypeEmailAddress)];
    [self.InfoScrollView addSubview: self.theEmailTextfield];
    
    [self refreshBabiesViews];
    
    self.theBabyAddButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.theBabyAddButton.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    self.theBabyAddButton.titleLabel.textColor=[UIColor whiteColor];
    self.theBabyAddButton.backgroundColor = [UIColor colorWithRed:157/255.0 green:153/255.0 blue:190/255.0 alpha:1];
    self.theBabyAddButton.frame=CGRectMake(130, 450, 100, 30);
    [self.theBabyAddButton setTitle:NSLocalizedString(@"Add Baby", @"添加一个宝宝") forState:UIControlStateNormal];
    [self.theBabyAddButton addTarget:self action:@selector(addBaby:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.theBabyAddButton];
    
    self.theCustomerAddButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.theCustomerAddButton.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    self.theCustomerAddButton.titleLabel.textColor=[UIColor whiteColor];
    self.theCustomerAddButton.backgroundColor = [UIColor colorWithRed:157/255.0 green:153/255.0 blue:190/255.0 alpha:1];
    self.theCustomerAddButton.frame=CGRectMake(380, 450, 100, 30);
    [self.theCustomerAddButton setTitle:NSLocalizedString(@"Create", @"确认创建") forState:UIControlStateNormal];
    [self.theCustomerAddButton addTarget:self action:@selector(addCustomer:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.theCustomerAddButton];
}

-(void)refreshBabiesViews{
    NSLog(@"refreshBabiesViews array=[%@]",self.baby_cells);
    [self.InfoScrollView setContentSize: CGSizeMake(580, 180+140*[self.baby_cells count])];
    for (int i=0; i<[self.baby_cells count]; i++) {
        LSNewCustomer_BabyCell*cell=[self.baby_cells objectAtIndex:i];
        [cell removeFromSuperview];
        if([self.baby_cells count]>1)
            cell.theBabyLabel.text=[NSString stringWithFormat: NSLocalizedString(@"For Baby [%d]:", @"第%d个宝宝信息："),(i+1)];
        [cell setFrame:CGRectMake(0,180+140*i, 500, 140)];
        [self.InfoScrollView addSubview:cell];
    }
}

-(void)provinceChanged:(id)sender{
    NSString * v=self.theProvinceCB.value_string;
    NSLog(@"provinceChanged -> %@ !",v);
    [self.theCityCB reloadDataForSelection:
     self.cities_array
     //     [LSLocations getCityArray:v]
     ];
}

-(void)addBaby:(id)sender{
    NSLog(@"addBaby called");
    LSNewCustomer_BabyCell * first=[[LSNewCustomer_BabyCell alloc]initWithFrame:CGRectMake(0, 0, 500, 140) withinController:self];
    //[first initDate];
    [self.baby_cells addObject:first];
    [self refreshBabiesViews];
    [self.InfoScrollView scrollRectToVisible:CGRectMake(0,180-140+140*[self.baby_cells count], 500, 140) animated:YES];
}

-(void)addCustomer:(id)sender{
    NSLog(@"addCustomer called");
    /*
     LSCustomer * cc=[LSCustomer getCurrentCustomer];
     
     [cc setTheTitle:self.theTitleCB.value_string];
     [cc setTheName:self.theCustomerNameLabel.text];
     [cc setTheProvince:self.theProvinceCB.value_string];
     [cc setTheCity:self.theCityCB.value_string];
     [cc setTheAddress:self.theAddressTextfield.text];
     [cc setTheMobile:self.theMobileTextfield.text];
     [cc setTheEmail:self.theEmailTextfield.text];
     
     for (LSNewCustomer_BabyCell* cell in self.baby_cells) {
     LSBaby * baby=[[LSBaby alloc]init];
     [baby setThe_birth_day:[cell.theBabyBirthday_Day.value_string intValue]];
     [baby setThe_birth_month:[cell.theBabyBirthday_Month.value_string intValue]];
     [baby setThe_birth_year:[cell.theBabyBirthday_Year.value_string intValue]];
     [baby setThe_nick:cell.theBaby_Nick.text];
     [baby setThe_sex:cell.theBaby_Sex.value_string];
     [cc addOneBaby:baby];
     }
     NSString* result=[cc createCustomer];
     [cc reset];
     */
    [self closeView:sender];
}

-(void)closeView:(id)sender{
    NSLog(@"closeView called");
    //[self sendAction:@selector(customer_create_hide:) to:self.superview forEvent:UIControlEventTouchUpInside];
    //[self.theController receive_event:sender forEventDescription:@"close_new_customer_apply_view" withNSString:@""];
    //[self.theController popoverModeViewOff];
    [self dismissViewControllerAnimated:YES completion:^{
        _Log(@"New Customer VC dismissed");
    }];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.provinces_array=@[@"Zhejiang",@"Shanghai"];
    self.cities_array=@[@"Hangzhou",@"Pudong"];
    
    [self designView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

//
- (void)keyboardWillShow:(NSNotification *)notification
{
	CGRect rect;
	NSValue *value = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
	[value getValue:&rect];
    rect=[self.view convertRect:rect fromView:nil];
    _Log(@"rect=[%f] value rect=[%f]",rect.origin.y,[value CGRectValue].origin.y);
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
	[UIView setAnimationCurve:(UIViewAnimationCurve)[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue]];
    CGRect frame=self.view.frame;
    frame.origin.y-=rect.size.height;
    //[self.view setFrame:frame];
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
    CGRect frame=self.view.frame;
    frame.origin.y=0;
    //[self.view setFrame:frame];
    [UIView commitAnimations];
}


@end
