//
//  VitNewsUI.m
//  VitMobile
//
//  Created by Aaron.Wu on 12-7-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "VTNewsUI.h"

@interface VTNewsUI ()

@end

@implementation VTNewsUI
@synthesize newsDictArry;

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self.tableView setBackgroundColor:[UIColor lightTextColor]];
//    [self.tableView setAlpha:0.85];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma tableview datasource & delegate


//for the section header

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [newsDictArry count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDictionary *groupDic =  [newsDictArry objectAtIndex:section];
    NSString *sectionNewsTitle = [groupDic objectForKey:VITNEWSDICTKEY_SECTION_TITLE];
    return sectionNewsTitle;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{   
    NSDictionary *groupDic =  [newsDictArry objectAtIndex:section];
    NSArray *sectionNewsArray = [groupDic objectForKey:VITNEWSDICTKEY_NEWS_ARRAY];
    return [sectionNewsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSDictionary *groupDic =  [newsDictArry objectAtIndex:indexPath.section];
    NSArray *sectionNewsArray = [groupDic objectForKey:VITNEWSDICTKEY_NEWS_ARRAY];
    NSDictionary *news =  [sectionNewsArray objectAtIndex:indexPath.row];
    NSString *text = [news objectForKey:VITNEWSDICTKEY_NEWSCONTENT];
    NSString *authandDate = [news objectForKey:VITNEWSDICTKEY_NEWSDATE];
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FS_BODY_CONTENT] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    CGFloat height = MAX(size.height, 44.0f);
    if (authandDate) {
        return height + (CELL_CONTENT_MARGIN * 2)+SUBLABEL_HEIGHT;
    }
    return height+ (CELL_CONTENT_MARGIN * 2);
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    UILabel *label,*subLabel = nil;
    UIImageView *new;
    static NSString *cellIdentity = @"VitNewsCell";
    cell = [tv dequeueReusableCellWithIdentifier:cellIdentity];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        [label setLineBreakMode:UILineBreakModeWordWrap];
        [label setMinimumFontSize:FS_BODY_CONTENT];
        [label setNumberOfLines:0];
        [label setFont:[UIFont systemFontOfSize:FS_BODY_CONTENT]];
        [label setTag:1];
        label.backgroundColor = [UIColor clearColor];
        //add the cell seperator on cell top
        UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 5)];
        line1.image = [UIImage imageNamed:@"cell_seperator"];
        [[cell contentView]addSubview:line1];
        [[cell contentView] addSubview:label];
        
        subLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [subLabel setLineBreakMode:UILineBreakModeWordWrap];
        [subLabel setMinimumFontSize:FS_SUB_CONTENT];
        [subLabel setNumberOfLines:0];
        [subLabel setFont:[UIFont systemFontOfSize:FS_SUB_CONTENT]];
        [subLabel setTextAlignment:UITextAlignmentLeft];
        [subLabel setTag:2];
        subLabel.textColor = [UIColor grayColor];
        subLabel.backgroundColor = [UIColor clearColor];
        [[cell contentView] addSubview:subLabel];
        
        new = [[UIImageView alloc] initWithFrame:CGRectZero];
        [new setImage:[UIImage imageNamed:@"new4"]];
        [new setFrame:CGRectMake(290, 8, 26, 26)];
        new.alpha = 0.8;
        [new setTag:3];
        [[cell contentView] addSubview:new];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [VTUtils setCellBgColor:tv :indexPath :cell];
    }

    NSDictionary *groupDic =  [newsDictArry objectAtIndex:indexPath.section];
    NSArray *sectionNewsArray = [groupDic objectForKey:VITNEWSDICTKEY_NEWS_ARRAY];
    NSDictionary *news =  [sectionNewsArray objectAtIndex:indexPath.row];
    NSString *text = [news objectForKey:VITNEWSDICTKEY_NEWSCONTENT];
    NSString *authandDate = [news objectForKey:VITNEWSDICTKEY_NEWSDATE];
    Boolean displayNews = [[news objectForKey:VITNEWSDICTKEY_NEWSICON] boolValue];
    
    //for the content setting    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FS_BODY_CONTENT] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    label = (UILabel*)[cell viewWithTag:1]; 
    [label setText:text];
    [label setFrame:CGRectMake(CELL_CONTENT_MARGIN_LEFT, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.height, 44.0f))];
    if(authandDate){
        subLabel = (UILabel*)[cell viewWithTag:2];
        [subLabel setText:authandDate];
        [subLabel setFrame:CGRectMake(CELL_CONTENT_MARGIN_LEFT, CELL_CONTENT_MARGIN+MAX(size.height, 44.0f), CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), SUBLABEL_HEIGHT)];
    }
    // display news or not
    new = (UIImageView*) [cell viewWithTag:3];
    [new setHidden:!displayNews];
    //set the cell label text color and font size
    cell.textLabel.textColor = [UIColor colorWithRed:FC_LABEL_R green:FC_LABEL_G blue:FC_LABEL_B alpha:1];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:FS_BODY_CONTENT];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
