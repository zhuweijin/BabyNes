//
//  NCTableViewCell.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-22.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "NCTableViewCell.h"

@implementation NCTableViewCell

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

-(void)setCellWithTitle:(NSString *)title withPreview:(NSString*)preview{
    if(_cellTitle){
        [_cellTitle removeFromSuperview];
        _cellTitle=nil;
    }
    
    _cellTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 30)];
    [_cellTitle setText:title];
    [self addSubview:_cellTitle];
    
    [self setCellWithPreview:preview];
}

-(void)setCellWithPreview:(NSString*)preview{
    if(_cellPreview){
        [_cellPreview removeFromSuperview];
        _cellPreview = nil;
    }
    _cellPreview=[[UILabel alloc]initWithFrame:CGRectMake(250, 5, 200, 30)];
    [_cellPreview setText:preview];
    [_cellPreview setAlpha:0.8];
    [self addSubview:_cellPreview];
}

@end
