//
//  LocalSRMessageTool.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-17.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

/*
 //SAVE
 
 NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
 [def setObject:[NSKeyedArchiver archivedDataWithRootObject:self.myDictionary] forKey:@"MyData"];
 [def synchronize];
 
 //READ
 
 NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
 NSData *data = [def objectForKey:@"MyData"];
 NSDictionary *retrievedDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
 self.myDictionary = [[NSDictionary alloc] initWithDictionary:retrievedDictionary];
 */

#import "LocalSRMessageTool.h"
#import "DataLoader.h"

static NSMutableDictionary * local_sr_all;
static NSMutableArray * SRArray;

@implementation LocalSRMessageTool

+(NSMutableDictionary*) getLocalSRDict_all{
    //NSDictionary * inLocalAllSRDict=[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"SR_Messages"];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSData *data = [def objectForKey:@"SR_Messages"];
    //NSMutableDictionary *
    local_sr_all=[[NSMutableDictionary alloc] init];
    if(data && ![data isEqual:[NSNull null]]){
        _Log(@"LocalSRMessageTool getLocalSRDict_all get data=%@",data);
        NSDictionary *retrievedDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSDictionary * inLocalAllSRDict = [[NSDictionary alloc] initWithDictionary:retrievedDictionary];
        if(inLocalAllSRDict){
            [local_sr_all addEntriesFromDictionary:inLocalAllSRDict];
        }
    }
    return local_sr_all;
}

+(NSMutableDictionary*) getLocalSRDict_mine{
    NSDictionary * mine=[[LocalSRMessageTool getLocalSRDict_all] objectForKey:[DataLoader accessToken]];
    NSMutableDictionary * mySR=[[NSMutableDictionary alloc]init];
    if(mine){
        [mySR addEntriesFromDictionary:mine];
    }
    //[LocalSRMessageTool getSRArrayIfForce:YES];
    return mySR;
}

+(NSDictionary*)LocalSRMessageDictionaryMergedWithArray:(NSArray*)array{
    NSMutableDictionary * mine=[LocalSRMessageTool getLocalSRDict_mine];
    _Log(@"LocalSRMessageTool LocalSRMessageDictionaryMergedWithArray=%@\nInto dict=%@",array,mine);
    @try {
        for (NSDictionary * item in array) {
            if([item[@"srid"] integerValue]>0){
                SRMessage * srm=[[SRMessage alloc]initWithItemDictionary:item];
                [mine setObject:srm forKey:[NSNumber numberWithInt:[srm srid]]];
            }
        }
    }
    @catch (NSException *exception) {
        _Log(@"LocalSRMessageTool LocalSRMessageDictionaryMergedWithArray Exception to purse:%@",exception.debugDescription);
    }
    @finally {
        //Nothing
    }
    NSDictionary * mineReadonly=[[NSDictionary alloc]initWithDictionary:mine];
    _Log(@"LocalSRMessageTool LocalSRMessageDictionaryMergedWithArray mineReadonly=%@",mineReadonly);
    local_sr_all=[LocalSRMessageTool getLocalSRDict_all];
    [local_sr_all setObject:mineReadonly forKey:[DataLoader accessToken]];
    _Log(@"LocalSRMessageTool LocalSRMessageDictionaryMergedWithArray local all=%@",local_sr_all);
    [LocalSRMessageTool saveLocalSRAll];
    return [LocalSRMessageTool getLocalSRDict_mine];
}

+(void)saveLocalSRAll{
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:local_sr_all] forKey:@"SR_Messages"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    _Log(@"standardUserDefaults=\n%@",[NSUserDefaults standardUserDefaults]);
    [LocalSRMessageTool getSRArrayIfForce:YES];
}

+(void)setSRtoHaveRead:(int)srid{
    NSMutableDictionary * mine=[LocalSRMessageTool getLocalSRDict_mine];
    SRMessage* srm=[mine objectForKey:[NSNumber numberWithInt:srid]];
    if(srm){
        [srm setRead:YES];
        //[[NSUserDefaults standardUserDefaults]synchronize];
    }
}

+(void)setSRArraytoHaveRead:(NSArray*)srids{
    _Log(@"LocalSRMessageTool setSRArraytoHaveRead:%@",srids);
    NSMutableDictionary * mine=[LocalSRMessageTool getLocalSRDict_mine];
    for (NSNumber * num in srids) {
        SRMessage* srm=[mine objectForKey:[NSNumber numberWithInt:[num intValue]]];
        if(srm){
            [srm setRead:YES];
            //[[NSUserDefaults standardUserDefaults]synchronize];
        }
    }
    NSDictionary * mineReadonly=[[NSDictionary alloc]initWithDictionary:mine];
    local_sr_all=[LocalSRMessageTool getLocalSRDict_all];
    [local_sr_all setObject:mineReadonly forKey:[DataLoader accessToken]];
    [LocalSRMessageTool saveLocalSRAll];
}

#pragma mark OnSRMessage
+(NSArray*)getSRArrayIfForce:(BOOL)force{
    if(force || SRArray==nil){
        
        SRArray=[[NSMutableArray alloc]init];
        NSDictionary * local_mine=[LocalSRMessageTool getLocalSRDict_mine];
        //NSDictionary * dict=[[NSDictionary alloc]initWithDictionary:local_mine];
        _Log(@"LocalSRMessageTool getSRArrayIfForce force=[%d] local_mine=%@",force,local_mine);
        NSArray* sortedKeys=[local_mine keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            int v1 = [(SRMessage *)obj1 srid];
            int v2 = [(SRMessage *)obj2 srid];
            if (v1 < v2)
                return NSOrderedDescending;
            //return NSOrderedAscending;
            else if (v1 > v2)
                return NSOrderedAscending;
            //return NSOrderedDescending;
            else
                return NSOrderedSame;
        }];
        for (id key in sortedKeys) {
            SRMessage * srm=[local_mine objectForKey:key];
            [SRArray addObject:srm];
            _Log(@"LocalSRMessageTool getSRArrayIfForce sorted key (%@)",[srm logAbstract]);
        }
    }
    
    return SRArray;
}

+(int)getSRAPIAfterParamValue{
    int count=[[LocalSRMessageTool getSRArrayIfForce:NO] count];
    if(count>0)
        return [[[LocalSRMessageTool getSRArrayIfForce:NO] objectAtIndex:0] srid];
    else return -1;
}
+(int)getSRAPIBeforeParamValue{
    int count=[[LocalSRMessageTool getSRArrayIfForce:NO] count];
    if(count>0)
        return [[[LocalSRMessageTool getSRArrayIfForce:NO] objectAtIndex:count-1] srid];
    else return -1;
}

@end
