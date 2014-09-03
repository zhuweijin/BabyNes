//
//  LSShopViewController.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-6-26.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

//#import <UIKit/UIKit.h>
//#import "AutoWizardController.h"

#import "DataController.h"
//#import "LSShopMonoTableViewController.h"
#import "MonoTable.h"
//#import "LSShopCartTableViewController.h"
#import "CartTable.h"
//#import "LSCustomerSearchViewController.h"
//#import "NewCustomerXController.h"
#import "NewCustomerYController.h"

#import "RMAFeedbackViewController.h"

#import "CartEntity.h"

@interface LSShopViewController :  DataController//UIViewController
<UITextFieldDelegate,UIAlertViewDelegate,UIScrollViewDelegate,DataControllerPullReloadDelegate>
{
    UILabel * reloadLabel;
    NSInteger appear_count;
    
    UIActivityIndicatorView * searchCustomerAI;
}
-(void)addObservers;
-(void)removeObservers;

-(void)onCacheKilled:(NSNotification*)notification;

@end
