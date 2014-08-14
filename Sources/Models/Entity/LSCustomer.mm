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
    self.theID=nil;
    
    self.theSign=@"";
    
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
    return [self validateCustomerInformation:NO];
}
-(BOOL)validateCustomerInformation:(BOOL)isSlient{
    if([self.theTitle isEqualToString:@""]){
        _LogLine();
        if(!isSlient)UIUtil::ShowAlert(NSLocalizedString(@"Title is empty", @"称呼未填写"));
        return NO;
    }
    if([self.theName isEqualToString:@""]){
        _LogLine();
        if(!isSlient)UIUtil::ShowAlert(NSLocalizedString(@"Name is empty", @"姓名未填写"));
        return NO;
    }
    if([self.theProvince isEqualToString:@""]){
        _LogLine();
        if(!isSlient)UIUtil::ShowAlert(NSLocalizedString(@"Province is empty", @"省份未填写"));
        return NO;
    }
    if([self.theCity isEqualToString:@""]){
        _LogLine();
        if(!isSlient)UIUtil::ShowAlert(NSLocalizedString(@"City is empty", @"城市未填写"));
        return NO;
    }
    if([self.theAddress isEqualToString:@""]){
        _LogLine();
        if(!isSlient)UIUtil::ShowAlert(NSLocalizedString(@"Address is empty", @"地址未填写"));
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
        _LogLine();
        if(!isSlient)UIUtil::ShowAlert(NSLocalizedString(@"Mobile is empty", @"手机号未填写"));
        return NO;
    }else{
        /*
         NSString *string = self.theMobile;
         NSError  *error  = nil;
         
         NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:                                      NSLocalizedString(@"^[569][\\d]{7}$", @"^1[\\d]{10}$") options:0 error:&error];
         
         NSRange range = [regex rangeOfFirstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
         if(range.location==NSNotFound){
         //NSString *result = [string substringWithRange:range];
         UIUtil::ShowAlert(NSLocalizedString(@"Mobile is not correct", @"手机号未填写正确"));
         return NO;
         }
         */
        _LogLine();
    }
    if(![self.theEmail isEqualToString:@""]){
        NSString *string = self.theEmail;
        NSError  *error  = nil;
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^\\S+@\\S+\\.\\S+$" options:0 error:&error];
        
        NSRange range = [regex rangeOfFirstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
        if(range.location==NSNotFound){
            //NSString *result = [string substringWithRange:range];
            if(!isSlient)UIUtil::ShowAlert(NSLocalizedString(@"Email is not correct", @"电子邮件地址未填写正确"));
            _LogLine();
            return NO;
        }
    }
    
    for(int i=0;i<[self.theBabies count];i++){
        LSBaby * baby=[self.theBabies objectAtIndex:i];
        if(![baby validateBabyInformation:(i+1)]){
            _LogLine();
            return NO;
        }
    }
    _LogLine();
    return YES;
}

-(NSString*)getOneBabyBirthday{
    if([_theBabies count]>0){
        LSBaby * baby=[_theBabies objectAtIndex:0];
        NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd"];
        NSString *ymd = [dateFormatter stringFromDate:baby.the_birth_date];
        return ymd;
    }else{
        return NSLocalizedString(@"None registered", @"没有登记");
    }
}
-(NSString*)createCustomer{
    return [self createCustomer:NO];
}
-(NSString*)createCustomer:(BOOL)isSlient{
    _Log(@"createCustomer called");
    if([self validateCustomerInformation:isSlient]){
        _LogLine();
        /*
         NSString * msg=[NSString stringWithFormat:NSLocalizedString(@"Please ensure that the mobile (%@) of the customer is correct, which would affect your points. Select ‘Confirm’ to continue create new customer, or cancel it to recheck.", @"请确保登记的顾客手机号码(%@)正确，以免影响员工绩效。选择‘确认’以继续创建顾客账号，选择取消可以返回进行检查。"),_theMobile];
         
         DialogUIAlertView * dav=[[DialogUIAlertView alloc]initWithTitle:NSLocalizedString(@"Reminder", @"提醒") message:msg cancelButtonTitle:NSLocalizedString(@"Cancel", @"取消") otherButtonTitles:NSLocalizedString(@"Confirm", @"确认")];
         [dav setAlert_view_type:NCDialogAlertViewTypeBigger];
         int r=[dav showDialog];
         
         if(r!=0){
         //DO STH
         self.theID=@"MOCKED RETURN CUSTOMER ID";
         currentCustomer=self;
         return self.theID;
         }
         */
        
        NSString*salutation=@"Unknown";
        if([_theTitle isEqualToString:NSLocalizedString(@"Mr", @"先生")]){
            salutation=@"Mr";
        }else if([_theTitle isEqualToString:NSLocalizedString(@"Ms", @"女士")]){
            salutation=@"Ms";
        }
        
        NSMutableDictionary * registerDict=[@{
                                              @"salutation": salutation,//Yes Customer name prefix/salutation
                                              
                                              @"firstname": _theName,//Yes Customer firstname, for CN, put customer full name here.
                                              //@"email": _theEmail,//DELETED No A temporary customer email will be generated by Magento. Ex: QF4yujeGgwQcTEjF-tmp-mag@babynes.com
                                              @"mobilePrefix": _theRegionCode,//Yes +86
                                              @"phonePrefix": _theRegionCode,//Yes +86
                                              @"mobile": _theMobile,//Yes Customer phone number
                                              //@"phone": @"11111111",//No Home phone number
                                              //@"phonePrefix": @"86",//No +86
                                              //@"phoneAreaCode": @"571",//No Customer home phone number area code
                                              //@"password": @"PW",//DELETED No Customer password. Magento to generate and set temporary password (to send by SMS).
                                              //@"isNestleNewsletterDeclined": @"Mr",//No Newsletter subscription status(1/0). Will be 0 by default (opt-in by default).
                                              //@"city": @"Suihua",//No Used to create default billing address
                                              //@"province": @"Heilongjiang",//No Used to create default billing address
                                              //@"street": @"Address",//No Used to create default billing address. If not set, set to "unknown" by default (if required for creating                                      the address in Magento)
                                              } mutableCopy];
        if(![_theEmail isEqualToString:@""]){
            [registerDict setObject:_theEmail forKey:@"email"];
        }
        if(![_theAreaCode isEqualToString:@""]){
            [registerDict setObject:_theAreaCode forKey:@"phoneAreaCode"];
            //[registerDict setObject:_theRegionCode forKey:@"phonePrefix"];
        }
        if(![_theProvince isEqualToString:@""]){
            [registerDict setObject:_theProvince forKey:@"province"];
        }
        if(![_theCity isEqualToString:@""]){
            [registerDict setObject:_theCity forKey:@"city"];
        }
        if(![_theAddress isEqualToString:@""]){
            [registerDict setObject:_theAddress forKey:@"street"];
        }
        
        NSLog(@"New Customer dict = %@",registerDict);
        
        APIWorker * worker=[[APIWorker alloc]init];
        NSDictionary*newCustomerDict=[worker createUserWithDictionary:[registerDict copy]];
        
        if(newCustomerDict[@"done"]){
            //net ok
            if(![[newCustomerDict objectForKey: @"data"] isEqual:[NSNull null]]){
                NSLog(@"MAIN->register customer %@",newCustomerDict[@"data"]);
                _theID = newCustomerDict[@"data"];
                NSLog(@"REGISTERED CUSTOMER ID=%@",_theID);
            }else{
                NSLog(@"MAIN->register customer not");
                if(!isSlient)[[[UIAlertView alloc]initWithTitle:@"FAILED" message:newCustomerDict[@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil]show];
            }
        }else{
            //net error
            NSLog(@"MAIN->register net error");
        }
        if(_theID){
            //BABIES
            for (LSBaby*baby in _theBabies) {
                NSString * date_str=[NSString stringWithFormat:@"%d-%d%d-%d%d",baby.the_birth_year,baby.the_birth_month/10,baby.the_birth_month%10,baby.the_birth_day/10,baby.the_birth_day%10];
                NSString*gender=@"neutral";//NSLocalizedString(@"Boy", @"男"),NSLocalizedString(@"Girl", @"女")
                if([baby.the_sex isEqualToString:NSLocalizedString(@"Boy", @"男")]){
                    gender=@"male";
                }else if([baby.the_sex isEqualToString:NSLocalizedString(@"Girl", @"女")]){
                    gender=@"female";
                }
                NSMutableDictionary * registerDict=[@{
                                                      @"customerId":_theID,//Yes The customer id returned by the pos_customer/search or pos_customer/register calls.
                                                      @"birthday":date_str,//No Baby date of birth in unix time. Ex 2014-01-30
                                                      
                                                      //@"capsuleSize":@"Standard",//No The type of capsule recommended for the baby. 'Standard'/'Large'(Default 'Standard')
                                                      @"gender":gender,//No Baby gender. 'male'/'female'(Default 'neutral')
                                                      
                                                      //@"firstname":@"BABYNAME",//No Baby name. (Default 'Your Baby')
                                                      
                                                      } mutableCopy];
                if(![baby.the_nick isEqualToString:@""]){
                    [registerDict setObject:baby.the_nick forKey:@"firstname"];
                }
                
                NSDictionary*newBabyDict=[worker createBabyWithDictionary:registerDict];
                
                if(newBabyDict[@"done"]){
                    //net ok
                    if(![[newBabyDict objectForKey: @"data"] isEqual:[NSNull null]]){
                        NSLog(@"MAIN->baby created %@",newBabyDict[@"data"]);
                        [baby setThe_ID:[newBabyDict[@"data"] objectForKey:@"babyId"]];
                    }else{
                        NSLog(@"MAIN->baby created not");
                    }
                }else{
                    //net error
                    NSLog(@"MAIN->baby net error");
                }
                
            }
            //SIGN
#warning TODO the signature
            NSString* AT=DataLoader.accessToken;
            if(AT!=nil){
                NSDictionary* dict=[[NSDictionary alloc]initWithObjectsAndKeys:
                                    _theID,@"customer_id",
                                    _theSign,@"signature",
                                    _theMobile,@"mobile",
                                    AT,@"token",
                                    nil
                                    ];
                NSString* param=NSUtil::URLQuery(dict);
                
                NSString * url=[NSString stringWithFormat:@"%@",[[ServerConfig getServerConfig]getURL_customer_signature]];
                NSData * body=[param dataUsingEncoding:NSUTF8StringEncoding];
                NSMutableURLRequest * request=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url] cachePolicy:(NSURLRequestReloadIgnoringLocalAndRemoteCacheData) timeoutInterval:30];
                //[request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request addValue:[NSString stringWithFormat:@"%luld",(unsigned long)[body length]] forHTTPHeaderField:@"Content-Length"];
                [request setHTTPBody:body];
                [request setHTTPMethod:@"POST"];
                
                NSURLResponse * response=nil;
                NSError * error=nil;
                
                NSData*data=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                {
                    NSString * getStr=(data?[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]:nil);
                    NSLog(@"log customer signature: [%@] ...(response=%@,error=%@) get %@ ",url,response,error,getStr);
                }
                if(data){
                    NSDictionary * dict=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:&error];
                    //dict[@"CODE"];
                    NSLog(@"SIGN return:%@",dict);
                }
            }else{
                NSLog(@"Sign upload- -not executed duo to no access token");
            }
        }
    }
    return _theID;
}

