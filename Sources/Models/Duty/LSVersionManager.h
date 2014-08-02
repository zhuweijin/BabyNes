//
//  LSVersionManager.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-8-2.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerConfig.h"

@interface LSVersionManager : NSObject

+(NSInteger)currentVerion;
+(void)setCurrentVersion:(NSInteger)currentVersion;

+(BOOL)isNeedUpdateVersion:(NSString**)url;

+(BOOL)updateWithDownloadedZip;

+(NSString*)allZipFilePath;
+(NSString*)allZipToJsonPath;
+(NSString*)allJsonFilePath;

@end
