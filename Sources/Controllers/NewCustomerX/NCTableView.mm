//
//  NCTableView.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-19.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "NCTableView.h"

@implementation NCTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

#pragma mark - Delegate for Table

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_sectionArrayOfDict objectAtIndex:section]count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_sectionArrayOfDict count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"NewCustomerInfoCell";
    //LSShopMonoTableViewCell *cell = (LSShopMonoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //UITableViewCell
    NCTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        //cell = [[LSShopMonoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell=[[NCTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    //[[cell textLabel]setText:[NSString stringWithFormat:@"Section %d Row %d",indexPath.section,indexPath.row]];
    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    
    NSDictionary* dict=[_sectionArrayOfDict objectAtIndex:indexPath.section];
    if(indexPath.section==0){
        switch (indexPath.row) {
            case 0:
                //[[cell textLabel]setText:dict[@"title"]];
                [cell setCellWithTitle:[dict[@"title"] objectForKey:@"name"] withPreview:[dict[@"title"] objectForKey:@"value"] asTag:(indexPath.section*100+indexPath.row)];
                
                break;
            case 1:
                //[[cell textLabel]setText:dict[@"name"]];
                [cell setCellWithTitle:[dict[@"name"] objectForKey:@"name"] withPreview:[dict[@"name"] objectForKey:@"value"] asTag:(indexPath.section*100+indexPath.row)];
                cell.accessoryType =  UITableViewCellAccessoryNone;
                break;
            case 2:
                //[[cell textLabel]setText:dict[@"address"]];
                [cell setCellWithTitle:[dict[@"address"] objectForKey:@"name"] withPreview:[dict[@"address"] objectForKey:@"value"] asTag:(indexPath.section*100+indexPath.row)];
                break;
            case 3:
                //[[cell textLabel]setText:dict[@"contact"]];
                [cell setCellWithTitle:[dict[@"contact"] objectForKey:@"name"] withPreview:[dict[@"contact"] objectForKey:@"value"] asTag:(indexPath.section*100+indexPath.row)];
                break;
            /*
            case 4:
                [cell setCellWithTitle:[dict[@"contact"] objectForKey:@"name"] withPreview:[dict[@"contact"] objectForKey:@"value"] asTag:(indexPath.section*100+indexPath.row)];
             */
                break;
             
            default:
                [[cell textLabel]setText:@"!"];
                break;
        }
    }else{
        switch (indexPath.row) {
            case 0:
                //[[cell textLabel]setText:dict[@"nick"]];
                [cell setCellWithTitle:[dict[@"nick"] objectForKey:@"name"] withPreview:[dict[@"nick"] objectForKey:@"value"] asTag:(indexPath.section*100+indexPath.row)];
                break;
            case 1:
                //[[cell textLabel]setText:dict[@"birthday"]];
                [cell setCellWithTitle:[dict[@"birthday"] objectForKey:@"name"] withPreview:[dict[@"birthday"] objectForKey:@"value"] asTag:(indexPath.section*100+indexPath.row)];
                break;
            case 2:
                //[[cell textLabel]setText:dict[@"sex"]];
                [cell setCellWithTitle:[dict[@"sex"] objectForKey:@"name"] withPreview:[dict[@"sex"] objectForKey:@"value"] asTag:(indexPath.section*100+indexPath.row)];
                break;
            default:
                [[cell textLabel]setText:@"!"];
                break;
        }
    }
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if([view isKindOfClass:[UITableViewHeaderFooterView class]]){
        UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *) view;
        //tableViewHeaderFooterView.textLabel.textColor = [UIColor blueColor];
        tableViewHeaderFooterView.textLabel.font=[UIFont systemFontOfSize:20];
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section==0){
        return  NSLocalizedString(@"Customer Information", @"顾客信息");
    }else{
        return  NSLocalizedString(@"Baby Information", @"宝宝信息");
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_NCDelegate){
        [_NCDelegate processTableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    [self deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Response to buttons

@end
