//
//  PushHandler.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-8-4.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushHandler : NSObject
+(NSString*)getPushToken;
+(void)setPushToken:(NSString*)token;

+(BOOL)hasOutSingleModePermitted;

+(void)handlePush:(NSDictionary*)userInfo;

+(void)actIntoSingleMode;
+(void)actOutSingleMode;
+(void)actVersionUpdate;
+(void)actCleanCache;
+(void)actCleanSR;
+(void)actSendStatus;

+(void)actAlertNewMessage:(NSDictionary*)msgUnit;
@end
