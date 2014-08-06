//
//  LSOrder.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-8-4.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "LSOrder.h"

@implementation LSOrder

-(id)initWithCart:(CartEntity*)cart forCustomer:(LSCustomer*)customer{
    self=[super init];
    if(self){
        self.theCart=cart;
        self.theCustomer=customer;
        self.theCreateTime=[[NSDate date] timeIntervalSince1970];
        self.theOrderType=@"SALE";
        for (ProductEntity * pe in cart.cart_array) {
            if([pe product_id]<0){
                self.theOrderType=@"RMA";
                break;
            }
        }
    }
    return self;
}

-(NSString*)create{
    NSString*json=[self toJson];
    if(json){
        //TO MAGENTO
        /*
         TODO (╯‵□′)╯︵┻━┻
         */
        //TO LEQEE
        /*
        NSData * data=[[[[@"token=" stringByAppendingString:[DataLoader accessToken]] stringByAppendingString:@"&json="] stringByAppendingString:json] dataUsingEncoding:NSUTF8StringEncoding];
        NSData* res=HttpUtil::HttpUpload([[ServerConfig getServerConfig] getURL_create_order], data);
        */
        //第一步，创建URL
        NSURL *url = [NSURL URLWithString:
                      //@"http://172.16.0.2/Leqee/tmp/newOrder.php"
                      //@"http://172.16.1.19/test/newOrder.php"
                      //@"http://172.16.0.186:8088/babynesios/admin/api/create_order.php"
                      [[ServerConfig getServerConfig] getURL_create_order]
                      ];
        //第二步，创建请求
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
        NSString *str = [[[@"token=" stringByAppendingString:[DataLoader accessToken]] stringByAppendingString:@"&json="] stringByAppendingString:json];//设置参数
        NSLog(@"Order to Leqee preparation: url=%@ param=%@",url,str);
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
        //第三步，连接服务器
        
        NSData *res = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        NSLog(@"Order to Leqee response: %@",[[NSString alloc]initWithData:res encoding:NSUTF8StringEncoding]);
        
        
    }
    return @"ORDER ID DUMMY";
}

-(NSString*)toJson{
    NSError * error=nil;
    NSDictionary * jsonDict=@{@"cart":[self.theCart toJson],
                              @"customer":[self.theCustomer toJson],
                              @"date": [NSNumber numberWithLongLong:(long long)self.theCreateTime],
                              @"type":self.theOrderType};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        return [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }else{
        return nil;
    }
}

+(LSOrder*)fromJson:(NSString*)json{
    NSError * error=nil;
    NSDictionary* dict=[NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    LSOrder * order=[[LSOrder alloc]init];
    [order setTheCreateTime:(double)[dict[@"date"] longLongValue]];
    [order setTheCart:[CartEntity fromJson:dict[@"cart"]]];
    [order setTheCustomer:[LSCustomer fromJson:dict[@"customer"]]];
    [order setTheOrderType:dict[@"type"]];
    return order;
}
@end
