//
//  LSOrder.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-8-4.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "LSOrder.h"
#import "LSOfflineTasks.h"

static LSOrder * currentOrder=nil;

@implementation LSOrder

+(LSOrder*)getCurrentOrder{
    return currentOrder;
}
+(void)setCurrentOrder:(LSOrder*)order{
    currentOrder=order;
}
+(void)emptyCurrentOrder{
    currentOrder.theCart=nil;
    currentOrder.theCustomer=nil;
}
+(void)resetCurrentOrder{
    currentOrder=nil;
}

+(void)updateCurrentOrderWithCart:(CartEntity*)cart forCustomer:(LSCustomer*)customer{
    if(currentOrder){
        currentOrder.theCart=cart;
        currentOrder.theCustomer=customer;
        currentOrder.theOrderType=@"SALE";
        for (ProductEntity * pe in cart.cart_array) {
            if([pe product_id]<0){
                currentOrder.theOrderType=@"RMA";
                break;
            }
        }
    }else{
        currentOrder=[[LSOrder alloc]initWithCart:cart forCustomer:customer];
    }
}

-(id)initWithCart:(CartEntity*)cart forCustomer:(LSCustomer*)customer{
    self=[super init];
    if(self){
        self.theCart=cart;
        self.theCustomer=customer;
        self.theCreateTime=[[NSDate date] timeIntervalSince1970];
        self.theOrderType=@"SALE";
        self.store_province=[DataLoader storeProvince];
        self.store_city=[DataLoader storeCity];
        self.store_address=[DataLoader storeAddress];
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
    return [self createIsAtBack:NO];
}
-(NSString*)createWithReturnMsg:(NSString**)returnMsg{
    return [self createIsAtBack:YES returnMsg:returnMsg];
}
-(NSString*)createIsAtBack:(BOOL)isBack{
    return [self createIsAtBack:isBack returnMsg:nil];
}
-(NSString*)createIsAtBack:(BOOL)isBack returnMsg:(NSString**)returnMsg{
    NSString * OrderID=nil;
    NSString*json=nil;
    json=[self toJson];
    if(json){
        //TO MAGENTO
        if([_theOrderType isEqualToString:@"SALE"]){
            
            /*
             TODO (╯‵□′)╯︵┻━┻
             */
            _LogLine();
            
            APIWorker * worker = [[APIWorker alloc]init];
            NSMutableArray * monoArray=[[NSMutableArray alloc]init];
            for (ProductEntity * pe in _theCart.cart_array) {
                NSDictionary * dict=@{
                                      @"boxCount":[NSNumber numberWithInt: pe.quantity],
                                      @"itemType":pe.product_magento_id
                                      }
                ;//Yes A list of order items(sku's) and quantities to be added to the order.
                [monoArray addObject:dict];
            }
            _LogLine();
            //_Log(@"ORDER CREATE by [%@]%@ ",_theCustomer.theID,_theCustomer.theName)
            NSDictionary * registerDict=@{
                                          @"customerId":_theCustomer.theID,//Yes The customer id returned by the pos_customer/search or pos_customer/register calls.
                                          
                                          @"shippingName":_theCustomer.theName,//Yes Shipping address name
                                          
                                          @"shippingProvince":_store_province,//@"Chongqing",//Yes Shipping address province name. Must match the province list in Magento.
                                          
                                          @"shippingCity":_store_city,//@"Chongqing",//Yes Shipping address city name. Must match the city list in Magento
                                          @"shippingStreet":_store_address,//Yes Street address.
                                          @"deliveryModeID":@"pos",//No(IF NOT CONTAINS, ERROR) The delivery method identifier. Defaults to "pos".
                                          //@"shippingMethod":@"pos",
                                          
                                          @"orderItems":monoArray,//Yes A list of order items(sku's) and quantities to be added to the order.
                                          
                                          };
            _LogLine();
            NSDictionary*newCustomerDict=[worker createOrderWithDictionary:registerDict];
            _Log(@"创建订单，封装收到的结果为 %@",newCustomerDict);
            if(newCustomerDict[@"done"]){
                //net ok
                if(![newCustomerDict[@"data"] isEqual:[NSNull null]]){
                    OrderID=newCustomerDict[@"data"];
                    NSLog(@"MAIN->order created %@",OrderID);
                }else{
                    NSLog(@"MAIN->order(back=%d) created not : %@",isBack,newCustomerDict[@"msg"]);
                    *returnMsg=[NSString stringWithString: newCustomerDict[@"msg"]];
                    if(!isBack){
                        [[[UIAlertView alloc]initWithTitle:@"FAILED" message:newCustomerDict[@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil]show];
                    }
                }
                _LogLine();
            }else{
                //net error
                NSLog(@"MAIN->order net error");
            }
        }else{
            OrderID=@"RMA";
        }
        
        //TO LEQEE
        /*
         NSData * data=[[[[@"token=" stringByAppendingString:[DataLoader accessToken]] stringByAppendingString:@"&json="] stringByAppendingString:json] dataUsingEncoding:NSUTF8StringEncoding];
         NSData* res=HttpUtil::HttpUpload([[ServerConfig getServerConfig] getURL_create_order], data);
         */
        //第一步，创建URL
        NSURL *url = [NSURL URLWithString:
                      //@"http://172.16.0.2/Leqee/tmp/newOrder.php"
                      //@"http://172.16.1.19/test/newOrder.php"
                      //@"https://172.16.0.186:233/babynesios/admin/api/create_order.php"
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
        if([OrderID isEqualToString:@"RMA"]){
            if(res){
                //NSString*result=[[NSString alloc]initWithData:res encoding:NSUTF8StringEncoding];
                NSDictionary * jsonDict=[NSJSONSerialization JSONObjectWithData:res options:(NSJSONReadingMutableLeaves) error:nil];
                if([[jsonDict objectForKey:@"CODE"] isEqualToString:@"200"]){
                    OrderID=[NSString stringWithFormat:@"LSRMA%lld",(long long)self.theCreateTime];
                }
            }else{
                OrderID=nil;
            }
        }
        NSLog(@"Order to Leqee response: %@",OrderID);
        
        
    }
    return OrderID;
}

-(NSString*)toJson{
    _LogLine();
    NSError * error=nil;
    NSDictionary * jsonDict=@{@"cart":[self.theCart toJson],
                              @"customer":[self.theCustomer toJson],
                              @"date": [NSNumber numberWithLongLong:(long long)self.theCreateTime],
                              @"type":self.theOrderType,
                              @"store_province":self.store_province,
                              @"store_city":self.store_city,
                              @"store_address":self.store_address,
                              };
    _LogObj(jsonDict);
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
    
    [order setStore_province:dict[@"store_province"]];
    [order setStore_city:dict[@"store_city"]];
    [order setStore_address:dict[@"store_address"]];
    
    return order;
}
@end
