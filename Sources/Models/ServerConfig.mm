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
    dict=@{@"SoapLogin":@"http://www.babynesshop.com.cn/e-cn-zh/api/v2_soap",
           //@"https://babynes-asia.ocentric.com/api/v2_soap/index",
           @"kServerUrl":
                //@"http://uniquebaby.duapp.com/babynesios/admin/api",//BAIDU MOCK
                @"https://172.16.0.186:233/babynes/admin/api",//ERP LOCAL
                //@"https://testbaby.i9i8.com/admin/api",//TESTBABY
           @"login": @"login.php",
           @"device_register":@"device_details.php",
           @"device_report":@"device_status.php",
           @"sr_receipt":@"SRReceipt.php",
           @"idle_video":@"PR/babynes.mp4",//@"video/video-4.mp4"
           @"version_check":@"check_version.php",
           @"create_order":@"create_order.php",
           @"customer_signature":@"customer_signature.php",
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

-(NSString*)getSoapLoginURL{
    return dict[@"SoapLogin"];
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

-(NSString*)getURL_sr_receipt{
    return [self findURL:@"sr_receipt"];
}

-(NSString*)getURL_version_check{
    return [self findURL:@"version_check"];
}
-(NSString*)getURL_create_order{
    return [self findURL:@"create_order"];
}
-(NSString*)getURL_customer_signature{
    return [self findURL:@"customer_signature"];
}
@end
