

#import "DataLoader.h"
#import "LoginController.h"
#import "DialogUIAlertView.h"
#import "SinriUIApplication.h"

//
@interface ErrorAlertView : UIAlertView
@property(nonatomic,strong) DataLoader *loader;
@property(nonatomic,strong) id<DataLoaderDelegate> loader_delegate;
+ (id)alertWithError:(NSString *)error loader:(DataLoader *)loader;
@end

@implementation ErrorAlertView

//
static ErrorAlertView *_alertView = nil;
+ (id)alertWithError:(NSString *)error loader:(DataLoader *)loader
{
	if (_alertView == nil)
	{
		_alertView = [[ErrorAlertView alloc] init];
		_alertView.title = error;
		_alertView.delegate = _alertView;
		if (loader.error == DataLoaderServerError || loader.error == DataLoaderNetworkError)
		{
			[_alertView addButtonWithTitle:NSLocalizedString(@"Cancel", @"取消")];
			[_alertView addButtonWithTitle:NSLocalizedString(@"Retry", @"重试")];
		}
		else
		{
			[_alertView addButtonWithTitle:NSLocalizedString(@"OK", @"确定")];
		}
		_alertView.loader = loader;
		_alertView.loader_delegate = loader.delegate;
		//[_alertView show];
        //CGRect win_frame=[[[UIApplication sharedApplication]keyWindow] frame];
	}
    [_alertView setFrame:CGRectMake(0, 400, 1024, 100)];
	return _alertView;
}

//
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 1)
	{
		[_loader loadBegin];
		_loader_delegate = nil;
		_loader = nil;
	}
    //	else if (_loader.error == DataLoaderProfileIncomplete)
    //	{
    //		UIViewController *controller = [[BasicProfileController alloc] init];
    //		[UIUtil::RootViewController() presentNavigationController:controller animated:YES];
    //	}
	_alertView = nil;
}
@end


@implementation DataLoader

//
+ (void)loadWithService:(NSString *)service params:(id)params success:(void (^)(DataLoader *loader))success failure:(BOOL (^)(DataLoader *loader, NSString *error))failure
{
	DataLoader *loader = [DataLoader loaderWithService:service params:params completion:success];
	loader.completionOnSuccess = YES;
	loader.failure = failure;
	[loader loadBegin];
}

//
+ (void)loadWithService:(NSString *)service params:(id)params success:(void (^)(DataLoader *loader))success
{
	DataLoader *loader = [DataLoader loaderWithService:service params:params completion:success];
	loader.completionOnSuccess = YES;
	[loader loadBegin];
}

//
+ (void)loadWithService:(NSString *)service params:(id)params delegate:(id<DataLoaderDelegate>)delegate completion:(void (^)(DataLoader *loader))completion
{
	DataLoader *loader = [DataLoader loaderWithService:service params:params completion:completion];
	loader.delegate = delegate;
	[loader loadBegin];
}

//
+ (void)loadWithService:(NSString *)service params:(id)params showLoading:(BOOL)showLoading checkError:(BOOL)checkError completion:(void (^)(DataLoader *loader))completion
{
	DataLoader *loader = [DataLoader loaderWithService:service params:params completion:completion];
	loader.checkError = checkError;
	loader.showLoading = showLoading;
	[loader loadBegin];
}

//
+ (void)loadWithService:(NSString *)service params:(id)params completion:(void (^)(DataLoader *loader))completion
{
	[[DataLoader loaderWithService:service params:params completion:completion] loadBegin];
}

//
+ (id)loaderWithService:(NSString *)service params:(id)params completion:(void (^)(DataLoader *loader))completion
{
	DataLoader *loader = [[DataLoader alloc] init];
	loader.service = service;
	loader.params = params;
	loader.completion = completion;
	return loader;
}

#pragma mark Auth methods

static NSString *_accessToken = nil;

static NSString *_storeProvince = nil;
static NSString *_storeCity = nil;
static NSString *_storeAddress = nil;

static NSString *_storeID = nil;

static NSString *_username=nil;
static NSString *_password=nil;

//
+ (void)setAccessToken:(NSString *)accessToken
{
	_accessToken = accessToken;
}

//
+ (NSString *)accessToken
{
	return _accessToken;
}
+ (NSString *)storeID{
    if(!_storeID) return @"null";
    else return _storeID;
}
+ (void)setStoreID:(NSString *)storeID{
    _storeID=storeID;
}
+ (NSString *)storeProvince{
    if(!_storeProvince) return @"null";
    else return _storeProvince;
}
+ (void)setStoreProvince:(NSString *)storeProvince{
    _storeProvince=storeProvince;
}
+ (NSString *)storeCity{
    if(!_storeCity) return @"null";
    else return _storeCity;
}
+ (void)setStoreCity:(NSString *)storeCity{
    _storeCity=storeCity;
}
+ (NSString *)storeAddress{
    return _storeAddress;
}
+ (void)setStoreAddress:(NSString *)storeAddress{
    _storeAddress=storeAddress;
}
+ (NSString*)username{
    return _username;
}
+ (void)setUsername:(NSString*)username{
    _username=username;
}
+ (NSString*)password{
    return _password;
}
+ (void)setPassword:(NSString*)password{
    _password=password;
}

