//
//  APIWorker.m
//  BabyNesPosApiTester
//
//  Created by 倪 李俊 on 14-8-6.
//  Copyright (c) 2014年 com.sinri. All rights reserved.
//

#import "APIWorker.h"
#import "LSDeviceInfo.h"

@implementation APIWorker

-(id)init{
    self=[super init];
    if(self){
        _token=[DataLoader accessToken];
        _country_id=NSLocalizedString(@"HK", @"CN"); //@"CN";
        _unique_device_id=[LSDeviceInfo device_sn];
        _language_id=NSLocalizedString(@"en", @"zh"); //@"zh";
        _device_id=[LSDeviceInfo device_sn];
        _promoter_id=[DataLoader username];
        isRefreshing=NO;
        
        //[self setCountry_id:@"CN"];
        //[self setUnique_device_id:@"E7BA48E2-3370-4433-8FDD-03B3FF06EA1X"];
        //[self setLanguage_id:@"zh"];
        //[self setDevice_id:@"f0595195f0bdf1c2f27b8a4b5a78f472"];
        //[self setPromoter_id:@"1233"];
        
        //NOW I NEED LOGIN
        //NSLog(@"APIWorker INIT ONETIME LOGIN:%@",[self loginWithUser:[DataLoader username] password:[DataLoader password]]);
    }
    return self;
}

-(NSString*)loginWithUser:(NSString*)username password:(NSString*)pw{
    _token = [LSSoapLoginWorker LoginWithUsername:username withPassword:pw];
    if(_token){
        NSLog(@"login...token=%@",_token);
    }else{
        NSLog(@"login...failed");
    }
    return _token;
}
-(NSDictionary*)searchCustomerWithRegionCode:(NSString*)regionCode withNumber:(NSString*)number{
    NSString * url=[NSString stringWithFormat:@"%@/?mobile=%@-%@",BABYNES_REST_SEARCH_CUSTOMER,regionCode,number];
    NSMutableURLRequest * request=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url] cachePolicy:(NSURLRequestReloadIgnoringLocalAndRemoteCacheData) timeoutInterval:30];
    [request addValue:_country_id forHTTPHeaderField:@"X-Country"];
    [request addValue:_unique_device_id forHTTPHeaderField:@"X-Unique-Device-Id"];
    [request addValue:_language_id forHTTPHeaderField:@"X-Language"];
    [request addValue:_token forHTTPHeaderField:@"X-Pos-Session-Id"];
    [request addValue:_device_id forHTTPHeaderField:@"X-Pos-Id"];
    [request addValue:_promoter_id forHTTPHeaderField:@"X-Pos-Promoter-Id"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"NNBN" forHTTPHeaderField:@"X-Brand"];
    [request addValue:@"Asia/Shanghai" forHTTPHeaderField:@"X-Timezone"];
    [request setHTTPMethod:@"GET"];
    
    NSURLResponse * response=nil;
    NSError * error=nil;
    
    NSData*data=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    {
        NSString * getStr=(data?[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]:nil);
        NSLog(@"searchCustomer: [%@] ...(response=%@,error=%@) get %@ ",url,response,error,getStr);
    }
    if(data){
        NSDictionary * dict=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:&error];
        if([dict objectForKey:@"success"] && ![dict[@"success"] boolValue]){
            return @{@"done":@YES,@"data":[NSNull null]};
        }else{
            return @{@"done":@YES,@"data":dict};
        }
    }else{
        return @{@"done":@NO};
    }
}

