//
//  DropDownList.m
//  LegalTap
//
//  Created by Apptunix on 3/11/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "DropDownList.h"

@implementation DropDownList

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

*/

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    imageView_BackGround.layer.borderWidth = 1.0;
    imageView_BackGround.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_lbl_Text setAdjustsFontSizeToFitWidth:YES];
    _lbl_Text.numberOfLines = 2;
}

-(void)hideBackGround
{
    imageView_BackGround.hidden = YES;
}
- (void)loadList:(NSArray*)array
{
    _list = array;
    if (array.count)
    {
        _lbl_Text.text = array[0];
    }
}

- (void)setImageViewCornerRadiouswithRadious:(CGFloat)radious
{
    imageView_BackGround.layer.cornerRadius = radious;
}

- (IBAction)btnClicked_OpenCloseList:(UIButton*)sender
{
    if (isOpen)
    {
        [self unLoadTableView];
    }
    else
    {
        [self loadTableView];
    }
    isOpen = !isOpen;
}

-(void)loadTableView
{
    CGFloat height = 150;

    tableView_List = [[UITableView alloc] init];
    {
        if (_list.count < 5)
        {
            height = 30*_list.count;
        }
        tableView_List.frame = CGRectMake(0,
                                          CGRectGetMaxY(btn_OpenCloseList.frame),
                                          CGRectGetWidth(self.frame),
                                          0);
        [UIView animateWithDuration:0.25 animations:^{
            
            tableView_List.frame = CGRectMake(0,
                                              CGRectGetMaxY(btn_OpenCloseList.frame),
                                              CGRectGetWidth(self.frame),
                                              height);
            
        } completion:^(BOOL finished) {
            
        }];
        
        tableView_List.delegate = self;
        tableView_List.dataSource = self;
        tableView_List.rowHeight = 30;
        tableView_List.backgroundColor = [UIColor whiteColor];
        
        tableView_List.layer.masksToBounds = YES;
        tableView_List.layer.cornerRadius = 6.0;
        
        tableView_List.layer.borderWidth = 1.0;
        tableView_List.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    [self addSubview:tableView_List];
    
    self.frame = CGRectMake(CGRectGetMinX(self.frame),
                            CGRectGetMinY(self.frame),
                            CGRectGetWidth(self.frame),
                            CGRectGetHeight(btn_OpenCloseList.frame) + height);
}

-(void)unLoadTableView
{
    [UIView animateWithDuration:0.25 animations:^{
        
        tableView_List.frame = CGRectMake(0,
                                          CGRectGetMaxY(btn_OpenCloseList.frame),
                                          CGRectGetWidth(self.frame),
                                          0);
        
    } completion:^(BOOL finished) {
        [tableView_List removeFromSuperview];
        tableView_List = nil;
        self.frame = CGRectMake(CGRectGetMinX(self.frame),
                                CGRectGetMinY(self.frame),
                                CGRectGetWidth(self.frame),
                                CGRectGetHeight(btn_OpenCloseList.frame));
    }];
}


#pragma mark Table View Data Source Method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger Number = _list.count;
    return Number;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }

    cell.textLabel.text = _list[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    [cell layoutIfNeeded];
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    [cell.textLabel setAdjustsFontSizeToFitWidth:YES];
    return cell;
}

#pragma Table View Delegates
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _lbl_Text.text = _list[indexPath.row];
    [self unLoadTableView];
    isOpen = !isOpen;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
