#import "LSRegularReporter.h"
#import "SinriUIApplication.h"
#import "PushHandler.h"

//
@interface AppDelegate : NSObject <UIApplicationDelegate>
{
}
@property(nonatomic,strong) UIWindow *window;

-(void)regularDeviceInfoReport:(NSTimer *)theTimer;

@end

// TODO:
// Refine DataLoader
// Refine SystemUtil (dysym call)