//
//  LSComboBox.h
//  BabyNesPOS_Akatsuki
//
//  Created by 倪 李俊 on 14-6-23.
//  Copyright (c) 2014年 Leqee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSComboBoxCell.h"
//#import "LSViewController.h"

@interface LSComboBox : UIControl <UITableViewDataSource,UITableViewDelegate>

@property UITextField * theTextfield;
@property UIButton * theArrowButton;

@property NSMutableArray * theArray;
@property UITableView * theList;

@property NSString * setsumei;
@property NSString * value_string;

@property UIViewController * theController;


- (void)designView;
- (id)initWithFrame:(CGRect)frame withinController:(UIViewController*)controller;
- (id)initWithFrame:(CGRect)frame withinController:(UIViewController*)controller withData:(NSArray*)array withSetsumei:(NSString*)theSetsumei;

-(void) loadDataForSelection:(NSArray *) array;
-(void) reloadDataForSelection:(NSArray *) array;

-(void)arrowButtonGo:(id)sender;

-(void)select_item:(id)sender;
@end