
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

@property id<DataControllerPullReloadDelegate> thePullReloadDelegate;

- (id)initWithService:(NSString *)service;
- (id)initWithService:(NSString *)service params:(NSDictionary *)params;
- (void)loadContentView:(UIView *)contentView withDict:(NSDictionary *)dict;

@end

