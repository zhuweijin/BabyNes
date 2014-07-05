//
//  LSCustomer.h
//  BabyNesPOS_Akatsuki
//
//  Created by 倪 李俊 on 14-6-24.
//  Copyright (c) 2014年 Leqee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSBaby.h"

@interface LSCustomer : NSObject

@property NSString * theID;

@property NSString * theTitle;
@property NSString * theName;
@property NSString * theProvince;
@property NSString * theCity;
@property NSString * theAddress;
@property NSString * theMobile;
@property NSString * theEmail;
@property NSMutableArray * theBabies;

-(void)addOneBaby:(LSBaby *)baby;
+(LSCustomer*) getCurrentCustomer;
+(LSCustomer*) newCustomer;
+(void)reset;
-(void)reset;
-(BOOL)validateCustomerInformation;
-(NSString*)createCustomer;

@end
