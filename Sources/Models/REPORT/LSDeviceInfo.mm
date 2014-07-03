//
//  LSDeviceInfo.m
//  BNLP_Ichi
//
//  Created by 倪 李俊 on 14-6-9.
//  Copyright (c) 2014年 Leqee. All rights reserved.
//

#import "LSDeviceInfo.h"
//AppStore 无法通过的私有API，用于解决获取iPad的卡号 BUT DISAPPEARED since iOS7
//extern NSString *CTSettingCopyMyPhoneNumber();

@implementation LSDeviceInfo

+(NSString*) check_all{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *result_machine = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSString *result_sysname = [NSString stringWithCString:systemInfo.sysname encoding:NSUTF8StringEncoding];
    NSString *result_nodename = [NSString stringWithCString:systemInfo.nodename encoding:NSUTF8StringEncoding];
    NSString *result_release = [NSString stringWithCString:systemInfo.release encoding:NSUTF8StringEncoding];
    NSString *result_version = [NSString stringWithCString:systemInfo.version encoding:NSUTF8StringEncoding];
    
    NSString*appBundleID=[[iVersion sharedInstance] applicationBundleID];
    NSString*appVerion=[[iVersion sharedInstance] applicationVersion];
    NSString*appVerionDetails=[[iVersion sharedInstance] versionDetails];
    NSString*appCountry=[[iVersion sharedInstance] appStoreCountry];
    
    NSString*my_number=[LSDeviceInfo myNumber];
    NSString*my_location=[LSDeviceInfo myLocation];
    
    NSString * result=[ NSString stringWithFormat:@"Check All Device Info\nMachine: %@\nSysname: %@\nNodename: %@\nRelease: %@\nVersion: %@\nApp Version: %@\nApp Desc: %@\nApp Country: %@\nappVerionDetails: %@\nPhone Number: %@\nLocation: %@",result_machine,result_sysname,result_nodename,result_release,result_version,appVerion,appBundleID,appCountry,appVerionDetails,my_number,my_location];
    return  result;
}

#pragma mark - Info for device

//AppStore 无法通过的私有API，用于解决获取iPad的卡号
+(NSString *)myNumber{
    return @"Unknown";
    //return CTSettingCopyMyPhoneNumber();
}

+(NSString*) myLocation{
    NSLocale *currentUsersLocale = [NSLocale currentLocale];
    NSString* localIdentifier = [currentUsersLocale localeIdentifier];
    NSLog(@"Current Locale: %@", localIdentifier);
    NSString* region = nil;
    //ISO 3166 国家编码http://zh.wikipedia.org/zh-cn/ISO_3166-1
    NSArray* codes = [NSLocale ISOCountryCodes];
    
    BOOL findCountry = NO;
    NSRange range = [localIdentifier  rangeOfString:@"_"];
    NSString* contry  = nil;
    if(range.location !=NSNotFound)
    {
        contry = [localIdentifier substringFromIndex:(range.location+range.length)];
        NSLog(@"contry:%@",contry);
        
        
        NSUInteger idx = NSUIntegerMax;
        idx = [codes indexOfObject:contry];
        if(idx < [codes count])
        {
            findCountry = YES;
        }
    }
    if(findCountry)
    {
        NSLog(@"contry is %@",contry);
        if([[contry uppercaseString] isEqualToString:@"HK"]||
           [[contry uppercaseString] isEqualToString:@"MO"]||
           [[contry uppercaseString] isEqualToString:@"TW"])
        {
            contry = @"CN";
        }
        region = contry;
    }
    else
    {
        region = @"未知";
    }
    return region;
}

+ (NSString *)identifierForVendor{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

+ (NSDictionary *)infoForDevice {
    NSString *device = [LSDeviceInfo platformType];
    NSDictionary *info = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[device stringByReplacingOccurrencesOfString:@" " withString:@""] ofType:@"plist"]];
    return info;
}
#pragma mark - Methods

+ (NSString *)deviceModel {
    return [[UIDevice currentDevice] model];
}

+ (NSString *)deviceName {
    return [[UIDevice currentDevice] name];
}

+ (NSString *)systemName {
    return [[UIDevice currentDevice] systemName];
}

+ (NSString *)systemVersion {
    return [[UIDevice currentDevice] systemVersion];
}

+ (NSInteger)screenWidth {
    return [[UIScreen mainScreen] bounds].size.width;
}

+ (NSInteger)screenHeight {
    return [[UIScreen mainScreen] bounds].size.height;
}

+ (CGFloat)brightness {
    return [[UIScreen mainScreen] brightness]*100;
}

+ (NSString *)platformType {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *result = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSString *type;
    if ([result isEqualToString:@"i386"])           type = @"Simulator";
    if ([result isEqualToString:@"iPod3,1"])        type = @"iPod Touch 3";
    if ([result isEqualToString:@"iPod4,1"])        type = @"iPod Touch 4";
    if ([result isEqualToString:@"iPod5,1"])        type = @"iPod Touch 5";
    if ([result isEqualToString:@"iPhone2,1"])      type = @"iPhone 3Gs";
    if ([result isEqualToString:@"iPhone3,1"])      type = @"iPhone 4";
    if ([result isEqualToString:@"iPhone4,1"])      type = @"iPhone 4s";
    if ([result isEqualToString:@"iPhone5,1"]   ||
        [result isEqualToString:@"iPhone5,2"])      type = @"iPhone 5";
    if ([result isEqualToString:@"iPad2,1"]     ||
        [result isEqualToString:@"iPad2,2"]     ||
        [result isEqualToString:@"iPad2,3"])        type = @"iPad 2";
    if ([result isEqualToString:@"iPad3,1"]     ||
        [result isEqualToString:@"iPad3,2"]     ||
        [result isEqualToString:@"iPad3,3"])        type = @"iPad 3";
    if ([result isEqualToString:@"iPad3,4"]     ||
        [result isEqualToString:@"iPad3,5"]     ||
        [result isEqualToString:@"iPad3,6"])         type = @"iPad 4";
    if ([result isEqualToString:@"iPad2,5"]     ||
        [result isEqualToString:@"iPad2,6"]     ||
        [result isEqualToString:@"iPad2,7"])        type = @"iPad Mini";
    if ([result isEqualToString:@"iPhone6,1"]   ||
        [result isEqualToString:@"iPhone6,2"])      type = @"iPhone 5s";
    if ([result isEqualToString:@"iPhone5,3"]   ||
        [result isEqualToString:@"iPhone5,4"])      type = @"iPhone 5c";
    
    return type;
}

