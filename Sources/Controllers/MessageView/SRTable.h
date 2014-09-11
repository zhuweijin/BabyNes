//
//  SRTable.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-17.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRTableCell.h"

@interface SRTable : UITableView<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property id<UIScrollViewDelegate> theSVDelegate;
//@property UIView * headerView;
@end
