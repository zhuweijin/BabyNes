//
//  LSMixTableCell.m
//  LSMixTableLib
//
//  Created by 倪 李俊 on 14-7-25.
//  Copyright (c) 2014年 Sinri. All rights reserved.
//

#import "LSMixTableCell.h"

@implementation LSMixTableCell

static NSArray * theProvinces;
//static NSArray * theCities;
static NSDictionary * thePCMap;
+(void)setProvinces:(NSArray*)array{
    theProvinces=array;
}
+(void)setPCMap:(NSDictionary*)dict{
    thePCMap=dict;
}

static NSArray * titleArray_customer=@[NSLocalizedString(@"Title*", @"称呼*"),
                                       NSLocalizedString(@"Title*", @"称呼*"),
                                       NSLocalizedString(@"Name*", @"姓名*"),
                                       NSLocalizedString(@"City*", @"城市*"),
                                       NSLocalizedString(@"City*", @"城市*"),
                                       NSLocalizedString(@"Address*", @"地址*"),
                                       NSLocalizedString(@"Mobile*", @"手机*"),
                                       NSLocalizedString(@"Phone", @"电话"),
                                       NSLocalizedString(@"Email", @"电子邮件")
                                       ];
static NSArray * titleArray_baby=@[NSLocalizedString(@"Nickname", @"昵称"),
                                   NSLocalizedString(@"Birthday*", @"生日*"),
                                   NSLocalizedString(@"Birthday*", @"生日*"),
                                   NSLocalizedString(@"Sex*", @"性别*")
                                   ];

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)removeSubviews{
    if(titleLabel)[titleLabel removeFromSuperview];
    if(textFieldMain)[textFieldMain removeFromSuperview];
    if(textFieldMore)[textFieldMore removeFromSuperview];
    if(picker)[picker removeFromSuperview];
    if(singlePicker)[singlePicker removeFromSuperview];
    if(datePicker)[datePicker removeFromSuperview];
    if(optinalButton)[optinalButton removeFromSuperview];
    if(previewLabel)[previewLabel removeFromSuperview];
}

