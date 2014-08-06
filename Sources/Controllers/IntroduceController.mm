
#import "IntroduceController.h"
#import "IntroduceItemView.h"
#import "IntroduceMonoDetailView.h"
#import <QuartzCore/QuartzCore.h>
#import "LSVersionManager.h"

static CGFloat reloadHeaderHeight=40;

static int MonoNumberInRow=3;

@implementation IntroduceController

#pragma mark Generic methods

// Constructor
- (id)init
{
    is_reloading=false;
	self = [super initWithService:@"pdt_classify"];
	self.title = NSLocalizedString(@"Introduce", @"产品介绍");
    
    self.thePullReloadDelegate=self;
    cate_id=0;
    

    
	return self;
}

#pragma mark View methods

// Creates the view that the controller manages.
//- (void)loadView
//{
//	[super loadView];
//}

// Do additional setup after loading the view.
//- (void)viewDidLoad
//{
//	[super viewDidLoad];
//}

// Called after the view controller's view is released and set to nil.
//- (void)viewDidUnload
//{
//	[super viewDidUnload];
//}

// Called when the view is about to made visible.
//- (void)viewWillAppear:(BOOL)animated
//{
//	[super viewWillAppear:animated];
//}

// Called after the view was dismissed, covered or otherwise hidden.
//- (void)viewWillDisappear:(BOOL)animated
//{
//	[super viewWillDisappear:animated];
//}

#pragma Event methods

