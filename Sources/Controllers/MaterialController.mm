
#import "MaterialController.h"
#import "MeterialImageItemView.h"
#import "MeterialVideoItemView.h"

static CGFloat CateItemWidth=200;//370;
static int MonoNumberInRow=4;

@implementation MaterialController

#pragma mark Generic methods

// Constructor
- (id)init
{
	self = [super initWithService:@"material"];
    _loader.jsonOptions = NSJSONReadingMutableContainers;
	self.title = NSLocalizedString(@"Material", @"媒介中心");
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
    _Log(@"MeterialController loadContentView");
    
    cateButtonDict=[[NSMutableDictionary alloc]init];
    
    [self refreshDownloadAllFilesWithDict:dict isForce:NO];
    
    UIView *catePane = [[UIView alloc] initWithFrame:CGRectMake(contentView.frame.size.width - CateItemWidth, 0, CateItemWidth, contentView.frame.size.height)];
	catePane.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
	catePane.backgroundColor = [UIColor grayColor];//UIUtil::Color(224,228,222);
	[contentView addSubview:catePane];
	
	NSInteger i = 0;
	//CGRect frame = CGRectMake(0, 0, 370, (catePane.frame.size.height - 0.5 * MonoNumberInRow)/4);
    CGRect frame = CGRectMake(0, 0, CateItemWidth, (catePane.frame.size.height - 0.5 * MonoNumberInRow)/[[dict objectForKey:@"category"] count]);
	for (NSDictionary *cate in dict[@"category"])
	{
        UIButton *button = [[UIButton alloc] initWithFrame:frame];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:30];
		catePane.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
		//[button setBackgroundImage:UIUtil::ImageWithColor(148, 189, 233) forState:UIControlStateNormal];
		//[button setBackgroundImage:UIUtil::ImageWithColor(117, 114, 184) forState:UIControlStateHighlighted];
		[button setTitle:cate[@"name"] forState:UIControlStateNormal];
		[catePane addSubview:button];
		[button addTarget:self action:@selector(cateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
		button.tag = i++;
        
		frame.origin.y += frame.size.height + 0.5;
        
        [cateButtonDict setValue:button forKey:cate[@"name"]];
	}
	[self cateButtonClicked:nil];
    cate_id=0;

}

//
- (void)cateButtonClicked:(UIButton *)sender
{
	[_itemPane removeFromSuperview];
	
	NSMutableDictionary *cate = _loader.dict[@"category"][sender.tag];
    cate_id=sender.tag;
    
    _Log(@"Material dict=[%@] cate=[%@] cate_id=[%d]",_loader.dict,cate,cate_id);
    
	if (cate[@"VIEW"] == nil)
	{
        //_Log(@"cateButtonClicked CATE=[%@]",cate);
		CGRect frame = CGRectMake(0, 0, _contentView.frame.size.width - CateItemWidth, _contentView.frame.size.height);
		if ([cate[@"value"] isEqualToString:@"video"])//非常神奇的事情，有image的反而是视频。。这个预览。
		{
			_itemPane = [[UIScrollView alloc] initWithFrame:frame];
			_itemPane.backgroundColor = UIUtil::Color(242,244,246);
			
			CGFloat width = ceil(frame.size.width / MonoNumberInRow);
			CGRect frame = {0, 0, width, width};
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
			//((UIScrollView *)_itemPane).contentSize = CGSizeMake(_itemPane.frame.size.width, frame.origin.y + (i % MonoNumberInRow != 0) * (frame.size.height + gap));
		}
		else
		{
			_itemPane = [[UIScrollView alloc] initWithFrame:frame];
			_itemPane.backgroundColor = UIUtil::Color(242,244,246);
			
			CGFloat width = ceil(frame.size.width / MonoNumberInRow);
			CGRect frame = {0, 0, width, width};
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
			//((UIScrollView *)_itemPane).contentSize = CGSizeMake(_itemPane.frame.size.width, frame.origin.y + (i % MonoNumberInRow != 0) * (frame.size.height + gap));
		}
		
		_itemPane.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
		cate[@"VIEW"] = _itemPane;
	}
	else
	{
		_itemPane = cate[@"VIEW"];
	}
    
    _Log(@"cate btn dict= [%@]",cateButtonDict);

    for (UIButton * btn in [cateButtonDict allValues]) {
        _Log(@"btn.tag = %d ~ sender.tag = %d",btn.tag,sender.tag);
        if(btn.tag==sender.tag){
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
    
    NSString * file_name=[[[_loader.dict objectForKey:@"video"]objectAtIndex:btn_tag] objectForKey:@"name"];
    if(cate_id==0){
        //video
        NSString * file_url=[[[_loader.dict objectForKey:@"video"]objectAtIndex:btn_tag] objectForKey:@"file"];
        
        
        NSString * cache_path = NSUtil::CacheUrlPath(file_url);
        NSString * final_video_url=nil;
        
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
                UIUtil::ShowAlert(NSLocalizedString(@"Sorry but there is not network available.", @"抱歉，目前无可用网络。"));
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
    }else if (cate_id==1){
        //image
        NSString * file_url=[[[_loader.dict objectForKey:@"picture"]objectAtIndex:btn_tag]objectForKey:@"file"];
        //UIUtil::ShowAlert([NSString stringWithFormat:@"Image btn_tag = %d - %d url=[%@]",cate_id,btn_tag,file_url]);
        
        NSString * cache_path = NSUtil::CacheUrlPath(file_url);
        
        UIImage *image = [UIImage imageWithContentsOfFile:cache_path];//[UIImage imageNamed:UIUtil::IsPad() ? @"DefaultPad" : (UIUtil::IsPhone5() ? @"Default-568h" : @"Default")];
        NSDictionary * dict=@{@"file": image,
                              @"name":file_name};
        [[NSNotificationCenter defaultCenter]postNotificationName:@"PR_PHOTO_CALLED" object:dict];
        /*
        PRPhotoPlayer *pp =[[PRPhotoPlayer alloc]initWithImage:image withTitle:file_name];
        [pp setModalPresentationStyle:(UIModalPresentationFullScreen)];
        [pp setModalTransitionStyle:(UIModalTransitionStyleFlipHorizontal)];
        [self presentViewController:pp animated:YES completion:^{
            _Log(@"show pp done");
        }];
         */
    }
    
}

@end