-(void)setSection:(int)section setWithRonriTag:(int)ronriRow{
    [self removeSubviews];
    baby_id=section-1;
    valueType=ronriRow;
    if(section==0){
        if(ronriRow!=1 && ronriRow!=4){
            titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, 5, 100, 30)];
            [titleLabel setText:[titleArray_customer objectAtIndex:ronriRow]];
            [self addSubview:titleLabel];
        }
        switch (ronriRow) {
            case 0:
                
                optinalButton=[[LSOptionalButton alloc]initWithFrame:CGRectMake(150, 5, 380, 30) withNames:@[NSLocalizedString(@"Mr", @"先生"),NSLocalizedString(@"Ms", @"女士")]];
                [optinalButton addTarget:self action:@selector(onCustomerSex:) forControlEvents:(UIControlEventTouchUpInside)];
                
                if([[[_MTDelegate getTheCustomer] theTitle] isEqualToString:NSLocalizedString(@"Ms", @"女士")]){
                    [optinalButton setButtonSelected:1];
                }else [optinalButton setButtonSelected:0];
                
                [self addSubview: optinalButton];
                
                
                
                if(NO){
                    previewLabel=[[UILabel alloc]initWithFrame:CGRectMake(150, 5, 380, 30)];
                    [previewLabel setHidden:YES];
                    [previewLabel setHidden:NO];
                    NSString* p=[[_MTDelegate getTheCustomer] theTitle];
                    if(p && ![p isEqualToString:@""]){
                        [previewLabel setText:[NSString stringWithFormat:@"%@",p]];
                        [previewLabel setTextColor:[UIColor blackColor]];
                    }else{
                        [previewLabel setText:[NSString stringWithFormat:@"%@",
                                               [titleArray_customer objectAtIndex:ronriRow]//NSLocalizedString(@"Unselected", @"未选择")
                                               ]];
                        [previewLabel setTextColor:[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1]];
                    }
                    _LogLine();
                     [self addSubview:previewLabel];
                }
               
                break;
            case 1:
                singlePicker=[[LSSinglePicker alloc]initWithFrame:CGRectMake(50, 5, 450, 90) withSelection:@[NSLocalizedString(@"Mr", @"先生"),NSLocalizedString(@"Ms", @"女士")]];
                [singlePicker addTarget:self action:@selector(titleValueChanged:) forControlEvents:(UIControlEventValueChanged)];
                [singlePicker setSelection:NSLocalizedString(@"Mr", @"先生")];
                [self addSubview:singlePicker];
                break;
            case 2:
                textFieldMain=[[UITextField alloc]initWithFrame:CGRectMake(150, 5, 380, 30)];
                [textFieldMain setPlaceholder:[titleArray_customer objectAtIndex:ronriRow]];
                //[textFieldMain setBorderStyle:(UITextBorderStyleRoundedRect)];
                
                if([[_MTDelegate getTheCustomer] theName] && ![[[_MTDelegate getTheCustomer] theName] isEqualToString:@""]){
                    [textFieldMain setText:[[_MTDelegate getTheCustomer] theName]];
                }
                
                [self addSubview:textFieldMain];
                break;
            case 3:
                previewLabel=[[UILabel alloc]initWithFrame:CGRectMake(150, 5, 380, 30)];
            {
                NSString* p=[[_MTDelegate getTheCustomer] theProvince];
                //if(!p || [p isEqualToString:@""])p=NSLocalizedString(@"None", @"未选择");
                NSString* c=[[_MTDelegate getTheCustomer] theCity];
                //if(!c || [c isEqualToString:@""])c=NSLocalizedString(@"None", @"未选择");
                if(p && ![p isEqualToString:@""] && c && ![c isEqualToString:@""]){
                    [previewLabel setText:[NSString stringWithFormat:@"%@ %@",p,c]];
                    [previewLabel setTextColor:[UIColor blackColor]];
                }else{
                    [previewLabel setText:[NSString stringWithFormat:@"%@",
                                           [titleArray_customer objectAtIndex:ronriRow]//NSLocalizedString(@"Unselected", @"未选择")
                                           ]];
                    [previewLabel setTextColor:[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1]];
                }
                _LogLine();
            }
                [self addSubview:previewLabel];
                break;
            case 4:
                if([theProvinces isKindOfClass:[NSArray class]] && [thePCMap isKindOfClass:[NSDictionary class]]){
                    picker=[[LSDuoPicker alloc]initWithFrame:CGRectMake(50, 5, 450, 150) withProvinces:theProvinces withCities:thePCMap];
                    [picker addTarget:self action:@selector(pcValueChanged:) forControlEvents:(UIControlEventValueChanged)];
                    [picker setLevel1:[[_MTDelegate getTheCustomer] theProvince] Level2:[[_MTDelegate getTheCustomer] theCity]];
                    [self addSubview:picker];
                    //[_MTDelegate refresh];
                    _LogLine();
                }
                break;
            case 5:
                textFieldMain=[[UITextField alloc]initWithFrame:CGRectMake(150, 5, 380, 30)];
                [textFieldMain setPlaceholder:[titleArray_customer objectAtIndex:ronriRow]];
                //[textFieldMain setBorderStyle:(UITextBorderStyleRoundedRect)];
                [textFieldMain setText:[[_MTDelegate getTheCustomer]theAddress]];
                //[textFieldMain setKeyboardType:(UIKeyboardTypeNamePhonePad)];
                [self addSubview:textFieldMain];
                break;
            case 6:
                textFieldMain=[[UITextField alloc]initWithFrame:CGRectMake(150, 5, 380, 30)];
                [textFieldMain setPlaceholder:[titleArray_customer objectAtIndex:ronriRow]];
                //[textFieldMain setBorderStyle:(UITextBorderStyleRoundedRect)];
                _Log(@"cell json=%@",[[_MTDelegate getTheCustomer]toJson]);
                [textFieldMain setText:[[_MTDelegate getTheCustomer]theMobile]];
                [textFieldMain setKeyboardType:(UIKeyboardTypePhonePad)];
                [self addSubview:textFieldMain];
                break;
            case 7:
                textFieldMore=[[UITextField alloc]initWithFrame:CGRectMake(150, 5, 100, 30)];
                [textFieldMore setPlaceholder:NSLocalizedString(@"Area Code", @"区号")];
                //[textFieldMore setBorderStyle:(UITextBorderStyleRoundedRect)];
                [textFieldMore setText:[[_MTDelegate getTheCustomer]theAreaCode]];
                [textFieldMore setKeyboardType:(UIKeyboardTypePhonePad)];
                [self addSubview:textFieldMore];
                
                textFieldMain=[[UITextField alloc]initWithFrame:CGRectMake(260, 5, 270, 30)];
                [textFieldMain setPlaceholder:[titleArray_customer objectAtIndex:ronriRow]];
                //[textFieldMain setBorderStyle:(UITextBorderStyleRoundedRect)];
                [textFieldMain setText:[[_MTDelegate getTheCustomer]thePhone]];
                [textFieldMain setKeyboardType:(UIKeyboardTypePhonePad)];
                [self addSubview:textFieldMain];
                break;
            case 8:
                textFieldMain=[[UITextField alloc]initWithFrame:CGRectMake(150, 5, 380, 30)];
                [textFieldMain setPlaceholder:[titleArray_customer objectAtIndex:ronriRow]];
                //[textFieldMain setBorderStyle:(UITextBorderStyleRoundedRect)];
                [textFieldMain setText:[[_MTDelegate getTheCustomer]theEmail]];
                [textFieldMain setKeyboardType:(UIKeyboardTypeEmailAddress)];
                [self addSubview:textFieldMain];
                break;
            default:
                break;
        }
    }else{
        if(ronriRow!=2 && ronriRow!=4){
            titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, 5, 170, 30)];
            [titleLabel setText:[titleArray_baby objectAtIndex:ronriRow]];
            [self addSubview:titleLabel];
        }
        switch (ronriRow) {
            case 4:
                if([[[[[_MTDelegate getTheCustomer]theBabies] objectAtIndex:baby_id] the_sex] isEqualToString:NSLocalizedString(@"Pregnant",@"胎儿")]){
                    singlePicker=[[LSSinglePicker alloc]initWithFrame:CGRectMake(50, 5, 450, 150) withSelection:@[NSLocalizedString(@"Pregnant",@"胎儿")]];
                    [singlePicker addTarget:self action:@selector(babySexValueChanged:) forControlEvents:(UIControlEventValueChanged)];
                    [singlePicker setSelection:NSLocalizedString(@"Pregnant",@"胎儿")];
                    [self addSubview:singlePicker];
                }else{
                    singlePicker=[[LSSinglePicker alloc]initWithFrame:CGRectMake(50, 5, 450, 90) withSelection:@[NSLocalizedString(@"Boy", @"男"),NSLocalizedString(@"Girl", @"女")]];
                    [singlePicker addTarget:self action:@selector(babySexValueChanged:) forControlEvents:(UIControlEventValueChanged)];
                    [singlePicker setSelection:NSLocalizedString(@"Boy", @"男")];
                    [self addSubview:singlePicker];
                }
                break;
            case 3:
                
                if([[[[[_MTDelegate getTheCustomer]theBabies] objectAtIndex:baby_id] the_sex] isEqualToString:NSLocalizedString(@"Pregnant",@"胎儿")]){
                    previewLabel=[[UILabel alloc]initWithFrame:CGRectMake(150, 5, 380, 30)];
                    [self addSubview:previewLabel];
                    [previewLabel setText:NSLocalizedString(@"Pregnant",@"胎儿")];
                }else{
                    optinalButton=[[LSOptionalButton alloc]initWithFrame:CGRectMake(150, 5, 380, 30) withNames:@[NSLocalizedString(@"Boy", @"男"),NSLocalizedString(@"Girl", @"女")]];
                    [optinalButton addTarget:self action:@selector(onBabySex:) forControlEvents:(UIControlEventTouchUpInside)];
                    if([[[[[_MTDelegate getTheCustomer]theBabies] objectAtIndex:baby_id] the_sex] isEqualToString:NSLocalizedString(@"Girl", @"女")]){
                        [optinalButton setButtonSelected:1];
                    }else [optinalButton setButtonSelected:0];
                    [self addSubview: optinalButton];
                }
                
               
                
                if(NO){
                    previewLabel=[[UILabel alloc]initWithFrame:CGRectMake(150, 5, 380, 30)];
                    
                    if(![[[[_MTDelegate getTheCustomer]theBabies] objectAtIndex:baby_id] the_sex] || [[[[[_MTDelegate getTheCustomer]theBabies] objectAtIndex:baby_id] the_sex] isEqualToString:@""]){
                        [previewLabel setText:[NSString stringWithFormat:@"%@",
                                               [titleArray_baby objectAtIndex:ronriRow]//NSLocalizedString(@"Unselected", @"未选择")
                                               ]];
                        [previewLabel setTextColor:[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1]];
                    }else{
                        previewLabel=[[UILabel alloc]initWithFrame:CGRectMake(150, 5, 380, 30)];
                        [self addSubview:previewLabel];
                        [previewLabel setText:[[[[_MTDelegate getTheCustomer]theBabies] objectAtIndex:baby_id] the_sex]];
                        [previewLabel setTextColor:[UIColor blackColor]];
                    }
                    [self addSubview:previewLabel];
                }
                
                
                break;
            case 2:
                datePicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(50, 5, 450, 150)];
                [datePicker setDatePickerMode:(UIDatePickerModeDate)];
                [datePicker addTarget:self action:@selector(onDateChanged:) forControlEvents:(UIControlEventValueChanged)];
                [self addSubview:datePicker];
                if([[[[_MTDelegate getTheCustomer]theBabies] objectAtIndex:baby_id] the_birth_date]){
                    [datePicker setDate:[[[[_MTDelegate getTheCustomer]theBabies] objectAtIndex:baby_id] the_birth_date] animated:YES];
                }else{
                    [datePicker setDate:[NSDate date] animated:YES];
                    [self onDateChanged:datePicker];
                }
                break;
            case 1:
                previewLabel=[[UILabel alloc]initWithFrame:CGRectMake(150, 5, 380, 30)];
                if([[[[_MTDelegate getTheCustomer]theBabies] objectAtIndex:baby_id] the_birth_date]){
                    [previewLabel setText:
                     [NSString stringWithFormat:@"%d/%d/%d",
                      [[[[_MTDelegate getTheCustomer]theBabies] objectAtIndex:baby_id] the_birth_year],
                      [[[[_MTDelegate getTheCustomer]theBabies] objectAtIndex:baby_id] the_birth_month],
                      [[[[_MTDelegate getTheCustomer]theBabies] objectAtIndex:baby_id] the_birth_day]
                      ]
                     ];
                    _Log(@"set Preview = %@ for baby_id=%d",[previewLabel text],baby_id);
                    [previewLabel setTextColor:[UIColor blackColor]];
                }else{
                    [previewLabel setText:
                     [titleArray_baby objectAtIndex:ronriRow]//NSLocalizedString(@"Unselected", @"未选择")
                     ];
                    [previewLabel setTextColor:[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1]];
                }
                [self addSubview:previewLabel];
                break;
            case 0:
                textFieldMain=[[UITextField alloc]initWithFrame:CGRectMake(150, 5, 380, 30)];
                [textFieldMain setPlaceholder:[titleArray_baby objectAtIndex:ronriRow]];
                //[textFieldMain setBorderStyle:(UITextBorderStyleRoundedRect)];
                [textFieldMain setText: [[[[_MTDelegate getTheCustomer]theBabies] objectAtIndex:baby_id] the_nick]];
                [self addSubview:textFieldMain];
            default:
                break;
        }
    }
    if(textFieldMain){
        [textFieldMain setBorderStyle:(UITextBorderStyleNone)];
        [textFieldMain setDelegate:self];
        [textFieldMain setReturnKeyType:(UIReturnKeyDone)];
        [textFieldMain setAutocapitalizationType:(UITextAutocapitalizationTypeNone)];
        [textFieldMain setAutocorrectionType:UITextAutocorrectionTypeNo];
    }
    if(textFieldMore){
        [textFieldMore setBorderStyle:(UITextBorderStyleNone)];
        [textFieldMore setDelegate:self];
        [textFieldMore setReturnKeyType:(UIReturnKeyNext)];
        [textFieldMore setAutocapitalizationType:(UITextAutocapitalizationTypeNone)];
        [textFieldMore setAutocorrectionType:UITextAutocorrectionTypeNo];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    _Log(@"cell touchedEnded in %d-%d",baby_id,valueType);
    if (textFieldMain && ![textFieldMain isExclusiveTouch]) {
        _LogLine();
        [textFieldMain resignFirstResponder];
    }
    if (textFieldMore && ![textFieldMore isExclusiveTouch]) {
        _LogLine();
        [textFieldMore resignFirstResponder];
    }
    [super touchesEnded:touches withEvent:event];
}

