
#import "BaseController.h"
#import "CacheDataLoader.h"

//
@interface DataController : BaseController <DataLoaderDelegate>
{
	CacheDataLoader *_loader;
}
@end