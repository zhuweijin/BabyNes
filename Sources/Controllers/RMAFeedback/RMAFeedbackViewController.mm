//
//  RMAFeedbackViewController.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-9-2.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "RMAFeedbackViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SinriUIApplication.h"

@interface RMAFeedbackViewController ()

@end

@implementation RMAFeedbackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(NO){
        // Do any additional setup after loading the view.
        [self.view setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2]];
        
        _honbuView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 540, 620)];
        [self.view addSubview:_honbuView];
        //    [_honbuView setCenter:self.view.center];
        //    _honbuView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width)];
        //    [self.view addSubview:_honbuView];
        
        self.honbuView.backgroundColor=UIUtil::Color(240, 240, 240);
        
        self.theExitButton=[UIButton minorButtonWithTitle:NSLocalizedString(@"Cancel", @"取消") width:100];
        self.theExitButton.frame=CGRectMake(10, 10, 100, 30);
        [self.theExitButton addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
        [self.honbuView addSubview:self.theExitButton];
        
        self.theTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(160, 10, 200, 30)];
        [self.theTitleLabel setCenter:CGPointMake(self.honbuView.frame.size.width/2, 25)];
        [self.theTitleLabel setText:NSLocalizedString(@"RMA Feedback", @"问题反馈")];
        [self.theTitleLabel setFont:[UIFont systemFontOfSize:20]];
        [self.theTitleLabel setTextColor:[UIColor colorWithRed:157/255.0 green:153/255.0 blue:190/255.0 alpha:1]];
        [self.theTitleLabel setTextAlignment:(NSTextAlignmentCenter)];
        [self.honbuView addSubview:self.theTitleLabel];
        
        self.feedback_label=[[UILabel alloc]initWithFrame:CGRectMake(10, 60, 520, 20)];
        [self.feedback_label setText:NSLocalizedString(@"Issue Description:", @"问题描述：")];
        [self.feedback_label setTextColor:[UIColor colorWithRed:157/255.0 green:153/255.0 blue:190/255.0 alpha:1]];
        [self.honbuView addSubview:self.feedback_label];
        
        self.feedback_text = [[UITextView alloc]initWithFrame:(CGRectMake(10, 90, 520, 200))];
        [self.honbuView addSubview:self.feedback_text];
        
        self.image_label=[[UILabel alloc]initWithFrame:CGRectMake(10, 300, 100, 30)];
        [self.image_label setText:NSLocalizedString(@"Add Photos:", @"附图：")];
        [self.image_label setTextColor:[UIColor colorWithRed:157/255.0 green:153/255.0 blue:190/255.0 alpha:1]];
        [self.honbuView addSubview:self.image_label];
        
        self.pickImageButton=[UIButton minorButtonWithTitle:NSLocalizedString(@"Select Images", @"选择图片") width:100];
        self.pickImageButton.frame=CGRectMake(300, 300, 100, 30);
        [self.pickImageButton addTarget:self action:@selector(onPickImageButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.honbuView addSubview:self.pickImageButton];
        
        self.takePhotoButton=[UIButton minorButtonWithTitle:NSLocalizedString(@"Take Photos", @"拍摄照片") width:100];
        self.takePhotoButton.frame=CGRectMake(430, 300, 100, 30);
        [self.takePhotoButton addTarget:self action:@selector(onTakeImageButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.honbuView addSubview:self.takePhotoButton];
        
        self.imagesView = [[ImagePreviewListView alloc]initWithFrame:(CGRectMake(10, 340, 520, 160))];
        [self.honbuView addSubview:self.imagesView];
        
        self.imagesView.layer.borderColor=[UIColor grayColor].CGColor;
        self.imagesView.layer.borderWidth=1;
        self.imagesView.layer.cornerRadius = 5;
        self.imagesView.layer.masksToBounds = YES;
        
    }else{
        self.view.backgroundColor=UIUtil::Color(240, 240, 240);
        
        self.navigationItem.title=NSLocalizedString(@"RMA Feedback", @"问题反馈");
        
        UIBarButtonItem * sendButton=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Send", @"发送") style:(UIBarButtonItemStylePlain) target:self action:@selector(onSend:)];
        self.navigationItem.rightBarButtonItem=sendButton;
        
        self.feedback_label=[[UILabel alloc]initWithFrame:CGRectMake(10, 70, 520, 20)];
        [self.feedback_label setText:NSLocalizedString(@"Issue Description:", @"问题描述：")];
        [self.feedback_label setTextColor:[UIColor colorWithRed:157/255.0 green:153/255.0 blue:190/255.0 alpha:1]];
        [self.view addSubview:self.feedback_label];
        
        self.feedback_text = [[UITextView alloc]initWithFrame:(CGRectMake(10, 100, 1004, 200))];
        [self.view addSubview:self.feedback_text];
        
        self.image_label=[[UILabel alloc]initWithFrame:CGRectMake(10, 310, 150, 30)];
        [self.image_label setText:NSLocalizedString(@"Add Photos:", @"附图：")];
        [self.image_label setTextColor:[UIColor colorWithRed:157/255.0 green:153/255.0 blue:190/255.0 alpha:1]];
        [self.view addSubview:self.image_label];
        
        self.pickImageButton=[UIButton minorButtonWithTitle:NSLocalizedString(@"Select Images", @"选择图片") width:100];
        self.pickImageButton.frame=CGRectMake(200, 310, 100, 30);
        [self.pickImageButton addTarget:self action:@selector(onPickImageButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.pickImageButton];
        
        self.takePhotoButton=[UIButton minorButtonWithTitle:NSLocalizedString(@"Take Photos", @"拍摄照片") width:100];
        self.takePhotoButton.frame=CGRectMake(350, 310, 100, 30);
        [self.takePhotoButton addTarget:self action:@selector(onTakeImageButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.takePhotoButton];
        
        self.deleteImageButton=[UIButton minorButtonWithTitle:NSLocalizedString(@"Remove Selected Photos", @"移除选中的照片") width:200];
        self.deleteImageButton.frame=CGRectMake(800, 310, 200, 30);
        [self.deleteImageButton addTarget:self action:@selector(onDeleteImageButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.deleteImageButton];
        
        self.imagesView = [[ImagePreviewListView alloc]initWithFrame:(CGRectMake(10, 350, 1004, 350))];
        [self.view addSubview:self.imagesView];
        
        self.imagesView.layer.borderColor=[UIColor grayColor].CGColor;
        self.imagesView.layer.borderWidth=1;
        self.imagesView.layer.cornerRadius = 5;
        self.imagesView.layer.masksToBounds = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self setViewOrientation:UIInterfaceOrientationLandscapeRight];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(void)setRotatable:(BOOL)able{
    [((SinriUIApplication * )[UIApplication sharedApplication]) setIsNeedRotatable:able];
    [[UIApplication sharedApplication]setStatusBarOrientation:(UIInterfaceOrientationLandscapeRight) animated:YES];
    
}
-(void)closeView:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
}

-(void)onSend:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onDeleteImageButton:(id)sender{
    [_imagesView removeSelectedImages];
}
-(void)onPickImageButton:(id)sender{
    [self setRotatable:YES];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        if(YES){
            imagePicker.modalPresentationStyle=UIModalPresentationPageSheet;
            imagePicker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:imagePicker animated:YES completion:^{}];
        }else{
            [[self navigationController] pushViewController:imagePicker animated:YES];
        }
    }else{
        NSLog(@"no photo lib");
        UIUtil::ShowAlert(NSLocalizedString(@"There is no available photo library!", @"没有可用的相册"));
        
    }
}

#pragma mark 从摄像头获取活动图片
- (void)onTakeImageButton:(id)sender
{
    [self setRotatable:YES];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.modalPresentationStyle=UIModalPresentationCurrentContext;
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        if(YES){
            [self presentViewController:imagePicker animated:YES completion:^{ }];
        }else{
            [[self navigationController] pushViewController:imagePicker animated:YES];
        }
    }else{
        NSLog(@"no camera");
        UIUtil::ShowAlert(NSLocalizedString(@"There is no available camera!", @"没有可用的摄像头"));
    }
}

