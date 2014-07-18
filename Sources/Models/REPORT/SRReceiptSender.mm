//
//  SRReceiptSender.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-18.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "SRReceiptSender.h"
#import "DataLoader.h"
#import "LSNetAPIWorker.h"
#import "LocalSRMessageTool.h"

@implementation SRReceiptSender

+(void)report_have_read:(int)srid{
    NSString* AT=DataLoader.accessToken;
    if(AT==nil)return;
    NSDictionary* dict=[[NSDictionary alloc]initWithObjectsAndKeys:
                        [NSString stringWithFormat:@"%d",srid],@"srids",
                        AT,@"token",
                        nil
                        ];
    NSString* param=NSUtil::URLQuery(dict);
    LSNetAPIWorker * worker=[[LSNetAPIWorker alloc]init];
    SRReceiptSender * srrs=[[SRReceiptSender alloc]init];
    srrs.srids=@[[NSNumber numberWithInt: srid]];
    BOOL done= [worker doAsyncAPIRequestByURL:[[ServerConfig getServerConfig]getURL_device_report] withParameterString:param toDelegate:srrs];
    _Log(@"SRReceiptSender report_have_read:%d -> %d",srid,done);
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
    //_Log(@"Regular Report didReceiveResponse [%@]",response);
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    _Log(@"Regular Report didReceiveData:[%@]",data);
    NSDictionary * dict=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
    _Log(@"Regular Report didReceiveData to dict=[%@]",dict);
    if([dict isKindOfClass:[NSDictionary class]]){
        id done=dict[@"DONE"];
        id undone=dict[@"UNDONE"];
        if (![done isEqual:[NSNull null]]) {
            [LocalSRMessageTool setSRArraytoHaveRead:done];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:@"SRReceiptSenderDone" object:@{@"DoneIds":([done isEqual: [NSNull null]]?[NSNull null]:done),@"UndoneIds":([undone isEqual:[NSNull null]]?[NSNull null]:undone)}];
    }else{
        [self connection:connection didFailWithError:nil];
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    _Log(@"Regular Report didFailWithError [%@]",error);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SRReceiptSenderError" object:@{@"srids": _srids}];
}


@end
