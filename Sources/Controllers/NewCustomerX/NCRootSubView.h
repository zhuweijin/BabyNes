//
//  NCRootSubView.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-21.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSCustomer.h"

typedef enum : NSInteger {
	NCSubViewPropertyTypeCustomerTitle=10,
    NCSubViewPropertyTypeCustomerName=11,
    NCSubViewPropertyTypeCustomerAddress=12,
    NCSubViewPropertyTypeCustomerContact=13,
    
    NCSubViewPropertyTypeCustomerProvince=14,
    NCSubViewPropertyTypeCustomerCity=15,
    NCSubViewPropertyTypeCustomerHome=16,
    NCSubViewPropertyTypeCustomerAreaCode=17,
    NCSubViewPropertyTypeCustomerMobile=18,
    NCSubViewPropertyTypeCustomerEmail=19,

    NCSubViewPropertyTypeBabyNick=20,
    NCSubViewPropertyTypeBabyBirthday=21,
    NCSubViewPropertyTypeBabySex=22,
    
	NCSubViewPropertyTypeBabyYear=23,
    NCSubViewPropertyTypeBabyMonth=24,
    NCSubViewPropertyTypeBabyDay=25
    
} NCSubViewPropertyType;

@protocol NCSubViewDelegate <NSObject>

-(void)confirmCustomerProperty:(NCSubViewPropertyType)propertyType withValue:(NSString*)value;
-(void)confirmBabyProperty:(NCSubViewPropertyType)propertyType forNo:(int)babyNo withValue:(NSString *)value;
-(void)confirmBabyBirthdayForNo:(int)babyNo withDate:(NSDate *)date;
-(void)tableUnloadSubViewToRight:(UIView*)view;

@end

@interface NCRootSubView : UIView

@property id<NCSubViewDelegate> delegate;

@property UIView * topBarView;
@property UIButton * backButton;
@property UILabel * barTitleLabel;
//@property UIButton * cancelButton;

@property UIView *contentView;

-(id)initWithFrame:(CGRect)frame withDelegate:(id<NCSubViewDelegate>) delegate;
-(void)setBarTitle:(NSString*)title;

-(void)setWithCustomer:(LSCustomer*)customer;
-(void)setWithBaby:(LSBaby *)baby;
@end
