//
//  LSNewCustomer_BabyCell.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-6-27.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSComboBox.h"

@interface LSNewCustomer_BabyCell : UIView
- (void)designView;
- (id)initWithFrame:(CGRect)frame withinController:(UIViewController*)controller;
@property UIViewController * theController;

@property UILabel * theBabyLabel;

@property UILabel * theBabyBirthdayLabel;
@property UILabel * theBabySex;
@property UILabel * theBabyNick;

@property LSComboBox * theBabyBirthday_Year;
@property LSComboBox * theBabyBirthday_Month;
@property LSComboBox * theBabyBirthday_Day;

@property LSComboBox * theBaby_Sex;

@property UITextField * theBaby_Nick;

@property NSArray * theYearArray;
@property NSArray * theMonthArray;
@property NSArray * theDayArray_28;
@property NSArray * theDayArray_29;
@property NSArray * theDayArray_30;
@property NSArray * theDayArray_31;

-(void) initDate;
@end
