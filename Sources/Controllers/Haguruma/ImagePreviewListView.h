//
//  ImagePreviewListView.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-9-2.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagePreviewListView : UIScrollView
{

    NSMutableArray * imageArray;
    NSMutableArray * imageViewArray;
    UITapGestureRecognizer * tapper;
    CGFloat image_height;
    NSMutableDictionary * selectedDict;
}
@property CGFloat sep_length;
-(void)refreshView;
-(NSArray*)getImageArray;
-(void)appendImage:(UIImage*)image;
-(void)removeImageAt:(NSInteger)index;
-(void)removeSelectedImages;
@end
/*
@interface LSPreviewImageCell : UIImageView
@property NSInteger cell_id;
@end
*/