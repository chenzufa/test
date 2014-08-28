//
//  HelpCrnterVC.m
//  HaiLanZhiJia
//
//  Created by creaver on 13-11-28.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "HelpCrnterVC.h"
#import "RetureVC.h"
#import "DSRequest.h"
@interface HelpCrnterVC ()<UITableViewDataSource,UITableViewDelegate,DSRequestDelegate>

{
    UITableView *helpTable;
    NSMutableArray *titleAry;
    
    
}

@property(nonatomic,retain)NSArray *helpList;
@property(nonatomic,retain)NSString *serveNo;
@property(nonatomic,retain)NSArray *joinAry;
@property(nonatomic,retain)DSRequest *aRequest;

@end

@implementation HelpCrnterVC


- (void)dealloc
{
    SAFETY_RELEASE(helpTable);
    SAFETY_RELEASE(titleAry);
    self.aRequest.delegate = nil;
    self.aRequest = nil;
    self.joinAry = nil;
    [super dealloc];
}

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
    
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    
    titleAry = [[NSMutableArray alloc]initWithObjects:@"货到付款区域查询",@"退换货政策",@"退换货流程",@"退款方式",@"隐私声明", nil];
    [self setTitleString:@"帮助中心"];
    [self initDate];
    
    
	// Do any additional setup after loading the view.
}

-(void)initView
{
    UIScrollView *myScro = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 50, MainViewWidth, MainViewHeight - TITLEHEIGHT - 20)];
    myScro.contentSize = CGSizeMake(MainViewWidth, self.helpList.count*45+(self.joinAry.count+1)*45+25+20+40+10+20);
    myScro.backgroundColor = VIEW_BACKGROUND_COLOR;
    [self.view addSubview:myScro];
    [myScro release];
    
    helpTable = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, 300, self.helpList.count*45)];
    helpTable.backgroundColor = [UIColor clearColor];
    [helpTable setShowsVerticalScrollIndicator:NO];
    helpTable.delegate = self;
    helpTable.scrollEnabled = NO;
    helpTable.dataSource = self;
    if ([helpTable respondsToSelector:@selector(setSeparatorInset:)]) { //去掉ios7每行分割线前的空白
        [helpTable setSeparatorInset:UIEdgeInsetsZero];
    }

    //helpTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    helpTable.tableFooterView = [[[UIView alloc]init]autorelease];
    [myScro addSubview:helpTable];
    
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.helpList.count*45+20, 200, 20)];
    phoneLabel.text = @"客户服务热线(仅收市话费)";
    phoneLabel.font = SYSTEMFONT(14);
    phoneLabel.backgroundColor = [UIColor clearColor];
    [myScro addSubview:phoneLabel];
    [phoneLabel release];
    
    UIImage *fuwuImage = GETIMG(@"button4.png");
    UIButton *fuwuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fuwuBtn.tag = 1001;
    [fuwuBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [fuwuBtn setTitle:self.serveNo forState:UIControlStateNormal];
    [fuwuBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    fuwuBtn.frame = CGRectMake(10,self.helpList.count*45+50, fuwuImage.size.width, fuwuImage.size.height);
    
    [fuwuBtn setBackgroundImage:GETIMG(@"button4.png") forState:UIControlStateNormal];
    [fuwuBtn setBackgroundImage:GETIMG(@"button4_press.png") forState:UIControlStateHighlighted];
    [myScro addSubview:fuwuBtn];
    

//    UILabel *jiaMengLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.helpList.count*45+50+fuwuImage.size.height+10, 200, 20)];
//    jiaMengLabel.text = @"加盟热线";
//    jiaMengLabel.font = SYSTEMFONT(14);
//    jiaMengLabel.backgroundColor = [UIColor clearColor];
//    [myScro addSubview:jiaMengLabel];
//    [jiaMengLabel release];
//    
//    for (int i=0; i<self.joinAry.count; i++)
//    {
//        UIButton *jiamengBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        jiamengBtn.frame = CGRectMake(10, self.helpList.count*45+50+fuwuImage.size.height+10+25+50*i, fuwuImage.size.width, fuwuImage.size.height);
//        [jiamengBtn setBackgroundImage:GETIMG(@"button4.png") forState:UIControlStateNormal];
//        jiamengBtn.tag = 1002+i;
//        [jiamengBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [jiamengBtn setTitle:[self.joinAry objectAtIndex:i] forState:UIControlStateNormal];
//        [jiamengBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [jiamengBtn setBackgroundImage:GETIMG(@"button4_press.png") forState:UIControlStateHighlighted];
//        [myScro addSubview:jiamengBtn];
//    }
 
}


-(void)initDate
{
     [self addHud:Loading];
    
    DSRequest *requestObj = [[DSRequest alloc]init];
    self.aRequest = requestObj;
    requestObj.delegate = self;
    [requestObj requestDataWithInterface:GetHelpInfo param:[self GetHelpInfoParam] tag:0];
    [requestObj release]; 
}

-(void)requestDataSuccess:(id)dataObj tag:(int)tag
{
    [self hideHud:nil];
    HelpInfoEntity* entity = (HelpInfoEntity *)dataObj;
   // self.helpList = [NSArray arrayWithObjects:@"1",@"4",@"2",@"1",@"5", nil];
    self.helpList = entity.helplist;//帮助列表
    self.joinAry = entity.jointel;//加盟热线
    self.serveNo = entity.servicetel;
    //服务热线
 //   [helpTable reloadData];
    [self initView];
    
    
    
}

-(void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError *)error
{
    NSLog(@"失败");
    [self hideHud:nil];
     [self addFadeLabel:error.domain];
}
-(void)clickBtn:(UIButton *)btn
{
       //服务
    if(btn.tag == 1001)
    {
        [WCAlertView showAlertWithTitle:@"提示" message:@"确定呼叫电话吗？" customizationBlock:^(WCAlertView *alertView) {
            alertView.style = WCAlertViewStyleWhite;
            alertView.labelTextColor=[UIColor blackColor];
            alertView.buttonTextColor=[UIColor blueColor];
        } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
            if (buttonIndex == 0) {
                NSLog(@"Cancel");
            } else {
                NSLog(@"Ok");
                NSURL* telUrl=[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.serveNo]];
                [[UIApplication sharedApplication]openURL:telUrl];
            }
            
        } cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
 
    }
    //加盟
//    else
//    {
//        NSString *telStrint = [NSString stringWithFormat:@"tel://%@",[self.joinAry objectAtIndex:btn.tag-1002]];
//        [WCAlertView showAlertWithTitle:@"提示" message:@"确定呼叫电话吗？" customizationBlock:^(WCAlertView *alertView) {
//            alertView.style = WCAlertViewStyleWhite;
//            alertView.labelTextColor=[UIColor blackColor];
//            alertView.buttonTextColor=[UIColor blueColor];
//        } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
//            if (buttonIndex == 0) {
//                NSLog(@"Cancel");
//            } else {
//                NSLog(@"Ok");
//                NSURL* telUrl=[NSURL URLWithString:telStrint];
//                [[UIApplication sharedApplication]openURL:telUrl];
//            }
//            
//        } cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
//    }
}

