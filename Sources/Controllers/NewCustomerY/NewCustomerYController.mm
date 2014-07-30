//
//  LSPopViewController.m
//  LSMixTableLib
//
//  Created by 倪 李俊 on 14-7-25.
//  Copyright (c) 2014年 Sinri. All rights reserved.
//

#import "NewCustomerYController.h"

@interface NewCustomerYController ()
@property BOOL showingCell01;
@property BOOL showingCell04;
@property NSMutableArray * showingCellInSection;

@property NSArray * provinces_array;
@property NSArray * cities_array;
@property NSDictionary * province_city_dict;

@property CGFloat baby_cells_top;
@property CGFloat baby_cell_height;

@property CGRect leftBabyBtnFrame;
@property CGRect midBabyBtnFrame;
@property CGRect leftCustomerBtnFrame;
@property CGRect midCustomerBtnFrame;
@end

@implementation NewCustomerYController

- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

-(id)init{
    self = [super initWithService:@"ls_location"];
    self.baby_cells_top=160.0;
    self.baby_cell_height=180.0;
    
    _NewCustomer=[[LSCustomer alloc]init];
    //[_NewCustomer setTheTitle:NSLocalizedString(@"Mr", @"先生")];
    //[_NewCustomer addOneBaby:[[LSBaby alloc]init]];
    //[self addBaby:self];
    
    //selection=-1;
    
	return self;
}

- (void)loadContentView:(UIView *)contentView withDict:(NSDictionary *)dict{
    _Log(@"NewCustomerController loadContentView - -");
    
    //_Log(@"get locations [%@]",dict);
    self.provinces_array=[dict objectForKey:@"provinces"];
    self.province_city_dict=[dict objectForKey:@"cities"];
    self.cities_array=@[];//@[NSLocalizedString(@"Province first", @"未选择省份")];
    
    [LSMixTableCell setProvinces:self.provinces_array];
    [LSMixTableCell setPCMap:self.province_city_dict];
    
    //[self.theProvinceCB reloadDataForSelection:     self.provinces_array     ];
    //[self.theCityCB     reloadDataForSelection:     self.cities_array     ];
    
    [contentView setFrame:CGRectZero];
    //[self designView:contentView];
    
    [self designView];
}

