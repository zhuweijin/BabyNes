//
//  APIWorker.h
//  BabyNesPosApiTester
//
//  Created by 倪 李俊 on 14-8-6.
//  Copyright (c) 2014年 com.sinri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSSoapLoginWorker.h"
#import "DataLoader.h"

//cn-zh
//hk-en
/*
//OLD
#define BABYNES_REST_SEARCH_CUSTOMER @"http://babynes-asia.ocentric.com/hk-en/babynes_rest/pos_user/search"
#define BABYNES_REST_REGISTER_CUSTOMER @"http://babynes-asia.ocentric.com/cn-zh/babynes_rest/pos_user/register"
#define BABYNES_REST_REGISTER_BABY @"http://babynes-asia.ocentric.com/hk-en/babynes_rest/pos_baby/create"
#define BABYNES_REST_CREATE_ORDER @"http://babynes-asia.ocentric.com/hk-en/babynes_rest/pos_orders/create/"
*/
#define BABYNES_REST_SEARCH_CUSTOMER @"http://www.babynesshop.com.cn/e-cn-zh/babynes_rest/pos_user/search"
#define BABYNES_REST_REGISTER_CUSTOMER @"http://www.babynesshop.com.cn/e-cn-zh/babynes_rest/pos_user/register"
#define BABYNES_REST_REGISTER_BABY @"http://www.babynesshop.com.cn/e-cn-zh/babynes_rest/pos_baby/create"
#define BABYNES_REST_CREATE_ORDER @"http://www.babynesshop.com.cn/e-cn-zh/babynes_rest/pos_orders/create/"

@interface APIWorker : NSObject
{
    BOOL isRefreshing;
}
@property NSString * country_id;
@property NSString * language_id;
@property NSString * unique_device_id;
@property (readonly) NSString * token;
@property NSString * device_id;
@property NSString * promoter_id;

-(NSString*)loginWithUser:(NSString*)username password:(NSString*)pw;

-(NSDictionary*)searchCustomerWithRegionCode:(NSString*)regionCode withNumber:(NSString*)number;

-(NSDictionary*)createUserWithDictionary:(NSDictionary*)dict;

-(NSDictionary*)createBabyWithDictionary:(NSDictionary*)dict;

-(NSDictionary*)createOrderWithDictionary:(NSDictionary*)dict;

+(NSString*)lineJsonFromObj:(id)obj;

//-(NSString*)refreshMCToken;

@end