+ (NSString *)bootTime {
    NSInteger ti = (NSInteger)[[NSProcessInfo processInfo] systemUptime];
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    return [NSString stringWithFormat:@"%02i:%02i:%02i", hours, minutes, seconds];
}

+ (BOOL)proximitySensor {
    // Make a Bool for the proximity Sensor
    BOOL proximitySensor = NO;
    // Is the proximity sensor enabled?
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setProximityMonitoringEnabled:)]) {
        // Create a UIDevice variable
        UIDevice *device = [UIDevice currentDevice];
        // Turn the sensor on, if not already on, and see if it works
        if (device.proximityMonitoringEnabled != YES) {
            // Sensor is off
            // Turn it on
            [device setProximityMonitoringEnabled:YES];
            // See if it turned on
            if (device.proximityMonitoringEnabled == YES) {
                // It turned on!  Turn it off
                [device setProximityMonitoringEnabled:NO];
                // It works
                proximitySensor = YES;
            } else {
                // Didn't turn on, no good
                proximitySensor = NO;
            }
        } else {
            // Sensor is already on
            proximitySensor = YES;
        }
    }
    // Return on or off
    return proximitySensor;
}

+ (BOOL)multitaskingEnabled {
    // Is multitasking enabled?
    if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)]) {
        // Create a bool
        BOOL multitaskingSupported = [UIDevice currentDevice].multitaskingSupported;
        // Return the value
        return multitaskingSupported;
    } else {
        // Doesn't respond to selector
        return NO;
    }
}

// 1.2

+ (NSString *)sim {
    return [[self infoForDevice] objectForKey:@"sim"];
}

+ (NSString *)dimensions {
    return [[self infoForDevice] objectForKey:@"dimensions"];
}

+ (NSString *)weight {
    return [[self infoForDevice] objectForKey:@"weight"];
}

+ (NSString *)displayType {
    return [[self infoForDevice] objectForKey:@"display-type"];
}

+ (NSString *)displayDensity {
    return [[self infoForDevice] objectForKey:@"display-density"];
}

+ (NSString *)WLAN {
    return [[self infoForDevice] objectForKey:@"WLAN"];
}

+ (NSString *)bluetooth {
    return [[self infoForDevice] objectForKey:@"bluetooth"];
}

+ (NSString *)cameraPrimary {
    return [[self infoForDevice] objectForKey:@"camera-primary"];
}

+ (NSString *)cameraSecondary {
    return [[self infoForDevice] objectForKey:@"camera-secondary"];
}

+ (NSString *)cpu {
    return [[self infoForDevice] objectForKey:@"cpu"];
}

+ (NSString *)gpu {
    return [[self infoForDevice] objectForKey:@"gpu"];
}

+ (BOOL)siri {
    if ([[[self infoForDevice] objectForKey:@"siri"] isEqualToString:@"Yes"])
        return YES;
    else
        return NO;
}

+ (BOOL)touchID {
    if ([[[self infoForDevice] objectForKey:@"touch-id"] isEqualToString:@"Yes"])
        return YES;
    else
        return NO;
}

+ (int)batteryState{
    return [[UIDevice currentDevice] batteryState];
}
+ (int)batteryState_isPlugIn{
    switch ([[UIDevice currentDevice] batteryState]) {
        case UIDeviceBatteryStateUnknown:
            return -1;
            //batteryStateText=@"UIDeviceBatteryStateUnknown";//unknown
            break;
        case UIDeviceBatteryStateUnplugged:
            return 0;
            //batteryStateText=@"UIDeviceBatteryStateUnplugged";//is_plugin=0
            break;
        case UIDeviceBatteryStateCharging:
            return 1;
            //batteryStateText=@"UIDeviceBatteryStateCharging";//is_plugin=1
            break;
        case UIDeviceBatteryStateFull:
            return 1;
            //batteryStateText=@"UIDeviceBatteryStateFull";//is_plugin=1
            break;
        default:
            return -2;
            break;
    }

}
+ (int)batteryLevel{
    return (int)([[UIDevice currentDevice] batteryLevel]*100);
}

+ (long)bootTimeInSeconds {
    NSInteger ti = (NSInteger)[[NSProcessInfo processInfo] systemUptime];
    return ti;
}

+(NSString*) device_sn{
    /*
     SystemUtil *su=new SystemUtil();
     NSString* sn=su->SN();
     NSData* sndata = [sn dataUsingEncoding:NSASCIIStringEncoding];
     NSLog(@"SN=[%@]",sn);
     NSLog(@"SN data=[%@]",sndata);
     return sn;
     */
    NSString *udid = [SecureUDID UDIDForDomain:@"erp.leqee.com" usingKey:@"BabyNesPOS"];
    return udid;
}

@end
