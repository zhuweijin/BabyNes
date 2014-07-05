//
//  LSRegularReporter.m
//  BabyNesPOS_Akatsuki
//
//  Created by 倪 李俊 on 14-6-25.
//  Copyright (c) 2014年 Leqee. All rights reserved.
//

#import "LSRegularReporter.h"

static NSString * ReportURL=@"https://172.16.0.186:233/babynesios/admin/api/device_status.php";

@implementation LSRegularReporter

+(void)report{
    int bs=[LSDeviceInfo batteryState];
    int bs_p=[LSDeviceInfo batteryState_isPlugIn];
    NSInteger level=[LSDeviceInfo batteryLevel];
    NSString* SUUID=[LSDeviceInfo device_sn];//SystemUtil::SN();//[LSUserModel device_sn];
    _Log(@"REPORT-SUUID=%@",SUUID);
    //Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NSInteger net_state=-1;//[r currentReachabilityStatus]
    switch ([LSDeviceInfo currentNetworkType]) {
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
    
    NSNumber * num = [[NSUserDefaults standardUserDefaults]objectForKey:@"BabyNesPOS_LastCleanCache_UnixTime"];
    if(num==nil){
        num=[NSNumber numberWithLong:-1];
    }
    
    NSDictionary* dict=[[NSDictionary alloc]initWithObjectsAndKeys:
                        @"update_status",@"act",
                        AT,@"token",
                        [NSString stringWithFormat:@"%d",bs_p],@"is_plugin",
                        [NSString stringWithFormat:@"%d",level],@"battery_level",
                        [NSString stringWithFormat:@"%ld",boot_time_second],@"bootBefore",
                        num,@"lastClean",
                        [NSString stringWithFormat:@"%d",net_state],@"net",
                        SUUID,@"SUUID",
                        nil
                        ];
    
    NSString* param=NSUtil::URLQuery(dict);
    
    _Log(@"[LSUserModel]doLoginWork:URL=%@ param=%@",ReportURL,param);
    //NSError *error = nil;
    //NSURLResponse *response = nil;
    //NSData *post = [param dataUsingEncoding:NSUTF8StringEncoding];
    //NSData* return_data = HttpUtil::HttpData(ReportURL, post, NSURLRequestReloadIgnoringCacheData, &response, &error);
    //NSString * return_data_string= [[NSString alloc] initWithData:return_data  encoding:NSUTF8StringEncoding];
    
    LSNetAPIWorker* worker=[[LSNetAPIWorker alloc]init];
    
    BOOL done= [worker doAsyncAPIRequestByURL:ReportURL withParameterString:param toDelegate:[[LSRegularReporter alloc]init]];
    
    _Log(@"regularDeviceInfoReport {\n battery state [%d] plug in?[%d] level is [%d]\nSecureUUID is %@\nnet [%d]\nsince boot [%ld]\nAT[%@]\n} POSTED=%d",bs,bs_p,level,SUUID,net_state,boot_time_second,AT,done);
}

- (BOOL)connection:(NSURLConnection *)connection
canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
	return [protectionSpace.authenticationMethod
			isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection
didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
	if ([challenge.protectionSpace.authenticationMethod
		 isEqualToString:NSURLAuthenticationMethodServerTrust])
	{
		// we only trust our own domain
		if ([challenge.protectionSpace.host isEqualToString:[LSNetAPIWorker getTrustHost]])
		{
			NSURLCredential *credential =
            [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
			[challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
		}
	}
    
	[challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    _Log(@"Regular Report didReceiveResponse [%@]",response);
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
     _Log(@"Regular Report didReceiveData [%@]",data);
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    _Log(@"Regular Report didFailWithError [%@]",error);
}

@end