//
+ (BOOL)isLogon
{
	return _accessToken != nil;
}

//
+ (void)logout
{
    _Log(@"DataLoader logout");
	_accessToken = nil;
	Settings::Save(kAccessToken);
	[[NSNotificationCenter defaultCenter] postNotificationName:kLogoutNotification object:nil];//My old solution
}

//
+ (void)login
{
    _Log(@"DataLoader login");
	//[self logout];
    _accessToken = nil;
	Settings::Save(kAccessToken);
    //That's what logout wanna do.
    
	UIViewController *controller = [[LoginController alloc] init];
	UIUtil::PresentModalNavigationController(UIUtil::RootViewController(), controller);
}

+ (void)login:(NSString*)msg
{
    _Log(@"DataLoader login");
    
    if(_accessToken!=nil){
        
        //[self logout];
        _accessToken = nil;
        Settings::Save(kAccessToken);
        //That's what logout wanna do.
        
        //UIViewController *controller = [[LoginController alloc] initWithMessage:msg];//Yonsm's
        /*
         [(SinriUIApplication *)[UIApplication sharedApplication] setLoginController:[[LoginController alloc] initWithMessage:msg]];
         UIViewController *controller=[(SinriUIApplication *)[UIApplication sharedApplication] loginController];
         UIUtil::PresentModalNavigationController(UIUtil::RootViewController(), controller);
         */
        //Mine
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kLogoutNotification object:nil];//My old solution
        _Log(@"DataLoader login PresentModalNavigationController");
    }else{
        _Log(@"DataLoader login has been running");
    }
}

+(BOOL)refreshAccessToken{
    NSString* at=[DataLoader accessToken];
    NSString* u=[DataLoader username];
    NSString* p=[DataLoader password];
    if(at && u && p){
        NSDictionary* dict=@{
                             @"username": u,
                             @"password":p,
                             @"uuid":[LSDeviceInfo device_sn]
                             };
        NSString* param=NSUtil::URLQuery(dict);
        
        NSString * url=[NSString stringWithFormat:@"%@",[[ServerConfig getServerConfig]getURL_login]];
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
            NSLog(@"relogin : [%@] ...(response=%@,error=%@) get %@ ",url,response,error,getStr);
        }
        if(data){
            NSDictionary * dict=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:&error];
            NSLog(@"relogin return:%@",dict);
            if(dict){
                if([dict[@"CODE"] isEqualToString:@"200"]){
                    NSDictionary * loaderdict=dict[@"DATA"];
                    //GET
                    DataLoader.accessToken = loaderdict[@"token"];
                    [DataLoader setStoreID:loaderdict[@"store_id"]];
                    [DataLoader setStoreProvince:loaderdict[@"storeProvince"]];
                    [DataLoader setStoreCity:loaderdict[@"storeCity"]];
                    [DataLoader setStoreAddress:loaderdict[@"storeAddress"]];
                    [DataLoader setUsername:u];
                    [DataLoader setPassword:p];
                    //SAVE
                    Settings::Save(kAccessToken, DataLoader.accessToken);
                    Settings::Save(kUsername, DataLoader.username);
                    Settings::Save(kPassword, DataLoader.password);
                    Settings::Save(kStoreId,[DataLoader storeID]);
                    Settings::Save(kStoreProvince,[DataLoader storeProvince]);
                    Settings::Save(kStoreCity,[DataLoader storeCity]);
                    Settings::Save(kStoreAddress,[DataLoader storeAddress]);
                    NSLog(@"RELOGIN DOWN at=%@",[DataLoader accessToken]);
                    return YES;
                }
            }
        }
    }
    return NO;
}

//
+ (NSDictionary *)login:(NSString *)username password:(NSString *)password
{
	return nil;
}

#pragma mark Generic methods

// Constructor
- (id)init
{
	self = [super init];
	_checkError = YES;
	_showLoading = YES;
	return self;
}

//
- (void)clearData
{
	//self.service = nil;
	//self.params = nil;
	self.checkError = YES;
	self.checkChange = NO;
	self.dict = nil;
	self.date = nil;
	//self.error = DataLoaderNoData;
}

//
- (NSString *)stamp
{
	NSDate *date = self.date;
	NSString *stamp = date ? NSUtil::SmartDate(date, NSDateFormatterMediumStyle, NSDateFormatterShortStyle) : NSLocalizedString(@"Never", @"从未");
	return [NSString stringWithFormat:NSLocalizedString(@"Last Updated: %@", @"最近更新：%@"), stamp];
}

