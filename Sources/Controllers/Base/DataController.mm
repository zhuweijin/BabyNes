
#import "DataController.h"
#import "LSVersionManager.h"
#import "JDStatusBarNotification.h"

@implementation DataController

#pragma mark Generic methods

// Constructor
- (id)initWithService:(NSString *)service params:(NSDictionary *)params
{
    //_Log(@"DataController initWithService[%@] params[%@] called",service,params);
	self = [super init];
	_loader = [[CacheDataLoader alloc] init];
	_loader.delegate = self;
	_loader.service = service;
	_loader.params = params;
    
    //A Test.
    is_reloading=NO;
    
    _is_expired=NO;
    
    _forceOnline=NO;
    if([service isEqualToString:@"SRCheck"]){
        [((CacheDataLoader*)_loader) forceOnline];
    }
    
	return self;
}

//
- (id)initWithService:(NSString *)service
{
    //_Log(@"DataController initWithService[%@] called",service);
	self = [self initWithService:service params:nil];
	return self;
}

#pragma mark View methods

// Creates the view that the controller manages.
//- (void)loadView
//{
//	[super loadView];
//}

-(void)removeObservers{
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"ReceiveForceUpdateVersionPush" object:nil];
}
-(void)addObservers{
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveVerisonUpdatePush) name:@"ReceiveForceUpdateVersionPush" object:nil];
}

// Do additional setup after loading the view.
- (void)viewDidLoad
{
	[super viewDidLoad];
    if(_forceOnline)[_loader forceOnline];
	[_loader loadBegin];
}

// Called after the view controller's view is released and set to nil.
//- (void)viewDidUnload
//{
//	[super viewDidUnload];
//}

// Called when the view is about to made visible.
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [self removeObservers];
    [self addObservers];
}

// Called after the view was dismissed, covered or otherwise hidden.
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [self removeObservers];
}

#pragma Event methods

-(NSData *)loadData:(DataLoader *)loader url:(NSString *)url{
    if(_forceOnline){
        //_LogLine();
        [((CacheDataLoader*)loader) forceOnline];
        NSData * data = [loader loadData:url];
        //NSUtil::RemovePath(NSUtil::CacheUrlPath(url));
        return data;
    }
    NSLog(@"DataController LoadData for url=%@",url);
    _LogLine();
    
    NSString* zip_url=nil;
    BOOL needUpdate=[LSVersionManager isNeedUpdateVersion:&zip_url];
    if(needUpdate && zip_url){
        NSLog(@"DataController LoadData need update and get zip url=%@",zip_url);
        // An alert view
        //[[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Content Update", @"内容更新") message:NSLocalizedString(@"Now POS App is to download new content, please wait till is completed.",@"POS应用将要更新内容，请耐心等待。") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",@"好") otherButtonTitles:nil] show];
        //[JDStatusBarNotification showWithStatus:NSLocalizedString(@"Now POS App is to download new content, please wait till is completed.",@"POS应用将要更新内容，请耐心等待。")];
        //ToastView * toastview=[self.view toastWithLoading:NSLocalizedString(@"Loading...", @"加载中...")];
        UIViewController *controller = [self respondsToSelector:@selector(view)] ? (UIViewController *)self : UIUtil::VisibleViewController();
		[controller.view toastWithLoading];
        
        //_LogLine();
        NSString * download_error=HttpUtil::HttpFile(zip_url, [LSVersionManager allZipFilePath]);
        if(download_error){
            //_LogLine();
            //[JDStatusBarNotification dismissAnimated:YES];
            //[toastview dismissToast];
            UIViewController *controller = [self respondsToSelector:@selector(view)] ? (UIViewController *)self : UIUtil::VisibleViewController();
            [controller.view dismissToast];
            
            UIAlertView * av=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Failed to update",@"更新失败") message:NSLocalizedString(@"Sorry for failing download updating information duo to server error.", @"很抱歉，由于服务器问题，下载更新信息失败。") delegate:nil cancelButtonTitle:NSLocalizedString(@"Confirm", @"确认") otherButtonTitles: nil];
            [av show];
            
            return nil;//Later server error to minasareyo
        }else{
            //_LogLine();
            //Update with LSVersionManager
            BOOL updated=[LSVersionManager updateWithDownloadedZip];
            if(updated){
                //_LogLine();
                NSData * data=[NSData dataWithContentsOfFile:(NSUtil::CacheUrlPath(loader.service))];
                //[JDStatusBarNotification dismissAnimated:YES];
                //[toastview dismissToast];
                UIViewController *controller = [self respondsToSelector:@selector(view)] ? (UIViewController *)self : UIUtil::VisibleViewController();
                [controller.view dismissToast];
                return data;
            }else{
                //_LogLine();
                //[JDStatusBarNotification dismissAnimated:YES];
                //[toastview dismissToast];
                UIViewController *controller = [self respondsToSelector:@selector(view)] ? (UIViewController *)self : UIUtil::VisibleViewController();
                [controller.view dismissToast];
                return [loader loadData:url];
            }
        }
    }else{
        //_LogLine();
        //[JDStatusBarNotification showWithStatus:NSLocalizedString(@"Nothing to update!", @"无需更新。") dismissAfter:3];
        return nil;
    }
}

//
- (void)loadEnded:(DataLoader *)loader
{
	_Log(@"load Ended with Dict [%@]", loader.dict);
    _Log(@"DataController loadEnded Error=%d:%@",loader.error,loader.errorString);
	if (loader.error == DataLoaderNoError)
	{
		[_contentView removeFromSuperview];
		
        CGRect contentViewFrame=self.view.bounds;
        //CGRect contentViewFrame=CGRectMake(0, 0, 1024, 702);
        
        //_Log(@"DataController loadEnded to init contentView when self.view = [%@]",self.view);
		_contentView = [[UIView alloc] initWithFrame:contentViewFrame];
        //_Log(@"DataController loadEnded to init contentView with frame[%f,%f,%f,%f]",contentViewFrame.origin.x,contentViewFrame.origin.y,contentViewFrame.size.width,contentViewFrame.size.height);
		_contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.view addSubview:_contentView];
		[self loadContentView:_contentView withDict:loader.dict];
	}else{
        is_reloading=NO;
        if(_thePullReloadDelegate){
            [_thePullReloadDelegate responseForReloadWork];
        }
    }
}

//
- (void)loadContentView:(UIView *)contentView withDict:(NSDictionary *)dict
{
	
}

// TODO
//- (void)loadNotification
//{
//	[_loader loadBegin];
//}
/*
-(void)responseForReloadWork{
    _Log(@"DataController responseForReloadWork withError=%@",_loader.errorString);
}
 */

-(void)receiveVerisonUpdatePush{
    _LogLine();
}
@end
