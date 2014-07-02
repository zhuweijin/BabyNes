//
//  NewCustomerController.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-6-27.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSComboBox.h"
#import "LSNewCustomer_BabyCell.h"
#import "DataController.h"
#import "LSCustomer.h"

@interface NewCustomerController : DataController//UIViewController

@property UIView * theTopLineView;
@property UILabel * theTitleLabel;

@property UILabel * theCustomerLabel;
@property UILabel * theCustomerTitleLabel;
@property UILabel * theCustomerNameLabel;
@property UILabel * theCustomerLocationLabel;
@property UILabel * theCustomerMobileLabel;

@property UILabel * theCustomerEmailLabel;
@property UILabel * theCustomerAddressLabel;

@property LSComboBox * theTitleCB;
@property LSComboBox * theProvinceCB;
@property LSComboBox * theCityCB;

@property UITextField * theAddressTextfield;

@property UITextField * theUserNameTextfield;
@property UITextField * theMobileTextfield;

@property UITextField * theEmailTextfield;

@property UIButton * theCustomerAddButton;
@property UIButton * theBabyAddButton;

@property UIButton * theExitButton;

@property NSMutableArray * baby_cells;

@property UIScrollView * InfoScrollView;

- (void)designView;

@end
