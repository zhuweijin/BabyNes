//
//  LSSoapLoginWorker.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-25.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "LSSoapLoginWorker.h"

@implementation LSSoapLoginWorker
+(NSString*)LoginWithUsername:(NSString*)username withPassword:(NSString*)password{
    //第一步，创建URL
    NSURL *url = [NSURL URLWithString:[[ServerConfig getServerConfig] getSoapLoginURL]];
    //第二步，创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    NSString *str =[NSString stringWithFormat:@"<soapenv:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:urn=\"urn:Magento\"> \
                    <soapenv:Header/> \
                    <soapenv:Body> \
                    <urn:login soapenv:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\"> \
                    <username xsi:type=\"xsd:string\">%@</username> \
                    <apiKey xsi:type=\"xsd:string\">%@</apiKey> \
                    </urn:login> \
                    </soapenv:Body> \
                    </soapenv:Envelope>",username,password];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    _Log(@"SOAP LOGIN XML = %@",str);
    [request setHTTPBody:data];
    //第三步，连接服务器
    
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if(received==nil || [received isEqual:[NSNull null]]){
        //return [NSString stringWithFormat:@"500: %@",NSLocalizedString(@"The response from server is in incorrect format.", @"服务器返回格式不正确")];
        return nil;
    }
    
    //NSString *str1 = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    
    LSXMLWorker * xmlWorker=[[LSXMLWorker alloc]initWithXMLData:received];
    if([xmlWorker prasing_done]){
        @try {
            NSMutableArray * bodyArray=[[xmlWorker rootObject] getSubNodeWithName:@"SOAP-ENV:Body" withAttributes:nil];
            for (LSXMLObject * body in bodyArray) {
                NSMutableArray * resArray=[body getSubNodeWithName:@"ns1:loginResponse" withAttributes:nil];
                if(resArray && [resArray count]>0){
                    for (LSXMLObject * res in resArray) {
                        NSMutableArray * returnArray=[res getSubNodeWithName:@"loginReturn" withAttributes:nil];
                        LSXMLObject * finalobj=[returnArray objectAtIndex:0];
                        //return [finalobj text];
                        return [[finalobj text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    }
                }
                /*
                 //不用解析错误的，因为。。。不用管错误代码。
                NSMutableArray * faultArray=[body getSubNodeWithName:@"SOAP-ENV:Fault" withAttributes:nil];
                if(faultArray && [faultArray count]>0){
                    for (LSXMLObject * res in faultArray) {
                        NSMutableArray * codeArray=[res getSubNodeWithName:@"faultcode" withAttributes:nil];
                        LSXMLObject * faultCode=[codeArray objectAtIndex:0];
                        NSMutableArray * stringArray=[res getSubNodeWithName:@"faultstring" withAttributes:nil];
                        LSXMLObject * faultString=[stringArray objectAtIndex:0];
                        NSString * ori=[NSString stringWithFormat:@"%@: %@",[faultCode text],[faultString text]];
                        return [ori stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    }
                }
                 */
            }
            //return [NSString stringWithFormat:@"500: %@",NSLocalizedString(@"The response from server is in incorrect format.", @"服务器返回格式不正确")];
            return nil;
        }
        @catch (NSException *exception) {
            _Log(@"Error in parse xml [%@], error:%@",[[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding],exception);
            //return [NSString stringWithFormat:@"500: %@",NSLocalizedString(@"The response from server is in incorrect format.", @"服务器返回格式不正确")];
            return nil;
        }
        @finally {
            
        }
        
        
    }else{
        //return [NSString stringWithFormat:@"500: %@",NSLocalizedString(@"The response from server is in incorrect format.", @"服务器返回格式不正确")];
        return nil;
    }
}
@end