-(NSDictionary*)createUserWithDictionary:(NSDictionary*)dict{
    NSString * param=@"";
    /*
     for (NSString * key in [dict allKeys]) {
     param=[param stringByAppendingFormat:@"&%@=%@",key,dict[key]];
     }
     if([param length]>0){
     param = [param substringFromIndex:1];
     }
     
     param=[param stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     */
    param=[APIWorker lineJsonFromObj:dict];
    NSData* body=[param dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSString * url=[NSString stringWithFormat:@"%@",BABYNES_REST_REGISTER_CUSTOMER];
    NSMutableURLRequest * request=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url] cachePolicy:(NSURLRequestReloadIgnoringLocalAndRemoteCacheData) timeoutInterval:30];
    [request addValue:_country_id forHTTPHeaderField:@"X-Country"];
    [request addValue:_unique_device_id forHTTPHeaderField:@"X-Unique-Device-Id"];
    [request addValue:_language_id forHTTPHeaderField:@"X-Language"];
    [request addValue:_token forHTTPHeaderField:@"X-Pos-Session-Id"];
    [request addValue:_device_id forHTTPHeaderField:@"X-Pos-Id"];
    [request addValue:_promoter_id forHTTPHeaderField:@"X-Pos-Promoter-Id"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"NNBN" forHTTPHeaderField:@"X-Brand"];
    [request addValue:@"Asia/Shanghai" forHTTPHeaderField:@"X-Timezone"];
    [request addValue:[NSString stringWithFormat:@"%lu",(unsigned long)[body length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:body];
    [request setHTTPMethod:@"POST"];
    
    for (id header_field in [[request allHTTPHeaderFields] allKeys]) {
        NSLog(@"HTTP HEADER: %@=%@",header_field,[[request allHTTPHeaderFields] objectForKey:header_field]);
    }
    
    NSURLResponse * response=nil;
    NSError * error=nil;
    
    NSData*data=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    {
        NSString * getStr=(data?[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]:nil);
        NSLog(@"registerCustomer: %@[%@] ...(response=%@,error=%@) get [%@] ",BABYNES_REST_REGISTER_CUSTOMER,param,response,error,getStr);
    }
    if(data){
        _LogLine();
        NSDictionary * dict=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:&error];
        if(dict){
            if([dict objectForKey:@"success"] && [dict[@"success"] boolValue]){
                return @{@"done":@YES,@"data":dict[@"customerId"],@"toOffline":@NO};
            }else{
                return @{@"done":@YES,@"data":[NSNull null],@"msg":dict[@"message"],@"toOffline":@NO};
            }
        }else{//NOT 200
            NSLog(@"registerCustomer: analyze failed... server error maybe... JSON error=%@",error);
            return @{@"done":@YES,@"data":[NSNull null],@"msg":NSLocalizedString(@"Failed due to some issue in server, BabyNes POS is to store customer info offline.", @"由于服务器原因用户注册不顺利，将离线暂存用户信息。"),@"toOffline":@YES};
        }
    }else{
        return @{@"done":@NO};
    }
}

-(NSDictionary*)createBabyWithDictionary:(NSDictionary*)dict{
    NSString * param=@"";
    /*
     for (NSString * key in [dict allKeys]) {
     param=[param stringByAppendingFormat:@"&%@=%@",key,dict[key]];
     }
     if([param length]>0){
     param = [param substringFromIndex:1];
     }
     */
    param=[APIWorker lineJsonFromObj:dict];
    NSData* body=[param dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSString * url=[NSString stringWithFormat:@"%@",BABYNES_REST_REGISTER_BABY];
    NSMutableURLRequest * request=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url] cachePolicy:(NSURLRequestReloadIgnoringLocalAndRemoteCacheData) timeoutInterval:30];
    [request addValue:_country_id forHTTPHeaderField:@"X-Country"];
    [request addValue:_unique_device_id forHTTPHeaderField:@"X-Unique-Device-Id"];
    [request addValue:_language_id forHTTPHeaderField:@"X-Language"];
    [request addValue:_token forHTTPHeaderField:@"X-Pos-Session-Id"];
    [request addValue:_device_id forHTTPHeaderField:@"X-Pos-Id"];
    [request addValue:_promoter_id forHTTPHeaderField:@"X-Pos-Promoter-Id"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"NNBN" forHTTPHeaderField:@"X-Brand"];
    [request addValue:@"Asia/Shanghai" forHTTPHeaderField:@"X-Timezone"];
    [request addValue:[NSString stringWithFormat:@"%lu",(unsigned long)[body length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:body];
    [request setHTTPMethod:@"POST"];
    
    NSURLResponse * response=nil;
    NSError * error=nil;
    
    NSData*data=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    {
        NSString * getStr=(data?[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]:nil);
        NSLog(@"registerBaby: %@[%@] ...(response=%@,error=%@) get %@ ",BABYNES_REST_REGISTER_BABY,param,response,error,getStr);
    }
    if(data){
        NSDictionary * dict=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:&error];
        if([dict objectForKey:@"success"] && [dict[@"success"] boolValue]){
            return @{@"done":@YES,@"data":dict};
        }else{
            return @{@"done":@YES,@"data":[NSNull null]};
        }
    }else{
        return @{@"done":@NO};
    }
    
}

