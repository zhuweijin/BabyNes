
#import "MessageController.h"
#import "IntroduceItemView.h"

@implementation MessageController

#pragma mark Generic methods

static CGFloat reloadHeaderHeight=40;

// Constructor
- (id)init
{
    NSDictionary * dict=@{@"after":[NSNumber numberWithInt:[LocalSRMessageTool getSRAPIAfterParamValue]]};
	self = [super initWithService:@"SRCheck" params:dict];
	_loader.jsonOptions = NSJSONReadingMutableContainers;
	self.title = NSLocalizedString(@"SR Center", @"消息中心");
    self.thePullReloadDelegate=self;
	return self;
}
-(UIScrollView*)getSRTable{
    return srTable;
}

-(CGFloat)getReloadHeaderHeight{
    return reloadHeaderHeight;
}

#pragma mark View methods

-(void)removeObservers{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SRReceiptSenderDone" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"CacheKilled" object:nil];
}
-(void)addObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSRReceiptSenderDone:) name:@"SRReceiptSenderDone" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCacheKilled:) name:@"CacheKilled" object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self removeObservers];
    [self addObservers];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeObservers];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _Log(@"srVC offset.y=%f",[[self getSRTable] contentOffset].y);
    [self scrollViewDidEndDragging:[self getSRTable] willDecelerate:NO];
    
    [srTable reloadData];
}

#pragma Event methods

//
- (void)loadContentView:(UIView *)contentView withDict:(NSDictionary *)dict
{
    //[self addDTBtn];
    _Log(@"MessageController loadContentView with dict=%@",dict);
    //NSDictionary* mySR=
    [LocalSRMessageTool LocalSRMessageDictionaryMergedWithArray:dict[@"messages"]];
    //_LogLine();
    if(srTable){
        [srTable removeFromSuperview];
        srTable=nil;
    }
    if(headerView){
        [headerView removeFromSuperview];
        headerView=nil;
    }
    if(headLineView){
        [headLineView removeFromSuperview];
        headLineView=nil;
    }
    if(subject_label){
        [subject_label removeFromSuperview];
        subject_label=nil;
    }
    if(time_label){
        [time_label removeFromSuperview];
        time_label=nil;
    }
    /*
     if(checkOlderLabel){
     [checkOlderLabel removeFromSuperview];
     checkOlderLabel=nil;
     }
     */
    CGFloat header_height=50;
    
    CGRect frame=self.view.frame;
    frame.origin.x=10;
    frame.origin.y=10+header_height;
    frame.size.width-=20;
    frame.size.height-=(20+header_height);
    
    srTable=[[SRTable alloc]initWithFrame:frame style:(UITableViewStylePlain)];
    [srTable setDataSource:srTable];
    [srTable setDelegate:srTable];
    [srTable setRowHeight:50];
    [srTable setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
    [srTable setScrollsToTop:NO];
    [self.view addSubview:srTable];
    
    reloadLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,-reloadHeaderHeight,srTable.frame.size.width,reloadHeaderHeight)];
    [reloadLabel setTextColor:[UIColor grayColor]];
    [reloadLabel setText:NSLocalizedString(@"Pull down to check new SR message", @"下拉以查收新的业务消息")];
    [reloadLabel setTextAlignment:(NSTextAlignmentCenter)];
    //[self setReloadLabelHidden:YES];
    [srTable setTableHeaderView:reloadLabel];
    /*
     checkOlderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,srTable.frame.size.width,reloadHeaderHeight)];
     [checkOlderLabel setTextColor:[UIColor grayColor]];
     [checkOlderLabel setTextAlignment:(NSTextAlignmentCenter)];
     [checkOlderLabel setText:NSLocalizedString(@"Pull to check SR messages earlier", @"上拉以加载更早的业务消息")];
     [self setCheckOlderLabelHidden:YES];
     */
    //[(UIScrollView*)srTable addSubview:reloadLabel];
    //[srTable setContentSize:{srTable.frame.size.width,srTable.frame.size.height+reloadHeaderHeight}];
    [srTable setContentSize:{frame.size.width,frame.size.height+reloadHeaderHeight}];
    //[srTable scrollRectToVisible:{0,0,srTable.frame.size.width,srTable.frame.size.height} animated:YES];
    [srTable scrollRectToVisible:{0,static_cast<CGFloat>(reloadHeaderHeight),srTable.frame.size.width,srTable.frame.size.height} animated:YES];
    
    //[(UIScrollView*)srTable setContentOffset:CGPointMake(0,reloadHeaderHeight)];
    
    [srTable setTheSVDelegate:self];
    
    headerView=[[UIView alloc]initWithFrame:CGRectMake(10, 10, srTable.frame.size.width, header_height)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:headerView];
    
    headLineView = [[UIView alloc]initWithFrame:{0,header_height,headerView.frame.size.width,1}];
    [headLineView setBackgroundColor:[UIColor grayColor]];
    [headerView addSubview:headLineView];
    
    subject_label=[[UILabel alloc]initWithFrame:CGRectMake(100, 0, 100, header_height)];
    [subject_label setText:NSLocalizedString(@"Subject", @"消息主题")];
    //[subject_label setTextAlignment:(NSTextAlignmentCenter)];
    [subject_label setTintColor:[UIColor blackColor]];
    //[subject_label setBackgroundColor:[UIColor greenColor]];
    [headerView addSubview:subject_label];
    
    time_label=[[UILabel alloc]initWithFrame:CGRectMake(800, 0, 100, header_height)];
    [time_label setText:NSLocalizedString(@"Sent Time", @"发布时间")];
    //[time_label setTextAlignment:(NSTextAlignmentCenter)];
    [time_label setTintColor:[UIColor blackColor]];
    //[time_label setBackgroundColor:[UIColor greenColor]];
    [headerView addSubview:time_label];
    
    is_reloading=NO;
}


