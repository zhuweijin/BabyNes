//
//  LSSoapLoginWorker.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-25.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSXMLWorker.h"
#import "ServerConfig.h"

@interface LSSoapLoginWorker : NSObject
+(NSString*)LoginWithUsername:(NSString*)username withPassword:(NSString*)password;
@end
