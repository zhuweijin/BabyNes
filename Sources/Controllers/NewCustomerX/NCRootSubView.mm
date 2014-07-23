//
//  NCRootSubView.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-21.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "NCRootSubView.h"

static CGFloat BarHeight=40;

@implementation NCRootSubView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame withDelegate:(id<NCSubViewDelegate>) delegate{
    self = [super initWithFrame:frame];
    if(self){
        _delegate=delegate;
        [self designView:0];
    }
    return self;
}

-(void)designView:(int)tag{
    if(tag==0){
        _topBarView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, BarHeight)];
        [_topBarView setBackgroundColor:[UIColor colorWithRed:157/255.0 green:153/255.0 blue:190/255.0 alpha:0.9]];
        //[_topBarView setBackgroundColor:[UIColor whiteColor]];
        //[[_topBarView layer]setOpacity:0.8];
        //_topBarView.layer.borderWidth = 1;
        //_topBarView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        [self addSubview:_topBarView];
        
        //_backButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, self.frame.size.width/4, 40)];
        _backButton=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
        [_backButton setFrame:CGRectMake(10, 5, 80, 30)];
        //[[_backButton titleLabel] setText:@"BACK"];
        [[_backButton titleLabel]setFont:[UIFont systemFontOfSize:20]];
        [_backButton setTitle:@"Back" forState:(UIControlStateNormal)];
        [[_backButton titleLabel] setTintColor:[UIColor blueColor]];
        [[_backButton titleLabel]setTextAlignment:(NSTextAlignmentLeft)];
        [_backButton addTarget:self action:@selector(onBackButton:) forControlEvents:(UIControlEventTouchUpInside)];
        //[_backButton setBackgroundColor:[UIColor redColor]];
        [_topBarView addSubview:_backButton];
        /*
        _cancelButton=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
        [_cancelButton setFrame:CGRectMake(self.frame.size.width/3*2, 10, self.frame.size.width/4, 20)];
        [[_cancelButton titleLabel]setTextAlignment:(NSTextAlignmentRight)];
        [_backButton addTarget:self action:@selector(onCancelButton:) forControlEvents:(UIControlEventTouchUpInside)];
        [_topBarView addSubview:_cancelButton];
        */
        _contentView =[[UIView alloc]initWithFrame:CGRectMake(0, BarHeight, self.frame.size.width, self.frame.size.height-BarHeight)];
        [self addSubview:_contentView];
    }
}

-(void)setBarTitle:(NSString*)title{
    if(_barTitleLabel)[_barTitleLabel removeFromSuperview];
    _barTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(100, 5, self.frame.size.width-200, 30)];
    [_barTitleLabel setText:title];
    [_barTitleLabel setFont:[UIFont systemFontOfSize:20]];
    [_barTitleLabel setTextAlignment:(NSTextAlignmentCenter)];
    [_topBarView addSubview:_barTitleLabel];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)onBackButton:(id)sender{
    //TODO save data changes
    [_delegate tableUnloadSubViewToRight:self];
}
-(void)onCancelButton:(id)sender{
    [_delegate tableUnloadSubViewToRight:self];
}

-(void)setWithCustomer:(LSCustomer*)customer{
    
}
-(void)setWithBaby:(LSBaby *)baby{
    
}

@end
