
#import "DataController.h"
#import "CateImageButton.h"

//
@interface IntroduceController : DataController
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

@end