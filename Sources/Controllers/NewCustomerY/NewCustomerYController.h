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

#import "LSOfflineTasks.h"
#import "LSSigner.h"
#import "UISignController.h"

#define SECTION_REMOVE_BABY_GATE 7632

@interface NewCustomerYController : DataController//UIViewController
<UITableViewDataSource,UITableViewDelegate,LSMixTableCellDelegate>
{
    
    UIView * recheckView;
    
    UILabel * recheckLabel;
    UIButton * recheckCancel;
    UIButton * recheckConfirm;
    
    LSSigner * signer;
    
    //NSString * searchedMobile;
    
}

@property (readonly) UIView * honbuView;

@property (atomic) LSCustomer * NewCustomer;

@property UILabel * theTitleLabel;
//@property UIView * theTopLineView;
@property UIButton * theExitButton;

@property UIButton * theBabyAddButton;
@property UIButton * theCustomerAddButton;

@property NSMutableArray * rowNumberArray;
@property LSMixTable * mixTable;
@property int focusingCellTag;

//-(void)focusToCell:(int)cellTag;
-(id)initWithSearchedMobile:(NSString*)sm;

@end
