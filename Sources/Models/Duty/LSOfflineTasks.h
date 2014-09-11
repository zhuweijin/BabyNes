//
//  LSOfflineTasks.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-8-4.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "LSCustomer.h"
#import "LSOrder.h"

@interface LSOfflineTasks : NSObject
+(NSMutableDictionary*)getCustomerTaskArray;
+(NSMutableDictionary*)getOrderTaskArray;
+(BOOL)saveCustomer:(LSCustomer*) customer;
+(BOOL)saveOrder:(LSOrder*)order;
+(BOOL)doneCustomer:(NSString*)target;
+(BOOL)doneOrder:(NSString*)target;
+(void)attemptProcess;
@end
