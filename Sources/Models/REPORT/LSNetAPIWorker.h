//
//  LSNetAPIWorker.h
//  BNLP_Ichi
//
//  Created by 倪 李俊 on 14-6-7.
//  Copyright (c) 2014年 Leqee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SecureUDID.h"
#import "LSConnectionDelegater.h"
//#import "LSPromotorLoginConnectionDelegate.h"

// return the unique device ID; it is cached because accessing this object is expensive
/*
static NSString *DeviceID() {
    static NSString *deviceID = nil;
    if (!deviceID) {
        deviceID = [SecureUDID UDIDForDomain:@"sinri" usingKey:@"AllahuAkbar"];
    }
    return deviceID;
}
*/

@interface LSNetAPIWorker : NSObject
@property (strong,atomic) id resultDictionary;
@property (strong,atomic) id resultArray;
@property (strong,atomic) id resultData;

+(NSString*)getTrustHost;

-(BOOL)doAsyncAPIRequestByURL:(NSString *)URL withParameterString:(NSString*)parameterString toDelegate:(LSConnectionDelegater*)delegate;

-(BOOL)doAPIRequestForJSONByURL:(NSString*)URL;
-(BOOL)doURLSessionRequest:(NSString *)URL;
-(BOOL)doAPIRequestByURL:(NSString *)URL withParameterString:(NSString*)parameterString;

@end

