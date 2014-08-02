//
//  ServerConfig.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-5.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerConfig : NSObject{
    NSDictionary * dict;
}

-(NSString*)findURL:(NSString*)api_name;

+(ServerConfig*)getServerConfig;

-(NSString*)getURL_root;

-(NSString*)getURL_login;
-(NSString*)getURL_device_register;
-(NSString*)getURL_device_report;
-(NSString*)getURL_idle_video;
-(NSString*)getURL_sr_receipt;
-(NSString*)getURL_version_check;

-(NSString*)getSoapLoginURL;

@end
