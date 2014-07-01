

#import "DataLoader.h"
#import "LoginController.h"

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
		if (loader.error == DataLoaderNoData || loader.error == DataLoaderNetworkError)
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
	}
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

//
+ (BOOL)isLogon
{
	return _accessToken != nil;
}

//
+ (void)logout
{
	_accessToken = nil;
	Settings::Save(kAccessToken);
	[[NSNotificationCenter defaultCenter] postNotificationName:kLogoutNotification object:nil];
}

//
+ (void)login
{
	[self logout];
	UIViewController *controller = [[LoginController alloc] init];
	UIUtil::PresentModalNavigationController(UIUtil::RootViewController(), controller);
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
	const static NSString *c_strings[] =
	{
		NSLocalizedString(@"Not initialized", @"尚未初始化"),
		NSLocalizedString(@"No change", @"数据无变化"),
		NSLocalizedString(@"Data error", @"数据服务错误"),
		NSLocalizedString(@"Network error", @"网络连接不给力啊"),
	};
	return (_error < _NumOf(c_strings)) ? (NSString *)c_strings[_error] : [NSString stringWithFormat:NSLocalizedString(@"Uknown error: %d", @"未知错误，代码：%d"), _error];
}

#pragma mark Data loading methods

//
- (BOOL)loadBegin
{
	if (_loading) return NO;

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
	UIUtil::ShowNetworkIndicator(YES);
	if (!_dict && _showLoading)
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
		
		id dict =[_delegate respondsToSelector:@selector(loadDoing:)] ? [_delegate loadDoing:self] : [self loadDoing];
		[self performSelectorOnMainThread:@selector(loadEnded:) withObject:dict waitUntilDone:YES];
	}
}

//
- (id)loadDoing
{
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
				}
			}
		}
		else
		{
			_error = DataLoaderDataError;
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
	NSString *url = kServiceUrl(_service);
	return [_delegate respondsToSelector:@selector(loadData: url:)] ? [_delegate loadData:self url:url] : [self loadData:url];
}

//
- (NSData *)loadData:(NSString *)url
{
    //_Log(@"DataLoader loadData url=%@",url);
	NSError *error = nil;
	NSURLResponse *response = nil;
	id params = [_params isKindOfClass:[NSDictionary class]] ? NSUtil::URLQuery((NSDictionary *)_params) : _params;
	if (_accessToken)
	{
		params = [NSString stringWithFormat:@"token=%@&%@", _accessToken, params];
	}
	_Log(@"DataLoader loadData url&param -> %@?%@", url, params ? [@"&" stringByAppendingString:params] : @"");
	NSData *post = [params dataUsingEncoding:NSUTF8StringEncoding];
	NSData *data = HttpUtil::HttpData(url, post, NSURLRequestReloadIgnoringCacheData, &response, &error);
	if (data == nil)
	{
		_Log(@"Response: %@\n\nError: %@\n\n", response, error);
	}
	return data;
}

//
- (id)parseData:(NSData *)data
{
	NSError *error = nil;
	NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:_jsonOptions error:&error];
	if (dict == nil)
	{
		_Log(@"Data: %@\n\n Error: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding], error);
	}
	return dict;
}

//
- (void)loadEnded:(NSDictionary *)dict
{
	_loading = NO;
	if (_error == DataLoaderNoError)
	{
		self.dict = dict;
	}
	else if (_error == DataLoaderUserError)
	{
		[DataLoader login];
	}
	else if (_error == DataLoaderPassError)
	{
		[DataLoader logout];
	}
	else
	{
		_Log(@"%@: %d =>\n%@", (_error == DataLoaderNoChange) ? @"NOCHANGE" : @"ERROR", _error, dict);
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
	if (_failure)
	{
		if (!_failure(self, error))
		{
			return;
		}
	}
	if (_error == DataLoaderUserError || _error == DataLoaderPassError)
	{
		[ToastView toastWithError:error];
	}
	else if (_checkError)
	{
		// 延迟是为了解决网络没连接时，下拉松开后，快速返回错误后弹框，点击后导致不能下拉
		// 同时也是为了解决要求登录时弹出 Toast 被遮住的问题
		[[ErrorAlertView alertWithError:error loader:self] performSelector:@selector(show) withObject:nil afterDelay:0.2];
	}
}

@end
