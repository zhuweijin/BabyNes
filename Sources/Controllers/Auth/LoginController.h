
#import "BaseController.h"
#import "LSDeviceRegister.h"

//
@interface LoginController : BaseController<DataLoaderDelegate>
{
	UIImageView *_logoView;
	UIImageView *_loginPane;
	UIImageView *_footView;
	UIButton *_rememberButton;;
	UIButton *_doneButton;
	
	UITextField *_usernameField;
	UITextField *_passwordField;
}

@property NSString * msg;
-(id)initWithMessage:(NSString*)theMessage;

@end
