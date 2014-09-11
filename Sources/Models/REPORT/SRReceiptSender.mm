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
    srrs.type=0;
    srrs.srids=@[[NSNumber numberWithInt: srid]];
    BOOL done= [worker doAsyncAPIRequestByURL:[[ServerConfig getServerConfig]getURL_sr_receipt] withParameterString:param toDelegate:srrs];
    _Log(@"SRReceiptSender report_have_read:%d -> %d",srid,done);
}

+(void)report_have_reported:(int)srid{
    NSString* AT=DataLoader.accessToken;
    if(AT==nil)return;
    NSDictionary* dict=[[NSDictionary alloc]initWithObjectsAndKeys:
                        [NSString stringWithFormat:@"%d",srid],@"srid",
                        NSLocalizedString(@"en", @"cn"),@"lang",
                        AT,@"token",
                        nil
                        ];
    NSString* param=NSUtil::URLQuery(dict);
    LSNetAPIWorker * worker=[[LSNetAPIWorker alloc]init];
    SRReceiptSender * srrs=[[SRReceiptSender alloc]init];
    srrs.type=1;
    srrs.targetSIRD=srid;
    srrs.srids=@[[NSNumber numberWithInt: srid]];
    BOOL done= [worker doAsyncAPIRequestByURL:[[ServerConfig getServerConfig]getURL_sr_feedback] withParameterString:param toDelegate:srrs];
    _Log(@"SRReceiptSender report_have_feedback:%d -> %d",srid,done);
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
    tmp_data=[[NSMutableData alloc]init];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    _Log(@"SRReceiptSender didReceiveData:[%@]",data);
    [tmp_data appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    _Log(@"SRReceiptSender didFailWithError [%@]",error);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SRReceiptSenderError" object:@{@"srids": _srids}];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    _Log(@"SRReceiptSender connectionDidFinishLoading ...");
    if(_type==0){
    NSDictionary * dict=[NSJSONSerialization JSONObjectWithData:tmp_data options:(NSJSONReadingMutableLeaves) error:nil];
    _Log(@"SRReceiptSender connectionDidFinishLoading to dict=[%@]",dict);
    if([dict isKindOfClass:[NSDictionary class]]){
        if([dict[@"CODE"] integerValue]==200){
            NSDictionary * data_dict=dict[@"DATA"];
            id done=data_dict[@"DONE"];
            id undone=data_dict[@"UNDONE"];
            if (done && ![done isEqual:[NSNull null]]) {
                [LocalSRMessageTool setSRArraytoHaveRead:done];
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:@"SRReceiptSenderDone" object:@{@"DoneIds":([done isEqual: [NSNull null]]?[NSNull null]:done),@"UndoneIds":([undone isEqual:[NSNull null]]?[NSNull null]:undone)}];
        }else{
            _Log(@"SRReceiptSender connectionDidFinishLoading return error code");
        }
    }else{
        [self connection:connection didFailWithError:nil];
    }
    }else if(_type==1){
        [LocalSRMessageTool setSRtoHaveReported:_targetSIRD];
    }
}

@end
