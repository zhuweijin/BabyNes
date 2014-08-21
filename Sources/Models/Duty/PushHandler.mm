//
//  PushHandler.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-8-4.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "PushHandler.h"

#import "LSRegularReporter.h"
#import "LSVersionManager.h"
#import "LocalSRMessageTool.h"
#import "CartEntity.h"

static NSString * pushToken=nil;
static BOOL outSingleModePermitted=NO;

@implementation PushHandler
+(NSString*)getPushToken{
    return pushToken;
}
+(void)setPushToken:(NSString*)token{
    pushToken=token;
}

+(BOOL)hasOutSingleModePermitted{
    return outSingleModePermitted;
}

+(void)showStatusBarNews:(NSString*)news{
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 1024, 20)];
    [label setText:news];
    [label setBackgroundColor:[UIColor blackColor]];
    [label setTextColor:[UIColor whiteColor]];
    [UIView animateWithDuration:3 animations:^{
        [[[[UIApplication sharedApplication] delegate]window] addSubview:label];
    } completion:^(BOOL finished) {
        if(label){
            [label removeFromSuperview];
        }
    }];
}

+(void)handlePush:(NSDictionary*)userInfo{
    NSString * act=userInfo[@"act"];
    if([act isEqualToString:@"-1"]){
        //TEST
        [[[UIAlertView alloc]initWithTitle:userInfo[@"alert"] message:@"The push notification has been shown successfully when you see this alert." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
    else
        if([act isEqualToString:@"0"]){
            //Out Single Mode
            outSingleModePermitted=YES;
            [PushHandler actOutSingleMode];
        }else if([act isEqualToString:@"1"]){
            //Into Single Mode
            outSingleModePermitted=NO;
            [PushHandler actIntoSingleMode];
        }else if([act isEqualToString:@"2"]){
            //Force Version Update
            [PushHandler actCleanCache];
            [PushHandler actVersionUpdate];
        }else if([act isEqualToString:@"3"]){
            //Force Clean Cache
            [PushHandler actCleanCache];
        }else if([act isEqualToString:@"4"]){
            //PING
            [PushHandler actSendStatus];
        }else if([act isEqualToString:@"5"]){
            //MSG PUSH
            [PushHandler actAlertNewMessage:@{
                                              @"title":userInfo[@"addition"],
                                              //@"url":userInfo[@"url"],
                                              }];
        }
    NSLog(@"Push act[%@] handled.",act);
}
+(void)actIntoSingleMode{
    if (!UIAccessibilityIsGuidedAccessEnabled()) {
        UIAccessibilityRequestGuidedAccessSession(YES, ^(BOOL didSucceed) {
            if(didSucceed){
                NSString*news=@"Have been into Single Mode!";
                NSLog(@"%@",news);
                //[PushHandler showStatusBarNews:news];
            }else{
                NSString*news=@"Have failed to be into Single Mode!";
                NSLog(@"%@",news);
                //[PushHandler showStatusBarNews:news];
            }
        });
    }
}
+(void)actOutSingleMode{
    if(UIAccessibilityIsGuidedAccessEnabled()) {
        UIAccessibilityRequestGuidedAccessSession(NO, ^(BOOL didSucceed) {
            if(didSucceed){
                NSString*news=@"Have been out of Single Mode!";
                NSLog(@"%@",news);
                //[PushHandler showStatusBarNews:news];
            }else{
                NSString*news=@"Have failed to be out of Single Mode!";
                NSLog(@"%@",news);
                //[PushHandler showStatusBarNews:news];
            }
        });
    }
}
+(void)actVersionUpdate{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ReceiveForceUpdateVersionPush" object:nil];
}
+(void)actCleanCache{
    //无差别消灭缓存
    NSUtil::CleanCache();
    //检查并缩减SR
    [LocalSRMessageTool killTails];
    //消灭版本
    [LSVersionManager setCurrentVersion:0];
    NSUtil::RemovePath(NSUtil::DocumentPath([LSVersionManager allZipFilePath]));
    NSUtil::RemovePath(NSUtil::DocumentPath([LSVersionManager allZipToJsonPath]));
    //消灭购物车
    //[ProductEntity resetProductsAsEmpty];
    [[CartEntity getDefaultCartEntity]resetCart];
    //顺便昭告天下
    [[NSNotificationCenter defaultCenter]postNotificationName:@"CacheKilled" object:nil];
    
    //Log time for cleaning cache
    long time;
    NSDate *fromdate=[NSDate date];
    time=(long)[fromdate timeIntervalSince1970];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithLong:time] forKey:@"BabyNesPOS_LastCleanCache_UnixTime"];
}
+(void)actCleanResponseCache{
    //无差别消灭缓存
    //NSUtil::CleanCache();
    NSFileManager * fm=NSUtil::FileManager();
    NSString* cachePath= NSUtil::CachePath();
    NSArray* files=[fm subpathsAtPath:cachePath];
    for (NSString* file in files) {
        if(![file hasPrefix:@"http"]){
            [fm removeItemAtPath:[cachePath stringByAppendingPathComponent:file] error:nil];
        }
    }
    //检查并缩减SR
    [LocalSRMessageTool killTails];
    //消灭版本
    [LSVersionManager setCurrentVersion:0];
    NSUtil::RemovePath(NSUtil::DocumentPath([LSVersionManager allZipFilePath]));
    NSUtil::RemovePath(NSUtil::DocumentPath([LSVersionManager allZipToJsonPath]));
    //消灭购物车
    //[ProductEntity resetProductsAsEmpty];
    [[CartEntity getDefaultCartEntity]resetCart];
    //顺便昭告天下
    [[NSNotificationCenter defaultCenter]postNotificationName:@"CacheKilled" object:nil];
    
    //Log time for cleaning cache
    long time;
    NSDate *fromdate=[NSDate date];
    time=(long)[fromdate timeIntervalSince1970];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithLong:time] forKey:@"BabyNesPOS_LastCleanCache_UnixTime"];
}
+(void)actCleanSR{
    //只消灭自己的Token对应的本地消息记录
    [LocalSRMessageTool cleanMyLocalSR];
}
+(void)actSendStatus{
    [LSRegularReporter report];
}

+(void)actAlertNewMessage:(NSDictionary*)msgUnit{
    if(msgUnit){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"NewSRMessage" object:msgUnit];
    }
}

@end
