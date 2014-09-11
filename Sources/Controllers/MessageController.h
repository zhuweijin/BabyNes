
#import "DataController.h"
#import "LocalSRMessageTool.h"
#import "SRTable.h"

//
@interface MessageController : DataController
<UIScrollViewDelegate,DataControllerPullReloadDelegate>
{
	//UIView *_itemPane;
    UIView * headerView;
    UIView * headLineView;
    SRTable * srTable;
    UILabel * subject_label;
    UILabel * time_label;
    UILabel * reloadLabel;
    //UILabel * checkOlderLabel;
    BOOL isCheckOld;
}

@property BOOL isNeedRefresh;

-(UIScrollView*)getSRTable;
-(CGFloat)getReloadHeaderHeight;
-(void)removeObservers;
-(void)addObservers;

-(void)onCacheKilled:(NSNotification*)notification;
@end