-(void) designView{
    self.view.backgroundColor=UIUtil::Color(240, 240, 240);
    
    self.theExitButton=[UIButton minorButtonWithTitle:NSLocalizedString(@"Cancel", @"取消") width:100];
    //self.theExitButton=[UIButton buttonWithType:UIButtonTypeCustom];
    //self.theExitButton.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    //self.theExitButton.titleLabel.textColor=[UIColor whiteColor];
    //self.theExitButton.backgroundColor = [UIColor colorWithRed:157/255.0 green:153/255.0 blue:190/255.0 alpha:1];
    //[self.theExitButton setBackgroundImage:UIUtil::ImageWithColor(117, 114, 184) forState:UIControlStateHighlighted];
    self.theExitButton.frame=CGRectMake(10, 10, 100, 30);
    //[self.theExitButton setTitle:NSLocalizedString(@"Close", @"取消创建") forState:UIControlStateNormal];
    [self.theExitButton addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.theExitButton];
    /*
     self.theTopLineView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 540, 8)];
     self.theTopLineView.backgroundColor =[UIColor colorWithRed:157/255.0 green:153/255.0 blue:190/255.0 alpha:1];
     [self.view addSubview:self.theTopLineView];
     */
    self.theTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(160, 10, 200, 30)];
    [self.theTitleLabel setCenter:CGPointMake(self.view.frame.size.width/2, 25)];
    [self.theTitleLabel setText:NSLocalizedString(@"New Customer", @"招募顾客")];
    [self.theTitleLabel setFont:[UIFont systemFontOfSize:20]];
    [self.theTitleLabel setTextColor:[UIColor colorWithRed:157/255.0 green:153/255.0 blue:190/255.0 alpha:1]];
    [self.theTitleLabel setTextAlignment:(NSTextAlignmentCenter)];
    [self.view addSubview:self.theTitleLabel];
    
    //self.midBabyBtnFrame=CGRectMake(100, 450, 100, 30);
    self.midBabyBtnFrame=CGRectMake(100, 460, 100, 30);
    //self.leftBabyBtnFrame=CGRectMake(-500, 450, 100, 30);
    
    self.theBabyAddButton=[UIButton minorButtonWithTitle:NSLocalizedString(@"Add Baby", @"添加一个宝宝") width:150];
    //self.theBabyAddButton=[UIButton buttonWithType:UIButtonTypeCustom];
    //self.theBabyAddButton.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    //self.theBabyAddButton.titleLabel.textColor=[UIColor whiteColor];
    //self.theBabyAddButton.backgroundColor = [UIColor colorWithRed:157/255.0 green:153/255.0 blue:190/255.0 alpha:1];
    //[self.theBabyAddButton setBackgroundImage:UIUtil::ImageWithColor(117, 114, 184) forState:UIControlStateHighlighted];
    //[self.theBabyAddButton setBackgroundImage:UIUtil::ImageWithColor(100,100,100) forState:UIControlStateDisabled];
    //self.theBabyAddButton.frame=self.midBabyBtnFrame;
    self.theBabyAddButton.center=CGPointMake(self.view.frame.size.width/2, 460);
    //[self.theBabyAddButton setTitle:NSLocalizedString(@"Add Baby", @"添加一个宝宝") forState:UIControlStateNormal];
    [self.theBabyAddButton addTarget:self action:@selector(addBaby:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.theBabyAddButton];
    
    //self.midCustomerBtnFrame=CGRectMake(340, 450, 100, 30);
    self.midCustomerBtnFrame=CGRectMake(430, 10, 100, 30);
    //self.leftCustomerBtnFrame=CGRectMake(self.view.frame.size.width-200-600, 450, 100, 30);
    
    self.theCustomerAddButton=[UIButton minorButtonWithTitle:NSLocalizedString(@"Create", @"创建") width:100];
    //self.theCustomerAddButton=[UIButton buttonWithType:UIButtonTypeCustom];
    //self.theCustomerAddButton.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    //self.theCustomerAddButton.titleLabel.textColor=[UIColor whiteColor];
    //self.theCustomerAddButton.backgroundColor = [UIColor colorWithRed:157/255.0 green:153/255.0 blue:190/255.0 alpha:1];
    //[self.theCustomerAddButton setBackgroundImage:UIUtil::ImageWithColor(117, 114, 184) forState:UIControlStateHighlighted];
    //[self.theCustomerAddButton setBackgroundImage:UIUtil::ImageWithColor(100,100,100) forState:UIControlStateDisabled];
    self.theCustomerAddButton.frame=self.midCustomerBtnFrame;
    //[self.theCustomerAddButton setTitle:NSLocalizedString(@"Create", @"创建") forState:UIControlStateNormal];
    [self.theCustomerAddButton addTarget:self action:@selector(addCustomer:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.theCustomerAddButton];
    
    _mixTable=[[LSMixTable alloc]initWithFrame:CGRectMake(0, 50, 540, 370) style:(UITableViewStyleGrouped)];
    [_mixTable setBackgroundColor:[UIColor whiteColor]];
    [_mixTable setDelegate:self];
    [_mixTable setDataSource:self];
    [self.view addSubview:_mixTable];
    
    _rowNumberArray=[@[
                       [NSNumber numberWithInt:7],
                       //[NSNumber numberWithInt:3]
                       ] mutableCopy];
    
    _focusingCellTag = -1;
    _showingCell01=NO;
    _showingCell04=NO;
    _showingCellInSection=[[NSMutableArray alloc]init];
    
    //[self performSelector:@selector(refresh) withObject:nil afterDelay:0.5];
    
    //[self refresh];
    [self addBaby:self];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpForDismissKeyboard];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    /*
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBehind:)];
    
    [recognizer setNumberOfTapsRequired:1];
    recognizer.cancelsTouchesInView = NO; //So the user can still interact with controls in the modal view
    [self.view.window addGestureRecognizer:recognizer];
     */
}
/*
- (void)handleTapBehind:(UITapGestureRecognizer *)sender
{
    _LogLine();
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        _LogLine();
        CGPoint location = [sender locationInView:nil]; //Passing nil gives us coordinates in the window
        
        //Then we convert the tap's location into the local view's coordinate system, and test to see if it's in or outside. If outside, dismiss the view.
        
        if (![self.view pointInside:[self.view convertPoint:location fromView:self.view.window] withEvent:nil])
        {
            // Remove the recognizer first so it's view.window is valid.
            //[self.view.window removeGestureRecognizer:sender];
            [self.view.window endEditing:YES];
            _LogLine();
            //[self dismissModalViewControllerAnimated:YES];
        }
    }
}
*/
- (void)setUpForDismissKeyboard {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view.window addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view.window removeGestureRecognizer:singleTapGR];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view.window endEditing:YES];
    _LogLine();
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark table

