//
//  LSBaby.h
//  BabyNesPOS_Akatsuki
//
//  Created by 倪 李俊 on 14-6-23.
//  Copyright (c) 2014年 Leqee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSBaby : NSObject<NSCoding>
@property int the_birth_year;
@property int the_birth_month;
@property int the_birth_day;
@property NSString * the_sex;
@property NSString * the_nick;

@property NSDate * the_birth_date;

-(BOOL)validateBabyInformation:(int)baby_index;

-(NSString*)toJson;
+(LSBaby*)fromJson:(NSString*)json;
@end
