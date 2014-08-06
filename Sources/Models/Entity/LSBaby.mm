//
//  LSBaby.m
//  BabyNesPOS_Akatsuki
//
//  Created by 倪 李俊 on 14-6-23.
//  Copyright (c) 2014年 Leqee. All rights reserved.
//

#import "LSBaby.h"

@implementation LSBaby

-(id)init{
    self=[super init];
    
    self.the_birth_day=0;
    self.the_birth_month=0;
    self.the_birth_year=0;
    
    self.the_birth_date=nil;
    
    self.the_sex=@"";
    
    self.the_nick=@"";
    
    return self;
}

-(BOOL)validateBabyInformation:(int)baby_index{
    _Log(@"validateBabyInformation %d-%d-%d %@/%@",self.the_birth_year,self.the_birth_month,self.the_birth_day,self.the_sex,self.the_nick);
    if((self.the_birth_day<1 || self.the_birth_day>31)
       || (self.the_birth_month<1 || self.the_birth_month>12)
       || (self.the_birth_year<1)){
        if(baby_index>=0){
        UIUtil::ShowAlert([NSString stringWithFormat: NSLocalizedString(@"Birthday is not completed yet for No.%d baby", @"第%d个宝宝的生日未填写完整"),baby_index]);
        }
        return NO;
    }
    if([self.the_sex isEqualToString:@""]){
        if(baby_index>=0){
        UIUtil::ShowAlert([NSString stringWithFormat: NSLocalizedString(@"Sex of Baby is not completed yet for No.%d baby", @"第%d个宝宝的性别未填写"),baby_index]);
        }
        return NO;
    }
    /*
    if([self.the_nick isEqualToString:@""]){
        UIUtil::ShowAlert([NSString stringWithFormat: NSLocalizedString(@"Nickname of Baby is not completed yet for No.%d baby", @"第%d个宝宝的昵称未填写"),baby_index]);
        return NO;
    }
     */
    return YES;
}

- (void) encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:_the_nick forKey:@"nick"];
    [coder encodeObject:_the_sex forKey:@"sex"];
    [coder encodeObject:_the_birth_date forKey:@"birthday"];
    [coder encodeInteger:_the_birth_year forKey:@"year"];
    [coder encodeInteger:_the_birth_month forKey:@"month"];
    [coder encodeInteger:_the_birth_day forKey:@"day"];
}

- (id) initWithCoder: (NSCoder *) coder
{
    _the_nick=[[coder decodeObjectForKey:@"nick"]copy];
    _the_sex=[[coder decodeObjectForKey:@"sex"]copy];
    _the_birth_date=[[coder decodeObjectForKey:@"birthday"] copy];
    _the_birth_year=[coder decodeIntegerForKey:@"year"];
    _the_birth_month=[coder decodeIntegerForKey:@"month"];
    _the_birth_day=[coder decodeIntegerForKey:@"day"];
    return self;
}

-(NSString*)toJson{
    if([self validateBabyInformation:-1]){
        NSError * error=nil;
        NSDictionary * jsonDict=@{@"year": [NSNumber numberWithInt: self.the_birth_year],
                             @"month": [NSNumber numberWithInt: self.the_birth_month],
                             @"day": [NSNumber numberWithInt: self.the_birth_day],
                             @"sex": self.the_sex,
                             @"nick": self.the_nick,
                             @"date": [NSNumber numberWithDouble: [self.the_birth_date timeIntervalSince1970]]};
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        
        if ([jsonData length] > 0 && error == nil){
            return [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        }else{
            return nil;
        }
        
    }else{
        return nil;
    }
}
+(LSBaby*)fromJson:(NSString*)json{
    NSError * error=nil;
    NSDictionary* dict=[NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    
    LSBaby * baby=[[LSBaby alloc]init];
    
    baby.the_birth_year=[[dict objectForKey:@"year"] intValue];
    baby.the_birth_month=[[dict objectForKey:@"month"] intValue];
    baby.the_birth_day=[[dict objectForKey:@"day"] intValue];
    baby.the_birth_date=[[NSDate alloc]initWithTimeIntervalSince1970: [[dict objectForKey:@"date"] doubleValue]];
    baby.the_sex=[dict objectForKey:@"sex"];
    baby.the_nick=[dict objectForKey:@"nick"];
    
    return baby;
}

@end
