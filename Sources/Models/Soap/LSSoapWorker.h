//
//  LSSoapWorker.h
//  SoapTester
//
//  Created by 倪 李俊 on 14-7-22.
//  Copyright (c) 2014年 Sinri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSXMLWorker.h"

@interface LSSoapWorker : NSObject
<NSXMLParserDelegate,  NSURLConnectionDelegate>
@property (strong, nonatomic) NSMutableData *webData;
@property (strong, nonatomic) NSMutableString *soapResults;
@property (strong, nonatomic) NSXMLParser *xmlParser;
@property (nonatomic) BOOL elementFound;
@property (strong, nonatomic) NSString *matchingElement;
@property (strong, nonatomic) NSURLConnection *conn;

+(BOOL)debugMode;
+(void)setDebugMode:(BOOL)on;

- (void)doQueryWithMatchingElement:(NSString*)matchingElement withSoapMsg:(NSString*)soapMsg withURL:(NSString*)the_url withHeaders:(NSDictionary*)dict;
@end
