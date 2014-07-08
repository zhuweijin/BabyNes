
#import "IntroduceController.h"
#import "IntroduceItemView.h"
#import "IntroduceMonoDetailView.h"

@implementation IntroduceController

#pragma mark Generic methods

// Constructor
- (id)init
{
	self = [super initWithService:@"pdt_classify"];
	_loader.jsonOptions = NSJSONReadingMutableContainers;
	self.title = NSLocalizedString(@"Introduce", @"产品介绍");
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
    cateButtonDict=[[NSMutableDictionary alloc]init];
    
	UIView *catePane = [[UIView alloc] initWithFrame:CGRectMake(contentView.frame.size.width - 370, 0, 370, contentView.frame.size.height)];
	catePane.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
	catePane.backgroundColor = UIUtil::Color(148, 189, 233);//UIUtil::Color(224,228,222);
	[contentView addSubview:catePane];
	
	NSInteger i = 0;
	CGRect frame = CGRectMake(0, 0, 370, (catePane.frame.size.height - 0.5 * 3)/4);
	for (NSDictionary *cate in dict[@"category"])
	{
        
		UIButton *button = [[CacheImageButton alloc] initWithFrame:frame];
		button.titleLabel.font = [UIFont boldSystemFontOfSize:30];
		catePane.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
		button.cacheImageUrl = cate[@"image"];
		//[button setBackgroundImage:UIUtil::ImageWithColor(148, 189, 233) forState:UIControlStateNormal];
		[button setBackgroundImage:UIUtil::ImageWithColor(117, 114, 184) forState:UIControlStateHighlighted];
		[button setTitle:cate[@"name"] forState:UIControlStateNormal];
		[catePane addSubview:button];
		[button addTarget:self action:@selector(cateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
		button.tag = i++;
        
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//设置button的内容横向居中。。设置content是title和image一起变化
        [button.imageView.layer setCornerRadius:CGRectGetHeight([button.imageView bounds]) / 2];
        button.imageView.layer.masksToBounds = YES;
        //然后再给图层添加一个有色的边框，类似qq空间头像那样
        button.imageView.layer.borderWidth = 5;
        button.imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        button.imageView.layer.contents = (id) [button.imageView.image CGImage];
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
	
    cate_id=sender.tag;
    
	NSMutableDictionary *cate = _loader.dict[@"category"][sender.tag];
	if (cate[@"VIEW"] == nil)
	{
		CGRect frame = CGRectMake(0, 0, _contentView.frame.size.width - 370, _contentView.frame.size.height);
		if (cate[@"url"])
		{
			_itemPane = [[UIWebView alloc] initWithFrame:frame];
			[(UIWebView *)_itemPane loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:cate[@"url"]]]];
		}
		else
		{
			_itemPane = [[UIScrollView alloc] initWithFrame:frame];
			_itemPane.backgroundColor = UIUtil::Color(242,244,246);
			
			CGFloat width = ceil(frame.size.width / 3);
			CGRect frame = {0, 0, width, width};
			NSUInteger i = 0;
			for (NSDictionary *item in _loader.dict[cate[@"value"]])	// TODO: 解析
			{
				IntroduceItemView *view = [[IntroduceItemView alloc] initWithFrame:frame dict:item];
				view.tag = i;
				UIUtil::AddTapGesture(view, self, @selector(itemButtonClicked:));
				[_itemPane addSubview:view];
				
				//
				if (++i % 3 == 0)
				{
					frame.origin.x = 0;
					frame.origin.y += frame.size.width;
				}
				else
				{
					frame.origin.x += frame.size.width;
				}
			}
			//((UIScrollView *)_itemPane).contentSize = CGSizeMake(_itemPane.frame.size.width, frame.origin.y + (i % 3 != 0) * (frame.size.height + gap));
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
	NSDictionary *item = _loader.dict[@"capsule"][sender.view.tag];
	_Log(@"Introduce Item Button Clicked --> dict=[%@]",item);
    CGRect frame = _itemPane.frame;
    [_itemPane removeFromSuperview];
    UIScrollView * sv;
    sv = [[UIScrollView alloc] initWithFrame:frame];
    sv.backgroundColor = UIUtil::Color(242,244,246);//[UIColor redColor];
    
    
    for (int i=0;i<[item[@"products"] count];i++){
        id product=[item[@"products"] objectAtIndex:i];
        CGRect subFrame=CGRectMake((frame.size.width)*i, 5, (frame.size.width), frame.size.height);
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

@end