//
- (void)loadContentView:(UIView *)contentView withDict:(NSDictionary *)dict
{
    is_reloading=false;
    [self responseForReloadWork];
    _Log(@"IntroduceController reload (loadContentView) !");
    
    [LSVersionManager DownloadAllFiles_PDT_WithDict:dict isForce:NO];
    
	_itemPanes = [[NSMutableDictionary alloc]init];
    cateButtonDict=[[NSMutableDictionary alloc]init];
    
    if(catePane!=nil){
        [catePane removeFromSuperview];
        catePane=nil;
    }
    
    catePane = [[UIView alloc] initWithFrame:CGRectMake(contentView.frame.size.width - 370, 0, 370, contentView.frame.size.height)];
	catePane.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
	catePane.backgroundColor = UIUtil::Color(150,150,150);//UIUtil::Color(148, 189, 233);
	
    [[catePane layer] setShadowOffset:{-1, 0.0}];
    [[catePane layer] setShadowRadius:2];
    [[catePane layer] setShadowOpacity:1];
    [[catePane layer] setShadowColor:[UIColor grayColor].CGColor];
    
    [contentView addSubview:catePane];
	
	NSInteger i = 0;
	CGRect frame = CGRectMake(0, 0, 370, (catePane.frame.size.height - 1 * 3)/4);
    //CGRect frame = CGRectMake(0, 0, 370, (catePane.frame.size.height - 0.5 * 3)/4);
	for (NSDictionary *cate in dict[@"category"])
	{
        catePane.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        
        CateImageButton * button=[[CateImageButton alloc]initWithFrame:frame withTitle:cate[@"name"] withTag:(i++) withCacheImageURL:cate[@"image"]];
        [button addTarget:self action:@selector(cateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [catePane addSubview:button];
		frame.origin.y += frame.size.height + 1;
        //frame.origin.y += frame.size.height + 0.5;
        
        [cateButtonDict setValue:button forKey:cate[@"name"]];
	}
    
    //[self cateButtonClicked:nil];
    [self cateButtonClicked:nil anywayCateId:cate_id];
}
- (void)cateButtonClicked:(UIButton *)sender{
    [self cateButtonClicked:sender anywayCateId:sender.tag];
}
//
//- (void)cateButtonClicked:(UIButton *)sender
- (void)cateButtonClicked:(UIButton *)sender anywayCateId:(int)sender_tag
{
	[_itemPane removeFromSuperview];
	
    //cate_id=sender.tag;
    cate_id=sender_tag;
    _Log(@"IntroduceController cateButtonClicked anywayCateId=%d cate_id to be %d",sender_tag,cate_id);
    
	//NSDictionary *cate = _loader.dict[@"category"][sender.tag];
    NSDictionary *cate = _loader.dict[@"category"][sender_tag];
	_itemPane = _itemPanes[cate[@"value"]];
	if (_itemPane == nil)
	{
		CGRect frame = CGRectMake(0, 0, _contentView.frame.size.width - 370, _contentView.frame.size.height);
		if (cate[@"url"])
		{
            /*
             _itemPane = [[UIWebView alloc] initWithFrame:frame];
             [(UIWebView *)_itemPane loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:cate[@"url"]]]];
             */
            
            CGRect wvframe = CGRectMake(0, reloadHeaderHeight, _contentView.frame.size.width - 370-5, _contentView.frame.size.height);
            UIWebView *webView=[[UIWebView alloc] initWithFrame:wvframe];
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:cate[@"url"]]]];
            
            _itemPane = [[UIScrollView alloc] initWithFrame:frame];
			//_itemPane.backgroundColor = UIUtil::Color(242,244,246);
            _itemPane.backgroundColor=[UIColor clearColor];
            
            [_itemPane addSubview:webView];
            
            CGFloat h=_itemPane.frame.size.height+reloadHeaderHeight;
            
            ((UIScrollView *)_itemPane).contentSize = CGSizeMake(_itemPane.frame.size.width, h);
            ((UIScrollView *)_itemPane).contentOffset=CGPointMake(0, reloadHeaderHeight);
            ((UIScrollView *)_itemPane).delegate=self;
            
            reloadLabel=[[UILabel alloc]initWithFrame:{0,10,_itemPane.frame.size.width,reloadHeaderHeight-20}];
            [reloadLabel setTextColor:[UIColor grayColor]];
            [reloadLabel setText:NSLocalizedString(@"Pull to reload", @"下拉以刷新")];
            [reloadLabel setTextAlignment:(NSTextAlignmentCenter)];
            [_itemPane addSubview:reloadLabel];
		}
		else
		{
			_itemPane = [[UIScrollView alloc] initWithFrame:frame];
			//_itemPane.backgroundColor = UIUtil::Color(242,244,246);
			_itemPane.backgroundColor=[UIColor clearColor];
			CGFloat width = ceil(frame.size.width / MonoNumberInRow);
			//CGRect frame = {0, 0, width, width};
            CGRect frame = {0, reloadHeaderHeight, width, width};
			NSUInteger i = 0;
			for (NSDictionary *item in _loader.dict[cate[@"value"]])	// TODO: 解析
			{
				IntroduceItemView *view = [[IntroduceItemView alloc] initWithFrame:frame dict:item];
				view.tag = i;
				UIUtil::AddTapGesture(view, self, @selector(itemButtonClicked:));
				[_itemPane addSubview:view];
				
				//
				if (++i % MonoNumberInRow == 0)
				{
					frame.origin.x = 0;
					frame.origin.y += frame.size.width;
				}
				else
				{
					frame.origin.x += frame.size.width;
				}
			}
            CGFloat gap=20;
			//((UIScrollView *)_itemPane).contentSize = CGSizeMake(_itemPane.frame.size.width, frame.origin.y + (i % 3 != 0) * (frame.size.height + gap));
            CGFloat h=frame.origin.y + (i % MonoNumberInRow != 0) * (frame.size.height + gap);
            
            if(h<=_itemPane.frame.size.height+reloadHeaderHeight){
                h=_itemPane.frame.size.height+reloadHeaderHeight;
            }
            
            ((UIScrollView *)_itemPane).contentSize = CGSizeMake(_itemPane.frame.size.width, h);
            ((UIScrollView *)_itemPane).contentOffset=CGPointMake(0, reloadHeaderHeight);
            ((UIScrollView *)_itemPane).delegate=self;
            
            reloadLabel=[[UILabel alloc]initWithFrame:{0,10,_itemPane.frame.size.width,reloadHeaderHeight-20}];
            [reloadLabel setTextColor:[UIColor grayColor]];
            [reloadLabel setText:NSLocalizedString(@"Pull to reload", @"下拉以刷新")];
            [reloadLabel setTextAlignment:(NSTextAlignmentCenter)];
            [_itemPane addSubview:reloadLabel];
		}
		
		_itemPane.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		_itemPanes[cate[@"value"]] = _itemPane;
	}
    
    //_Log(@"cate btn dict= [%@]",cateButtonDict);
    
    for (UIButton * btn in [cateButtonDict allValues]) {
        //_Log(@"btn.tag = %d ~ sender.tag = %d",btn.tag,sender_tag);
        //if(btn.tag==sender.tag){
        if(btn.tag==sender_tag){
            btn.backgroundColor=UIUtil::Color(117, 114, 184) ;
            [btn setHighlighted:YES];
        }else{
            btn.backgroundColor=UIUtil::Color(148, 189, 233);
            [btn setHighlighted:NO];
        }
    }
    
    [((UIScrollView*)_itemPane) setScrollsToTop:NO];
	[_contentView addSubview:_itemPane];
}

