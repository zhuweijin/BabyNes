
#import "DataController.h"
#import "CateImageButton.h"

//
@interface IntroduceController : DataController
{
    UIView *catePane;
	UIView *_itemPane;
    
    BOOL is_reloading;
    
    int cate_id;
    
	NSMutableDictionary *_itemPanes;
    NSMutableDictionary * cateButtonDict;
}

@end