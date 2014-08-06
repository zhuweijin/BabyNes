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

-(id)initWithCart:(CartEntity*)cart forCustomer:(LSCustomer*)customer;

-(NSString*)create;

-(NSString*)toJson;

+(LSOrder*)fromJson:(NSString*)json;

@end
