//
//  IntroduceMonoDetailView.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-7.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"
#import "CacheDataLoader.h"

@interface IntroduceMonoDetailView : UIView<DataLoaderDelegate>{
    CacheDataLoader * cache_data_loader;
    
    CacheImageView * mono_image_view;
    CacheImageView * mono_detailed_image_view;
    //CacheImageButton * mono_detailed_image_view;
    //UILabel * mono_info_label;
    UITextView *mono_text_view;
}

-(id)initWithFrame:(CGRect)frame withPid:(NSString*)pid;
-(void)loadProduct:(NSDictionary*)dict;
@end
