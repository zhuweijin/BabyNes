//
//  RMAFeedbackViewController.h
//  BabyNes
//
//  Created by 倪 李俊 on 14-9-2.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageWorker.h"
#import "ImagePreviewListView.h"

@interface RMAFeedbackViewController : UIViewController
<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
        UIImagePickerController * imagePicker;
}
@property (readonly) UIView * honbuView;
@property UILabel * theTitleLabel;
//@property UIView * theTopLineView;
@property UIButton * theExitButton;

@property UILabel * feedback_label;
@property UITextView * feedback_text;

@property UILabel * image_label;
@property UIButton * pickImageButton;
@property UIButton * takePhotoButton;

@property ImagePreviewListView * imagesView;

@end
