
#import "BaseController.h"
#import "CacheDataLoader.h"
#import "FileDownloader.h"

//
@interface DataController : BaseController <DataLoaderDelegate>
{
	CacheDataLoader *_loader;
	UIView *_contentView;
}
- (id)initWithService:(NSString *)service;
- (id)initWithService:(NSString *)service params:(NSDictionary *)params;
- (void)loadContentView:(UIView *)contentView withDict:(NSDictionary *)dict;
@end