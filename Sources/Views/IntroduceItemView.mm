

#import "IntroduceItemView.h"


@implementation IntroduceItemView

//
#define kThumbImageWidth 120
#define kThumbImageHeight 120
- (id)initWithFrame:(CGRect)frame dict:(NSDictionary *)dict
{
	self = [super initWithFrame:frame];
	//self.backgroundColor = UIColor.greenColor;
	
	CGRect imageFrame;
	imageFrame.origin.x = (frame.size.width - kThumbImageWidth) / 2;
	imageFrame.origin.y = imageFrame.origin.x;
	imageFrame.size.width = kThumbImageWidth;
	imageFrame.size.height = kThumbImageHeight;
	
	//
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
	imageView.contentMode = UIViewContentModeScaleAspectFit;
	imageView.cacheImageUrl = dict[@"image"];
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

