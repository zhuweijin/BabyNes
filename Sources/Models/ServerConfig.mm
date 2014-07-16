//
//  ServerConfig.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-5.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "ServerConfig.h"

ServerConfig * defaultServerConfig=nil;//[[ServerConfig alloc]init];

@implementation ServerConfig

-(id)init{
    self=[super init];
    dict=@{@"kServerUrl":
               //@"http://uniquebaby.duapp.com/babynesios/admin/api",
                @"https://testbaby.i9i8.com/admin/api",
           @"login": @"login.php",
           @"device_register":@"device_details.php",
           @"device_report":@"device_status.php",
           @"idle_video":@"PR/babynes.mp4"//@"video/video-4.mp4"
           };
    return self;
}

-(NSString*)findURL:(NSString*)api_name{
    return [NSString stringWithFormat:@"%@/%@", [dict objectForKey:@"kServerUrl"], [dict objectForKey:api_name]];
}

+(ServerConfig*)getServerConfig{
    if(defaultServerConfig==nil){
        defaultServerConfig=[[ServerConfig alloc]init];
    }
    return defaultServerConfig;
}

-(NSString*)getURL_root{
    return [dict objectForKey:@"kServerUrl"];
}

-(NSString*)getURL_login{
    return [self findURL:@"login"];
}

-(NSString*)getURL_device_register{
    return [self findURL:@"device_register"];
}

-(NSString*)getURL_device_report{
    return [self findURL:@"device_report"];
}

-(NSString*)getURL_idle_video{
    return [self findURL:@"idle_video"];
}


@end
