//
//  LSRegularReporter.h
//  BabyNesPOS_Akatsuki
//
//  Created by 倪 李俊 on 14-6-25.
//  Copyright (c) 2014年 Leqee. All rights reserved.
//

//#import <Foundation/Foundation.h>
//#import "LSJsonFileReader.h"
#import "LSDeviceInfo.h"
#import "Reachability.h"
//#import "LSUserModel.h"
#import "DataLoader.h"
//#import "LSNetAPIWorker.h"
//#import "LSConnectionDelegater.h"
#import "LSNetAPIWorker.h"


@interface LSRegularReporter : LSConnectionDelegater < NSURLConnectionDelegate
//, NSURLConnectionDownloadDelegate
, NSURLConnectionDataDelegate>

+(void)report;
@end
