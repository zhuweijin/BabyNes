//
//  LSPopViewController.h
//  LSMixTableLib
//
//  Created by 倪 李俊 on 14-7-25.
//  Copyright (c) 2014年 Sinri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSMixTable.h"
#import "LSCustomer.h"
#import "DataController.h"

@interface NewCustomerYController : DataController//UIViewController
<UITableViewDataSource,UITableViewDelegate,LSMixTableCellDelegate>
{
    
    UIView * recheckView;
    
    UILabel * recheckLabel;
    UIButton * recheckCancel;
    UIButton * recheckConfirm;
    
}
@property LSCustomer * NewCustomer;

@property UILabel * theTitleLabel;
//@property UIView * theTopLineView;
@property UIButton * theExitButton;

@property UIButton * theBabyAddButton;
@property UIButton * theCustomerAddButton;

@property NSMutableArray * rowNumberArray;
@property LSMixTable * mixTable;
@property int focusingCellTag;

//-(void)focusToCell:(int)cellTag;

@end