#pragma mark ---tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.helpList.count;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    HelpCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if(cell == nil)
    {
        cell = [[[HelpCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
    }
    HelpEntity *entity = [self.helpList objectAtIndex:indexPath.row];
    [cell setCellBackGroundView:indexPath.row andMax:self.helpList.count-1];//背景框 由于不确定数量，所有把最大row传过去
    [cell creatCell:entity.title];//网络标题
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HelpEntity *entity = [self.helpList objectAtIndex:indexPath.row];
    switch (indexPath.row) {
        case 0:
        {
            LocationVC *locView = [[LocationVC alloc]init];
            locView.thisTiltle = entity.title;
            locView.detailString = entity.detail;
            [self pushViewController:locView];
            [locView release];
        }
            break;
        case 1:
        {
            RetureVC *returnGoodView = [[RetureVC alloc]init];
            returnGoodView.detailString = entity.detail;
            returnGoodView.thisTitle = entity.title;
            [self pushViewController:returnGoodView];
            [returnGoodView release];
        }
            break;
        case 2:
        {
            TuiHuoLiuVC *tuihuoView = [[TuiHuoLiuVC alloc]init];
            tuihuoView.thisTitle = entity.title;
            tuihuoView.detailString = entity.detail;
            [self pushViewController:tuihuoView];
            [tuihuoView release];
        }
            break;
        case 3:
        {
            TuiKuanVC *tuikuanView = [[TuiKuanVC alloc]init];
            tuikuanView.thisTitle = entity.title;
            tuikuanView.detailString = entity.detail;
            [self pushViewController:tuikuanView];
            [tuikuanView release];
        }
            break;
            
        case 4:
        {
            NSLog(@"隐私声明");
            SecretVC *secretView = [[SecretVC alloc]init];
            secretView.thisTitle = secretView.title;
            secretView.detailString = entity.detail;
            [self pushViewController:secretView];
            [secretView release];
        }
            break;
            
        default:
            break;
    }}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
