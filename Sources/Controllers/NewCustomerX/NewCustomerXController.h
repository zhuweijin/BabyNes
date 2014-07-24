//
//  NewCustomerXController.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-19.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "DataController.h"
#import "LSCustomer.h"
#import "NCTableView.h"
#import "NCRootSubView.h"
#import "LSDialoger.h"

#import "NCCreateReconfrimSubView.h"


@interface NewCustomerXController : DataController//UIViewController
<NCTableViewDelegate,NCSubViewDelegate,NCCreateReconfrimSubViewDelegate>
{
    CGRect midFrame;
    CGRect rightFrame;
    CGRect leftFrame;
    
    int selection;
}

@property LSCustomer * NewCustomer;

@property UILabel * theTitleLabel;
@property UIView * theTopLineView;
@property UIButton * theExitButton;

@property NCTableView * theTableView;
@property NCRootSubView * subView;

@property UIButton * theBabyAddButton;
@property UIButton * theCustomerAddButton;

@end