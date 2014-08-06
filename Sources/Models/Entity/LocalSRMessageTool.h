//
//  LocalSRMessageTool.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-17.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRMessage.h"

@interface LocalSRMessageTool : NSObject
+(void)cleanMyLocalSR;
//+(NSMutableDictionary*) getLocalSRDict_all;
+(NSMutableDictionary*) getLocalSRDict_mine;
+(NSDictionary*)LocalSRMessageDictionaryMergedWithArray:(NSArray*)array;
+(void)setSRtoHaveRead:(int)srid;

+(NSArray*)getSRArrayIfForce:(BOOL)force;

+(int)getSRAPIAfterParamValue;
+(int)getSRAPIBeforeParamValue;
+(void)saveLocalSRAll;
+(void)setSRArraytoHaveRead:(NSArray*)srids;

+(void)killTails;
@end
