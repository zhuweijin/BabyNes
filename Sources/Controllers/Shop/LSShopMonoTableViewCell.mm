//
//  LSShopMonoTableViewCell.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-6-26.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "LSShopMonoTableViewCell.h"

@implementation LSShopMonoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void) loadProduct:(ProductEntity*) mono{
    if(//self.image ||
       self.image_view ||
       self.label){
        //NSLog(@"LSMonoTableViewCell Loaded...PASSOVER");
        
        [self.image_view removeFromSuperview];
        [self.label removeFromSuperview];
        
        //self.image=nil;
        self.image_view=nil;
        self.label=nil;
    }
    /*
    self.image=UIUtil::Image(mono.product_image);
    //NSLog(@"[loadMono] image name=%@ image=%@",image_name,self.image);
    CGFloat ihDch=self.image.size.height/60;
    self.image_view=[[UIImageView alloc]initWithFrame:];
    [self.image_view setImage:self.image];
    [self addSubview:self.image_view];
    */
    self.image_view = [[CacheImageView alloc] init];
	self.image_view.contentMode = UIViewContentModeScaleAspectFit;
	self.image_view.cacheImageUrl = mono.product_image;//dict[@"image"];
    //CGFloat ihDch=self.image_view.image.size.height/60;
    //_Log(@"image[%@]=[%@] ihDch=%f",mono.product_image,self.image_view.image,ihDch);
    //CGRect imageFrame=CGRectMake(40+(60-self.image_view.image.size.width/ihDch), 5, self.image_view.image.size.width/ihDch, self.image_view.image.size.height/ihDch);
    CGRect imageFrame=CGRectMake(40,5,80,60);
    self.image_view.frame=imageFrame;
    
    
    
	[self addSubview:self.image_view];
    
    self.label= [[UILabel alloc] initWithFrame:CGRectMake(150, 10, 300, 40)];
    self.label.text=mono.product_title;
//    self.label.text=[[mono.product_title stringByAppendingString:@"-"] stringByAppendingFormat:@"%d",mono.product_id];
    [self addSubview:self.label];
    
    [self setTag:mono.product_id];
}
/*
-(void) loadMonoWithName:(NSString*)name andImageName:(NSString*)image_name{
    if(self.image
       || self.image_view
       || self.label){
        //NSLog(@"LSMonoTableViewCell Loaded...PASSOVER");
        
        [self.image_view removeFromSuperview];
        [self.label removeFromSuperview];
        
        self.image=nil;
        self.image_view=nil;
        self.label=nil;
    }
    
    //self.backgroundColor=[UIColor greenColor];
    
    //self.image=[UIImage imageNamed:image_name];
    
    self.image=UIUtil::Image(image_name);
    //NSLog(@"[loadMono] image name=%@ image=%@",image_name,self.image);
    CGFloat ihDch=self.image.size.height/60;
    self.image_view=[[UIImageView alloc]initWithFrame:CGRectMake(40+(60-self.image.size.width/ihDch), 5, self.image.size.width/ihDch, self.image.size.height/ihDch)];
    //[self.imageView setFrame:CGRectMake(40+(60-self.image.size.width/ihDch), 5, self.image.size.width/ihDch, self.image.size.height/ihDch)];
    //[self.imageView setImage:self.image];
    [self.image_view setImage:self.image];
    [self addSubview:self.image_view];
    
    self.label= [[UILabel alloc] initWithFrame:CGRectMake(150, 10, 300, 40)];
    self.label.text=name;
    [self addSubview:self.label];
}
*/

@end
