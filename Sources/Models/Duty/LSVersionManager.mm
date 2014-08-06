//
//  LSVersionManager.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-8-2.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "LSVersionManager.h"
#import "DataLoader.h"
#import "ZipArchive.h"
#import "LSDeviceInfo.h"
#import "FileDownloader.h"

//static NSInteger theCurrentVersion=0;

@implementation LSVersionManager

#pragma mark the current version

+(NSInteger)currentVerion{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSInteger cv=[def integerForKey:@"DataCacheVersion"];
    _Log(@"read DataCacheVersion as [%ld]",(long)cv);
    return cv;
}
+(void)setCurrentVersion:(NSInteger)currentVersion{
    //theCurrentVersion=currentVersion;
    [[NSUserDefaults standardUserDefaults] setInteger:currentVersion forKey:@"DataCacheVersion"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _Log(@"set DataCacheVersion as [%d]",currentVersion);
}

#pragma mark version check

+(BOOL)isNeedUpdateVersion:(NSString**)url{
    NSDictionary* returnDict=[LSVersionManager runVersionCheckAPI_isDoneReport:NO];
    _Log(@"get check version dict=%@",returnDict);
    if(returnDict[@"CODE"]){
        if([returnDict[@"CODE"] isEqualToString:@"200"]){
            NSDictionary * dict=returnDict[@"DATA"];
            if([dict[@"need_update"] isEqualToString:@"1"]) {
                *url=dict[@"zip_url"];
                return YES;
            }else{
                //return NO;
            }
        }else{
            //return NO;
        }
    }else{
        //反正连不上网，更新也没用。
        //return NO;
    }
    [LSVersionManager refreshIdlePRVideo:NO];
    return NO;
}

+(NSDictionary*)runVersionCheckAPI_isDoneReport:(BOOL)isDoneReport{
    NSString * url=[[ServerConfig getServerConfig]getURL_version_check];
	NSError *error = nil;
	NSURLResponse *response = nil;
    NSMutableDictionary * paramsDict=[@{@"version": [NSNumber numberWithInteger:[LSVersionManager currentVerion]]} mutableCopy];
    if(isDoneReport){
        [paramsDict setObject: [NSNumber numberWithLong:[[NSDate date]timeIntervalSince1970]] forKey:@"updateTime"];
    }
	id params = NSUtil::URLQuery(paramsDict);
	if ([DataLoader accessToken])
	{
		NSString *token = [NSString stringWithFormat:@"token=%@", [DataLoader accessToken]];
		params = params ? [NSString stringWithFormat:@"%@&%@", token, params] : token;
	}
	_Log(@"LSVersionManager: curl -d \"%@\" %@", params, url);
	NSData *post = [params dataUsingEncoding:NSUTF8StringEncoding];
	NSData *data = HttpUtil::HttpData(url, post, NSURLRequestReloadIgnoringCacheData, &response, &error);
	if (data == nil)
	{
		_Log(@"LSVersionManager runVersionCheckAPI_isDoneReport:%d url=[%@] Response: %@\n\nError: %@\n\n",isDoneReport,url, response, error);
        return nil;
	}
    NSDictionary * dict=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:&error];
	if(dict){
        return dict;
    }else{
        _Log(@"runVersionCheckAPI_isDoneReport:%d parse data to dictionary error:%@",isDoneReport,error);
        return nil;
    }
    
}

+(NSString*)allZipFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentpath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString* l_zipfile = [documentpath stringByAppendingString:@"/all.zip"];
    return l_zipfile;
}

+(NSString*)allZipToJsonPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentpath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString* unzipto = [documentpath stringByAppendingString:@"/all"] ;
    return unzipto;
}

+(NSString*)allJsonFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentpath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString* unzipto = [documentpath stringByAppendingString:@"/all/all.json"] ;
    return unzipto;
}

+(BOOL)unzip:(NSString*)fromPath to:(NSString*)toPath{
    ZipArchive* zip = [[ZipArchive alloc] init];
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *documentpath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    NSString* l_zipfile = fromPath;//[documentpath stringByAppendingString:@"/test.zip"];
    NSString* unzipto = toPath;//[documentpath stringByAppendingString:@"/test"] ;
    BOOL done=YES;
    if( [zip UnzipOpenFile:l_zipfile] )
    {
        BOOL ret = [zip UnzipFileTo:unzipto overWrite:YES];
        if( NO==ret )
        {
            _Log(@"Failed unzip");
            done=NO;
        }
        [zip UnzipCloseFile];
    }
    return done;
}

