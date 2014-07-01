//
//  LSRegularReporter.m
//  BabyNesPOS_Akatsuki
//
//  Created by 倪 李俊 on 14-6-25.
//  Copyright (c) 2014年 Leqee. All rights reserved.
//

#import "LSRegularReporter.h"

static NSString * ReportURL=@"https://172.16.0.143:233/babynesios/admin/api/device_info.php";

@implementation LSRegularReporter

+(void)report{
    int bs=[LSDeviceInfo batteryState];
    int bs_p=[LSDeviceInfo batteryState_isPlugIn];
    NSInteger level=[LSDeviceInfo batteryLevel];
    NSString* SUUID=[LSDeviceInfo device_sn];//SystemUtil::SN();//[LSUserModel device_sn];
    _Log(@"REPORT-SUUID=%@",SUUID);
    Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NSInteger net_state=-1;
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            // 没有网络连接
            //stateInfo=[stateInfo stringByAppendingString:@"No web connection"];
            net_state=0;
            break;
        case ReachableViaWWAN:
            // 使用3G网络
            //stateInfo=[stateInfo stringByAppendingString:@"using 3G"];
            net_state=1;
            break;
        case ReachableViaWiFi:
            // 使用WiFi网络
            //stateInfo=[stateInfo stringByAppendingString:@"using WiFi"];
            net_state=2;
            break;
    }
    long boot_time_second=[LSDeviceInfo bootTimeInSeconds];
    NSString* AT=DataLoader.accessToken; //[[LSUserModel getCurrentUser] accessToken];
    if(AT==nil)AT=@"Unlogined";
    NSDictionary* dict=[[NSDictionary alloc]initWithObjectsAndKeys:
                        @"update_status",@"act",
                        AT,@"token",
                        [NSString stringWithFormat:@"%d",bs_p],@"is_plugin",
                        [NSString stringWithFormat:@"%d",level],@"battery_level",
                        [NSString stringWithFormat:@"%ld",boot_time_second],@"bootBefore",
                        @"Unknown",@"lastClean",
                        [NSString stringWithFormat:@"%d",net_state],@"net",
                        SUUID,@"SUUID",
                        nil
                        ];
    
    NSString* param=NSUtil::URLQuery(dict);
    
    NSLog(@"[LSUserModel]doLoginWork:URL=%@ param=%@",ReportURL,param);
    NSError *error = nil;
    NSURLResponse *response = nil;
    NSData *post = [param dataUsingEncoding:NSUTF8StringEncoding];
    NSData* return_data = HttpUtil::HttpData(ReportURL, post, NSURLRequestReloadIgnoringCacheData, &response, &error);
    NSString * return_data_string= [[NSString alloc] initWithData:return_data  encoding:NSUTF8StringEncoding];
    
    //LSNetAPIWorker* worker=[[LSNetAPIWorker alloc]init];
    
    //BOOL done= [worker doAsyncAPIRequestByURL:URL withParameterString:param toDelegate:[[LSRegularReporter alloc]init]];
    
    NSLog(@"regularDeviceInfoReport {\n battery state [%d] plug in?[%d] level is [%d]\nSecureUUID is %@\nnet [%d]\nsince boot [%ld]\nAT[%@]\n} POSTED=%@ response=[%@]",bs,bs_p,level,SUUID,net_state,boot_time_second,AT,return_data_string,response);
}

@end
