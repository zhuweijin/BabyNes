//
//  LSComboBox.m
//  BabyNesPOS_Akatsuki
//
//  Created by 倪 李俊 on 14-6-23.
//  Copyright (c) 2014年 Leqee. All rights reserved.
//

#import "LSComboBox.h"

@interface LSComboBox ()
@property CGRect txtFrame;
@property CGRect buttonFrame;
@property CGRect listFrame;
@property CGRect upFrame;
@property CGRect downFrame;
@property CGRect cellButtonFrame;
@end

@implementation LSComboBox

-(void) countFrames{
    self.cellButtonFrame=CGRectMake(0, 0, self.upFrame.size.width, self.upFrame.size.height);
    self.txtFrame=CGRectMake(0, 0, self.upFrame.size.width-self.upFrame.size.height, self.upFrame.size.height);
    self.buttonFrame=CGRectMake(self.txtFrame.size.width, 0, self.upFrame.size.height, self.upFrame.size.height);
    
    int array_len=0;
    if([self theArray]!=nil){
        array_len=[[self theArray]count];
        if(array_len>=4){
            array_len=4;
        }
    }
    
    //self.listFrame=CGRectMake(0, self.upFrame.size.height, self.upFrame.size.width-self.upFrame.size.height, self.upFrame.size.height*array_len);
    self.listFrame=CGRectMake(self.frame.origin.x, self.frame.origin.y+self.upFrame.size.height, self.upFrame.size.width, self.upFrame.size.height*array_len);
    self.downFrame=CGRectMake(self.upFrame.origin.x,self.upFrame.origin.y, self.upFrame.size.width, self.upFrame.size.height+self.listFrame.size.height);
}

- (void)designView{
    [self countFrames];
    
    UIColor* cbColor=[UIColor colorWithRed:242/255.0 green:242/255.0 blue:244/255.0 alpha:0.9];
    
    self.theTextfield=[[UITextField alloc]initWithFrame:self.txtFrame];
    [self.theTextfield setTextAlignment:(NSTextAlignmentCenter)];
    [self.theTextfield setBorderStyle:(UITextBorderStyleNone)];
    [self.theTextfield setBackgroundColor:cbColor];
    [self.theTextfield setPlaceholder:self.setsumei];
    [self setValue_string:@""];
    [self.theTextfield setUserInteractionEnabled:NO];
    [self addSubview:self.theTextfield];
    
    self.theArrowButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.theArrowButton.frame=self.buttonFrame;
    [self.theArrowButton setBackgroundColor:cbColor];
    [self.theArrowButton setBackgroundImage:UIUtil::Image(@"app/arrow_down@2x.png")
//     [UIImage imageNamed:@"arrow_down@2x.png"]
                                   forState:UIControlStateNormal];
    [self.theArrowButton addTarget:self action:@selector(arrowButtonGo:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.theArrowButton];
    
    self.theList = [[UITableView alloc] initWithFrame:self.listFrame style:(UITableViewStylePlain)];
    [self.theList setDelegate:self];
    [self.theList setDataSource:self];
    [self.theList setRowHeight:self.upFrame.size.height];
    //[self.theList setUserInteractionEnabled:YES];
    [self.theList setSeparatorStyle:(UITableViewCellSeparatorStyleSingleLineEtched)];
    
    //[self addSubview:self.theList];
    [self.theList setHidden:YES];
    
}

- (id)initWithFrame:(CGRect)frame withinController:(UIViewController*)controller withData:(NSArray*)array withSetsumei:(NSString*)theSetsumei{
    self = [super initWithFrame:frame];
    if (self) {
        self.theController=controller;
        // Initialization code
        //_Log(@"LSComboBox[%@] Array=[%@]",theSetsumei,array);
        
        self.upFrame=frame;
        self.setsumei=theSetsumei;
        [self loadDataForSelection:array];
        [self designView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withinController:(UIViewController*)controller{
    self = [super initWithFrame:frame];
    if (self) {
        self.upFrame=frame;
        self.theController=controller;
        // Initialization code
        [self designView];
    }
    return self;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.upFrame=frame;
        // Initialization code
        [self designView];
    }
    return self;
}

-(void) loadDataForSelection:(NSArray *) array{
    [self setTheArray:[[NSMutableArray alloc]initWithArray:array]];
}

-(void) reloadDataForSelection:(NSArray *) array{
    [self setTheArray:[[NSMutableArray alloc]initWithArray:array]];
    [self countFrames];
    [self.theTextfield setPlaceholder:self.setsumei];
    [self setValue_string:@""];
    self.theTextfield.text=@"";
    [self.theList setFrame:self.listFrame];
    [self.theList reloadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //_Log(@"[self.theArray count]=%d",[self.theArray count]);
    return [self.theArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    //NSString *key=[NSString stringWithFormat:@"section %d row %d",section,row]; //[_arrayType objectAtIndex:section];
    
    static NSString *CellIdentifier = @"CBTypeCell";
    LSComboBoxCell *cell =(LSComboBoxCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        //_Log(@"cell is nil for row %d",row);
        cell = [[LSComboBoxCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell loadforComboBox:self withTag:row withText:[self.theArray objectAtIndex:row] asFrame:self.cellButtonFrame];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    _Log(@"CB第%d个section中第%d行的被点击",indexPath.section, indexPath.row);
    [self.theTextfield setText:[self.theArray objectAtIndex:indexPath.row]];
    [self.theList setHidden:YES];
    [self.theArrowButton setBackgroundImage:[UIImage imageNamed:@"arrow_down@2x.png"] forState:UIControlStateNormal];
     */
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)select_item:(id)sender{
    int tag=[sender tag];
    _Log(@"select_item tag=[%d]", tag);
    [self.theTextfield setText:[self.theArray objectAtIndex:tag]];
    [self.theList setHidden:YES];
    [self.theList removeFromSuperview];
    [self.theArrowButton setBackgroundImage: UIUtil::Image(@"app/arrow_down@2x.png")
//     [UIImage imageNamed:@"arrow_down@2x.png"]
                                   forState:UIControlStateNormal];
    [self setValue_string:self.theTextfield.text];
    [self sendActionsForControlEvents:UIControlEventEditingDidEnd];
}

-(void)arrowButtonGo:(id)sender{
    //_Log(@"LSComboBox showList called");
    if([self.theList isHidden]){
        [self.theList setHidden:NO];
        [self.superview addSubview: self.theList];
        [self.theArrowButton setBackgroundImage:UIUtil::Image(@"app/arrow_up@2x.png")
         //     [UIImage imageNamed:@"arrow_up@2x.png"]
                                       forState:UIControlStateNormal];
        [self setFrame:self.downFrame];
    }else{
        [self.theList setHidden:YES];
        [self.theList removeFromSuperview];
        [self.theArrowButton setBackgroundImage:UIUtil::Image(@"app/arrow_down@2x.png")
         //     [UIImage imageNamed:@"arrow_down@2x.png"]
                                       forState:UIControlStateNormal];
        [self setFrame:self.upFrame];
    }
}


@end

