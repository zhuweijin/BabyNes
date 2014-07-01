//
//  LSConnectionDelegater.h
//  BNLP_Ni
//
//  Created by 倪 李俊 on 14-6-11.
//  Copyright (c) 2014年 Leqee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSConnectionDelegater : NSObject
//< NSURLConnectionDelegate
//, NSURLConnectionDownloadDelegate
//, NSURLConnectionDataDelegate>
@property (strong,atomic) id resultDictionary;
@property (strong,atomic) id resultArray;
@property (strong,atomic) id resultData;

-(BOOL)tryMakeArrayFromData;
-(BOOL)tryMakeDictionaryFromData;

@property (strong,atomic) NSURLConnection* connection;
@end
