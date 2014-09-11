
#import "BaseController.h"
#import "CacheDataLoader.h"
#import "FileDownloader.h"

@protocol DataControllerPullReloadDelegate <NSObject>

-(void)responseForReloadWork;

@end

//
@interface DataController : BaseController <DataLoaderDelegate>
{
	CacheDataLoader *_loader;
	UIView *_contentView;
    
    
    
    BOOL is_reloading;
    UIActivityIndicatorView * reload_indicator;
}

@property BOOL is_expired;

@property id<DataControllerPullReloadDelegate> thePullReloadDelegate;

@property BOOL forceOnline;

- (id)initWithService:(NSString *)service;
- (id)initWithService:(NSString *)service params:(NSDictionary *)params;
- (void)loadContentView:(UIView *)contentView withDict:(NSDictionary *)dict;

-(void)receiveVerisonUpdatePush;
@end

