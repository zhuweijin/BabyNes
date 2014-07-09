//
//  CateImageButton.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-8.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "CateImageButton.h"

@implementation CateImageButton

- (id)initWithFrame:(CGRect)frame withTitle:(NSString*)title withTag:(int)tag withCacheImageURL:(NSString*)url
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if(url==nil || [url isEqual:[NSNull null]]){
            _label=[[UILabel alloc]initWithFrame:CGRectMake(frame.size.width*0.1, 0, frame.size.width*0.8, frame.size.height)];
        }else{
            _label=[[UILabel alloc]initWithFrame:CGRectMake(frame.size.width*0.1, 0, frame.size.width*0.5, frame.size.height)];
        }
        
        _label.font = [UIFont boldSystemFontOfSize:30];
        _label.textColor=[UIColor whiteColor];
        [_label setText:title];
        [_label setTextAlignment:(NSTextAlignmentCenter)];
		
		
		//[self setBackgroundImage:UIUtil::ImageWithColor(148, 189, 233) forState:UIControlStateNormal];
		[self setBackgroundImage:UIUtil::ImageWithColor(117, 114, 184) forState:UIControlStateHighlighted];
		self.tag = tag;
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//设置button的内容横向居中。。设置content是title和image一起变化
        
        _cacheImageView=[[CacheImageView alloc]initWithFrame:CGRectMake(frame.size.width*0.6+0*(frame.size.width*0.4-frame.size.height*0.6)/2, frame.size.height*0.2, frame.size.height*0.6, frame.size.height*0.6)];
        _cacheImageView.cacheImageUrl = url;
        [_cacheImageView.layer setCornerRadius:CGRectGetHeight([_cacheImageView bounds]) / 2];
        _cacheImageView.layer.masksToBounds = YES;
        //然后再给图层添加一个有色的边框，类似qq空间头像那样
        _cacheImageView.layer.borderWidth = 0;
        _cacheImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        _cacheImageView.layer.contents = (id) [_cacheImageView.image CGImage];
        
        //[button setTitleEdgeInsets:(UIEdgeInsetsMake(0, 100, 0, 10))];
        
        [self addSubview:_label];
        [self addSubview:_cacheImageView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