-(void)setPreview:(NSString*)str{
    if(previewLabel){
        [previewLabel setText:str];
        [previewLabel setTextColor:[UIColor blackColor]];
    }
}

-(void)setBabySexCell:(int)v{
    _Log(@"setBabySexCell:%d for baby %d,%@",v,baby_id,titleLabel.text);
    
     if(v==-1){
     _LogLine();
     if(optinalButton){
     [optinalButton removeFromSuperview];
     optinalButton=nil;
     }
     if(!previewLabel){
     previewLabel=[[UILabel alloc]initWithFrame:CGRectMake(150, 5, 380, 30)];
     [self addSubview:previewLabel];
     }
     [previewLabel setText:NSLocalizedString(@"Pregnant",@"胎儿")];
     _LogLine();
     }else{
     _LogLine();
     if(previewLabel){
     [previewLabel removeFromSuperview];
     previewLabel=nil;
     }
     if(!optinalButton){
     optinalButton=[[LSOptionalButton alloc]initWithFrame:CGRectMake(150, 5, 380, 30) withNames:@[NSLocalizedString(@"Boy", @"男"),NSLocalizedString(@"Girl", @"女")]];
     [optinalButton addTarget:self action:@selector(onBabySex:) forControlEvents:(UIControlEventTouchUpInside)];
     [self addSubview: optinalButton];
     }
     [optinalButton setButtonSelected:v];
     }
     
    if(NO){
    if(!previewLabel){
        previewLabel=[[UILabel alloc]initWithFrame:CGRectMake(150, 5, 380, 30)];
        [self addSubview:previewLabel];
    }
    [previewLabel setTextColor:[UIColor blackColor]];
    if(v==-1){
        [previewLabel setText:NSLocalizedString(@"Pregnant",@"胎儿")];
    }else{
        [previewLabel setText:[@[NSLocalizedString(@"Boy", @"男"),NSLocalizedString(@"Girl", @"女")] objectAtIndex:v]];
    }
    }
}

