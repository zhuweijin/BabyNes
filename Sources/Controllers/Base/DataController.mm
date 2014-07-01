
#import "DataController.h"

@implementation DataController

#pragma mark Generic methods

// Constructor
- (id)initWithService:(NSString *)service params:(NSDictionary *)params
{
    _Log(@"DataController initWithService[%@] params[%@] called",service,params);
	self = [super init];
	_loader = [[CacheDataLoader alloc] init];
	_loader.delegate = self;
	_loader.service = service;
	_loader.params = params;
	return self;
}

//
- (id)initWithService:(NSString *)service
{
    _Log(@"DataController initWithService[%@] called",service);
	self = [self initWithService:service params:nil];
	return self;
}

#pragma mark View methods

// Creates the view that the controller manages.
//- (void)loadView
//{
//	[super loadView];
//}

// Do additional setup after loading the view.
- (void)viewDidLoad
{
	[super viewDidLoad];
	[_loader loadBegin];
}

// Called after the view controller's view is released and set to nil.
//- (void)viewDidUnload
//{
//	[super viewDidUnload];
//}

// Called when the view is about to made visible.
//- (void)viewWillAppear:(BOOL)animated
//{
//	[super viewWillAppear:animated];
//}

// Called after the view was dismissed, covered or otherwise hidden.
//- (void)viewWillDisappear:(BOOL)animated
//{
//	[super viewWillDisappear:animated];
//}

#pragma Event methods

//
- (void)loadEnded:(DataLoader *)loader
{
	_Log(@"load Ended with Dict [%@]", loader.dict);
	if (loader.error == DataLoaderNoError)
	{
		[_contentView removeFromSuperview];
		
		_contentView = [[UIView alloc] initWithFrame:self.view.bounds];
		_contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.view addSubview:_contentView];
		[self loadContentView:_contentView withDict:loader.dict];
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

@end
