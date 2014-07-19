//
//  SRReceiptSender.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-18.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSConnectionDelegater.h"

@interface SRReceiptSender : LSConnectionDelegater < NSURLConnectionDelegate
//, NSURLConnectionDownloadDelegate
, NSURLConnectionDataDelegate>
{
    NSMutableData * tmp_data;
}

+(void)report_have_read:(int)srid;
@property NSArray * srids;

@end