#pragma mark on textField
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if([_MTDelegate isNoPickerOpen]){
        return YES;
    }else{
        [_MTDelegate wannaWriteBabyId:baby_id valueType:valueType isMain:([textField isEqual:textFieldMain])];
        return YES;
    }
}
/*
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    //[_MTDelegate killAllExpanseCell];
    [textField becomeFirstResponder];
}
*/
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    if (baby_id==-1) {
        if(valueType==2){
            _Log(@"set customer name as %@",textField.text);
            [[_MTDelegate getTheCustomer] setTheName:textField.text];
        }else if (valueType==5){
            _Log(@"set customer address as %@",textField.text);
            [[_MTDelegate getTheCustomer] setTheAddress:textField.text];
        }else if (valueType==6){
            _Log(@"set customer mobile as %@",textField.text);
            [[_MTDelegate getTheCustomer] setTheMobile:textField.text];
        }else if (valueType==7){
            _Log(@"set customer phone as %@-%@",textFieldMore.text, textFieldMain.text);
            [[_MTDelegate getTheCustomer] setTheAreaCode:textFieldMore.text];
            [[_MTDelegate getTheCustomer] setThePhone:textFieldMain.text];
        }else if (valueType==8){
            _Log(@"set customer email as %@",textField.text);
            [[_MTDelegate getTheCustomer] setTheEmail:textField.text];
        }
    }else{
        if(valueType==0){
            _Log(@"set baby[%d] nick as %@",baby_id,textField.text);
            LSBaby * baby=[[[_MTDelegate getTheCustomer] theBabies] objectAtIndex:baby_id];
            [baby setThe_nick:textField.text];
            
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if([textFieldMore isFirstResponder]){
        [textFieldMain becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    return NO;
}

-(void)onCustomerSex:(id)sender{
    //[_MTDelegate killAllExpanseCell];
    
    _Log(@"onCustomerSex: %d",[optinalButton getSelectedButton]);
    [[_MTDelegate getTheCustomer]setTheTitle:[@[NSLocalizedString(@"Mr", @"先生"),NSLocalizedString(@"Ms", @"女士")] objectAtIndex:[optinalButton getSelectedButton]]];
    [_MTDelegate refresh];
    
    [_MTDelegate killAllExpanseCell];
}

-(void)babySexValueChanged:(id)sender{
    _Log(@"babySexValueChanged[%d] set Sex: %@",baby_id,[singlePicker level1Value]);
    LSBaby * baby=[[[_MTDelegate getTheCustomer] theBabies] objectAtIndex:baby_id];
    //[baby setThe_sex:[@[NSLocalizedString(@"Boy", @"男"),NSLocalizedString(@"Girl", @"女")] objectAtIndex:[optinalButton getSelectedButton]]];
    [baby setThe_sex:[singlePicker level1Value]];
    [_MTDelegate refresh];
}

-(void)onBabySex:(id)sender{
    //[_MTDelegate killAllExpanseCell];
    
    _Log(@"onBaby[%d] set Sex: %d",baby_id,[optinalButton getSelectedButton]);
    LSBaby * baby=[[[_MTDelegate getTheCustomer] theBabies] objectAtIndex:baby_id];
    [baby setThe_sex:[@[NSLocalizedString(@"Boy", @"男"),NSLocalizedString(@"Girl", @"女")] objectAtIndex:[optinalButton getSelectedButton]]];
    [_MTDelegate refresh];
    
    [_MTDelegate killAllExpanseCell];
}

/*
 -(void)onCustomerName:(id)sender{
 _Log(@"onCustomerName: %@",[textField text]);
 }
 */

-(void)onDateChanged:(id)sender{
    //[_MTDelegate killAllExpanseCell];
    
    _Log(@"onDateChanged for baby[%d] as %@",baby_id,datePicker.date);
    LSBaby * baby=[[[_MTDelegate getTheCustomer] theBabies] objectAtIndex:baby_id];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:datePicker.date];
    NSInteger day = [components day];
    NSInteger month = [components month];
    NSInteger year = [components year];
    [baby setThe_birth_year:year];
    [baby setThe_birth_month:month];
    [baby setThe_birth_day:day];
    [baby setThe_birth_date:datePicker.date];
    [_MTDelegate refresh];
}

-(void)pcValueChanged:(id)sender{
    //[_MTDelegate killAllExpanseCell];
    
    _Log(@"pcValueChanged: %@-%@",picker.level1Value,picker.level2Value);
    [[_MTDelegate getTheCustomer] setTheProvince:picker.level1Value];
    [[_MTDelegate getTheCustomer] setTheCity:picker.level2Value];
    [_MTDelegate refresh];
}

-(void)titleValueChanged:(id)sender{
    _Log(@"titleValueChanged: %@",singlePicker.level1Value);
    [[_MTDelegate getTheCustomer] setTheTitle:singlePicker.level1Value];
    [_MTDelegate refresh];
}

-(void)receiveWannaWriteToBabyId:(NSInteger)babyId valueType:(NSInteger)vt isMain:(BOOL)isMain{
    if(babyId==baby_id && vt==valueType){
        _Log(@"Sinri 0915 receiveWannaWrite:%d",isMain);
        if(isMain){
            if(textFieldMain){
                [textFieldMain becomeFirstResponder];
            }
        }else{
            if(textFieldMore){
                [textFieldMore becomeFirstResponder];
            }
        }
    }
}
@end
