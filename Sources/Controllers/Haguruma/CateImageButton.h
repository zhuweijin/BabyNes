//
//  CateImageButton.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-8.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CateImageButton : UIButton

@property CacheImageView * cacheImageView;
@property UILabel * label;

- (id)initWithFrame:(CGRect)frame withTitle:(NSString*)title withTag:(int)tag withCacheImageURL:(NSString*)url;

@end