#pragma UIViewScrollerDelegate

-(void)setReloadLabelHidden:(BOOL)toHide{
    if(toHide){
        [reloadLabel setHidden:YES];
        [reloadLabel setFrame:CGRectZero];
    }else{
        [reloadLabel setHidden:NO];
        [reloadLabel setFrame:CGRectMake(0,0,srTable.frame.size.width,reloadHeaderHeight)];
    }
    [srTable setTableHeaderView:reloadLabel];
}
/*
 -(void)setCheckOlderLabelHidden:(BOOL)toHide{
 if(toHide){
 [checkOlderLabel setHidden:YES];
 [checkOlderLabel setFrame:CGRectZero];
 }else{
 [checkOlderLabel setHidden:NO];
 [checkOlderLabel setFrame:CGRectMake(0,0,srTable.frame.size.width,reloadHeaderHeight)];
 }
 [srTable setTableFooterView:checkOlderLabel];
 }
 */
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //[self setReloadLabelHidden:NO];
    
    //[self setCheckOlderLabelHidden:NO];
}

-(BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    return NO;
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if(targetContentOffset->y<reloadHeaderHeight){
        //_Log(@"MessageController scrollViewWillEndDragging withVelocity targetContentOffset.y=%f to do",targetContentOffset->y);
        [scrollView setContentOffset:{0,static_cast<CGFloat>(reloadHeaderHeight)} animated:YES];
        targetContentOffset->y=scrollView.contentOffset.y;
        //_Log(@"MessageController scrollViewWillEndDragging withVelocity targetContentOffset.y=%f set done",targetContentOffset->y);
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //[self setReloadLabelHidden:YES];
    if (!is_reloading) { // 判断是否处于刷新状态，刷新中就不执行
        if(-scrollView.contentOffset.y>reloadHeaderHeight*2){
            //[self setCheckOlderLabelHidden:YES];
            _Log(@"SR到顶查找新消息");
            is_reloading=YES;
            isCheckOld=NO;
            [self responseForReloadWork];
            return;
        }
        if(scrollView.contentOffset.y > ((scrollView.contentSize.height - scrollView.frame.size.height))){
            //_Log(@"显示查找更久远信息的label");
            //[self setCheckOlderLabelHidden:NO];
        }
        _Log(@"SR下拉到最底部 %f~%f",scrollView.contentOffset.y , reloadHeaderHeight+((scrollView.contentSize.height - scrollView.frame.size.height)));
        if(scrollView.contentOffset.y > reloadHeaderHeight+((scrollView.contentSize.height - scrollView.frame.size.height))){
            _Log(@"SR下拉到最底部时显示更多数据");
            is_reloading=YES;
            isCheckOld=YES;
            [self responseForReloadWork];
            return;
        }
        /*
         else{
         [self setCheckOlderLabelHidden:YES];
         }
         */
    }
    _Log(@"MessageController scrollViewDidEndDragging not response as ing[%d] %f - %d",is_reloading,scrollView.contentOffset.y,decelerate);
    //[self setReloadLabelHidden:YES];
    //[scrollView setContentOffset:{0,reloadHeaderHeight} animated:YES];
    if(!decelerate && scrollView.contentOffset.y<=reloadHeaderHeight){
        //_Log(@"MessageController scrollViewDidEndDragging GO anyway");
        [scrollView setContentOffset:{0,static_cast<CGFloat>(reloadHeaderHeight)} animated:YES];
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    @try {
        //_Log(@"MessageController scrollViewDidEndDecelerating as ing[%d] at offset.y=%f",is_reloading,scrollView.contentOffset.y);
        if(!is_reloading && scrollView.contentOffset.y<reloadHeaderHeight){
            //_Log(@"MessageController scrollViewDidEndDecelerating as I ing[%d] at offset.y=%f",is_reloading,scrollView.contentOffset.y);
            [scrollView setContentOffset:{0,static_cast<CGFloat>(reloadHeaderHeight)} animated:YES];
            //_Log(@"MessageController scrollViewDidEndDecelerating as II ing[%d] at offset.y=%f",is_reloading,scrollView.contentOffset.y);
        }
        /*
         if(!is_reloading){
         [self setCheckOlderLabelHidden:YES];
         }
         */
    }
    @catch (NSException *exception) {
        _Log(@"~");
    }
    @finally {
        //_Log(@"~~");
        //[self setReloadLabelHidden:NO];
    }
}

-(void)responseForReloadWork{
    _Log(@"MessageController responseForReloadWork isWithError=%@ is_reloading=%d",_loader.errorString,is_reloading);
    if(is_reloading){
        if(isCheckOld){//CHECK OLD
            NSNumber * num=[NSNumber numberWithInt:[LocalSRMessageTool getSRAPIBeforeParamValue]];
            if([num integerValue]<=1){
                is_reloading=NO;
                return;
            }
            NSDictionary * dict=@{@"before":num};
            [_loader setParams:dict];
            [_loader loadBegin];
            //[checkOlderLabel setText:NSLocalizedString(@"Loading...", @"加载中...")];
            //[self.view.window setUserInteractionEnabled:NO];
            [srTable scrollRectToVisible:{0,0,srTable.frame.size.width,srTable.frame.size.height} animated:YES];
            
            //转转 开始
            UIViewController *controller = [self respondsToSelector:@selector(view)] ? (UIViewController *)self : UIUtil::VisibleViewController();
            [controller.view toastWithLoading];
            _LogLine();
            
            //_Log(@"MessageController responseForReloadWork to 0,0");
            _Log(@"MessageController responseForReloadWork begin reload done");
        }else{//CHECK NEW
            NSDictionary * dict=@{@"after":[NSNumber numberWithInt:[LocalSRMessageTool getSRAPIAfterParamValue]]};
            [_loader setParams:dict];
            [_loader loadBegin];
            [reloadLabel setText:NSLocalizedString(@"Loading...", @"加载中...")];
            //[self.view.window setUserInteractionEnabled:NO];
            [srTable scrollRectToVisible:{0,0,srTable.frame.size.width,srTable.frame.size.height} animated:YES];
            
            //转转 开始
            UIViewController *controller = [self respondsToSelector:@selector(view)] ? (UIViewController *)self : UIUtil::VisibleViewController();
            [controller.view toastWithLoading];
            _LogLine();
            
            //_Log(@"MessageController responseForReloadWork to 0,0");
            _Log(@"MessageController responseForReloadWork begin reload done");
        }
    }else{
        //[self setCheckOlderLabelHidden:YES];
        if(isCheckOld) {
            //[checkOlderLabel setText:NSLocalizedString(@"Pull to check SR messages earlier", @"上拉以加载更早的业务消息")];
            CGFloat lastY=srTable.contentSize.height-srTable.frame.size.height;
            if(lastY<reloadHeaderHeight){
                lastY=reloadHeaderHeight;
            }
            [srTable setContentOffset:{0,lastY} animated:YES];
            _Log(@"查找老消息之后恢复为Y偏移为%f",lastY);
            //[srTable scrollRectToVisible:{0,static_cast<CGFloat>(reloadHeaderHeight),srTable.frame.size.width,srTable.frame.size.height} animated:YES];
            //_Log(@"MessageController responseForReloadWork to 0,reloadHeaderHeight");
            //[self.view.window setUserInteractionEnabled:YES];
            
            //转转 消失
            UIViewController *controller = [self respondsToSelector:@selector(view)] ? (UIViewController *)self : UIUtil::VisibleViewController();
            [controller.view dismissToast];
            _LogLine();
        }else{
            [reloadLabel setText:NSLocalizedString(@"Pull down to check new SR message", @"下拉以查收新的业务消息")];
            
            [srTable scrollRectToVisible:{0,static_cast<CGFloat>(reloadHeaderHeight),srTable.frame.size.width,srTable.frame.size.height} animated:YES];
            //_Log(@"MessageController responseForReloadWork to 0,reloadHeaderHeight");
            //[self.view.window setUserInteractionEnabled:YES];
            
            //转转 消失
            UIViewController *controller = [self respondsToSelector:@selector(view)] ? (UIViewController *)self : UIUtil::VisibleViewController();
            [controller.view dismissToast];
            _LogLine();
        }
        
        _Log(@"MessageController responseForReloadWork end reload done");
    }
}
/*
 -(void)showSRurl:(NSNotification*)notification{
 SRMessage* srm=notification.object;
 _Log(@"MessageController showSRurl : %@",[srm logAbstract]);
 }
 */

-(void)onSRReceiptSenderDone:(NSNotification*)notification{
    //[srTable reloadData];
}

-(void)onCacheKilled:(NSNotification*)notification{
    _Log(@"MessageController onCacheKilled - -");
    [srTable reloadData];
    [_loader loadBegin];
}

#pragma mark -
#pragma mark for dirtyToken test
-(void)addDTBtn{
    UIButton * btn=[UIButton buttonWithType:(UIButtonTypeInfoDark)];
    [btn setFrame:{100,100,100,50}];
    [btn setTitle:@"Dirty Token" forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(dirtToken:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
}
-(void)dirtToken:(id)sender{
    [DataLoader setAccessToken:@"lalala"];
    _Log(@"dirtToken => %@",[DataLoader accessToken]);
}
@end
