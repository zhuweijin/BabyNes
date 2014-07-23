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
        UIUtil::ShowAlert([NSString stringWithFormat: NSLocalizedString(@"Birthday is not completed yet for No.%d baby", @"第%d个宝宝的生日未填写完整"),baby_index]);
        return NO;
    }
    if([self.the_sex isEqualToString:@""]){
        UIUtil::ShowAlert([NSString stringWithFormat: NSLocalizedString(@"Sex of Baby is not completed yet for No.%d baby", @"第%d个宝宝的性别未填写"),baby_index]);
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

@end
