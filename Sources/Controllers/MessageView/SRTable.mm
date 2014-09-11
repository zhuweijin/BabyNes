//
//  SRTable.m
//  BabyNes
//
//  Created by 倪 李俊 on 14-7-17.
//  Copyright (c) 2014年 Yonsm. All rights reserved.
//

#import "SRTable.h"
#import "LocalSRMessageTool.h"

@interface SRTable ()

+(NSString*)getSRCellReuseId;

@end

@implementation SRTable

+(NSString*)getSRCellReuseId{
    static NSString* SRTableCellReuseId=@"SRTableCell";
    return SRTableCellReuseId;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int c=[[LocalSRMessageTool getSRArrayIfForce:NO] count];
    _Log(@"SRTable numberOfRowsInSection=%d",c);
    return c;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SRTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[SRTable getSRCellReuseId]];
    
    if(cell==nil){
        cell=[[SRTableCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:[SRTable getSRCellReuseId]];
    }
    
    // Configure the cell...
    SRMessage* srm=[[LocalSRMessageTool getSRArrayIfForce:NO] objectAtIndex:indexPath.row];
    [cell setSRMessage:srm];
    
    CGRect lframe=cell.frame;
    lframe.origin.x=0;
    lframe.origin.y=self.rowHeight-1;//lframe.size.height;
    lframe.size.width=self.frame.size.width;
    lframe.size.height=1;
    if(cell.lineView){
        [cell.lineView removeFromSuperview];
    }
    cell.lineView = [[UIView alloc]initWithFrame:lframe];
    [cell.lineView setBackgroundColor:[UIColor grayColor]];
    [cell addSubview: cell.lineView];
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SRSelected" object:[(SRTableCell*)[self cellForRowAtIndexPath:indexPath] msg]];
}

#pragma UIViewScrollerDelegate
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if(_theSVDelegate){
        _Log(@"SRTable scrollViewWillEndDragging withVelocity targetContentOffset!");
         [_theSVDelegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}

-(BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    if(_theSVDelegate){
        _Log(@"SRTable scrollViewShouldScrollToTop !");
        return [_theSVDelegate scrollViewShouldScrollToTop:scrollView];
    }else{
        return YES;
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if(_theSVDelegate){
        _Log(@"SRTable scrollViewWillBeginDragging !");
        [_theSVDelegate scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(_theSVDelegate){
        _Log(@"SRTable scrollViewDidEndDragging !");
        [_theSVDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(_theSVDelegate){
        _Log(@"SRTable scrollViewDidEndDecelerating !");
        [_theSVDelegate scrollViewDidEndDecelerating:scrollView];
    }
}

@end
