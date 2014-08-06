//
//  LSCustomer.m
//  BabyNesPOS_Akatsuki
//
//  Created by 倪 李俊 on 14-6-24.
//  Copyright (c) 2014年 Leqee. All rights reserved.
//

#import "LSCustomer.h"
#import "DialogUIAlertView.h"

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
+(void)setCurrentCustomer:(LSCustomer*)cutomer{
    currentCustomer=cutomer;
}
+(LSCustomer*) newCustomer{
    currentCustomer=[[LSCustomer alloc]init];
    [currentCustomer reset];
    return currentCustomer;
}

+(void)reset{
    currentCustomer=[[LSCustomer alloc]init];
}

-(id)init{
    self=[super init];
    if(self){
        [self reset];
    }
    return self;
}

-(void)reset{
    self.theTitle=@"";
    self.theName=@"";
    self.theProvince=@"";
    self.theCity=@"";
    self.theAddress=@"";
    self.theRegionCode=NSLocalizedString(@"852", @"86");
    self.theAreaCode=@"";
    self.thePhone=@"";
    self.theMobile=@"";
    self.theEmail=@"";
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
    /*
    if(![self.theAreaCode isEqualToString:@""]){
        NSString *string = self.theAreaCode;
        NSError  *error  = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:                                      NSLocalizedString(@"^852$", @"^86$") options:0 error:&error];
        
        NSRange range = [regex rangeOfFirstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
        if(range.location==NSNotFound){
            //NSString *result = [string substringWithRange:range];
            UIUtil::ShowAlert(NSLocalizedString(@"Area Code is not correct", @"地区号未填写正确"));
            return NO;
        }
    }
     */
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
        /*
        NSString * msg=[NSString stringWithFormat:NSLocalizedString(@"Please ensure that the mobile (%@) of the customer is correct, which would affect your points. Select ‘Confirm’ to continue create new customer, or cancel it to recheck.", @"请确保登记的顾客手机号码(%@)正确，以免影响员工绩效。选择‘确认’以继续创建顾客账号，选择取消可以返回进行检查。"),_theMobile];
        
        DialogUIAlertView * dav=[[DialogUIAlertView alloc]initWithTitle:NSLocalizedString(@"Reminder", @"提醒") message:msg cancelButtonTitle:NSLocalizedString(@"Cancel", @"取消") otherButtonTitles:NSLocalizedString(@"Confirm", @"确认")];
        [dav setAlert_view_type:NCDialogAlertViewTypeBigger];
        int r=[dav showDialog];
        
        if(r!=0){
            */
            //DO STH
            self.theID=@"MOCKED RETURN CUSTOMER ID";
            currentCustomer=self;
            return self.theID;
        /*
         }
         */
    }
    return nil;
}

-(NSString*)toJson{
    if([self validateCustomerInformation]){
        NSError * error=nil;
        NSMutableArray * babyarray=[[NSMutableArray alloc]init];
        for (LSBaby * baby in self.theBabies) {
            [babyarray addObject:[baby toJson]];
        }
        NSDictionary * jsonDict=@{@"title":self.theTitle,
                                  @"name":self.theName,
                                  @"province":self.theProvince,
                                  @"city":self.theCity,
                                  @"address":self.theAddress,
                                  @"regioncode":self.theRegionCode,
                                  @"areacode":self.theAreaCode,
                                  @"phone":self.thePhone,
                                  @"mobile":self.theMobile,
                                  @"email":self.theEmail,
                                  @"babies":babyarray
                                  };
        
        
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

+(LSCustomer*)fromJson:(NSString*)json{
    NSError * error=nil;
    NSDictionary* dict=[NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    
    LSCustomer * customer=[[LSCustomer alloc]init];
    
    customer.theTitle=dict[@"title"];
    customer.theName=dict[@"name"];
    customer.theProvince=dict[@"province"];
    customer.theCity=dict[@"city"];
    customer.theAddress=dict[@"address"];
    customer.theRegionCode=dict[@"regioncode"];
    customer.theAreaCode=dict[@"areacode"];
    customer.thePhone=dict[@"phone"];
    customer.theMobile=dict[@"mobile"];
    customer.theEmail=dict[@"email"];
    NSArray * babies=dict[@"babies"];
    for (NSString * babyJson in babies) {
        [customer addOneBaby:[LSBaby fromJson:babyJson]];
    }
    
    return customer;
}

@end
