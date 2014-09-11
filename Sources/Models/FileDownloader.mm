//
//  FileDownloader.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-4.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "FileDownloader.h"
//#import "DataLoader.h"

static NSString * LogSignature=@"FileDownloaderLog";
static NSString * FileDownloaderNotificationTypeSuccess=@"FILE_DOWNLOADED_SUCCESS";
static NSString * FileDownloaderNotificationTypeFailed=@"FILE_DOWNLOADED_FAILED";
static NSString * FileDownloaderNotificationTypeResponsed=@"FILE_DOWNLOADED_RESPONSED";
static NSString * FileDownloaderNotificationTypeReceivedData=@"FILE_DOWNLOADED_RECEIVED_DATA";

static NSMutableDictionary * fileTaskDict=[[NSMutableDictionary alloc]init];

@implementation FileDownloader

+(NSString*)getLogSignature{
    return LogSignature;
}
+(NSString*)getFileDownloaderNotificationTypeSuccess{
    return FileDownloaderNotificationTypeSuccess;
}
+(NSString*)getFileDownloaderNotificationTypeFailed{
    return FileDownloaderNotificationTypeFailed;
}
+(NSString*)getFileDownloaderNotificationTypeResponsed{
    return FileDownloaderNotificationTypeResponsed;
}
+(NSString*)getFileDownloaderNotificationTypeReceivedData{
    return FileDownloaderNotificationTypeReceivedData;
}

+(NSMutableDictionary *)getFileTaskDict{
    if(fileTaskDict==nil)fileTaskDict=[[NSMutableDictionary alloc]init];
    return fileTaskDict;
}
+(FileDownloader*)seekInFileTaskDict:(NSString*)url{
    return [[FileDownloader getFileTaskDict]objectForKey:url];
}
+(void)addFileTask:(NSString*)url withFD:(FileDownloader *)fd{
    [[FileDownloader getFileTaskDict]setObject:fd forKey:url];
}
+(void)removeFileTask:(NSString *)url{
    [[FileDownloader getFileTaskDict] removeObjectForKey:url];
}
+(BOOL)isNotRunningFileTask:(NSString *)url{
    return ([FileDownloader seekInFileTaskDict:url]==nil);
}

+(void)ariseNewDownloadTaskForURL:(NSString *)URL withAccessToken:(NSString *)AT{
    [FileDownloader sync_ariseNewDownloadTaskForURL:URL withAccessToken:AT];
}

+(void)blockBased_ariseNewDownloadTaskForURL:(NSString *)URL withAccessToken:(NSString *)AT{
    if(NSUtil::IsFileExist(NSUtil::CacheUrlPath(URL))){
        _Log(@"FileDownloader URL %@ existed,PASSOVER",URL);
        return;
    }
    //第一步，创建URL
    NSURL *url = [NSURL URLWithString:URL];
    //第二步，创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    NSString *str = [@"token=" stringByAppendingString:AT];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    UIUtil::ShowNetworkIndicator(YES);
    [NSURLConnection sendAsynchronousRequest:request queue:([NSOperationQueue mainQueue]) completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(data){
            _Log(@"FileDownloader end with data, error=%@ url=%@",connectionError,URL);
            [data writeToFile:NSUtil::CacheUrlPath(URL) atomically:YES];
        }else{
            _Log(@"FileDownloader failed with data, error=%@ url=%@",connectionError,URL);
        }
    }];
    UIUtil::ShowNetworkIndicator(NO);
}

+(void)sync_ariseNewDownloadTaskForURL:(NSString *)URL withAccessToken:(NSString *)AT{
    if(NSUtil::IsFileExist(NSUtil::CacheUrlPath(URL))){
        _Log(@"FileDownloader URL %@ existed,PASSOVER",URL);
        return;
    }
    UIUtil::ShowNetworkIndicator(YES);
    //第一步，创建URL
    NSURL *url = [NSURL URLWithString:URL];
    //第二步，创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    NSString *str = [@"token=" stringByAppendingString:AT];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    //第三步，连接服务器
    _Log(@"FileDownloader start download: %@",URL);
    NSData *res = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    _Log(@"FileDownloader end download: %@",URL);
    [res writeToFile:NSUtil::CacheUrlPath(URL) atomically:YES];
    UIUtil::ShowNetworkIndicator(NO);
}


+(void)delegateBased_ariseNewDownloadTaskForURL:(NSString *)URL withAccessToken:(NSString *)AT{
    FileDownloader *fd=[[FileDownloader alloc]init];
    //[FileDownloader addFileTask:URL withFD:fd];
    [fd doAsyncDownloadByURL:URL withParameterString:AT toDelegate:fd];
    /*
     while(!fd.finished) {
     [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
     }
     */
    //[FileDownloader removeFileTask:URL];
}