//
- (void)itemButtonClicked:(UITapGestureRecognizer *)sender
{
    int i=-1;
    id cate;
    for (cate in _loader.dict[@"category"]) {
        i++;
        _Log(@"IntroduceController itemButtonClicked FOR i=%d",i);
        if(i==cate_id){
            break;
        }
    }
    _Log(@"IntroduceController itemButtonClicked tag=%d cate=[%@] group=[%@]",cate_id,cate,_loader.dict[cate[@"value"]]);
	//NSDictionary *item = _loader.dict[@"capsule"][sender.view.tag];
    NSDictionary *item = _loader.dict[cate[@"value"]][sender.view.tag];
	_Log(@"IntroduceController itemButtonClicked --> dict=[%@]",item);
    CGRect frame = _itemPane.frame;
    [_itemPane removeFromSuperview];
    UIScrollView * sv;
    sv = [[UIScrollView alloc] initWithFrame:frame];
    sv.backgroundColor = UIUtil::Color(242,244,246);//[UIColor redColor];
    
    
    for (int i=0;i<[item[@"products"] count];i++){
        id product=[item[@"products"] objectAtIndex:i];
        CGRect subFrame=CGRectMake((frame.size.width)*i, 0, (frame.size.width), frame.size.height);
        IntroduceMonoDetailView * dmv=[[IntroduceMonoDetailView alloc]initWithFrame:subFrame withPid:[product objectForKey:@"pid"]];
        if(i%2==0){
            [dmv setBackgroundColor:[UIColor whiteColor]];
        }else{
            [dmv setBackgroundColor:[UIColor colorWithWhite:50 alpha:0.8]];
        }
        [sv addSubview:dmv];
    }
    [sv setPagingEnabled:YES];
    sv.contentSize = CGSizeMake(frame.size.width*[item[@"products"]count], sv.frame.size.height);
    sv.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _itemPane=sv;
    [_contentView addSubview:_itemPane];
}

#pragma UIViewScrollerDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!is_reloading) { // 判断是否处于刷新状态，刷新中就不执行
        if(-scrollView.contentOffset.y>reloadHeaderHeight*2){
            //_Log(@"IntroduceController scrollViewDidScroll: height=%f offset.y=%f",scrollView.contentSize.height,scrollView.contentOffset.y);
            
            _Log(@"IntroduceController reloadBegin(c=%d)",cate_id);
            is_reloading=true;
            [self responseForReloadWork];
            return;
        }
    }
    if(!decelerate && scrollView.contentOffset.y>=0 && scrollView.contentOffset.y<=reloadHeaderHeight){
        [scrollView scrollRectToVisible:{0,reloadHeaderHeight,scrollView.frame.size.width,scrollView.frame.size.height} animated:YES];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    @try {
        _Log(@"IntroduceController scrollViewDidEndDecelerating sV=[%@]",scrollView);
        if(!is_reloading && scrollView.contentOffset.y<reloadHeaderHeight){
            [scrollView scrollRectToVisible:{0,reloadHeaderHeight,scrollView.frame.size.width,scrollView.frame.size.height} animated:YES];
        }
    }
    @catch (NSException *exception) {
        _Log(@"~");
    }
    @finally {
        //_Log(@"~~");
    }
    
}

-(void)receiveVerisonUpdatePush{
    if(!is_reloading){
        is_reloading=YES;
        [self responseForReloadWork];
    }
}

-(void)responseForReloadWork{
    _Log(@"IntroduceController responseForReloadWork isWithError=%@",_loader.errorString);
    if(is_reloading){
        if(![LSDeviceInfo isNetworkOn]){
            //UIUtil::ShowAlert(NSLocalizedString(@"Please check your network status.", @"请检查网络状态。"));
            is_reloading=NO;
            [((UIScrollView *)_itemPane) scrollRectToVisible:{0,reloadHeaderHeight,_itemPane.frame.size.width,_itemPane.frame.size.height} animated:YES];
            return;
        }
    }
    if(is_reloading){
        [_loader loadBegin];
        [reloadLabel setText:NSLocalizedString(@"Loading...", @"加载中...")];
        //[self.view.window setUserInteractionEnabled:NO];
        [((UIScrollView *)_itemPane) scrollRectToVisible:{0,0,_itemPane.frame.size.width,_itemPane.frame.size.height} animated:YES];
        
        //转转 开始
        UIViewController *controller = [self respondsToSelector:@selector(view)] ? (UIViewController *)self : UIUtil::VisibleViewController();
		[controller.view toastWithLoading];
		_LogLine();
        
        //_Log(@"responseForReloadWork to 0,0");
        //_Log(@"IntroductController responseForReloadWork begin reload done");
    }else{
        [reloadLabel setText:NSLocalizedString(@"Pull to reload", @"下拉以刷新")];
        
        [((UIScrollView *)_itemPane) scrollRectToVisible:{0,reloadHeaderHeight,_itemPane.frame.size.width,_itemPane.frame.size.height} animated:YES];
        //_Log(@"responseForReloadWork to 0,reloadHeaderHeight");
        //[self.view.window setUserInteractionEnabled:YES];
        //_Log(@"IntroductController responseForReloadWork end reload done");
        
        //转转 消失
        UIViewController *controller = [self respondsToSelector:@selector(view)] ? (UIViewController *)self : UIUtil::VisibleViewController();
		[controller.view dismissToast];
		_LogLine();
    }
}

@end
