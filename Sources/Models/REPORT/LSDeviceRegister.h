//
//  LSDeviceRegister.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-3.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSDeviceInfo.h"
#import "DataLoader.h"

@interface LSDeviceRegister : NSObject

@property NSString * sec_uuid;//From SecureUUID
@property NSString * store_id;//UNKNOWN
@property NSString * ipad_number;//UNKNOWN
@property NSString * manufacturer_id;//UNKNOWN
@property NSString * os_version;//systemVersion
@property NSString * model;//deviceModel
@property NSString * app_version;//iVerion
@property NSString * app_name;//iVersion
@property NSString * language;//CN/EN
@property NSString * country;//UNKNOWN

+(BOOL)doDeviceRegister;

@end
