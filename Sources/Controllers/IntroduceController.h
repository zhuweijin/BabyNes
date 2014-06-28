
#import "BaseController.h"
#import "CacheDataLoader.h"

//
@interface IntroduceController : BaseController <DataLoaderDelegate>
{
	CacheDataLoader *_loader;
}
@end