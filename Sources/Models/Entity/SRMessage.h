//
//  SRMessage.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-17.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SRMessage : NSObject<NSCoding>

@property int srid;
@property BOOL read;
@property BOOL reported;
@property long time;
@property NSString * title;
@property NSString * url;

-(id)initWithItemDictionary:(NSDictionary*)dict;

-(NSString*)logAbstract;

@end