-(int)getRonriRowTag:(NSIndexPath *)indexPath{
    int section=indexPath.section;
    int row=indexPath.row;
    
    if(section==0){
        if(!_showingCell01 && !_showingCell04){
            switch (row) {
                case 0:return 0;break;//Title
                case 1:return 2;break;//Name
                case 2:return 3;break;//Province and city BAR //3 as Picker
                case 3:return 5;break;//Address
                case 4:return 6;break;//Mobile
                case 5:return 7;break;//Areacode and phone
                case 6:return 8;break;//Email
                    //case 7:return 8;break;
                default:
                    return -1;
                    break;
            }
        } else if(!_showingCell01 && _showingCell04){
            switch (row) {
                case 0:return 0;break;//Title
                case 1:return 2;break;//Name
                case 2:return 3;break;//Province and city BAR //3 as Picker
                case 3:return 4;break;//Address
                case 4:return 5;break;//Mobile
                case 5:return 6;break;//Areacode and phone
                case 6:return 7;break;//Email
                case 7:return 8;break;
                default:
                    return -1;
                    break;
            }
        } else if(_showingCell01 && !_showingCell04){
            switch (row) {
                case 0:return 0;break;//Title
                case 1:return 1;break;//Name
                case 2:return 2;break;//Province and city BAR //3 as Picker
                case 3:return 3;break;//Address
                case 4:return 5;break;//Mobile
                case 5:return 6;break;//Areacode and phone
                case 6:return 7;break;//Email
                case 7:return 8;break;
                default:
                    return -1;
                    break;
            }
        }
        else{
            return row;
        }
        //return -1;
    }else{
        BOOL showingBabyCell02=[[_showingCellInSection[indexPath.section-1] objectForKey:@"showingBirthdayPicker"] boolValue];
        BOOL showingBabyCell04=[[_showingCellInSection[indexPath.section-1] objectForKey:@"showingSexPicker"] boolValue];
        if(!showingBabyCell02 && !showingBabyCell04){
            switch (row) {
                case 0:return 0;break;//Nick
                case 1:return 1;break;//Birthday
                case 2:return 3;break;//Sex
                default:
                    return -1;
                    break;
            }
        }else if(!showingBabyCell02 && showingBabyCell04){
            switch (row) {
                case 0:return 0;break;//Nick
                case 1:return 1;break;//Birthday
                case 2:return 3;break;//Sex
                case 3:return 4;break;//SPicker
                default:
                    return -1;
                    break;
            }
        }else if(showingBabyCell02 && !showingBabyCell04){
            switch (row) {
                case 0:return 0;break;//Nick
                case 1:return 1;break;//Birthday
                case 2:return 2;break;//BPicker
                case 3:return 3;break;//Sex
                default:
                    return -1;
                    break;
            }
        }else{
            return row;
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if([view isKindOfClass:[UITableViewHeaderFooterView class]]){
        UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *) view;
        //tableViewHeaderFooterView.textLabel.textColor = [UIColor blueColor];
        //tableViewHeaderFooterView.textLabel.backgroundColor=[UIColor whiteColor];
        tableViewHeaderFooterView.textLabel.font=[UIFont systemFontOfSize:25];
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section==0){
        return  NSLocalizedString(@"Customer Information", @"顾客信息");
    }else{
        return  NSLocalizedString(@"Baby Information", @"宝宝信息");
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //if(section==0)return 3;
    //else return 4;
    _Log(@"numberOfRowsInSection:%d=%d",section,[[_rowNumberArray objectAtIndex:section]intValue]);
    return [[_rowNumberArray objectAtIndex:section]intValue];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_rowNumberArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"LSMixTableCell";
    //LSShopMonoTableViewCell *cell = (LSShopMonoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //UITableViewCell
    LSMixTableCell * cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        //cell = [[LSShopMonoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell=[[LSMixTableCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    int ronriRow=[self getRonriRowTag:indexPath];
    _Log(@"cellForRowAtIndexPath[%d-%d]=>%d",indexPath.section,indexPath.row,ronriRow);
    //[[cell textLabel]setText:[NSString stringWithFormat:@"Section %d Row %d : %d",indexPath.section,indexPath.row,ronriRow]];
    cell.accessoryType =  UITableViewCellAccessoryNone;
    
    [cell setSection:indexPath.section setWithRonriTag:ronriRow];
    [cell setMTDelegate:self];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    int ronriRow=[self getRonriRowTag:indexPath];
    if(indexPath.section==0){
        if(ronriRow==1){
            return 200;
        }else if(ronriRow==4){
            return 200;
        }
    }else{
        if(ronriRow==2 ){
            return 200;
        }else if( ronriRow==4){
            return 200;
        }
    }
    
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int ronriRow=[self getRonriRowTag:indexPath];
    _Log(@"didSelectRowAtIndexPath:%d-%d -> ronriRow=%d",indexPath.section,indexPath.row,ronriRow);
    if(indexPath.section==0){
        if(ronriRow==0){
            [tableView beginUpdates];
            
            NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
            
            // check if 'indexPath' has an attached date picker below it
            if (_showingCell01)
            {
                // found a picker below it, so remove it
                [tableView deleteRowsAtIndexPaths:indexPaths
                                 withRowAnimation:UITableViewRowAnimationNone];
                int old=[[_rowNumberArray objectAtIndex:indexPath.section] intValue];
                _rowNumberArray[indexPath.section]=[NSNumber numberWithInt:old-1];
            }
            else
            {
                // didn't find a picker below it, so we should insert it
                [tableView insertRowsAtIndexPaths:indexPaths
                                 withRowAnimation:UITableViewRowAnimationNone];
                int old=[[_rowNumberArray objectAtIndex:indexPath.section] intValue];
                _rowNumberArray[indexPath.section]=[NSNumber numberWithInt:old+1];
            }
            
            [tableView endUpdates];
            
            _showingCell01=!_showingCell01;
            
            [tableView reloadData];
            
            if(_showingCell01){
                [tableView scrollToRowAtIndexPath:indexPaths[0] atScrollPosition:(UITableViewScrollPositionMiddle) animated:YES];
            }
            [self refresh];
        }else if(ronriRow==3){
            [tableView beginUpdates];
            
            NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
            
            // check if 'indexPath' has an attached date picker below it
            if (_showingCell04)
            {
                // found a picker below it, so remove it
                [tableView deleteRowsAtIndexPaths:indexPaths
                                 withRowAnimation:UITableViewRowAnimationNone];
                int old=[[_rowNumberArray objectAtIndex:indexPath.section] intValue];
                _rowNumberArray[indexPath.section]=[NSNumber numberWithInt:old-1];
            }
            else
            {
                // didn't find a picker below it, so we should insert it
                [tableView insertRowsAtIndexPaths:indexPaths
                                 withRowAnimation:UITableViewRowAnimationNone];
                int old=[[_rowNumberArray objectAtIndex:indexPath.section] intValue];
                _rowNumberArray[indexPath.section]=[NSNumber numberWithInt:old+1];
            }
            
            [tableView endUpdates];
            
            _showingCell04=!_showingCell04;
            
            [tableView reloadData];
            
            if(_showingCell04){
                [tableView scrollToRowAtIndexPath:indexPaths[0] atScrollPosition:(UITableViewScrollPositionMiddle) animated:YES];
            }
            [self refresh];
        }
    }else{
        if(ronriRow==1){
            if(![[_showingCellInSection[indexPath.section-1] objectForKey:@"showingBirthdayPicker"] boolValue] &&
               [[_showingCellInSection[indexPath.section-1] objectForKey:@"showingSexPicker"] boolValue]){
                _LogLine();
                [self tableView:tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:indexPath.section]];
                [self tableView:tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:indexPath.section]];
                return;
            }
            
            [tableView beginUpdates];
            
            NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section]];
            
            // check if 'indexPath' has an attached date picker below it
            if([[_showingCellInSection[indexPath.section-1] objectForKey:@"showingBirthdayPicker"] boolValue]){
                _LogLine();
                // found a picker below it, so remove it
                [tableView deleteRowsAtIndexPaths:indexPaths
                                 withRowAnimation:UITableViewRowAnimationNone];
                int old=[[_rowNumberArray objectAtIndex:indexPath.section] intValue];
                _rowNumberArray[indexPath.section]=[NSNumber numberWithInt:old-1];
                [_showingCellInSection[indexPath.section-1] setObject:@NO forKey:@"showingBirthdayPicker"];
                _LogLine();
            }
            else
            {
                _LogLine();
                // didn't find a picker below it, so we should insert it
                [tableView insertRowsAtIndexPaths:indexPaths
                                 withRowAnimation:UITableViewRowAnimationNone];
                int old=[[_rowNumberArray objectAtIndex:indexPath.section] intValue];
                _rowNumberArray[indexPath.section]=[NSNumber numberWithInt:old+1];
                [_showingCellInSection[indexPath.section-1] setObject:@YES forKey:@"showingBirthdayPicker"];
                _LogLine();
            }
            
            [tableView endUpdates];
            
            [tableView reloadData];
            
            if([[_showingCellInSection[indexPath.section-1] objectForKey:@"showingBirthdayPicker"] boolValue]){
                _LogLine();
                [tableView scrollToRowAtIndexPath:indexPaths[0] atScrollPosition:(UITableViewScrollPositionMiddle) animated:YES];
            }
            
            [self refresh];
        }else if(ronriRow==3){
            if([[_showingCellInSection[indexPath.section-1] objectForKey:@"showingBirthdayPicker"] boolValue] &&
               ![[_showingCellInSection[indexPath.section-1] objectForKey:@"showingSexPicker"] boolValue]){
                _LogLine();
                [self tableView:tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:indexPath.section]];
                [self tableView:tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:indexPath.section]];
                return;
            }
            
            [tableView beginUpdates];
            
            NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section]];
            _Log(@"indexPaths=%@",indexPaths);
            
            // check if 'indexPath' has an attached date picker below it
            if([[_showingCellInSection[indexPath.section-1] objectForKey:@"showingSexPicker"] boolValue]){
                _LogLine();
                /*
                 if ([[_rowNumberArray objectAtIndex:indexPath.section]intValue]>3){
                 */
                // found a picker below it, so remove it
                [tableView deleteRowsAtIndexPaths:indexPaths
                                 withRowAnimation:UITableViewRowAnimationNone];
                int old=[[_rowNumberArray objectAtIndex:indexPath.section] intValue];
                _rowNumberArray[indexPath.section]=[NSNumber numberWithInt:old-1];
                [_showingCellInSection[indexPath.section-1] setObject:@NO forKey:@"showingSexPicker"];
            }
            else
            {
                _LogLine();
                // didn't find a picker below it, so we should insert it
                [tableView insertRowsAtIndexPaths:indexPaths
                                 withRowAnimation:UITableViewRowAnimationNone];
                _LogLine();
                int old=[[_rowNumberArray objectAtIndex:indexPath.section] intValue];
                _LogLine();
                _rowNumberArray[indexPath.section]=[NSNumber numberWithInt:old+1];
                _LogLine();
                [_showingCellInSection[indexPath.section-1] setObject:@YES forKey:@"showingSexPicker"];
                _LogLine();
            }
            
            [tableView endUpdates];
            _LogLine();
            [tableView reloadData];
            _LogLine();
            if([[_showingCellInSection[indexPath.section-1] objectForKey:@"showingSexPicker"] boolValue]){
                [tableView scrollToRowAtIndexPath:indexPaths[0] atScrollPosition:(UITableViewScrollPositionMiddle) animated:YES];
            }
            _LogLine();
            [self refresh];
        }
        
    }
    
}
#pragma mark MixTableCellDelegate
-(LSCustomer*)getTheCustomer{
    return _NewCustomer;
}

