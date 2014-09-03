//
//  ImagePreviewListView.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-9-2.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "ImagePreviewListView.h"

@implementation ImagePreviewListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _sep_length=5;
        imageArray=[[NSMutableArray alloc]init];
        //imageViewArray = [[NSMutableArray alloc]init];
        selectedDict=[[NSMutableDictionary alloc]init];
        
        image_height=self.frame.size.height-2*_sep_length;
        [self refreshView];
        tapper = [[UITapGestureRecognizer alloc]init];
        [tapper addTarget:self action:@selector(onTap:)];
        [tapper setNumberOfTapsRequired:1];
        [tapper setNumberOfTouchesRequired:1];
        [self addGestureRecognizer:tapper];
    }
    return self;
}

-(void)refreshView{
    CGFloat content_all_width=image_height*[imageArray count]+_sep_length*([imageArray count]+1);
    if(content_all_width>self.frame.size.width){
        self.contentSize=CGSizeMake(content_all_width, self.frame.size.height);
    }else{
        self.contentSize=CGSizeMake(self.frame.size.width, self.frame.size.height);
    }
    //    for (UIView * p in [self subviews]) {
    //        [p removeFromSuperview];
    //    }
    for (id p in imageViewArray) {
        [p removeFromSuperview];
    }
    imageViewArray = [[NSMutableArray alloc]init];
    for (int i=0;i<[imageArray count] ; i++) {
        UIImageView * image=[[UIImageView alloc]initWithImage:[imageArray objectAtIndex:i]];
        [image setFrame:(CGRectMake(_sep_length+i*(_sep_length+image_height), _sep_length, image_height, image_height))];
        [image setUserInteractionEnabled:NO];
        [self addSubview:image];
        [imageViewArray addObject:image];
        
        image.layer.borderWidth=0;
        image.layer.borderColor=[UIColor redColor].CGColor;
    }
}
-(NSArray*)getImageArray{
    return imageArray;
}
-(void)appendImage:(UIImage*)image{
    [imageArray addObject:image];
    [self refreshView];
}
-(void)removeImageAt:(NSInteger)index{
    @try {
        [imageArray removeObjectAtIndex:index];
        [self refreshView];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in removeImageAt: %@",exception);
    }
    @finally {
        //
    }
}

-(void)onTap:(id)sender{
    CGPoint p = [tapper locationInView:self];
    int index=(p.x-_sep_length)/(_sep_length+image_height);
    _Log(@"tap...in (%f,%f) index=%d",p.x,p.y,index);
    if(index>=0 && index<[imageViewArray count]){
        [self setImageCell:index];
    }
    
}
-(void)setImageCell:(NSUInteger)index{
    UIImageView * image=[imageViewArray objectAtIndex:index];
    if(image){
        id r=[selectedDict objectForKey:[NSNumber numberWithInteger:index]];
        if(r && [r boolValue]){
            image.layer.borderWidth=0;
            //image.layer.borderColor=[UIColor redColor].CGColor;
            [selectedDict setObject:@NO forKey:[NSNumber numberWithInteger:index]];
        }else{
            image.layer.borderWidth=3;
            //image.layer.borderColor=[UIColor redColor].CGColor;
            [selectedDict setObject:@YES forKey:[NSNumber numberWithInteger:index]];
        }
    }
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
