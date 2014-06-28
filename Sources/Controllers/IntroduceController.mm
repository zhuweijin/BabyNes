
#import "IntroduceController.h"

@implementation IntroduceController

#pragma mark Generic methods

// Constructor
- (id)init
{
	self = [super init];
	self.title = NSLocalizedString(@"Introduce", @"产品介绍");
	_loader = [[CacheDataLoader alloc] init];
	_loader.delegate = self;
	_loader.service = @"http://uniquebaby.duapp.com/babynesios/admin/api/product_test.php";
	_loader.params = @
	{
		@"act": @"sync_product",
		//@"version": @"1000000",
	};
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
	_Log(@"%@", loader.dict);
}

// TODO
//- (void)loadNotification
//{
//	[_loader loadBegin];
//}

@end