+(NSData*)dataWithDictionary:(NSDictionary*)dict{
    /*
     NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:dict];
     return myData;
     */
    NSError * error=nil;
    id result = [NSJSONSerialization dataWithJSONObject:dict
                                                options:0 error:&error];//NSJSONWritingPrettyPrinted
    if (error != nil) return nil;
    return result;
    
}
+(NSString*)jsonWithDictionary:(NSDictionary*)dict{
    //NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:dict];
    NSData * myData=[LSVersionManager dataWithDictionary:dict];
    
    NSString *jsonString = [[NSString alloc] initWithData:myData
                                                 encoding:NSUTF8StringEncoding];
    _Log(@"jsonWithDictionary: dict[%@]->json[%@]",dict,jsonString);
    return jsonString;
}
+(NSDictionary*)dictionaryWithData:(NSData*)data{
    NSDictionary *myDict = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return myDict;
}

+(BOOL)updateWithDownloadedZip{
    BOOL done1=[LSVersionManager unzip:[LSVersionManager allZipFilePath] to:[LSVersionManager allZipToJsonPath]];
    if(done1){
        NSData * all_data=[NSData dataWithContentsOfFile:[LSVersionManager allJsonFilePath]];
        NSError * error=nil;
        NSDictionary * all_dict=[NSJSONSerialization JSONObjectWithData:all_data options:(NSJSONReadingMutableLeaves) error:&error];
        if(all_dict){
            //_Log(@"updateWithDownloadedZip=%@",all_dict);
            @try {
                [LSVersionManager refreshIdlePRVideo:YES];
                BOOL done2=YES;
                //Material
                //BOOL done_material=[[LSVersionManager dataWithDictionary: all_dict[@"material"]] writeToFile:(NSUtil::CacheUrlPath([NSString stringWithFormat:@"%@/%@",[[ServerConfig getServerConfig]getURL_root],@"material"])) atomically:YES];
                NSString*json=[LSVersionManager jsonWithDictionary:all_dict[@"material"]];
                NSString*materialPath=(NSUtil::CacheUrlPath(@"material"));
                _Log(@"LSVersionManager updateWithDownloadedZip material path=%@ json=%@",materialPath,json);
                BOOL done_material=[json writeToFile:materialPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
                _Log(@"LSVersionManager updateWithDownloadedZip done_material=%d error=%@",done_material,error);
                [LSVersionManager DownloadAllFiles_Material_WithDict:[all_dict[@"material"] objectForKey:@"DATA"] isForce:NO];
                done2=done2 && done_material;
                //pdt_classify
                //BOOL done_pdt_classify=[[LSVersionManager dataWithDictionary: all_dict[@"pdt_classify"]] writeToFile:(NSUtil::CacheUrlPath([NSString stringWithFormat:@"%@/%@",[[ServerConfig getServerConfig]getURL_root],@"pdt_classify"])) atomically:YES];
                BOOL done_pdt_classify=[[LSVersionManager jsonWithDictionary:all_dict[@"pdt_classify"]] writeToFile:(NSUtil::CacheUrlPath(@"pdt_classify")) atomically:YES encoding:NSUTF8StringEncoding error:&error];
                _Log(@"LSVersionManager updateWithDownloadedZip done_pdt_classify=%d error=%@",done_pdt_classify,error);
                [LSVersionManager DownloadAllFiles_PDT_WithDict:[all_dict[@"pdt_classify"] objectForKey:@"DATA"] isForce:NO];
                done2=done2 && done_pdt_classify;
                //ls_location
                //BOOL done_ls_location=[[LSVersionManager dataWithDictionary: all_dict[@"ls_location"]] writeToFile:(NSUtil::CacheUrlPath([NSString stringWithFormat:@"%@/%@",[[ServerConfig getServerConfig]getURL_root],@"ls_location"])) atomically:YES];
                BOOL done_ls_location=[[LSVersionManager jsonWithDictionary:all_dict[@"ls_location"]] writeToFile:(NSUtil::CacheUrlPath(@"ls_location")) atomically:YES encoding:NSUTF8StringEncoding error:&error];
                _Log(@"LSVersionManager updateWithDownloadedZip done_ls_location=%d error=%@",done_ls_location,error);
                done2=done2 && done_ls_location;
                //pdt_detail
                NSArray * pdDictArray=[all_dict[@"pdt_detail"] objectForKey:@"DATA"];
                for (NSDictionary* pDict in pdDictArray) {
                    NSString * pdUrl=[[@"pdt_detail.php?" stringByAppendingString:[NSString stringWithFormat:@"pid=%@",[pDict objectForKey:@"pid"]]] stringByAppendingString:@"&gomi="];
                    //pdUrl=[[[ServerConfig getServerConfig] getURL_root] stringByAppendingString:pdUrl];
                    NSMutableDictionary * mdict=[[NSMutableDictionary alloc]init];
                    [mdict setObject:@"200" forKey:@"CODE"];
                    [mdict setObject:pDict forKey:@"DATA"];
                    //BOOL done_pd=[[LSVersionManager dataWithDictionary: mdict] writeToFile:(NSUtil::CacheUrlPath(pdUrl)) atomically:YES];
                    BOOL done_pd=[[LSVersionManager jsonWithDictionary:mdict] writeToFile:(NSUtil::CacheUrlPath(pdUrl)) atomically:YES encoding:NSUTF8StringEncoding error:&error];
                    [LSVersionManager DownloadAllFiles_PDetail_WithDict:pDict isForce:NO];
                    _Log(@"LSVersionManager updateWithDownloadedZip done_pd=%d error=%@",done_pd,error);
                    done2=done2 && done_pd;
                }
                if(done2){
                    [LSVersionManager setCurrentVersion: [all_dict[@"version"] integerValue]];
                    //TODO report here?
                    [LSVersionManager runVersionCheckAPI_isDoneReport:YES];
                    return YES;
                }else{
                    return NO;
                }
            }
            @catch (NSException *exception) {
                _Log(@"updateWithDownloadedZip error=%@",exception);
            }
            @finally {
                //TODO nothing
            }
        }else{
            _Log(@"json error=%@",error);
        }
    }else{
        return NO;
    }
}

+(void)DownloadAllFiles_Material_WithDict:(NSDictionary *)dict isForce:(BOOL)force_refresh{
    // NotReachable = 0,ReachableViaWiFi,ReachableViaWWAN
    //NetworkStatus network_status=[LSDeviceInfo currentNetworkType];
    //if(network_status==ReachableViaWiFi){
    if([LSDeviceInfo isNetworkOn]){
        NSMutableArray * files=[[NSMutableArray alloc]init];
        for (NSDictionary *cate in dict[@"category"]){
            for (NSDictionary *item in dict[cate[@"value"]]){
                {
                    NSString* file_level_url=[item objectForKey:@"file"];
                    NSString * cache_path = NSUtil::CacheUrlPath(file_level_url);
                    if(force_refresh || !NSUtil::IsFileExist(cache_path)){
                        if (![files containsObject:file_level_url]) {
                            [files addObject:file_level_url];
                            _Log(@"refreshDownloadAllFilesWithDict[%@]->[%@]",file_level_url,cache_path);
                        }
                        //[FileDownloader ariseNewDownloadTaskForURL:file_level_url withAccessToken:[DataLoader accessToken]];
                        //_Log(@"download duty [%@] arised",file_level_url);
                    }
                }
                {
                    NSString* image_level_url=[item objectForKey:@"image"];
                    NSString * image_cache_path = NSUtil::CacheUrlPath(image_level_url);
                    if(force_refresh || !NSUtil::IsFileExist(image_cache_path)){
                        if (![files containsObject:image_level_url]) {
                            [files addObject:image_level_url];
                            _Log(@"refreshDownloadAllFilesWithDict[%@]->[%@]",image_level_url,image_cache_path);
                        }
                        //[FileDownloader ariseNewDownloadTaskForURL:image_level_url withAccessToken:[DataLoader accessToken]];
                        //_Log(@"download duty [%@] arised",image_level_url);
                    }
                }
            }
        }
        for (NSString * url in files) {
            [FileDownloader ariseNewDownloadTaskForURL:url withAccessToken:[DataLoader accessToken]];
            _Log(@"download duty [%@] arised",url);
        }
    }
}

+(void)refreshIdlePRVideo:(BOOL)force_refresh{
    //NetworkStatus network_status=[LSDeviceInfo currentNetworkType];
    //if(network_status==ReachableViaWiFi){
    if([LSDeviceInfo isNetworkOn]){
        NSString*idle_video_url=[[ServerConfig getServerConfig]getURL_idle_video];
        NSString * cache_path = NSUtil::CacheUrlPath(idle_video_url);
        if(force_refresh || !NSUtil::IsFileExist(cache_path)){
            _Log(@"refreshIdlePRVideo[%@]->[%@]",idle_video_url,cache_path);
            [FileDownloader ariseNewDownloadTaskForURL:idle_video_url withAccessToken:[DataLoader accessToken]];
            _Log(@"download duty [%@] arised",idle_video_url);
        }
    }
    
}

+(void)DownloadAllFiles_PDetail_WithDict:(NSDictionary *)dict isForce:(BOOL)force_refresh{
    if([LSDeviceInfo isNetworkOn]){
        NSMutableArray * files=[[NSMutableArray alloc]init];
        {
            NSString* image_level_url=[dict objectForKey:@"small_image"];
            NSString * image_cache_path = NSUtil::CacheUrlPath(image_level_url);
            if(force_refresh || !NSUtil::IsFileExist(image_cache_path)){
                if (![files containsObject:image_level_url]) {
                    [files addObject:image_level_url];
                    _Log(@"refreshDownloadAllFilesWithDict[%@]->[%@]",image_level_url,image_cache_path);
                }
                //[FileDownloader ariseNewDownloadTaskForURL:image_level_url withAccessToken:[DataLoader accessToken]];
                //_Log(@"download duty [%@] arised",image_level_url);
            }
        }
        {
            NSString* image_level_url=[dict objectForKey:@"big_image"];
            NSString * image_cache_path = NSUtil::CacheUrlPath(image_level_url);
            if(force_refresh || !NSUtil::IsFileExist(image_cache_path)){
                if(![files containsObject:image_level_url]){
                    [files addObject:image_level_url];
                    _Log(@"refreshDownloadAllFilesWithDict[%@]->[%@]",image_level_url,image_cache_path);
                }
                
                //[FileDownloader ariseNewDownloadTaskForURL:image_level_url withAccessToken:[DataLoader accessToken]];
                //_Log(@"download duty [%@] arised",image_level_url);
            }
        }
        for (NSString * url in files) {
            [FileDownloader ariseNewDownloadTaskForURL:url withAccessToken:[DataLoader accessToken]];
            _Log(@"download duty [%@] arised",url);
        }
    }
}

+(void)DownloadAllFiles_PDT_WithDict:(NSDictionary *)dict isForce:(BOOL)force_refresh{
    if([LSDeviceInfo isNetworkOn]){
        NSMutableArray * files=[[NSMutableArray alloc]init];
        for (NSDictionary *cate in dict[@"category"]){
            if([cate objectForKey:@"image"]){
                _Log(@"cate-image:%@",[cate objectForKey:@"image"]);
                NSString* image_level_url=[cate objectForKey:@"image"];
                NSString * image_cache_path = NSUtil::CacheUrlPath(image_level_url);
                if(force_refresh || !NSUtil::IsFileExist(image_cache_path)){
                    if(![files containsObject:image_level_url]){
                        [files addObject:image_level_url];
                        _Log(@"refreshDownloadAllFilesWithDict[%@]->[%@]",image_level_url,image_cache_path);
                    }
                    //[FileDownloader ariseNewDownloadTaskForURL:image_level_url withAccessToken:[DataLoader accessToken]];
                    //_Log(@"download duty [%@] arised",image_level_url);
                }
            }
            for (NSDictionary *item in dict[cate[@"value"]]){
                _Log(@"item image:%@",[item objectForKey:@"image"]);
                NSString* image_level_url=[item objectForKey:@"image"];
                NSString * image_cache_path = NSUtil::CacheUrlPath(image_level_url);
                if(force_refresh || !NSUtil::IsFileExist(image_cache_path)){
                    if(![files containsObject:image_level_url]){
                        [files addObject:image_level_url];
                        _Log(@"refreshDownloadAllFilesWithDict[%@]->[%@]",image_level_url,image_cache_path);
                    }
                    //[FileDownloader ariseNewDownloadTaskForURL:image_level_url withAccessToken:[DataLoader accessToken]];
                    //_Log(@"download duty [%@] arised",image_level_url);
                }
            }
        }
        for (NSString * url in files) {
            [FileDownloader ariseNewDownloadTaskForURL:url withAccessToken:[DataLoader accessToken]];
            _Log(@"download duty [%@] arised",url);
        }
    }
}

@end
