//
//  MeterialVideoItemView.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-4.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "MeterialVideoItemView.h"

@implementation MeterialVideoItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

//
#define kThumbImageWidth 180 //120
#define kThumbImageHeight 120
- (id)initWithFrame:(CGRect)frame dict:(NSDictionary *)dict
{
    _Log(@"MeterialVideoItemView initWithFrame dict");
    
	self = [super initWithFrame:frame];
	//self.backgroundColor = UIColor.greenColor;
	
	CGRect imageFrame;
	imageFrame.origin.x = (frame.size.width - kThumbImageWidth) / 2;
	imageFrame.origin.y = imageFrame.origin.x;
	imageFrame.size.width = kThumbImageWidth;
	imageFrame.size.height = kThumbImageHeight;
	
	//
	CacheImageView *imageView = [[CacheImageView alloc] initWithFrame:imageFrame];
	imageView.contentMode = UIViewContentModeScaleAspectFit;
	//imageView.cacheImageUrl = dict[@"image"];
    [imageView setCacheImageUrl:dict[@"image"]];
    _Log(@"SINRI DEBUG MVV_PREVIEW_IMAGE=%@",dict[@"image"]);
	[self addSubview:imageView];
	
	imageView.backgroundColor = UIUtil::Color(239, 239, 241);
	imageView.clipsToBounds = YES;
	imageView.layer.cornerRadius = 4;
	imageView.layer.borderWidth = 1;
	imageView.layer.borderColor = UIUtil::Color(220,220,220).CGColor;
    
	//
	frame.origin.x = 12;
	frame.size.width -= 24;
	frame.origin.y = imageFrame.origin.y + imageFrame.size.height;
	frame.size.height = 40;
	UILabel *label = UIUtil::LabelWithFrame(frame, dict[@"name"], [UIFont systemFontOfSize:15], UIUtil::Color(100,100,100), NSTextAlignmentCenter);
	//label.backgroundColor = UIUtil::Color(194, 203, 235);
	label.numberOfLines = 0;
	[self addSubview:label];
    
	return self;
}

- (id)initWithFrame:(CGRect)frame dict:(NSDictionary *)dict isOLD:(BOOL)old
{
    _Log(@"MeterialVideoItemView initWithFrame dict");
    
	self = [super initWithFrame:frame];
	//self.backgroundColor = UIColor.greenColor;
	
	CGRect imageFrame;
	imageFrame.origin.x = (frame.size.width - kThumbImageWidth) / 2;
	imageFrame.origin.y = imageFrame.origin.x;
	imageFrame.size.width = kThumbImageWidth;
	imageFrame.size.height = kThumbImageHeight;
	
	//
	CacheImageView *imageView = [[CacheImageView alloc] initWithFrame:imageFrame];
	imageView.contentMode = UIViewContentModeScaleAspectFit;
	imageView.cacheImageUrl = dict[@"image"];
    _Log(@"SINRI DEBUG MVV_PREVIEW_IMAGE=%@",dict[@"image"]);
	[self addSubview:imageView];
	
	imageView.backgroundColor = UIUtil::Color(239, 239, 241);
	imageView.clipsToBounds = YES;
	imageView.layer.cornerRadius = 4;
	imageView.layer.borderWidth = 1;
	imageView.layer.borderColor = UIUtil::Color(220,220,220).CGColor;
    
	//
	frame.origin.x = 2;
	frame.size.width -= 4;
	frame.origin.y = imageFrame.origin.y + imageFrame.size.height;
	frame.size.height = 40;
	UILabel *label = UIUtil::LabelWithFrame(frame, dict[@"name"], [UIFont systemFontOfSize:15], UIUtil::Color(100,100,100), NSTextAlignmentCenter);
	//label.backgroundColor = UIColor.redColor;
	label.numberOfLines = 0;
	[self addSubview:label];
    
	return self;
}


@end
