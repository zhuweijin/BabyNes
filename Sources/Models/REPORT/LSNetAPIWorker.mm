//
//  LSNetAPIWorker.m
//  BNLP_Ichi
//
//  Created by 倪 李俊 on 14-6-7.
//  Copyright (c) 2014年 Leqee. All rights reserved.
//

#import "LSNetAPIWorker.h"

@implementation LSNetAPIWorker

static NSString* trust_host=@"172.16.0.186";

@synthesize resultDictionary;
@synthesize resultArray;
@synthesize resultData;

+(NSString*)getTrustHost{
    return trust_host;
}

-(BOOL)doAPIRequestByURL:(NSString *)URL withParameterString:(NSString*)parameterString{
    int HTTP_TIMEOUT=30;
    NSString *post = nil;
    post = parameterString;//[[NSString alloc] initWithFormat:@"message=%@",@"hello,world."];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL]];
    [request setTimeoutInterval:HTTP_TIMEOUT];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSData * data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //_Log(@"doAPIRequestByURL [%@][%@] receive [%@]",URL,parameterString,data);
    _Log(@"doAPIRequestByURL [%@][%@] received data",URL,parameterString);
    self.resultData=data;
    return YES;
}

- (BOOL)doAsyncAPIRequestByURL:(NSString *)URL withParameterString:(NSString*)parameterString toDelegate:(LSConnectionDelegater*)delegate
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
    //[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    //[request setCachePolicy:NSURLRequestUseProtocolCachePolicy]; // 设置缓存策略
    [request setTimeoutInterval:30]; // 设置超时
    /*
    _Log(@"[REQUEST-HEADER] count=%i",[[request allHTTPHeaderFields] count]);
    for(id key in [[request allHTTPHeaderFields] allKeys]){
        _Log(@"[REQUEST-HEADER] %@=%@",key,[[request allHTTPHeaderFields] valueForKey:key]);
    }
    _Log(@"[REQUEST-HEADER] URL=%@ param=%@[%@]",URL,postData,parameterString);
    */
    resultData=[[NSMutableData alloc] initWithData:nil];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:delegate];
    if (connection == nil) {
        _Log(@"doAsyncAPIRequestByURL Failed to create connection");
        return NO;
    }else{
        [delegate setConnection:connection];
        _Log(@"doAsyncAPIRequestByURL did create connection");
        return YES;
    }
}

-(BOOL)doAPIRequestForJSONByURL:(NSString*)URL{
    //_Log(@"URL=%@",URL);
    //NSString * URL=@"http://localhost/leqee/BNTest/api.php";
    int HTTP_TIMEOUT=30;
    
    NSString *post = nil;
    post = @"";//[[NSString alloc] initWithFormat:@"message=%@",@"hello,world."];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL]];
    [request setTimeoutInterval:HTTP_TIMEOUT];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    //[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    //[NSURLConnection connectionWithRequest:request delegate:self ];
    
    //同步请求的的代码
    //returnData就是返回得到的数据
    //    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningRequest:nil error:nil];
    
    NSData * data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //_Log(@"receive %@",data);
    //NSDictionary *
    resultDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    /*
    if(resultDictionary==nil)_Log(@"get nil");
    else{
        _Log(@"BP-1");
        NSArray * keyarray=[resultDictionary allKeys];
        _Log(@"BP-2");
        for (NSString * key in keyarray) {
            _Log(@"%@=%@\n",key,[resultDictionary valueForKey:key]);
        }
    }
    _Log(@"error=%@",[resultDictionary valueForKey:@"error"]);
    return resultDictionary;
    */
    if(resultDictionary!=nil)return YES;
    else return NO;
}

-(BOOL)doURLSessionRequest:(NSString *)URL{
    NSURLSessionDataTask* task= [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:URL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        _Log(@"doURLSessionRequest for URL[%@] complete data=[%@] response=[%@] error=[%@]",URL,data,[response debugDescription],[error debugDescription]);
        resultDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    }];
    [task resume];
    if(resultDictionary!=nil)return YES;
    else return NO;
}
@end
