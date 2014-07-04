
#import "DataController.h"

//
@interface MaterialController : DataController
{
    UIView *_itemPane;
    int cate_id;
}

-(void)refreshDownloadAllFilesWithDict:(NSDictionary *)dict isForce:(BOOL)force_refresh;
@end