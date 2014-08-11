//
//  LSOfflineTasks.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-8-4.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "LSOfflineTasks.h"
#import "LSDeviceInfo.h"
#import "LSCustomer.h"

static BOOL isRunning = NO;

@implementation LSOfflineTasks

+(NSString*)getCustomerTaskDirPath{
    NSString * path=NSUtil::DocumentPath(@"OfflineCustomers");
    if(!NSUtil::IsDirectoryExist(path)){
        [(NSUtil::FileManager()) createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}
+(NSString*)getOrderTaskDirPath{
    NSString * path=NSUtil::DocumentPath(@"OfflineOrders");
    if(!NSUtil::IsDirectoryExist(path)){
        [(NSUtil::FileManager()) createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

+(NSMutableDictionary*)getCustomerTaskArray{
    if(NSUtil::IsPathExist([LSOfflineTasks getCustomerTaskDirPath])){
        NSFileManager * fm=[NSFileManager defaultManager];
        NSArray * file_name_array=[fm subpathsAtPath:[LSOfflineTasks getCustomerTaskDirPath]];
        NSMutableDictionary * mDict=[[NSMutableDictionary alloc]init];
        for (NSString * mobileJson in file_name_array) {
            NSString * mobile = [mobileJson stringByDeletingPathExtension];
            [mDict setObject:mobileJson forKey:mobile];
        }
        NSLog(@"LSOfflineTasks getCustomerTaskArray:%@",mDict);
        return mDict;
    }else{
        return nil;
    }
}
+(NSMutableDictionary*)getOrderTaskArray{
    if(NSUtil::IsPathExist([LSOfflineTasks getOrderTaskDirPath])){
        NSFileManager * fm=[NSFileManager defaultManager];
        NSArray * file_name_array=[fm subpathsAtPath:[LSOfflineTasks getOrderTaskDirPath]];
        NSMutableDictionary * mDict=[[NSMutableDictionary alloc]init];
        for (NSString * timeJson in file_name_array) {
            NSString * time = [timeJson stringByDeletingPathExtension];
            [mDict setObject:timeJson forKey:time];
        }
        NSLog(@"LSOfflineTasks getOrderTaskArray:%@",mDict);
        return mDict;
    }else{
        return nil;
    }
}
+(BOOL)saveCustomer:(LSCustomer*) customer{
    NSString * json=[customer toJson];
    NSError * error=nil;
    NSString * filePath=[[[LSOfflineTasks getCustomerTaskDirPath] stringByAppendingPathComponent:customer.theMobile] stringByAppendingPathExtension:@"json"];
    BOOL done=[json writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    return done;
}
+(BOOL)saveOrder:(LSOrder*)order{
    NSString * json=[order toJson];
    NSError * error=nil;
    NSString * filePath=[[[LSOfflineTasks getOrderTaskDirPath] stringByAppendingPathComponent: [NSString stringWithFormat:@"%lld",(long long)order.theCreateTime]] stringByAppendingPathExtension:@"json"];
    BOOL done=[json writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    return done;
}
+(BOOL)doneCustomer:(NSString*)target{
    @try {
        NSString * filePath=[[[LSOfflineTasks getCustomerTaskDirPath] stringByAppendingPathComponent:target] stringByAppendingPathExtension:@"json"];
        return NSUtil::RemovePath(filePath);
    }
    @catch (NSException *exception) {
        NSLog(@"doneCustomer:%@ failed:%@",target,exception);
        return NO;
    }
    @finally {
        //
    }
}
+(BOOL)doneOrder:(NSString*)target{
    @try {
        NSString * filePath=[[[LSOfflineTasks getOrderTaskDirPath] stringByAppendingPathComponent: target] stringByAppendingPathExtension:@"json"];
        return  NSUtil::RemovePath(filePath);
    }
    @catch (NSException *exception) {
        NSLog(@"doneOrder:%@ failed:%@",target,exception);
        return NO;
    }
    @finally {
        //
    }
    
}
+(void)attemptProcess{
    if(isRunning)return;
    else isRunning=YES;
    @try {
        if([LSDeviceInfo isNetworkOn]){
            //CUSTOMER
            for (NSString * customer_mobile in [LSOfflineTasks getCustomerTaskArray]) {
                NSString* customer_fn=[[NSUtil::DocumentPath(@"OfflineCustomers") stringByAppendingPathComponent:customer_mobile] stringByAppendingPathExtension:@"json"];
                NSString * customer_json=[NSString stringWithContentsOfFile:customer_fn encoding:NSUTF8StringEncoding error:nil];
                NSLog(@"挖出一个离线顾客,%@",customer_fn);
                LSCustomer * customer=[LSCustomer fromJson:customer_json];
                @try {
                    NSString * cid=[customer createCustomer:YES];
                    NSLog(@"后台尝试创建用户[%@]结果：%@",customer.theMobile,cid);
                    //尝试注册用户
                    if(cid){
                        NSLog(@"成功了 可以删掉顾客文件");
                        [LSOfflineTasks doneCustomer:customer.theMobile];
                    }else{
                        NSLog(@"失败了 保留顾客文件");
                    }
                }
                @catch (NSException *exception) {
                    NSLog(@"后台顾客创建出现异常:%@",exception);
                }
                @finally {
                    //
                }
                
            }
            //ORDER
            for (NSString* order_time in [LSOfflineTasks getOrderTaskArray]) {
                NSString* order_fn=[[NSUtil::DocumentPath(@"OfflineOrders") stringByAppendingPathComponent:order_time] stringByAppendingPathExtension:@"json"];
                NSString * order_json=[NSString stringWithContentsOfFile:order_fn encoding:NSUTF8StringEncoding error:nil];
                NSLog(@"挖出一个离线订单,%@",order_fn);
                LSOrder * order=[LSOrder fromJson:order_json];
                @try {
                    LSCustomer*customer=[LSCustomer searchCustomer:order.theCustomer.theMobile];
                    NSLog(@"搜查用户是[%@]否已经存在",order.theCustomer.theMobile);
                    if(!customer){
                        NSLog(@"搜查用户是否已经存在：返回为空，说明现在网络不行，还是睡觉去");
                        break;
                    }else{
                        if([customer.theID isEqualToString:@""]){
                            NSLog(@"搜查用户是否已经存在：返回的用户不是被注册的用户");
                            customer=order.theCustomer;
                            NSString * cid=[customer createCustomer:YES];
                            NSLog(@"后台尝试创建用户[%@]结果：%@",customer.theMobile,cid);
                            //尝试注册用户
                            if(cid){
                                NSLog(@"注册成功了的样子[%@] 更新订单离线文件",cid);
                                order.theCustomer=customer;
                                [LSOfflineTasks saveOrder:order];
                                NSLog(@"可以删掉顾客文件");
                                [LSOfflineTasks doneCustomer:customer.theMobile];
                                NSLog(@"递交订单");
                                NSString*res=[order createIsAtBack:YES];
                                if(res){
                                    NSLog(@"竟然order OK");
                                    [LSOfflineTasks doneOrder:[NSString stringWithFormat:@"%lld",(long long)order.theCreateTime]];
                                    NSLog(@"后台递交订单给Magento[%@]成功：%@",[NSString stringWithFormat:@"%lld",(long long)order.theCreateTime],res);
                                }else{
                                    NSLog(@"后台递交订单给Magento[%@]失败",[NSString stringWithFormat:@"%lld",(long long)order.theCreateTime]);
                                }
                            }else{
                                NSLog(@"悲伤的发现注册用户失败了 不要伤心，我们先把这个放一边，干下一件事");
                                continue;
                            }
                        }else{
                            NSLog(@"用户找到 更新订单离线文件");
                            order.theCustomer=customer;
                            [LSOfflineTasks saveOrder:order];
                            NSLog(@"可以删掉顾客文件");
                            [LSOfflineTasks doneCustomer:customer.theMobile];
                            NSLog(@"递交订单");
                            NSString*res=[order createIsAtBack:YES];
                            if(res){
                                NSLog(@"竟然order OK");
                                [LSOfflineTasks doneOrder:[NSString stringWithFormat:@"%lld",(long long)order.theCreateTime]];
                                NSLog(@"后台递交订单给Magento[%@]成功：%@",[NSString stringWithFormat:@"%lld",(long long)order.theCreateTime],res);
                            }else{
                                NSLog(@"后台递交订单给Magento[%@]失败",[NSString stringWithFormat:@"%lld",(long long)order.theCreateTime]);
                            }
                        }
                    }
                    
                }
                @catch (NSException *exception) {
                    NSLog(@"后台订单创建出现异常:%@",exception);
                }
                @finally {
                    //
                }
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"LSOfflineTasks attemptProcess exception:%@",exception);
    }
    @finally {
        //
    }
    
    isRunning=NO;
}
@end
