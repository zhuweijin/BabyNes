//
//  FileDownloader.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-4.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "LSNetAPIWorker.h"

@interface FileDownloader : NSObject
< NSURLConnectionDelegate
//, NSURLConnectionDownloadDelegate
, NSURLConnectionDataDelegate>
{
    NSString * source_url;
    NSMutableData * the_data;
    NSString * the_cache_path;
    long long expected_length;
    long long done_length;
}
@property (strong,atomic) NSURLConnection* connection;

+(void)ariseNewDownloadTaskForURL:(NSString *)URL withAccessToken:(NSString *)AT;
- (BOOL)doAsyncDownloadByURL:(NSString *)URL withParameterString:(NSString*)parameterString toDelegate:delegate;
-(NSString*)getURL;
-(float)getPercent;
+(NSString*)getLogSignature;
+(NSString*)getFileDownloaderNotificationTypeSuccess;
+(NSString*)getFileDownloaderNotificationTypeFailed;
+(NSString*)getFileDownloaderNotificationTypeResponsed;
+(NSString*)getFileDownloaderNotificationTypeReceivedData;
@end