- (BOOL)doAsyncDownloadByURL:(NSString *)URL withParameterString:(NSString*)parameterString toDelegate:delegate
{
    source_url=URL;
    _finished=YES;
    
    if([FileDownloader isNotRunningFileTask:source_url]){
        [FileDownloader addFileTask:source_url withFD:self];
        
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
        _finished=NO;
        
        
        if (connection == nil) {
            _Log(@"FileDownloader doAsyncAPIRequestByURL [%@] Failed to create connection",URL);
            [FileDownloader removeFileTask:source_url];
            return NO;
        }else{
            [delegate setConnection:connection];
            _Log(@"FileDownloader doAsyncAPIRequestByURL [%@] arised",URL);
            
            @try {
                return YES;
            }
            @catch (NSException *exception) {
                //
            }
            @finally {
                while(!_finished) {
                    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                }
            }
            
            //return YES;
        }
    }else{
        _Log(@"FileDownloader PASSOVER: URL[%@] has been running.",URL);
        return NO;
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
		//if ([challenge.protectionSpace.host isEqualToString:[LSNetAPIWorker getTrustHost]])
		{
			NSURLCredential *credential =
            [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
			[challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
		}
	}
    
	[challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}
/*
 -(void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{
 NSString * url=[[[connection currentRequest]URL]absoluteString];
 _Log(@"FileDownloader url = %@\ndidSendBodyData=%d\ntotalBytesWritten=%d\ntotalBytesExpectedToWrite=%d",url,bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
 
 }
 */

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSString* suggestedFilename=[response suggestedFilename];
    expected_length=[response expectedContentLength];
    done_length=0;
    _Log(@"FileDownloader didReceiveResponse suggestedFilename=%@,content length=%lld\n(response=%@)",suggestedFilename,expected_length,response);
    NSDictionary * obj=@{
                         @"url":[[[connection currentRequest]URL]absoluteString],
                         @"AllLength":[NSNumber numberWithLongLong: expected_length],
                         };
    [[NSNotificationCenter defaultCenter]postNotificationName:[FileDownloader getFileDownloaderNotificationTypeResponsed]  object:obj];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [the_data appendData:data];
    done_length+=[data length];
    
    //NSString * url=[[[connection currentRequest]URL]absoluteString];
    //[FileDownloader MyLog:[NSString stringWithFormat:@"FileDownloader didReceiveData length=%d from [%@]",[data length],url]];
    //_Log(@"FileDownloader didReceiveData length=%d now done %f%% for URL[%@]",[data length],(100.0*done_length/expected_length),source_url);
    
    NSDictionary * obj=@{
                         @"url":[[[connection currentRequest]URL]absoluteString],
                         @"ThisLength":[NSNumber numberWithLongLong: [data length]],
                         @"NowPercent":[NSNumber numberWithFloat:(100.0*done_length/expected_length)],
                         @"NowLength":[NSNumber numberWithLongLong: done_length],
                         @"AllLength":[NSNumber numberWithLongLong: expected_length],
                         };
    [[NSNotificationCenter defaultCenter]postNotificationName:[FileDownloader getFileDownloaderNotificationTypeReceivedData]  object:obj];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSString * url=[[[connection currentRequest]URL]absoluteString];
    BOOL written=[the_data writeToFile:the_cache_path atomically:YES];
    if(written){
        [[NSNotificationCenter defaultCenter] postNotificationName:[FileDownloader getFileDownloaderNotificationTypeSuccess] object:url];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:[FileDownloader getFileDownloaderNotificationTypeFailed] object:url];
    }
    [FileDownloader removeFileTask:source_url];
    _finished=YES;
    _Log(@"FileDownloader connectionDidFinishLoading for url [%@] written=%d",url,written);
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSString * url=[[[connection currentRequest]URL]absoluteString];
    [FileDownloader removeFileTask:source_url];
    _Log(@"FileDownloader didFailWithError url = %@",url);
    [[NSNotificationCenter defaultCenter] postNotificationName:[FileDownloader getFileDownloaderNotificationTypeFailed] object:url];
    _finished=YES;
}
-(NSString*)getURL{
    return source_url;
}
-(float)getPercent{
    return done_length*100.0/expected_length;
}
+(NSString*)currentDownloadProgress{
    NSDictionary * dict=[FileDownloader getFileTaskDict];
    NSString* log=@"FileDownloader Log\n";
    for (FileDownloader * fd in dict) {
        log=[log stringByAppendingString:[NSString stringWithFormat:@"URL[%@]:%f%%\n",[fd getURL],[fd getPercent]]];
    }
    return log;
}

@end
