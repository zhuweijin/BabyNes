//
//  LSOfflineTasks.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-8-4.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "LSOfflineTasks.h"


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
            [mDict setObject:time forKey:timeJson];
        }
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
    NSString * filePath=[[[LSOfflineTasks getCustomerTaskDirPath] stringByAppendingPathComponent:target] stringByAppendingPathExtension:@"json"];
    return NSUtil::RemovePath(filePath);
}
+(BOOL)doneOrder:(NSString*)target{
    NSString * filePath=[[[LSOfflineTasks getOrderTaskDirPath] stringByAppendingPathComponent: target] stringByAppendingPathExtension:@"json"];
   return  NSUtil::RemovePath(filePath);
}
+(void)attemptProcess{
    //TODO
}
@end
