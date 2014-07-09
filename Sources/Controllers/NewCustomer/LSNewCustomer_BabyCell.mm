//
//  LSNewCustomer_BabyCell.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-6-27.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "LSNewCustomer_BabyCell.h"

@implementation LSNewCustomer_BabyCell

-(void) initDate{
    _Log(@"LSNewCustomer_BabyCell initDate");
    NSDate *now = [NSDate date];
    NSCalendar *myCal = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned units  = NSMonthCalendarUnit|NSDayCalendarUnit|NSYearCalendarUnit;
    NSDateComponents *comp1 = [myCal components:units fromDate:now];
    NSInteger month = [comp1 month];
    NSInteger year = [comp1 year];
    NSInteger day = [comp1 day];
    
    self.theYearArray=@[[NSString stringWithFormat:@"%d",year],[NSString stringWithFormat:@"%d",year-1],[NSString stringWithFormat:@"%d",year-2],[NSString stringWithFormat:@"%d",year-3]];
    
    NSMutableArray * array=[[NSMutableArray alloc]init];
    for (int i=1; i<=12; i++) {
        [array addObject:[NSString stringWithFormat:@"%d",i]];
    }
    self.theMonthArray=[[NSArray alloc]initWithArray:array];
    for (int i=13;i<29;i++){
        [array addObject:[NSString stringWithFormat:@"%d",i]];
    }
    self.theDayArray_28=[[NSArray alloc]initWithArray:array];
    [array addObject:[NSString stringWithFormat:@"%d",29]];
    self.theDayArray_29=[[NSArray alloc]initWithArray:array];
    [array addObject:[NSString stringWithFormat:@"%d",30]];
    self.theDayArray_30=[[NSArray alloc]initWithArray:array];
    [array addObject:[NSString stringWithFormat:@"%d",31]];
    self.theDayArray_31=[[NSArray alloc]initWithArray:array];
}

- (void) designView{
    [self initDate];
    
    self.theBabyLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, 10, 400, 30)];
    [self.theBabyLabel setText:NSLocalizedString(@"About Baby:", @"宝宝信息：")];
    [self.theBabyLabel setFont:[UIFont systemFontOfSize:19]];
    [self addSubview:self.theBabyLabel];
    
    self.theBabyBirthdayLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 40, 180, 30)];
    [self.theBabyBirthdayLabel setText:NSLocalizedString(@"*(Expected) Birthday:", @"*宝宝的生日/预产期：")];
    [self addSubview:self.theBabyBirthdayLabel];
    
    self.theBabyBirthday_Year = [[LSComboBox alloc] initWithFrame:CGRectMake(220, 40, 100, 30) withinController:self.theController withData:self.theYearArray withSetsumei:NSLocalizedString(@"Year",@"年份")];
    [self addSubview:self.theBabyBirthday_Year];
    
    self.theBabyBirthday_Month = [[LSComboBox alloc] initWithFrame:CGRectMake(330, 40, 80, 30) withinController:self.theController withData:self.theMonthArray withSetsumei:NSLocalizedString(@"Month",@"月")];
    [self addSubview:self.theBabyBirthday_Month];
    
    self.theBabyBirthday_Day = [[LSComboBox alloc] initWithFrame:CGRectMake(420, 40, 90, 30) withinController:self.theController withData:self.theDayArray_31 withSetsumei:NSLocalizedString(@"Day",@"日")];
    [self addSubview:self.theBabyBirthday_Day];
    
    
    self.theBabySex = [[UILabel alloc]initWithFrame:CGRectMake(30, 80, 120, 30)];
    [self.theBabySex setText:NSLocalizedString(@"*Sex of baby:", @"*宝宝的性别：")];
    [self addSubview:self.theBabySex];
    
    self.theBaby_Sex = [[LSComboBox alloc] initWithFrame:CGRectMake(150, 80, 100, 30) withinController:self.theController withData:@[NSLocalizedString(@"Boy", @"男"),NSLocalizedString(@"Girl", @"女")] withSetsumei:NSLocalizedString(@"Sex",@"性别")];
    [self addSubview:self.theBaby_Sex];
    
    self.theBabyNick = [[UILabel alloc]initWithFrame:CGRectMake(280, 80, 120, 30)];
    [self.theBabyNick setText:NSLocalizedString(@"*Nickname:", @"*宝宝的昵称：")];
    [self addSubview:self.theBabyNick];
    
    self.theBaby_Nick = [[UITextField alloc] initWithFrame:CGRectMake(400, 80, 110, 30)];
    [self.theBaby_Nick setBackgroundColor:[UIColor colorWithRed:242/255.0 green:242/255.0 blue:244/255.0 alpha:0.9]];
    [self.theBaby_Nick setTextAlignment:(NSTextAlignmentCenter)];
    [self.theBaby_Nick setPlaceholder:NSLocalizedString(@"Nickname", @"昵称")];
    [self.theBaby_Nick setReturnKeyType:(UIReturnKeyDone)];
    //[self.theBaby_Nick setDelegate:self];
    [self addSubview: self.theBaby_Nick];
    
}

- (id)initWithFrame:(CGRect)frame withinController:(UIViewController*)controller{
    self = [super initWithFrame:frame];
    if (self) {
        self.theController=controller;
        // Initialization code
        [self designView];
    }
    return self;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self designView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
