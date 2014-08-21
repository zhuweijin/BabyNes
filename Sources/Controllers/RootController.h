
#import "PivotController.h"
#import "NewCustomerController.h"
#import "NewCustomerXController.h"
#import "NewCustomerYController.h"
#import "LoginController.h"
#import "SettingController.h"
#import "LSShopViewController.h"
#import "IntroduceController.h"
#import "MoviePlayer.h"
#import "MaterialController.h"
#import "MessageController.h"


//
@interface RootController : PivotController
{
    UIButton * newsBtn;
    BOOL isNeedHideStatusBar;
}

@property LSShopViewController * shopVC;
@property IntroduceController * intrVC;
@property MaterialController * mateVC;
@property MessageController * srVC;
@end