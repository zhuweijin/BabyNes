
#import "MaterialController.h"
#import "MeterialImageItemView.h"
#import "MeterialVideoItemView.h"
#import "MWPhotoBrowser.h"
#import "ServerConfig.h"

static CGFloat CateItemWidth=200;//370;
static int MonoNumberInRow=4;

static CGFloat reloadHeaderHeight=40;

@implementation MaterialController

#pragma mark Generic methods

// Constructor
- (id)init
{
	self = [super initWithService:@"material"];
	self.title = NSLocalizedString(@"Material", @"媒介中心");
    
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

-(void)refreshIdlePRVideo:(BOOL)force_refresh{
    NetworkStatus network_status=[LSDeviceInfo currentNetworkType];
    if(network_status==ReachableViaWiFi){
        NSString*idle_video_url=[[ServerConfig getServerConfig]getURL_idle_video];
        NSString * cache_path = NSUtil::CacheUrlPath(idle_video_url);
        if(force_refresh || !NSUtil::IsFileExist(cache_path)){
            _Log(@"refreshIdlePRVideo[%@]->[%@]",idle_video_url,cache_path);
            [FileDownloader ariseNewDownloadTaskForURL:idle_video_url withAccessToken:[DataLoader accessToken]];
        }
    }
   
}

-(void)refreshDownloadAllFilesWithDict:(NSDictionary *)dict isForce:(BOOL)force_refresh{
    // NotReachable = 0,ReachableViaWiFi,ReachableViaWWAN
    NetworkStatus network_status=[LSDeviceInfo currentNetworkType];
    if(network_status==ReachableViaWiFi){
        for (NSDictionary *cate in dict[@"category"]){
            for (NSDictionary *item in dict[cate[@"value"]]){
                NSString* file_level_url=[item objectForKey:@"file"];
                NSString * cache_path = NSUtil::CacheUrlPath(file_level_url);
                if(force_refresh || !NSUtil::IsFileExist(cache_path)){
                    _Log(@"refreshDownloadAllFilesWithDict[%@]->[%@]",file_level_url,cache_path);
                    [FileDownloader ariseNewDownloadTaskForURL:file_level_url withAccessToken:[DataLoader accessToken]];
                }
            }
        }
    }
}
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    _Log(@"MeterialController viewWillAppear");
}
//
- (void)loadContentView:(UIView *)contentView withDict:(NSDictionary *)dict
{
    is_reloading=false;
    [self responseForReloadWork];
    _Log(@"MeterialController loadContentView");
    
 	_itemPanes = [[NSMutableDictionary alloc]init];
	cateButtonDict=[[NSMutableDictionary alloc]init];
    [self refreshIdlePRVideo:NO];
    [self refreshDownloadAllFilesWithDict:dict isForce:NO];
    
    if(catePane!=nil){
        [catePane removeFromSuperview];
        catePane=nil;
    }
    
    catePane = [[UIView alloc] initWithFrame:CGRectMake(contentView.frame.size.width - CateItemWidth, 0, CateItemWidth, contentView.frame.size.height)];
	catePane.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
	catePane.backgroundColor = UIUtil::Color(150,150,150);//UIUtil::Color(148, 189, 233);
	[contentView addSubview:catePane];
	
	NSInteger i = 0;
	//CGRect frame = CGRectMake(0, 0, 370, (catePane.frame.size.height - 0.5 * MonoNumberInRow)/4);
    //CGRect frame = CGRectMake(0, 0, CateItemWidth, (catePane.frame.size.height - 0.5 * MonoNumberInRow)/[[dict objectForKey:@"category"] count]);
    CGRect frame = CGRectMake(0, 0, CateItemWidth, (catePane.frame.size.height - 1 * MonoNumberInRow)/[[dict objectForKey:@"category"] count]);
	for (NSDictionary *cate in dict[@"category"])
	{
        UIButton *button = [[UIButton alloc] initWithFrame:frame];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:30];
		catePane.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
		//[button setBackgroundImage:UIUtil::ImageWithColor(148, 189, 233) forState:UIControlStateNormal];
		[button setBackgroundImage:UIUtil::ImageWithColor(117, 114, 184) forState:UIControlStateHighlighted];
		[button setTitle:cate[@"name"] forState:UIControlStateNormal];
		[catePane addSubview:button];
		[button addTarget:self action:@selector(cateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
		button.tag = i++;
        
		//frame.origin.y += frame.size.height + 0.5;
        frame.origin.y += frame.size.height + 1;
        
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
	
	NSMutableDictionary *cate = _loader.dict[@"category"][sender_tag];
    cate_id=sender_tag;
    
    _Log(@"Material dict=[%@] cate=[%@] cate_id=[%d]",_loader.dict,cate,cate_id);
	_itemPane = _itemPanes[cate[@"value"]];
	if (_itemPane == nil)
	{
        //_Log(@"cateButtonClicked CATE=[%@]",cate);
		CGRect frame = CGRectMake(0, 0, _contentView.frame.size.width - CateItemWidth, _contentView.frame.size.height);
		if ([cate[@"value"] isEqualToString:@"video"])
		{
			_itemPane = [[UIScrollView alloc] initWithFrame:frame];
			_itemPane.backgroundColor = UIUtil::Color(242,244,246);
			
			CGFloat width = ceil(frame.size.width / MonoNumberInRow);
			//CGRect frame = {0, 0, width, width};
            CGRect frame = {0, reloadHeaderHeight, width, width};
			NSUInteger i = 0;
			for (NSDictionary *item in _loader.dict[cate[@"value"]])	// TODO: 解析
			{
				MeterialVideoItemView *view = [[MeterialVideoItemView alloc] initWithFrame:frame dict:item];
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
            CGFloat h=frame.origin.y + (i % 3 != 0) * (frame.size.height + gap);
            if(h<=_itemPane.frame.size.height){
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
		else
		{
			_itemPane = [[UIScrollView alloc] initWithFrame:frame];
			_itemPane.backgroundColor = UIUtil::Color(242,244,246);
			
			CGFloat width = ceil(frame.size.width / MonoNumberInRow);
			//CGRect frame = {0, 0, width, width};
            CGRect frame = {0, reloadHeaderHeight, width, width};
			NSUInteger i = 0;
			for (NSDictionary *item in _loader.dict[cate[@"value"]])	// TODO: 解析
			{
				MeterialImageItemView *view = [[MeterialImageItemView alloc] initWithFrame:frame dict:item];
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
            CGFloat h=frame.origin.y + (i % 3 != 0) * (frame.size.height + gap);
            if(h<=_itemPane.frame.size.height){
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
        if(btn.tag==sender_tag){
            btn.backgroundColor=UIUtil::Color(117, 114, 184) ;
            [btn setHighlighted:YES];
        }else{
            btn.backgroundColor=UIUtil::Color(148, 189, 233);
            [btn setHighlighted:NO];
        }
    }
    
	[_contentView addSubview:_itemPane];
}
//
- (void)itemButtonClicked:(UITapGestureRecognizer *)sender
{
	//NSDictionary *item = _loader.dict[@"capsule"][sender.view.tag];
    int btn_tag = sender.view.tag;
    
    
    if(cate_id==0){
        //video
        NSString * file_url=[[[_loader.dict objectForKey:@"video"]objectAtIndex:btn_tag] objectForKey:@"file"];
        NSString * cache_path = NSUtil::CacheUrlPath(file_url);
        NSString * final_video_url=nil;
        NSString * file_name=[[[_loader.dict objectForKey:@"video"]objectAtIndex:btn_tag] objectForKey:@"name"];
        // NotReachable = 0,ReachableViaWiFi,ReachableViaWWAN
        NetworkStatus network_status=[LSDeviceInfo currentNetworkType];
        if(NSUtil::IsFileExist(cache_path)){
            _Log(@"Cache Video File [%@] for url [%@] existed",cache_path,file_url);
            final_video_url=cache_path;
        }else{
            _Log(@"Cache Video File [%@] for url [%@] not existed",cache_path,file_url);
            if(network_status==ReachableViaWiFi){
                final_video_url=file_url;
            }else if(network_status==ReachableViaWWAN){
                DialogUIAlertView *the_WWAN_alertview = [[DialogUIAlertView alloc] initWithTitle:NSLocalizedString(@"Paid Network Warning", @"付费网络提醒") message:NSLocalizedString(@"You are not using Wi-Fi now, the download task would cause to addtional payment. Please decide if you still want to continue.",@"目前您处在非Wi-Fi网络环境，下载可能会产生额外费用。您可以取消以避免下载引起的流量费用。") cancelButtonTitle:NSLocalizedString(@"Cancel", @"取消") otherButtonTitles:NSLocalizedString(@"Continue to view", @"继续观看"), nil];
                int ret =[the_WWAN_alertview showDialog];//cancel=0, continue=1
                if(ret==1)final_video_url=file_url;
            }else{
                UIUtil::ShowAlert(NSLocalizedString(@"Sorry but there is no network available.", @"抱歉，目前无可用网络。"));
            }
        }
        
        if(final_video_url!=nil){
            NSDictionary * dict=@{@"file": final_video_url,
                                  @"name":file_name};
            [[NSNotificationCenter defaultCenter]postNotificationName:@"PR_CALLED" object:dict];
            _Log(@"Video btn_tag = %d - %d play net[%d] url=[%@]",cate_id,btn_tag,network_status,file_url);
        }else{
            _Log(@"Video btn_tag = %d - %d cancel net[%d] url=[%@]",cate_id,btn_tag,network_status,file_url);
        }
    }else if (cate_id==1)
	{
		// Create browser
		MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:(id<MWPhotoBrowserDelegate>)self];
		browser.displayActionButton = YES;
		//browser.wantsFullScreenLayout = NO;
		[browser setInitialPageIndex:btn_tag];
		
		browser.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
		UIUtil::PresentModalNavigationController(self, browser).navigationBar.translucent = YES;
    }
    
}

#pragma mark - MWPhotoBrowserDelegate

//
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
	return [_loader.dict[@"image"] count];
}

//
- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
	NSString * url = _loader.dict[@"image"][index][@"file"];
	return [MWPhoto photoWithUrl:url];
}

//- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index {
//	MWPhoto *photo = [self.photos objectAtIndex:index];
//	MWCaptionView *captionView = [[MWCaptionView alloc] initWithPhoto:photo];
//	return [captionView autorelease];
//}

#pragma UIViewScrollerDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!is_reloading) { // 判断是否处于刷新状态，刷新中就不执行
        if(-scrollView.contentOffset.y>reloadHeaderHeight*2){
            //_Log(@"IntroduceController scrollViewDidScroll: height=%f offset.y=%f",scrollView.contentSize.height,scrollView.contentOffset.y);
            
            _Log(@"MaterialController reloadBegin(c=%d)",cate_id);
            is_reloading=true;
            [self responseForReloadWork];
            return;
        }
    }
    {
        [(UIScrollView*)_itemPane scrollRectToVisible:{0,reloadHeaderHeight,_itemPane.frame.size.width,_itemPane.frame.size.height} animated:YES];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    @try {
        _Log(@"MaterialController scrollViewDidEndDecelerating sV=[%@]",scrollView);
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

-(void)responseForReloadWork{
    _Log(@"MaterialController responseForReloadWork isWithError=%@",_loader.errorString);
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
        
        [self refreshIdlePRVideo:YES];
        [self refreshDownloadAllFilesWithDict:_loader.dict isForce:YES];
    }
}



@end
