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

-(void) loadMonoWithName:(NSString*)name andImageName:(NSString*)image_name{
    if(self.image
       //|| self.imageView
       || self.label){
        //NSLog(@"LSMonoTableViewCell Loaded...PASSOVER");
        return;
    }
    
    //self.backgroundColor=[UIColor greenColor];
    
    //self.image=[UIImage imageNamed:image_name];
    self.image=UIUtil::Image(image_name);
    NSLog(@"[loadMono] image name=%@ image=%@",image_name,self.image);
    CGFloat ihDch=self.image.size.height/60;
    //self.imageView=[[UIImageView alloc]initWithFrame:CGRectMake(40+(60-self.image.size.width/ihDch), 5, self.image.size.width/ihDch, self.image.size.height/ihDch)];
    [self.imageView setFrame:CGRectMake(40+(60-self.image.size.width/ihDch), 5, self.image.size.width/ihDch, self.image.size.height/ihDch)];
    [self.imageView setImage:self.image];
    //[self addSubview:self.image_view];
    
    self.label= [[UILabel alloc] initWithFrame:CGRectMake(150, 10, 300, 40)];
    self.label.text=name;
    [self addSubview:self.label];
}

@end