-(NSDictionary*)createOrderWithDictionary:(NSDictionary*)dict{
    NSString * param=@"";
    /*
     for (NSString * key in [dict allKeys]) {
     //if([key isEqualToString:@"orderItems"]) param=[param stringByAppendingFormat:@"&%@=%@",key,[APIWorker lineJsonFromObj: dict[key]]];else
     param=[param stringByAppendingFormat:@"&%@=%@",key,dict[key]];
     }
     //NSString * json=[APIWorker lineJsonFromObj:dict];
     //param=[param stringByAppendingFormat:@"&raw_json=%@",json];
     if([param length]>0){
     param = [param substringFromIndex:1];
     }
     */
    param=[APIWorker lineJsonFromObj:dict];
    
    //param=@"{\"customerId\":\"10000055\",\"shippingName\":\"Customer Name\",\"shippingProvince\":\"Chongqing\",\"shippingCity\":\"Chongqing\",\"shippingAddress\":\"Address\",\"deliveryModeID\":\"pos\",\"orderItems\":[{\"boxCount\":\"2\",\"itemType\":\"7613034431301_00\"}]}";
    
    NSData* body=[param dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSString * url=[NSString stringWithFormat:@"%@",BABYNES_REST_CREATE_ORDER];
    NSMutableURLRequest * request=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url] cachePolicy:(NSURLRequestReloadIgnoringLocalAndRemoteCacheData) timeoutInterval:30];
    [request addValue:_country_id forHTTPHeaderField:@"X-Country"];
    [request addValue:_unique_device_id forHTTPHeaderField:@"X-Unique-Device-Id"];
    [request addValue:_language_id forHTTPHeaderField:@"X-Language"];
    [request addValue:_token forHTTPHeaderField:@"X-Pos-Session-Id"];
    [request addValue:_device_id forHTTPHeaderField:@"X-Pos-Id"];
    [request addValue:_promoter_id forHTTPHeaderField:@"X-Pos-Promoter-Id"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"NNBN" forHTTPHeaderField:@"X-Brand"];
    [request addValue:@"Asia/Shanghai" forHTTPHeaderField:@"X-Timezone"];
    [request addValue:[NSString stringWithFormat:@"%lu",(unsigned long)[body length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:body];
    [request setHTTPMethod:@"POST"];
    
    NSURLResponse * response=nil;
    NSError * error=nil;
    
    NSData*data=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    {
        NSString * getStr=(data?[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]:nil);
        NSLog(@"createOrder: %@[%@] ...(response=%@,error=%@) get %@ ",BABYNES_REST_CREATE_ORDER,param,response,error,getStr);
    }
    if(data){
        NSDictionary * dict=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:&error];
        if([dict objectForKey:@"success"] && [dict[@"success"] boolValue]){
            return @{@"done":@YES,@"data":dict[@"id"]};
        }else{
            return @{@"done":@YES,@"data":[NSNull null],@"msg":dict[@"message"]};
        }
    }else{
        return @{@"done":@NO};
    }
    
}

+(NSString*)lineJsonFromObj:(id)obj{
    @try {
        NSString * json=[[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:obj options:(NSJSONWritingPrettyPrinted) error:nil] encoding:NSUTF8StringEncoding];
        json=[json stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        return json;
    }
    @catch (NSException *exception) {
        return nil;
    }
    @finally {
        //
    }
    
}
/*
 -(NSString*)refreshMCToken{
 NSDictionary *params = @
 {
 @"username": [DataLoader username],
 @"password": [DataLoader password],
 @"uuid": [LSDeviceInfo device_sn],
 };
 isRefreshing=YES;
 //[DataLoader loadWithService:@"login" params:params completion:^(DataLoader *loader)
 [DataLoader loadWithService:@"login" params:params success:^(DataLoader *loader) {
 DataLoader.accessToken = loader.dict[@"token"];
 [DataLoader setStoreProvince:loader.dict[@"storeProvince"]];
 [DataLoader setStoreCity:loader.dict[@"storeCity"]];
 [DataLoader setStoreAddress:loader.dict[@"storeAddress"]];
 //[DataLoader setUsername:_usernameField.text];
 //[DataLoader setPassword:_passwordField.text];
 if (Settings::Get(kAccessToken))
 {
 Settings::Save(kAccessToken, DataLoader.accessToken);
 }
 isRefreshing=YES;
 } failure:^BOOL(DataLoader *loader, NSString *error) {
 NSLog(@"refreshMCToken..FAILED with error = %@",error);
 isRefreshing=YES;
 return NO;
 }];
 self per
 }
 */
@end
