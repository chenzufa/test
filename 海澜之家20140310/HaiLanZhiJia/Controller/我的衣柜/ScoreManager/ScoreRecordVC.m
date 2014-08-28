 //
//  ScoreRecordVC.m
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-11-26.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "ScoreRecordVC.h"
#import "ScoreRecordCell.h"
#import "UITableView+RemindNoData.h"
@interface ScoreRecordVC ()

@end

@implementation ScoreRecordVC
{
    UITableView *srTableView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    self.recored = nil;
    [srTableView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setTitleString:@"积分记录"];
    
    srTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, TITLEHEIGHT, MainViewWidth, MainViewHeight - TITLEHEIGHT - 20)];
    [srTableView setShowsVerticalScrollIndicator:NO];
    srTableView.delegate = self;
    srTableView.dataSource = self;
    [srTableView setBackgroundColor:[UIColor clearColor]];
    srTableView.tableFooterView = [[[UIView alloc]init]autorelease];
    [self.view addSubview:srTableView];
    
    if (self.recored.count == 0) {
        [srTableView addRemindWhenNoData:@"抱歉，您还没有积分记录"];
    }
}

#pragma mark UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recored.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"tableviewcell";
    ScoreRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[ScoreRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]autorelease];
    }
    
    ScoreEntity *one = [self.recored objectAtIndex:indexPath.row];
    
    [cell setLabTime:one.date labMessage:one.detail];
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
