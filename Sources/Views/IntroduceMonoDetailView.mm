//
//  IntroduceMonoDetailView.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-7.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "IntroduceMonoDetailView.h"

@implementation IntroduceMonoDetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame withPid:(NSString*)pid{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        cache_data_loader=[[CacheDataLoader alloc]init];
        cache_data_loader.delegate = self;
        cache_data_loader.service = [[@"pdt_detail.php?" stringByAppendingString:[NSString stringWithFormat:@"pid=%@",pid]] stringByAppendingString:@"&gomi="];
        cache_data_loader.params =nil;
  /*
  @{//@"token": [DataLoader accessToken],
                                     //@"pid":pid,
                                     @"version":@"0"};
   */
        [cache_data_loader loadBegin];
        //[self loadProduct:pid];
    }
    return self;
}

- (void)loadEnded:(DataLoader *)loader
{
	_Log(@"load Ended with Dict [%@]", loader.dict);
	if (loader.error == DataLoaderNoError)
	{
		[self loadProduct:loader.dict];
	}else{
        _Log(@"MonoDetail load failed...%d:%@",loader.error,loader.errorString);
        //UIUtil::ShowAlert(NSLocalizedString(@"Failed to load the details of the product.", @"加载产品详情失败。"));
    }
}

-(void)loadProduct:(NSDictionary*)dict{
    
    NSString * info=[NSString stringWithFormat:
                     //NSLocalizedString(@"Product Name： %@\nSKU Number： %@\nNet Wt./Specification： %@\nCapacity： %@\nOrigin: %@\nPrice： %@", @"产品名称： %@\nSKU 编号： %@\n净含量/规格： %@\n容量： %@\n产地: %@\n价格： %@"),
                     NSLocalizedString(@"Product Name： %@\n\nSKU Number： %@\n\nNet Wt./Specification： %@\n\nCapacity： %@\n\nOrigin: %@\n\nPrice： %@", @"产品名称： %@\n\nSKU 编号： %@\n\n净含量/规格： %@\n\n容量： %@\n\n产地: %@\n\n价格： %@"),
                     dict[@"product_name"],
                     dict[@"sku_number"],
                     dict[@"net_weight"],
                     dict[@"volume"],
                     dict[@"origin_place"],
                     dict[@"market_price"]
                     ];
    
    CGRect whole_frame=self.frame;
    CGFloat small_image_width=75*4;
    CGFloat small_image_height=75*3;
    CGFloat big_image_width=whole_frame.size.width-20;
    CGFloat big_image_height=(whole_frame.size.width-20)/4.0*3;
    mono_image_view=[[CacheImageView alloc]initWithFrame:CGRectMake(5,5,small_image_width,small_image_height)];
    mono_info_label=[[UILabel alloc]initWithFrame:CGRectMake(small_image_width+10,5,whole_frame.size.width-small_image_width-10,small_image_height)];
    mono_detailed_image_view=[[CacheImageView alloc]initWithFrame:CGRectMake(5,small_image_height+10,big_image_width,big_image_height)];
    //mono_detailed_image_view=[[CacheImageButton alloc]initWithFrame:CGRectMake(5,small_image_height+10,big_image_width,big_image_height)];
    
    [mono_image_view setCacheImageUrl:dict[@"small_image"]];
    [mono_detailed_image_view setCacheImageUrl:dict[@"big_image"]];
    [mono_info_label setLineBreakMode:(NSLineBreakByCharWrapping)];
    [mono_info_label setNumberOfLines:0];
    [mono_info_label setText:info];
    /*
    [mono_detailed_image_view addTarget:self action:@selector(viewBigImage:) forControlEvents:(UIControlEventTouchDragInside)];
    */
    [self addSubview:mono_image_view];
    [self addSubview:mono_detailed_image_view];
    [self addSubview:mono_info_label];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
/*
-(void)viewBigImage:(id)sender{
    // Create browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:(id<MWPhotoBrowserDelegate>)self];
    browser.displayActionButton = YES;
    //browser.wantsFullScreenLayout = NO;
    [browser setInitialPageIndex:0];
    
    browser.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    UIUtil::PresentModalNavigationController(self.window.rootViewController, browser).navigationBar.translucent = YES;
    
    _Log(@"viewBigImage : %@",browser);
}


#pragma mark - MWPhotoBrowserDelegate

//
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
	return 1;//[_loader.dict[@"image"] count];
}

//
- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
	NSString * url = cache_data_loader.dict[@"big_image"];
	return [MWPhoto photoWithUrl:url];
}

//- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index {
//	MWPhoto *photo = [self.photos objectAtIndex:index];
//	MWCaptionView *captionView = [[MWCaptionView alloc] initWithPhoto:photo];
//	return [captionView autorelease];
//}
*/

@end
