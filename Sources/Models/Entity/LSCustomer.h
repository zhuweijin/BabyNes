//
//  LSCustomer.h
//  BabyNesPOS_Akatsuki
//
//  Created by 倪 李俊 on 14-6-24.
//  Copyright (c) 2014年 Leqee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSBaby.h"
#import "APIWorker.h"

@interface LSCustomer : NSObject

@property NSString * theID;

@property NSString * theTitle;
@property NSString * theName;
@property NSString * theProvince;
@property NSString * theCity;
@property NSString * theAddress;
@property NSString * theRegionCode;
@property NSString * theAreaCode;
@property NSString * thePhone;
@property NSString * theMobile;
@property NSString * theEmail;
@property NSMutableArray * theBabies;

@property NSString * theSign;

-(void)addOneBaby:(LSBaby *)baby;
+(LSCustomer*) getCurrentCustomer;
+(void)setCurrentCustomer:(LSCustomer*)cutomer;
+(LSCustomer*) newCustomer;
+(void)reset;
-(void)reset;
-(BOOL)validateCustomerInformation;
-(NSString*)createCustomer;
-(NSString*)createCustomer:(BOOL)isSlient;
+(LSCustomer*)searchCustomer:(NSString*)number;

-(NSString*)getOneBabyBirthday;

-(NSString*)toJson;
+(LSCustomer*)fromJson:(NSString*)json;
@end
