//
//  LSDeviceRegister.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-3.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "LSDeviceRegister.h"
#import "ServerConfig.h"

@implementation LSDeviceRegister

//static NSString * DeviceRegisterURL=@"https://172.16.0.186:233/babynesios/admin/api/device_details.php";

+(BOOL)doDeviceRegister{
    LSDeviceRegister * dr=[[LSDeviceRegister alloc]init];
    return [dr postDeviceDetails];
}

-(id)init{
    self=[super init];
    
    self.sec_uuid=[LSDeviceInfo device_sn];//From SecureUUID
    //self.store_id=@"Unknown";//UNKNOWN
    //self.ipad_number=@"Unknown";//UNKNOWN
    self.manufacturer_id=[LSDeviceInfo identifierForVendor];
    self.os_version=[NSString stringWithFormat:@"%@ %@",[LSDeviceInfo systemName],[LSDeviceInfo systemVersion]];//systemVersion
    self.model=[LSDeviceInfo deviceModelOriginal];//deviceModel
    self.app_version=[[iVersion sharedInstance] applicationVersion];//iVerion
    self.app_name=@"BabyNes POS";//iVersion
    self.language=NSLocalizedString(@"EN", @"CN");//CN/EN
    self.country=[LSDeviceInfo myLocation];//UNKNOWN
    
    return self;
}

-(BOOL)postDeviceDetails{
    NSString * AT=[DataLoader accessToken];
    NSDictionary* dict=[[NSDictionary alloc]initWithObjectsAndKeys:
                        @"register_device",@"act",
                        AT,@"token",
                        self.sec_uuid,@"sec_uuid",
                        //self.store_id,@"store_id",
                        //self.ipad_number,@"ipad_number",
                        self.manufacturer_id,@"manufacturer_id",
                        self.os_version,@"os_version",
                        self.model,@"model",
                        self.app_version,@"app_version",
                        self.app_name,@"app_name",
                        self.language,@"language",
                        self.country,@"country",
                        nil
                        ];
    
    NSString* param=NSUtil::URLQuery(dict);
    
    _Log(@"LSDeviceRegister postDeviceDetails:URL=%@ param=%@",[[ServerConfig getServerConfig]getURL_device_register],param);
    NSError *error = nil;
    NSURLResponse *response = nil;
    NSData *post = [param dataUsingEncoding:NSUTF8StringEncoding];
    NSData* return_data = HttpUtil::HttpData([[ServerConfig getServerConfig]getURL_device_register], post, NSURLRequestReloadIgnoringCacheData, &response, &error);
    //NSString * return_data_string= [[NSString alloc] initWithData:return_data  encoding:NSUTF8StringEncoding];
    _Log(@"LSDeviceRegister postDeviceDetails get return:%@",[[NSString alloc] initWithData:return_data  encoding:NSUTF8StringEncoding]);
    //TODO MAKE IT REAL
    NSDictionary* return_dict=[NSJSONSerialization JSONObjectWithData:return_data options:(NSJSONReadingMutableLeaves) error:nil];
    if(return_dict){
        if([[return_dict objectForKey:@"CODE"] integerValue]==200){
            return YES;
        }
    }
    return NO;    
}

@end
