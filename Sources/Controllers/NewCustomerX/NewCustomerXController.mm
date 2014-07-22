//
//  NewCustomerXController.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-19.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "NewCustomerXController.h"

#import "NCCustomerTitleSubView.h"
#import "NCCustomerNameSubView.h"
#import "NCCustomerContactSubView.h"
#import "NCCustomerAddressSubView.h"

#import "NCBabyNickSubView.h"
#import "NCBabySexSubView.h"
#import "NCBabyBirthdaySubView.h"

@interface NewCustomerXController ()

@property NSArray * provinces_array;
@property NSArray * cities_array;
@property NSDictionary * province_city_dict;

@property CGFloat baby_cells_top;
@property CGFloat baby_cell_height;

@end

@implementation NewCustomerXController

// Constructor
- (id)init
{
	self = [super initWithService:@"ls_location"];
    self.baby_cells_top=160.0;
    self.baby_cell_height=180.0;
    
    _NewCustomer=[[LSCustomer alloc]init];
    //[_NewCustomer addOneBaby:[[LSBaby alloc]init]];
    
	return self;
}

-(void)designView{
    //self.view.backgroundColor=[UIColor colorWithRed:157/255.0 green:153/255.0 blue:190/255.0 alpha:0.7];
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.theExitButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.theExitButton.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    self.theExitButton.titleLabel.textColor=[UIColor whiteColor];
    self.theExitButton.backgroundColor = [UIColor colorWithRed:157/255.0 green:153/255.0 blue:190/255.0 alpha:1];
    [self.theExitButton setBackgroundImage:UIUtil::ImageWithColor(117, 114, 184) forState:UIControlStateHighlighted];
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
    
    midFrame=CGRectMake(10, 60, 520, 350);
    rightFrame=midFrame;
    leftFrame=midFrame;
    rightFrame.origin.x+=midFrame.origin.x+midFrame.size.width+10;
    leftFrame.origin.x-=midFrame.origin.x+midFrame.size.width+10;
    
    NSMutableDictionary * customer_info_dict=[[NSMutableDictionary alloc]initWithDictionary:
                                              @{
                                                @"title":[[NSMutableDictionary alloc] initWithDictionary:@{@"name":NSLocalizedString(@"Title", @"称呼"), @"value":@""}],
                                                @"name":[[NSMutableDictionary alloc] initWithDictionary:@{@"name":NSLocalizedString(@"Name", @"姓名"), @"value":@""}],
                                                @"address":[[NSMutableDictionary alloc] initWithDictionary:@{@"name":NSLocalizedString(@"Address", @"地址"), @"value":@""}],
                                                @"contact":[[NSMutableDictionary alloc] initWithDictionary:@{@"name":NSLocalizedString(@"Contact", @"联系方式"), @"value":@""}]
                                                }];
    
    self.theTableView = [[NCTableView alloc]initWithFrame:midFrame style:(UITableViewStyleGrouped)];
    [self.theTableView setRowHeight:40];
    [self.theTableView setDataSource:self.theTableView];
    [self.theTableView setDelegate:self.theTableView];
    [self.theTableView setNCDelegate:self];
    self.theTableView.sectionArrayOfDict = [[NSMutableArray alloc]initWithArray:@[customer_info_dict]];
    
    [self.view addSubview:self.theTableView];
    
    self.theBabyAddButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.theBabyAddButton.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    self.theBabyAddButton.titleLabel.textColor=[UIColor whiteColor];
    self.theBabyAddButton.backgroundColor = [UIColor colorWithRed:157/255.0 green:153/255.0 blue:190/255.0 alpha:1];
    [self.theBabyAddButton setBackgroundImage:UIUtil::ImageWithColor(117, 114, 184) forState:UIControlStateHighlighted];
    [self.theBabyAddButton setBackgroundImage:UIUtil::ImageWithColor(100,100,100) forState:UIControlStateDisabled];
    self.theBabyAddButton.frame=CGRectMake(130, 450, 100, 30);
    [self.theBabyAddButton setTitle:NSLocalizedString(@"Add Baby", @"添加一个宝宝") forState:UIControlStateNormal];
    [self.theBabyAddButton addTarget:self action:@selector(addBaby:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.theBabyAddButton];
    
    self.theCustomerAddButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.theCustomerAddButton.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    self.theCustomerAddButton.titleLabel.textColor=[UIColor whiteColor];
    self.theCustomerAddButton.backgroundColor = [UIColor colorWithRed:157/255.0 green:153/255.0 blue:190/255.0 alpha:1];
    [self.theCustomerAddButton setBackgroundImage:UIUtil::ImageWithColor(117, 114, 184) forState:UIControlStateHighlighted];
    [self.theCustomerAddButton setBackgroundImage:UIUtil::ImageWithColor(100,100,100) forState:UIControlStateDisabled];
    self.theCustomerAddButton.frame=CGRectMake(380, 450, 100, 30);
    [self.theCustomerAddButton setTitle:NSLocalizedString(@"Create", @"确认创建") forState:UIControlStateNormal];
    [self.theCustomerAddButton addTarget:self action:@selector(addCustomer:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.theCustomerAddButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadContentView:(UIView *)contentView withDict:(NSDictionary *)dict{
    _Log(@"NewCustomerController loadContentView - -");
    
    //_Log(@"get locations [%@]",dict);
    self.provinces_array=[dict objectForKey:@"provinces"];
    self.province_city_dict=[dict objectForKey:@"cities"];
    self.cities_array=@[];//@[NSLocalizedString(@"Province first", @"未选择省份")];
    
    //[self.theProvinceCB reloadDataForSelection:     self.provinces_array     ];
    //[self.theCityCB     reloadDataForSelection:     self.cities_array     ];
    
    [contentView setFrame:CGRectZero];
    //[self designView:contentView];
    
    [self designView];
    [self addBaby:self];
}

- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
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

#pragma mark - NewCustomerX Table Delegate

-(void)tableLoadSubViewFromRight:(UIView*)view{
    _Log(@"NewCustomerXController tableLoadSubViewFromRight");
    view.frame=rightFrame;
    [self.view addSubview:view];
    [UIView animateWithDuration:0.5 animations:^{
        self.theTableView.frame=leftFrame;
        view.frame=midFrame;
        
        //[self.theBabyAddButton setHidden:YES];
        //[self.theCustomerAddButton setHidden:YES];
        [self.theBabyAddButton setEnabled:NO];
        [self.theCustomerAddButton setEnabled:NO];
    } completion:^(BOOL finished) {
        //Nothing
    }];
}

-(void)tableUnloadSubViewToRight:(UIView*)view{
    _Log(@"NewCustomerXController tableUnloadSubViewToRight");
    [UIView animateWithDuration:0.5 animations:^{
        self.theTableView.frame=midFrame;
        view.frame=rightFrame;
        
        //[self.theBabyAddButton setHidden:NO];
        //[self.theCustomerAddButton setHidden:NO];
        [self.theBabyAddButton setEnabled:YES];
        [self.theCustomerAddButton setEnabled:YES];
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
    [self reloadNewCustomerTableView];
}

-(void)processTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _Log(@"NewCustomerXController processTableView didSelectRowAtIndexPath:%@",indexPath);
    _subView=nil;
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0:
                _subView =[[NCCustomerTitleSubView alloc]initWithFrame:rightFrame withDelegate:self];
                break;
            case 1:
                _subView=[[NCCustomerNameSubView alloc]initWithFrame:rightFrame withDelegate:self];
                break;
            case 2:
                _subView=[[NCCustomerAddressSubView alloc]initWithFrame:rightFrame withDelegate:self withProvinces:_provinces_array withCities:_province_city_dict];
                break;
            case 3:
                _subView=[[NCCustomerContactSubView alloc]initWithFrame:rightFrame withDelegate:self];
                break;
            default:
                break;
        }
        if(_subView){
            [_subView setWithCustomer:_NewCustomer];
        }
    }else{
        LSBaby *baby= [[_NewCustomer theBabies] objectAtIndex:indexPath.section-1];
        switch (indexPath.row) {
            case 0:
                _subView=[[NCBabyNickSubView alloc]initWithFrame:rightFrame withDelegate:self withBabyNo:indexPath.section-1];
                break;
            case 1:
                _subView=[[NCBabyBirthdaySubView alloc]initWithFrame:rightFrame withDelegate:self withBabyNo:indexPath.section-1];
                break;
            case 2:
                if([baby the_birth_date]==nil || [[NSDate date] timeIntervalSinceDate:[baby the_birth_date]]>0){
                    _subView =[[NCBabySexSubView alloc]initWithFrame:rightFrame withDelegate:self withBabyNo:indexPath.section-1];
                }else{
                    [self.view toastWithCancel:NSLocalizedString(@"Baby's sex cannot be edited as baby is not born yet", @"胎儿不能修改性别")];
                }
                break;
            default:
                break;
        }
        if (_subView) {
            [_subView setWithBaby:baby];
        }
    }
    
    if(_subView){
        //[_subView setBackgroundColor:[UIColor greenColor]];
        [_subView setBackgroundColor:[UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:0.7]];
        [self tableLoadSubViewFromRight:_subView];
    }
}

-(void)confirmBabyProperty:(NCSubViewPropertyType)propertyType forNo:(int)babyNo withValue:(NSString *)value{
    //TODO
    if([_NewCustomer theBabies]){
        LSBaby * baby=[[_NewCustomer theBabies] objectAtIndex:babyNo];
        switch (propertyType) {
            case NCSubViewPropertyTypeBabySex:
                [baby setThe_sex:value];
                //[[self.theTableView.sectionArrayOfDict objectAtIndex:(babyNo+1)] setObject:[NSString stringWithFormat:@"%@     %@",NSLocalizedString(@"Sex of baby", @"宝宝的性别"),value] forKey:@"sex"];
                [[[self.theTableView.sectionArrayOfDict objectAtIndex:(babyNo+1)] objectForKey:@"sex"]setObject:value forKey:@"value"];
                break;
            case NCSubViewPropertyTypeBabyNick:
                [baby setThe_nick:value];
                //[[self.theTableView.sectionArrayOfDict objectAtIndex:(babyNo+1)] setObject:[NSString stringWithFormat:@"%@     %@",NSLocalizedString(@"Nickname(optional)", @"昵称（可选）"),value] forKey:@"nick"];
                [[[self.theTableView.sectionArrayOfDict objectAtIndex:(babyNo+1)] objectForKey:@"nick"]setObject:value forKey:@"value"];
                [self reloadNewCustomerTableView];
                break;
            default:
                break;
        }
        //[[_newCustomer theBabies] setObject:baby atIndexedSubscript:babyNo];
    }
    
}
-(void)confirmBabyBirthdayForNo:(int)babyNo withDate:(NSDate *)date{
    //TODO
    if([_NewCustomer theBabies]){
        LSBaby * baby=[[_NewCustomer theBabies] objectAtIndex:babyNo];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
        NSInteger day = [components day];
        NSInteger month = [components month];
        NSInteger year = [components year];
        [baby setThe_birth_year:year];
        [baby setThe_birth_month:month];
        [baby setThe_birth_day:day];
        [baby setThe_birth_date:date];
        //[[_newCustomer theBabies] setObject:baby atIndexedSubscript:babyNo];
        //[[self.theTableView.sectionArrayOfDict objectAtIndex:(babyNo+1)] setObject:[NSString stringWithFormat:@"%@     %d/%d/%d",NSLocalizedString(@"(Expected) Birthday", @"生日(预产期)"),year,month,day] forKey:@"birthday"];
        [[[self.theTableView.sectionArrayOfDict objectAtIndex:(babyNo+1)] objectForKey:@"birthday"]setObject:[NSString stringWithFormat:@"%d/%d/%d",year,month,day] forKey:@"value"];
        NSTimeInterval deltaOnTime=[[NSDate date] timeIntervalSinceDate:date];
        //_Log(@"%@ since %@, deltaOnTime=%lf",[NSDate date],date,deltaOnTime);
        if(deltaOnTime<=0){
            if([baby the_sex]==nil || ![[baby the_sex] isEqualToString:NSLocalizedString(@"Pregnant",@"胎儿")]){
                //[baby setThe_sex:NSLocalizedString(@"Pregnant",@"胎儿")];
                [self confirmBabyProperty:(NCSubViewPropertyTypeBabySex) forNo:babyNo withValue:NSLocalizedString(@"Pregnant",@"胎儿")];
            }
        }else{
            if([[baby the_sex] isEqualToString:NSLocalizedString(@"Pregnant",@"胎儿")]){
                //[baby setThe_sex:nil];
                [self confirmBabyProperty:(NCSubViewPropertyTypeBabySex) forNo:babyNo withValue:NSLocalizedString(@"Boy", @"男")];
            }
        }
    }
    //[self reloadNewCustomerTableView];
}

-(void)confirmCustomerProperty:(NCSubViewPropertyType)propertyType withValue:(NSString *)value{
    //TODO
    switch (propertyType) {
        case NCSubViewPropertyTypeCustomerTitle:
            [_NewCustomer setTheTitle:value];
            //[[self.theTableView.sectionArrayOfDict objectAtIndex:0] setObject:[NSString stringWithFormat:@"%@     %@",NSLocalizedString(@"Title", @"称呼"),value] forKey:@"title"];
            [[[self.theTableView.sectionArrayOfDict objectAtIndex:0] objectForKey:@"title"]setObject:value forKey:@"value"];
            break;
        case NCSubViewPropertyTypeCustomerName:
            [_NewCustomer setTheName:value];
            //[[self.theTableView.sectionArrayOfDict objectAtIndex:0] setObject:[NSString stringWithFormat:@"%@     %@",NSLocalizedString(@"Name", @"姓名"),value] forKey:@"name"];
            [[[self.theTableView.sectionArrayOfDict objectAtIndex:0] objectForKey:@"name"]setObject:value forKey:@"value"];
            [self reloadNewCustomerTableView];
            break;
        case NCSubViewPropertyTypeCustomerAreaCode:
            [_NewCustomer setTheAreaCode:value];
        {
            NSString * contact=@"";
            if([[_NewCustomer theAreaCode] isEqualToString:@""] || [[_NewCustomer theMobile] isEqualToString:@""]){
                contact=[NSString stringWithFormat:@"%@%@",[_NewCustomer theAreaCode],[_NewCustomer theMobile]];
            }else{
                contact=[NSString stringWithFormat:@"%@-%@",[_NewCustomer theAreaCode],[_NewCustomer theMobile]];
            }
            
            [[[self.theTableView.sectionArrayOfDict objectAtIndex:0] objectForKey:@"contact"]setObject:contact forKey:@"value"];
            [self reloadNewCustomerTableView];
        }
            break;
        case NCSubViewPropertyTypeCustomerMobile:
            [_NewCustomer setTheMobile:value];
            //[[self.theTableView.sectionArrayOfDict objectAtIndex:0] setObject:[NSString stringWithFormat:@"%@     %@",NSLocalizedString(@"Contact", @"联系方式"),value] forKey:@"contact"];
        {
            NSString * contact=@"";
            if([[_NewCustomer theAreaCode] isEqualToString:@""] || [[_NewCustomer theMobile] isEqualToString:@""]){
                contact=[NSString stringWithFormat:@"%@%@",[_NewCustomer theAreaCode],[_NewCustomer theMobile]];
            }else{
                contact=[NSString stringWithFormat:@"%@-%@",[_NewCustomer theAreaCode],[_NewCustomer theMobile]];
            }
            
            [[[self.theTableView.sectionArrayOfDict objectAtIndex:0] objectForKey:@"contact"]setObject:contact forKey:@"value"];
            [self reloadNewCustomerTableView];
        }
            break;
        case NCSubViewPropertyTypeCustomerEmail:
            [_NewCustomer setTheEmail:value];
            if([_NewCustomer theMobile]==nil || [[_NewCustomer theMobile] isEqualToString:@""]){
                //[[self.theTableView.sectionArrayOfDict objectAtIndex:0] setObject:[NSString stringWithFormat:@"%@     %@",NSLocalizedString(@"Contact", @"联系方式"),value] forKey:@"contact"];
                [[[self.theTableView.sectionArrayOfDict objectAtIndex:0] objectForKey:@"contact"]setObject:value forKey:@"value"];
            }
            [self reloadNewCustomerTableView];
            break;
        case NCSubViewPropertyTypeCustomerProvince:
            [_NewCustomer setTheProvince:value];
            break;
        case NCSubViewPropertyTypeCustomerCity:
            [_NewCustomer setTheCity:value];
            //[[self.theTableView.sectionArrayOfDict objectAtIndex:0] setObject:[NSString stringWithFormat:@"%@     %@ %@",NSLocalizedString(@"Address", @"地址"),[_NewCustomer theProvince],[_NewCustomer theCity]] forKey:@"address"];
            [[[self.theTableView.sectionArrayOfDict objectAtIndex:0] objectForKey:@"address"]setObject:[NSString stringWithFormat:@"%@ %@",[_NewCustomer theProvince],[_NewCustomer theCity]] forKey:@"value"];
            break;
        case NCSubViewPropertyTypeCustomerHome:
            [_NewCustomer setTheAddress:value];
            break;
        default:
            break;
    }
}

#pragma mark ForNewCustomerTest

-(void)reloadNewCustomerTableView{
    _Log(@"testNewCustomer:\nTitle: %@\nName: %@\nProvince: %@\nCity: %@\nAddress: %@\nMobile: %@\nEmail: %@",
         _NewCustomer.theTitle,
         _NewCustomer.theName,
         _NewCustomer.theProvince,
         _NewCustomer.theCity,
         _NewCustomer.theAddress,
         _NewCustomer.theMobile,
         _NewCustomer.theEmail
         );
    for (int i=0;i<[_NewCustomer.theBabies count];i++) {
        LSBaby * baby = [_NewCustomer.theBabies objectAtIndex:i];
        _Log(@"With BABY[%d]:\nNick: %@\nSex: %@\nBirthday: %d-%d-%d",i,
             baby.the_nick,
             baby.the_sex,
             baby.the_birth_year,
             baby.the_birth_month,
             baby.the_birth_day);
    }
    
    [self.theTableView reloadData];
}

#pragma mark -

/*
 -(void)provinceChanged:(id)sender{
 NSString * v=self.theProvinceCB.value_string;
 //_Log(@"provinceChanged -> %@ !",v);
 self.cities_array=[self.province_city_dict objectForKey:v];
 [self.theCityCB reloadDataForSelection:
 self.cities_array
 ];
 }
 */

-(void)addBaby:(id)sender{
    _Log(@"addBaby called");
    /*
     LSNewCustomer_BabyCell * first=[[LSNewCustomer_BabyCell alloc]initWithFrame:CGRectMake(0, 0, 500, self.baby_cell_height) withinController:self];
     //[first initDate];
     [self.baby_cells addObject:first];
     [self refreshBabiesViews];
     [self.InfoScrollView scrollRectToVisible:CGRectMake(0,self.baby_cells_top-self.baby_cell_height+self.baby_cell_height*[self.baby_cells count], 500, self.baby_cell_height) animated:YES];
     */
    [_NewCustomer addOneBaby:[[LSBaby alloc]init]];
    NSMutableDictionary * baby_info_dict=[[NSMutableDictionary alloc]initWithDictionary:
                                          @{
                                            @"nick":[[NSMutableDictionary alloc] initWithDictionary:@{@"name":NSLocalizedString(@"Nickname(optional)", @"昵称（可选）"), @"value":@""}],
                                            @"birthday":[[NSMutableDictionary alloc] initWithDictionary:@{@"name":NSLocalizedString(@"(Expected) Birthday", @"生日(预产期)"), @"value":@""}],
                                            @"sex":[[NSMutableDictionary alloc] initWithDictionary:@{@"name":NSLocalizedString(@"Sex of baby", @"宝宝的性别"), @"value":@""}]
                                            }];
    [self.theTableView.sectionArrayOfDict addObject:baby_info_dict];
    [self.theTableView reloadData];
}

-(void)addCustomer:(id)sender{
    _Log(@"addCustomer called");
    
    //LSCustomer * cc=[LSCustomer newCustomer];
    /*
     [cc setTheTitle:self.theTitleCB.value_string];
     [cc setTheName:self.theUserNameTextfield.text];
     [cc setTheProvince:self.theProvinceCB.value_string];
     [cc setTheCity:self.theCityCB.value_string];
     [cc setTheAddress:self.theAddressTextfield.text];
     [cc setTheMobile:self.theMobileTextfield.text];
     [cc setTheEmail:self.theEmailTextfield.text];
     
     for (LSNewCustomer_BabyCell* cell in self.baby_cells) {
     LSBaby * baby=[[LSBaby alloc]init];
     _Log(@"FOR BABY:%@-%@-%@ / %d-%d-%d nick[%@] sex[%@]",cell.theBabyBirthday_Year.value_string,cell.theBabyBirthday_Month.value_string,cell.theBabyBirthday_Day.value_string,[cell.theBabyBirthday_Year.value_string intValue],[cell.theBabyBirthday_Month.value_string intValue],[cell.theBabyBirthday_Day.value_string intValue],cell.theBaby_Nick.text,cell.theBaby_Sex.value_string);
     [baby setThe_birth_day:[cell.theBabyBirthday_Day.value_string intValue]];
     [baby setThe_birth_month:[cell.theBabyBirthday_Month.value_string intValue]];
     [baby setThe_birth_year:[cell.theBabyBirthday_Year.value_string intValue]];
     [baby setThe_nick:cell.theBaby_Nick.text];
     [baby setThe_sex:cell.theBaby_Sex.value_string];
     
     _Log(@"baby before add  %d-%d-%d %@/%@",baby.the_birth_year,baby.the_birth_month,baby.the_birth_day,baby.the_sex,baby.the_nick);
     
     [cc addOneBaby:baby];
     }
     */
    
    /*
     DialogUIAlertView * dav=[[DialogUIAlertView alloc]initWithTitle:NSLocalizedString(@"Reminder", @"") message:NSLocalizedString(@"Please check if the mobile of the customer is correct, it would affect your points.", @"") cancelButtonTitle:NSLocalizedString(@"The mobile needs changing.", @"") otherButtonTitles:NSLocalizedString(@"I have confirmed it is correct.", @"")];
     int r=[dav showDialog];
     */
    
    NSString* result=[_NewCustomer createCustomer];
    //    [cc reset];
    if(result!=nil){
        UIUtil::ShowAlert([NSString stringWithFormat: NSLocalizedString(@"Registered as [%@]", @"成功注册为[%@]"),result]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserRegistered" object:result];
        [self closeView:sender];
    }
}

-(void)closeView:(id)sender{
    _Log(@"closeView called");
    //[self sendAction:@selector(customer_create_hide:) to:self.superview forEvent:UIControlEventTouchUpInside];
    //[self.theController receive_event:sender forEventDescription:@"close_new_customer_apply_view" withNSString:@""];
    //[self.theController popoverModeViewOff];
    [self dismissViewControllerAnimated:YES completion:^{
        _Log(@"New Customer X VC dismissed");
    }];
}

@end
