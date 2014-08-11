//
//  LSOrder.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-8-4.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSCustomer.h"
#import "CartEntity.h"
#import "ServerConfig.h"
#import "DataLoader.h"

@interface LSOrder : NSObject

@property NSTimeInterval theCreateTime;
@property LSCustomer * theCustomer;
@property CartEntity * theCart;
@property NSString * theOrderType;

@property NSString * store_province;
@property NSString * store_city;
@property NSString * store_address;

+(LSOrder*)getCurrentOrder;
+(void)setCurrentOrder:(LSOrder*)order;
+(void)resetCurrentOrder;
+(void)emptyCurrentOrder;

-(id)initWithCart:(CartEntity*)cart forCustomer:(LSCustomer*)customer;
+(void)updateCurrentOrderWithCart:(CartEntity*)cart forCustomer:(LSCustomer*)customer;

-(NSString*)create;
-(NSString*)createIsAtBack:(BOOL)isBack;

-(NSString*)toJson;

+(LSOrder*)fromJson:(NSString*)json;

@end