//
- (NSString *)errorString
{
    /*
     const static NSString *c_strings[] =
     {
     NSLocalizedString(@"Not initialized", @"尚未初始化"),
     NSLocalizedString(@"No change", @"数据无变化"),
     NSLocalizedString(@"Data error", @"数据服务错误"),
     NSLocalizedString(@"Network error", @"网络连接不给力啊"),
     };
     return (_error < _NumOf(c_strings)) ? (NSString *)c_strings[_error] : [NSString stringWithFormat:NSLocalizedString(@"Uknown error: %d", @"未知错误，代码：%d"), _error];
     */
    NSString * info=nil;
    if(_error==DataLoaderNoCacheError){
        info=NSLocalizedString(@"No cache available.", @"加载本地缓存失败。");
    }else if(_error==DataLoaderNetworkError){
        info=NSLocalizedString(@"Error in network connection.", @"网络连接失败。");
    }else if(_error==DataLoaderNoError){
        info=NSLocalizedString(@"Success", @"成功");
    }else if(_error==DataLoaderTokenError){
        info=NSLocalizedString(@"Token has expired.", @"身份验证失效，需要重新登录。");
    }else if(_error==DataLoaderIllegalDevice){
        info=NSLocalizedString(@"This device is not permitted.", @"当前设备未获许可。");
    }else if(_error==DataLoaderNotFound){
        info=NSLocalizedString(@"Fail to get expected result.", @"网络请求失败。");
    }else if(_error==DataLoaderIdentificationError){
        info=NSLocalizedString(@"Failed in examine the identification.", @"身份验证失败。");
    }else if(_error==DataLoaderServerError){
        info=NSLocalizedString(@"Server response with error.", @"服务器返回错误。");
    }else if(_error==DataLoaderEmpty){
        info=NSLocalizedString(@"Server response with empty.", @"未获得数据。");
    }else if(_error==DataLoaderNoChange){
        info=NSLocalizedString(@"There is no need to update.", @"无需更新");
    }else{
        info=NSLocalizedString(@"Unknown error.", @"未知错误");
    }
    return info;
}

#pragma mark Data loading methods

//
- (BOOL)loadBegin
{
	if (_loading) return NO;
    
    _Log(@"SinriDigin DataLoader loadBegin");
    
	if ([_delegate respondsToSelector:@selector(loadBegan:)])
	{
		if (![_delegate loadBegan:self])
		{
			return NO;
		}
	}
	
	//
	_loading = YES;
	_retained_delegate = _delegate;
	[self loadStart];
	[self performSelectorInBackground:@selector(loadThread) withObject:nil];
	return YES;
}

//
- (void)loadStart
{
    _Log(@"SinriDigin DataLoader loadStart");
    
	UIUtil::ShowNetworkIndicator(YES);
	//if (!_dict && _showLoading)
    if(_showLoading)
	{
		UIViewController *controller = [_delegate respondsToSelector:@selector(view)] ? (UIViewController *)_delegate : UIUtil::VisibleViewController();
		[controller.view toastWithLoading];
		_LogLine();
	}
}

//
- (void)loadThread
{
	@autoreleasepool
	{
		//[NSThread sleepForTimeInterval:5];
		_LogLine();
		id dict =[_delegate respondsToSelector:@selector(loadDoing:)] ? [_delegate loadDoing:self] : [self loadDoing];
		[self performSelectorOnMainThread:@selector(loadEnded:) withObject:dict waitUntilDone:YES];
	}
}

//
- (id)loadDoing
{
    _Log(@"SinriDigin DataLoader loadDoing");
	// 装载数据并解析
	NSDictionary *dict = nil;
	NSData *data = [self loadData];
	if (data)
	{
		dict = [self parseData:data];
		if ([dict isKindOfClass:[NSDictionary class]])
		{
			_error = (DataLoaderError)[dict[@"CODE"] intValue];
			if (_error == DataLoaderNoError)
			{
				dict = [dict objectForKey:@"DATA"];
				if (_checkChange && [_dict isEqualToDictionary:dict])
				{
					_error = DataLoaderNoChange;
                    _Log(@"SinriDigin DataLoader loadDoing SEEM TO BE NO CHANGE");
                    //_Log(@"SinriDigin DataLoader loadDoing SEEM TO BE NO CHANGE old_dict=[%@]",_dict);
                    //_Log(@"SinriDigin DataLoader loadDoing SEEM TO BE NO CHANGE new_dict=[%@]",dict);
				}
			}
		}
		else
		{
			_error = DataLoaderServerError;
		}
	}
	else
	{
		_error = DataLoaderNetworkError;
	}
	
	return dict;
}

