
#import "DataController.h"
//#import "PRPhotoPlayer.h"

//
@interface MaterialController : DataController
<UIScrollViewDelegate,DataControllerPullReloadDelegate>
{
    UIView *catePane;
    UIView *_itemPane;
    int cate_id;
    
	NSMutableDictionary *_itemPanes;
    NSMutableDictionary * cateButtonDict;
    
    UILabel * reloadLabel;
    
    NSInteger appear_count;
}

-(void)refreshDownloadAllFilesWithDict:(NSDictionary *)dict isForce:(BOOL)force_refresh;
@end