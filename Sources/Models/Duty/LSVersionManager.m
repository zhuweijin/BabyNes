//
//  LSVersionManager.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-8-2.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "LSVersionManager.h"

//static NSInteger theCurrentVersion=0;

@implementation LSVersionManager

#pragma mark the current version

+(NSInteger)currentVerion{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSInteger cv=[def integerForKey:@"DataCacheVersion"];
    _Log(@"read DataCacheVersion as [%ld]",(long)cv);
    return cv;
}
+(void)setCurrentVersion:(NSInteger)currentVersion{
    //theCurrentVersion=currentVersion;
    [[NSUserDefaults standardUserDefaults] setInteger:currentVersion forKey:@"DataCacheVersion"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
