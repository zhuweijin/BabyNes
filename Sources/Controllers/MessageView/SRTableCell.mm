//
//  SRTableCell.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-17.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "SRTableCell.h"

@implementation SRTableCell

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

-(void)setSRMessage:(SRMessage*)sr_msg{
    _msg=sr_msg;
    NSDate * date= [NSDate dateWithTimeIntervalSince1970:[_msg time]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    
    //Optionally for time zone converstions
    //[formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
    
    NSString *stringFromDate = [formatter stringFromDate:date];

    //NSString * text=[NSString stringWithFormat:@"%d-%@ (%@)",[_msg srid],[_msg title],date];
    //[[self textLabel]setText:text];
    if(_titleLabel){
        [_titleLabel removeFromSuperview];
    }
    if(_timeLabel){
        [_timeLabel removeFromSuperview];
    }
    _titleLabel=[[UILabel alloc] initWithFrame:{100,0,550,50}];
    //[_titleLabel setBackgroundColor:[UIColor redColor]];
    [_titleLabel setText:[_msg title]];
    [self addSubview:_titleLabel];
    
    _timeLabel=[[UILabel alloc] initWithFrame:{800,0,250,50}];
    //[_timeLabel setBackgroundColor:[UIColor redColor]];
    //[_timeLabel setText:[date description]];
    [_timeLabel setText:stringFromDate];
    [self addSubview:_timeLabel];
    
    if([_msg reported]){
        [[self imageView]setImage:UIUtil::ImageNamed(@"mailreported")];
    }else{
        if([_msg read]){
            //[_titleLabel setTextColor:[UIColor blackColor]];
            [[self imageView]setImage:UIUtil::ImageNamed(@"mailopened")];
        }else{
            //[_titleLabel setTextColor:[UIColor redColor]];
            [[self imageView]setImage:UIUtil::ImageNamed(@"mailnew")];
        }
        
    }
    
//    if([_msg read]){
//        [_titleLabel setTextColor:[UIColor blackColor]];
//    }else{
//        [_titleLabel setTextColor:[UIColor redColor]];
//    }
    //_Log(@"SRTableCell setSRMessage:%@",text);
}

@end
