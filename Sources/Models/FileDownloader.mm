//
//  FileDownloader.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-4.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "FileDownloader.h"

@implementation FileDownloader

+(void)ariseNewDownloadTaskForURL:(NSString *)URL withAccessToken:(NSString *)AT{
    FileDownloader *fd=[[FileDownloader alloc]init];
    [fd doAsyncDownloadByURL:URL withParameterString:AT toDelegate:fd];
}

- (BOOL)doAsyncDownloadByURL:(NSString *)URL withParameterString:(NSString*)parameterString toDelegate:delegate
{
    // 初始化请求
    NSMutableURLRequest  *request = [[NSMutableURLRequest alloc] init];
    
    // 设置
    NSData *postData = [parameterString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    [request setURL:[NSURL URLWithString:URL]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    //[request setCachePolicy:NSURLRequestUseProtocolCachePolicy]; // 设置缓存策略
    //[request setTimeoutInterval:10*60]; // 设置超时
    /*
    _Log(@"[REQUEST-HEADER] count=%i",[[request allHTTPHeaderFields] count]);
    for(id key in [[request allHTTPHeaderFields] allKeys]){
        _Log(@"[REQUEST-HEADER] %@=%@",key,[[request allHTTPHeaderFields] valueForKey:key]);
    }
    _Log(@"[REQUEST-HEADER] URL=%@ param=%@[%@]",URL,postData,parameterString);
    */
    //resultData=[[NSMutableData alloc] initWithData:nil];
    
    the_data=[[NSMutableData alloc]init];
    the_cache_path=NSUtil::CacheUrlPath(URL);
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:delegate];
    if (connection == nil) {
        _Log(@"FileDownloader doAsyncAPIRequestByURL [%@] Failed to create connection",URL);
        return NO;
    }else{
        [delegate setConnection:connection];
        _Log(@"FileDownloader doAsyncAPIRequestByURL [%@] arised",URL);
        return YES;
    }
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
-(void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{
    NSString * url=[[[connection currentRequest]URL]absoluteString];
    _Log(@"FileDownloader url = %@\ndidSendBodyData=%d\ntotalBytesWritten=%d\ntotalBytesExpectedToWrite=%d",url,bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
    
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSString * url=[[[connection currentRequest]URL]absoluteString];
    [the_data appendData:data];
    //_Log(@"FileDownloader didReceiveData length=%d from [%@]",[data length],url);
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSString * url=[[[connection currentRequest]URL]absoluteString];
    BOOL written=[the_data writeToFile:the_cache_path atomically:YES];
    if(written){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FILE_DOWNLOADED_SUCCESS" object:url];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FILE_DOWNLOADED_FAILED" object:url];
    }
    _Log(@"FileDownloader connectionDidFinishLoading for url [%@] written=%d",url,written);
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSString * url=[[[connection currentRequest]URL]absoluteString];
    _Log(@"FileDownloader didFailWithError url = %@",url);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FILE_DOWNLOADED_FAILED" object:url];
}

@end