-(void)refresh{
    _Log(@"NCY-Refresh showCell01=%d,showCell04=%d",_showingCell01,_showingCell04);
    //[_mixTable reloadData];
    if(_showingCell01){
        LSMixTableCell *cell=(LSMixTableCell*)[_mixTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [cell setPreview:[NSString stringWithFormat:@"%@",[_NewCustomer theTitle]]];
        _Log(@"REFRESH TITLE: cell=%@" ,cell);
    }
    if(_showingCell04){
        if(_showingCell01){
            LSMixTableCell *cell=(LSMixTableCell*)[_mixTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
            [cell setPreview:[NSString stringWithFormat:@"%@ %@",[_NewCustomer theProvince],[_NewCustomer theCity]]];
            _Log(@"REFRESH CITY: cell=%@" ,cell);
        }else{
            LSMixTableCell *cell=(LSMixTableCell*)[_mixTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            [cell setPreview:[NSString stringWithFormat:@"%@ %@",[_NewCustomer theProvince],[_NewCustomer theCity]]];
            _Log(@"REFRESH CITY: cell=%@" ,cell);
        }
    }
    for (int i=0; i<[[_NewCustomer theBabies] count]; i++) {
        LSBaby * baby=[[_NewCustomer theBabies]objectAtIndex:i];
        LSMixTableCell *cellOfBirthdayPreview=(LSMixTableCell*)[_mixTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:i+1]];
        BOOL showingBabyCell02=[[_showingCellInSection[i] objectForKey:@"showingBirthdayPicker"]boolValue];
        BOOL showingBabyCell04=[[_showingCellInSection[i] objectForKey:@"showingSexPicker"]boolValue];
        if([baby the_birth_date]){
            [cellOfBirthdayPreview setPreview:[NSString stringWithFormat:@"%d/%d/%d",[baby the_birth_year],[baby the_birth_month],[baby the_birth_day]]];
            
            NSTimeInterval deltaOnTime=[[NSDate date] timeIntervalSinceDate:[baby the_birth_date]];
            //_Log(@"%@ since %@, deltaOnTime=%lf",[NSDate date],date,deltaOnTime);
            if(deltaOnTime<=0){
                if([baby the_sex]==nil || [[baby the_sex]isEqualToString:@""] || ![[baby the_sex] isEqualToString:NSLocalizedString(@"Pregnant",@"胎儿")]){
                    [baby setThe_sex:NSLocalizedString(@"Pregnant",@"胎儿")];
                }
            }else{
                if([[baby the_sex] isEqualToString:NSLocalizedString(@"Pregnant",@"胎儿")]){
                    [baby setThe_sex:NSLocalizedString(@"Boy",@"男")];
                }
            }
        }
        
        
        int rowId=2;
        if(showingBabyCell02){
            rowId=3;
        }
        LSMixTableCell *cellOfSexPreview=(LSMixTableCell*)[_mixTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowId inSection:i+1]];
        _Log(@"cell2=%@",cellOfSexPreview);
        if([[baby the_sex] isEqualToString:NSLocalizedString(@"Pregnant",@"胎儿")]){
            [cellOfSexPreview setBabySexCell:-1];
        }else{
            int v=-2;
            if([[baby the_sex] isEqualToString:NSLocalizedString(@"Boy",@"男")]){
                v=0;
            }else if([[baby the_sex] isEqualToString:NSLocalizedString(@"Girl",@"女")]){
                v=1;
            }
            if(v>=0)
            [cellOfSexPreview setBabySexCell:v];
        }
        
    }
}

#pragma mark IBAction
/*
 -(void)focusToCell:(int)cellTag{
 
 }
 */

-(void)addBaby:(id)sender{
    _Log(@"addBaby called");
    /*
     LSNewCustomer_BabyCell * first=[[LSNewCustomer_BabyCell alloc]initWithFrame:CGRectMake(0, 0, 500, self.baby_cell_height) withinController:self];
     //[first initDate];
     [self.baby_cells addObject:first];
     [self refreshBabiesViews];
     [self.InfoScrollView scrollRectToVisible:CGRectMake(0,self.baby_cells_top-self.baby_cell_height+self.baby_cell_height*[self.baby_cells count], 500, self.baby_cell_height) animated:YES];
     */
    LSBaby*baby=[[LSBaby alloc]init];
    //[baby setThe_sex:NSLocalizedString(@"Boy", @"男")];
    /*
     NSDate *date=[NSDate date];
     //LSBaby * baby=[[[_MTDelegate getTheCustomer] theBabies] objectAtIndex:baby_id];
     NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
     NSInteger day = [components day];
     NSInteger month = [components month];
     NSInteger year = [components year];
     [baby setThe_birth_year:year];
     [baby setThe_birth_month:month];
     [baby setThe_birth_day:day];
     [baby setThe_birth_date:date];
     */
    [_NewCustomer addOneBaby:baby];
    
    [_showingCellInSection addObject:[@{@"showingBirthdayPicker":@NO,@"showingSexPicker":@NO} mutableCopy]];
    [[self rowNumberArray]addObject:[NSNumber numberWithInt:3]];
    [self.mixTable reloadData];
}

-(void)addCustomer:(id)sender{
    _Log(@"addCustomer called");
    
    _Log(@"testNewCustomer:\nTitle: %@\nName: %@\nProvince: %@\nCity: %@\nAddress: %@\nMobile: %@\nEmail: %@",
         _NewCustomer.theTitle,
         _NewCustomer.theName,
         _NewCustomer.theProvince,
         _NewCustomer.theCity,
         _NewCustomer.theAddress,
         _NewCustomer.theMobile,
         _NewCustomer.theEmail
         );
    for (int i=0;i<[_NewCustomer.theBabies count];i++) {
        LSBaby * baby = [_NewCustomer.theBabies objectAtIndex:i];
        _Log(@"With BABY[%d]:\nNick: %@\nSex: %@\nBirthday: %d-%d-%d",i,
             baby.the_nick,
             baby.the_sex,
             baby.the_birth_year,
             baby.the_birth_month,
             baby.the_birth_day);
    }
    if(![_NewCustomer validateCustomerInformation])return;
    [self showRecheckView];
    /*
     
     if(![_NewCustomer validateCustomerInformation])return;
     
     if(selection==-1){
     
     NSString * msg=[NSString stringWithFormat:NSLocalizedString(@"Please ensure that the mobile (%@) of the customer is correct, which would affect your points. Select ‘Confirm’ to continue create new customer, or cancel it to recheck.", @"请确保登记的顾客手机号码(%@)正确，以免影响员工绩效。选择‘确认’以继续创建顾客账号，选择取消可以返回进行检查。"),[_NewCustomer theMobile]];
     
     
     if(_subView){
     [_subView removeFromSuperview];
     _subView=nil;
     }
     _subView=[[NCCreateReconfrimSubView alloc]initWithFrame:rightFrame WithTitle:NSLocalizedString(@"Reminder", @"提醒") message:msg cancelButtonTitle:NSLocalizedString(@"Cancel", @"取消") okButtonTitles:NSLocalizedString(@"Confirm", @"确认") withDelegate:self];
     if(_subView){
     //[_subView setBackgroundColor:[UIColor greenColor]];
     [_subView setBackgroundColor:[UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:0.7]];
     [self tableLoadSubViewFromRight:_subView];
     }
     
     }
     if(selection!=1){
     //
     }else{
     NSString* result=[_NewCustomer createCustomer];
     //    [cc reset];
     if(result!=nil){
     UIUtil::ShowAlert([NSString stringWithFormat: NSLocalizedString(@"Registered as [%@]", @"成功注册为[%@]"),result]);
     [[NSNotificationCenter defaultCenter] postNotificationName:@"UserRegistered" object:result];
     [self closeView:sender];
     }
     }
     selection=-1;
     */
}

-(void)showRecheckView{
    
    if(recheckView){
        [recheckView removeFromSuperview];
        recheckView=nil;
    }
    recheckView=[[UIView alloc]initWithFrame:CGRectMake(0, 50, 540, 550)];
    [recheckView setBackgroundColor:[UIColor whiteColor]];
    
    /*
     UILabel * recheckTitleLabel =[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 500, 50)];
     //[recheckLabel setBackgroundColor:[UIColor redColor]];
     [recheckTitleLabel setText:NSLocalizedString(@"Reminder", @"提醒")];
     [recheckTitleLabel setFont:[UIFont systemFontOfSize:30]];
     [recheckTitleLabel setLineBreakMode:(NSLineBreakByWordWrapping)];
     [recheckTitleLabel setNumberOfLines:0];
     [recheckView addSubview:recheckTitleLabel];
     */
    NSString * msg=[NSString stringWithFormat:NSLocalizedString(@"Please ensure that the mobile (%@) of the customer is correct, which would affect your points.\nSelect Confirm to continue create new customer, or Cancel it to recheck.", @"请确保登记的顾客手机号码正确，以免影响员工绩效: %@。\n选择确认以继续创建顾客账号，选择取消可以返回进行检查。"),[_NewCustomer theMobile]];
    recheckLabel =[[UILabel alloc]initWithFrame:CGRectMake(50, 20, 440, 350)];
    //recheckLabel =[[UILabel alloc]initWithFrame:_mixTable.frame];
    [recheckLabel setBackgroundColor:[UIColor whiteColor]];
    [recheckLabel setText:msg];
    [recheckLabel setFont:[UIFont systemFontOfSize:30]];
    [recheckLabel setTextColor:[UIColor colorWithRed:157/255.0 green:153/255.0 blue:190/255.0 alpha:1]];
    [recheckLabel setLineBreakMode:(NSLineBreakByWordWrapping)];
    [recheckLabel setNumberOfLines:0];
    [recheckView addSubview:recheckLabel];
    
    
    recheckCancel = [UIButton buttonWithType:(UIButtonTypeCustom)];
    //[recheckCancel setFrame:CGRectMake(100, 390, 100, 30)];
    [recheckCancel setFrame:CGRectMake(10, 10, 100, 30)];
    [recheckCancel setTitle:NSLocalizedString(@"Cancel", @"取消") forState:(UIControlStateNormal)];
    [[recheckCancel titleLabel] setFont:[UIFont systemFontOfSize:20]];
    [recheckCancel addTarget:self action:@selector(hideRecheckView) forControlEvents:(UIControlEventTouchUpInside)];
    recheckCancel.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    recheckCancel.titleLabel.textColor=[UIColor whiteColor];
    recheckCancel.backgroundColor = [UIColor colorWithRed:157/255.0 green:153/255.0 blue:190/255.0 alpha:1];
    [recheckCancel setBackgroundImage:UIUtil::ImageWithColor(117, 114, 184) forState:UIControlStateHighlighted];
    [recheckCancel setBackgroundImage:UIUtil::ImageWithColor(100,100,100) forState:UIControlStateDisabled];
    //[recheckView addSubview:recheckCancel];
    
    
    recheckConfirm = [UIButton buttonWithType:(UIButtonTypeCustom)];
    //[recheckConfirm setFrame:CGRectMake(340, 390, 100, 30)];
    [recheckConfirm setFrame:CGRectMake(430, 10, 100, 30)];
    [recheckConfirm setTitle:NSLocalizedString(@"Confirm", @"确认") forState:(UIControlStateNormal)];
    [recheckConfirm addTarget:self action:@selector(submit) forControlEvents:(UIControlEventTouchUpInside)];
    [[recheckConfirm titleLabel] setFont:[UIFont systemFontOfSize:20]];
    recheckConfirm.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    recheckConfirm.titleLabel.textColor=[UIColor whiteColor];
    recheckConfirm.backgroundColor = [UIColor colorWithRed:157/255.0 green:153/255.0 blue:190/255.0 alpha:1];
    [recheckConfirm setBackgroundImage:UIUtil::ImageWithColor(117, 114, 184) forState:UIControlStateHighlighted];
    [recheckConfirm setBackgroundImage:UIUtil::ImageWithColor(100,100,100) forState:UIControlStateDisabled];
    //[recheckView addSubview:recheckConfirm];
    
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.mixTable setHidden:YES];
        [_theExitButton setHidden:YES];
        [_theCustomerAddButton setHidden:YES];
        [_theBabyAddButton setHidden:YES];
        
        //[self.view addSubview:recheckLabel];
        [self.view addSubview:recheckCancel];
        [self.view addSubview:recheckConfirm];
        
        [self.view addSubview:recheckView];
    } completion:^(BOOL finished) {
        //
    }];
}
-(void)hideRecheckView{
    [UIView animateWithDuration:0.5 animations:^{
        [_theExitButton setHidden:NO];
        [_theCustomerAddButton setHidden:NO];
        [_theBabyAddButton setHidden:NO];
        [recheckCancel removeFromSuperview];
        [recheckConfirm removeFromSuperview];
        [self.mixTable setHidden:NO];
        [recheckView removeFromSuperview];
    } completion:^(BOOL finished) {
        //
    }];
}
-(void)submit{
    [self hideRecheckView];
    _LogLine();
    NSString* result=[_NewCustomer createCustomer];
    //    [cc reset];
    if(result!=nil){
        UIUtil::ShowAlert([NSString stringWithFormat: NSLocalizedString(@"Registered as [%@]", @"成功注册为[%@]"),result]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserRegistered" object:result];
        [self closeView:self];
    }
}
-(void)closeView:(id)sender{
    _Log(@"closeView called");
    [self dismissViewControllerAnimated:YES completion:^{
        _Log(@"New Customer Y VC dismissed");
    }];
}
@end