#pragma mark 保存图片到document
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
}

#pragma mark 从文档目录下获取Documents路径
- (NSString *)documentFolderPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

- (void)upLoadSalesBigImage:(NSString *)bigImage MidImage:(NSString *)midImage SmallImage:(NSString *)smallImage
{
    /*
     NSURL *url = [NSURL URLWithString:UPLOAD_SERVER_URL];
     ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
     [request setPostValue:@"photo" forKey:@"type"];
     [request setFile:bigImage forKey:@"file_pic_big"];
     [request buildPostBody];
     [request setDelegate:self];
     [request setTimeOutSeconds:TIME_OUT_SECONDS];
     [request startAsynchronous];
     */
}

-(void)refreshData{
    
}

#pragma mark delegate of image picker
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _Log(@"imagePickerController didFinishPickingMediaWithInfo: %@",info);
    
    UIImage *image= [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    /*
     UIImage * theImage = [ImageWorker imageWithImageSimple:image scaledToSize:CGSizeMake(120.0, 120.0)];
     UIImage *midImage = [ImageWorker imageWithImageSimple:image scaledToSize:CGSizeMake(210.0, 210.0)];
     UIImage *bigImage = [ImageWorker imageWithImageSimple:image scaledToSize:CGSizeMake(440.0, 440.0)];
     [self saveImage:theImage WithName:@"salesImageSmall.jpg"];
     [self saveImage:midImage WithName:@"salesImageMid.jpg"];
     [self saveImage:bigImage WithName:@"salesImageBig.jpg"];
     */
    [self dismissViewControllerAnimated:YES completion:^{
        //
        [_imagesView appendImage:image];
    }];
    //[self refreshData];
    
    [self setRotatable:NO];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
    [self setRotatable:NO];
}

#pragma mark rotate
/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    _LogLine();
    return (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
    
}

- (BOOL)shouldAutorotate
{
    _LogLine();
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    _LogLine();
    return UIInterfaceOrientationMaskLandscape;//只支持这一个方向(正常的方向)
}
*/
-(void)setViewOrientation:(UIInterfaceOrientation )orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        [[UIDevice currentDevice] performSelector:@selector(setOrientation:)
                                       withObject:[NSNumber numberWithInteger: orientation]];
    }
    [UIViewController attemptRotationToDeviceOrientation];//这句是关键
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight;
    //return UIInterfaceOrientationMaskLandscape;
}

-(BOOL)shouldAutorotate
{
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation==UIInterfaceOrientationLandscapeRight;// || toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft;
}

@end

@implementation UIImagePickerController (rotabale)

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear :YES];
//    [self setViewOrientation:UIInterfaceOrientationLandscapeRight];
//}
//重写下面子类的方法
- (NSUInteger) supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation NS_DEPRECATED_IOS(2_0, 6_0){
    return toInterfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

@end
