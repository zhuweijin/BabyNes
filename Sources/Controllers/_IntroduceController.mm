
#import "IntroduceController.h"
#import "IntroduceItemView.h"

@implementation IntroduceController

#pragma mark Generic methods

// Constructor
- (id)init
{
	self = [super initWithService:@"pdt_classify"];
	self.title = NSLocalizedString(@"Introduce", @"产品介绍");
	return self;
}

#pragma mark View methods

// Creates the view that the controller manages.
//- (void)loadView
//{
//	[super loadView];
//}

// Do additional setup after loading the view.
//- (void)viewDidLoad
//{
//	[super viewDidLoad];
//}

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
- (void)loadContentView:(UIView *)contentView withDict:(NSDictionary *)dict
{
	UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, contentView.frame.size.width * 2 / 3, contentView.frame.size.height)];
	scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	scrollView.backgroundColor = UIUtil::Color(242,244,246);
	[contentView addSubview:scrollView];
	
	CGFloat width = ceil((1024 * 2 / 3) / 3);
	CGRect frame = {0, 0, width, width};
	NSUInteger i = 0;
	for (NSDictionary *item in dict[@"capsule"])	// TODO: 解析
	{
		IntroduceItemView *view = [[IntroduceItemView alloc] initWithFrame:frame dict:item];
		view.tag = i;
		UIUtil::AddTapGesture(view, self, @selector(itemClicked:));
		[scrollView addSubview:view];
		
		//
		if (++i % 3 == 0)
		{
			frame.origin.x = 0;
			frame.origin.y += frame.size.width;
		}
		else
		{
			frame.origin.x += frame.size.width;
		}
	}
	
	//scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, frame.origin.y + (i % 3 != 0) * (frame.size.height + gap));
}

//
- (void)itemClicked:(UITapGestureRecognizer *)sender
{
	NSDictionary *item = _loader.dict[@"capsule"][sender.view.tag];
	UIUtil::ShowAlert(item.description);
}

@end