//
- (NSData *)loadData
{
	NSString *url =[NSString stringWithFormat:@"%@/%@.php", [[ServerConfig getServerConfig] getURL_root], _service];
    //kServiceUrl(_service);
	return [_delegate respondsToSelector:@selector(loadData: url:)] ? [_delegate loadData:self url:url] : [self loadData:url];
}

//
- (NSData *)loadData:(NSString *)url
{
    _Log(@"DataLoader loadData url=%@",url);
	NSError *error = nil;
	NSURLResponse *response = nil;
	id params = [_params isKindOfClass:[NSDictionary class]] ? NSUtil::URLQuery((NSDictionary *)_params) : _params;
	if (_accessToken)
	{
		NSString *token = [NSString stringWithFormat:@"token=%@", _accessToken];
		params = params ? [NSString stringWithFormat:@"%@&%@", token, params] : token;
	}
	_Log(@"DataLoader: curl -d \"%@\" %@", params, url);
    _Log(@"breakpoint");
	NSData *post = [params dataUsingEncoding:NSUTF8StringEncoding];
	NSData *data = HttpUtil::HttpData(url, post, NSURLRequestReloadIgnoringCacheData, &response, &error);
	if (data == nil)
	{
		_Log(@"DataLoader loadData url=[%@] Response: %@\n\nError: %@\n\n",url, response, error);
	}
	return data;
}

//
- (id)parseData:(NSData *)data
{
	NSError *error = nil;
    if(data){
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:_jsonOptions error:&error];
        if (dict == nil)
        {
            _Log(@"DataLoader parseData Data: %@\n\n Error: %@", (data==nil?@"nil":[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]), error);
        }
        return dict;
    }else{
        return nil;
    }
}

//
- (void)loadEnded:(NSDictionary *)dict
{
    _Log(@"SinriDigin DataLoader loadEnded with dict=%@",dict);
	_checkChange = YES;
    
	_loading = NO;
	if (_error == DataLoaderNoError)
	{
		self.dict = dict;
	}
	else if (_error == DataLoaderTokenError)
	{
		//[DataLoader login];
        [DataLoader login:[self errorString]];
        return;
	}
	else if (_error == DataLoaderIdentificationError)
	{
		//[DataLoader logout];
        //[DataLoader login];
        //return;
	}
	else
	{
        if(_error == DataLoaderNoChange){
            _Log(@"SinriDigin DataLoader loadEnded %@: %d", @"NOCHANGE", _error);
        }else{
            _Log(@"SinriDigin DataLoader loadEnded %@: %d =>\n%@", @"ERROR", _error, dict);
        }
	}
	
	[self loadStop:dict];
	
	//
	if ([_delegate respondsToSelector:@selector(loadEnded:)])
		[_delegate loadEnded:self];
	
	//
	if (_completion && (!_completionOnSuccess || _error == DataLoaderNoError))
	{
		_completion(self);
	}
	
	_retained_delegate = nil;
}

//
- (void)loadStop:(NSDictionary *)dict
{
    //_Log(@"SinriDigin DataLoader loadStop");
	UIUtil::ShowNetworkIndicator(NO);
	if (_showLoading)
	{
		UIViewController *controller = [_delegate respondsToSelector:@selector(view)] ? (UIViewController *)_delegate : UIUtil::VisibleViewController();
		[controller.view dismissToast];
		_LogLine();
	}
	
	// 记住时间戳
	if ((_error == DataLoaderNoError) || (_error == DataLoaderNoChange))
	{
		self.date = [NSDate date];
	}
	else
	{
		// 处理错误
		StatEvent(@"error", (NSString *)[NSString stringWithFormat:@"%d", _error]);
		
		NSString *error = [dict objectForKey:@"INFO"];
		if (error.length == 0) error = self.errorString;
		
		[self loadError:error];
	}
}

//
- (void)loadError:(NSString *)error
{
    _Log(@"DataLoader->loadError:error[%@]",error);
	if (_failure)
	{
		if (!_failure(self, error))
		{
			return;
		}
	}
	if (_error == DataLoaderIdentificationError || _error == DataLoaderTokenError)
	{
		//[ToastView toastWithError:error];
        /*
         UIAlertView * uiav= [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Data Loader Error", @"数据加载错误") message:error delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"确定") otherButtonTitles: nil];
         [uiav show];
         */
	}
	else if (_checkError)
	{
		// 延迟是为了解决网络没连接时，下拉松开后，快速返回错误后弹框，点击后导致不能下拉
		// 同时也是为了解决要求登录时弹出 Toast 被遮住的问题
		//[[ErrorAlertView alertWithError:error loader:self] performSelector:@selector(show) withObject:nil afterDelay:0.2];
        _Log(@"DataLoader->loadError _checkError should show alert of error[%@]",error);
	}
}

@end
