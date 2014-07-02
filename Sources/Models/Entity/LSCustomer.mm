//
//  LSCustomer.m
//  BabyNesPOS_Akatsuki
//
//  Created by 倪 李俊 on 14-6-24.
//  Copyright (c) 2014年 Leqee. All rights reserved.
//

#import "LSCustomer.h"

static LSCustomer * currentCustomer=nil;

@implementation LSCustomer


-(void)addOneBaby:(LSBaby *)baby{
    if(self.theBabies==nil){
        self.theBabies=[[NSMutableArray alloc]init];
    }
    [self.theBabies addObject:baby];
}

+(LSCustomer*) getCurrentCustomer{
    if(currentCustomer==nil){
        currentCustomer=[[LSCustomer alloc]init];
        [currentCustomer reset];
    }
    return currentCustomer;
}

+(LSCustomer*) newCustomer{
    currentCustomer=[[LSCustomer alloc]init];
    [currentCustomer reset];
    return currentCustomer;
}

+(void)reset{
    currentCustomer.theTitle=nil;
    currentCustomer.theName=nil;
    currentCustomer.theProvince=nil;
    currentCustomer.theCity=nil;
    currentCustomer.theMobile=nil;
    currentCustomer.theBabies=[[NSMutableArray alloc]init];
}

-(void)reset{
    self.theTitle=nil;
    self.theName=nil;
    self.theProvince=nil;
    self.theCity=nil;
    self.theMobile=nil;
    self.theBabies=[[NSMutableArray alloc]init];
}

-(BOOL)validateCustomerInformation{
    if([self.theTitle isEqualToString:@""]){
        UIUtil::ShowAlert(NSLocalizedString(@"Title is empty", @"称呼未填写"));
        return NO;
    }
    if([self.theName isEqualToString:@""]){
        UIUtil::ShowAlert(NSLocalizedString(@"Name is empty", @"姓名未填写"));
        return NO;
    }
    if([self.theProvince isEqualToString:@""]){
        UIUtil::ShowAlert(NSLocalizedString(@"Province is empty", @"省份未填写"));
        return NO;
    }
    if([self.theCity isEqualToString:@""]){
        UIUtil::ShowAlert(NSLocalizedString(@"City is empty", @"城市未填写"));
        return NO;
    }
    if([self.theAddress isEqualToString:@""]){
        UIUtil::ShowAlert(NSLocalizedString(@"Address is empty", @"地址未填写"));
        return NO;
    }
    if([self.theMobile isEqualToString:@""]){
        UIUtil::ShowAlert(NSLocalizedString(@"Mobile is empty", @"手机号未填写"));
        return NO;
    }else{
        NSString *string = self.theMobile;
        NSError  *error  = nil;
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:                                      NSLocalizedString(@"^[569][\\d]{7}$", @"^1[\\d]{10}$") options:0 error:&error];
        
        NSRange range = [regex rangeOfFirstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
        if(range.location==NSNotFound){
            //NSString *result = [string substringWithRange:range];
            UIUtil::ShowAlert(NSLocalizedString(@"Mobile is not correct", @"手机号未填写正确"));
            return NO;
        }

    }
    if(![self.theEmail isEqualToString:@""]){
        NSString *string = self.theEmail;
        NSError  *error  = nil;
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^\\S+@\\S+\\.\\S+$" options:0 error:&error];
        
        NSRange range = [regex rangeOfFirstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
        if(range.location==NSNotFound){
            //NSString *result = [string substringWithRange:range];
            UIUtil::ShowAlert(NSLocalizedString(@"Email is not correct", @"电子邮件地址未填写正确"));
            return NO;
        }
    }
    
    for(int i=0;i<[self.theBabies count];i++){
        LSBaby * baby=[self.theBabies objectAtIndex:i];
        if(![baby validateBabyInformation:(i+1)]){
            return NO;
        }
    }
    
    return YES;
}

-(NSString*)createCustomer{
    _Log(@"createCustomer called");
    if([self validateCustomerInformation]){
        //DO STH
        return @"MOCKED RETURN CUSTOMER ID";
    }
    return nil;
}

@end