+(LSCustomer*)searchCustomer:(NSString*)number{
    APIWorker * worker=[[APIWorker alloc]init];
    NSDictionary*customerDict=[worker searchCustomerWithRegionCode:NSLocalizedString(@"852", @"86") withNumber:number];
    if(customerDict[@"done"]){
        //net ok
        if(![[customerDict objectForKey: @"data"] isEqual:[NSNull null]]){
            NSDictionary* dict= customerDict[@"data"];
            NSLog(@"MAIN->customer found customer %@",dict);
            LSCustomer * customer=[[LSCustomer alloc]init];
            if(![dict[@"customerId"] isEqual:[NSNull null]])[customer setTheID:dict[@"customerId"]];
            if(![dict[@"firstname"] isEqual:[NSNull null]])[customer setTheName:dict[@"firstname"]];
            if(![dict[@"mobilePrefix"] isEqual:[NSNull null]])[customer setTheRegionCode:dict[@"mobilePrefix"]];
            if(![dict[@"mobile"] isEqual:[NSNull null]])[customer setTheMobile:dict[@"mobile"]];
            
            _LogLine();
            
            if(![dict[@"phoneAreaCode"] isEqual:[NSNull null]])[customer setTheAreaCode:dict[@"phoneAreaCode"]];
            
            _LogLine();
            
            if(![dict[@"phone"] isEqual:[NSNull null]])[customer setThePhone:dict[@"phone"]];
            if(![dict[@"salutation"] isEqual:[NSNull null]])[customer setTheTitle:dict[@"salutation"]];
            if(![dict[@"city"] isEqual:[NSNull null]])[customer setTheCity:dict[@"city"]];
            if(![dict[@"address"] isEqual:[NSNull null]])[customer setTheAddress:dict[@"address"]];
            if(![dict[@"email"] isEqual:[NSNull null]])[customer setTheEmail:dict[@"email"]];
            [customer setTheProvince:@"None"];
            _LogLine();
            
            if([[customer theName] hasPrefix:@"Mr "] || [[customer theName] hasPrefix:@"Ms "]){
                [customer setTheName:[[customer theName] substringFromIndex:3]];
            }else if([[customer theName] hasPrefix:@"Mrs "]){
                [customer setTheName:[[customer theName] substringFromIndex:4]];
            }
            
            if([[customer theName] hasPrefix:@"{{{Ms}}{{Ms}}{{Ms}}{{BabyNes_Customer}}}"]
               || [[customer theName] hasPrefix:@"{{{Mr}}{{Mr}}{{Mr}}{{BabyNes_Customer}}}"]){
                [customer setTheName:[[customer theName] substringFromIndex:[@"{{{Ms}}{{Ms}}{{Ms}}{{BabyNes_Customer}}}" length]]];
            }else if([[customer theName] hasPrefix:@"{{{Mrs}}{{Mrs}}{{Mrs}}{{BabyNes_Customer}}}"]){
                [customer setTheName:[[customer theName] substringFromIndex:[@"{{{Mrs}}{{Mrs}}{{Mrs}}{{BabyNes_Customer}}}" length]]];
            }
            
            [customer setTheName:[[customer theName] stringByTrimmingCharactersInSet:([NSCharacterSet whitespaceAndNewlineCharacterSet])]];
            
            if(dict[@"babies"]){
                _LogLine();
                for (NSDictionary * babyDict in dict[@"babies"]) {
                    _LogLine();
                    LSBaby * baby=[[LSBaby alloc]init];
                    [baby setThe_nick:babyDict[@"babyName"]];
                    NSDate* date=[LSCustomer dateFromString:babyDict[@"babyDob"]];
                    [baby setThe_birth_date:date];
                    
                    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                    
                    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
                    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
                    
                    NSDateComponents *comps  = [calendar components:unitFlags fromDate:date];
                    
                    int year = [comps year];
                    int month = [comps month];
                    int day = [comps day];
                    //int hour = [comps hour];
                    //int min = [comps minute];
                    //int sec = [comps second];
                    
                    [baby setThe_birth_year:year];
                    [baby setThe_birth_month:month];
                    [baby setThe_birth_day:day];
                    
                    [baby setThe_sex:@"neutral"];
                    
                    [customer addOneBaby:baby];
                }
            }
            _LogLine();
            currentCustomer=customer;
            return customer;
        }else{
            NSLog(@"MAIN->customer found customer not");
            LSCustomer * customer=[[LSCustomer alloc]init];
            return customer;
        }
    }else{
        //net error
        NSLog(@"MAIN->customer found net error");
        return nil;
    }
}

-(NSString*)toJson{
    _LogLine();
    if([self validateCustomerInformation:YES]){
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
                                  @"babies":babyarray,
                                  @"sign":self.theSign
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
        _LogLine();
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
    customer.theSign=dict[@"sign"];
    
    NSArray * babies=dict[@"babies"];
    for (NSString * babyJson in babies) {
        [customer addOneBaby:[LSBaby fromJson:babyJson]];
    }
    
    return customer;
}

+ (NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];// HH:mm:ss
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
    
}

@end
