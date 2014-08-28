//
//  AboutUsVC.m
//  HaiLanZhiJia
//
//  Created by creaver on 13-11-28.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "AboutUsVC.h"

@interface AboutUsVC ()
{
   // UITextView *fildView;
}

@end

@implementation AboutUsVC

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
    [self setTitleString:@"关于我们"];
    [self initView];
    
}
//06-02关于我们.png
-(void)initView
{
    UIImage *aboutImage = GetImage(@"06-02关于我们.png");
    UIImageView *aboutView = [[UIImageView alloc]initWithFrame:CGRectMake(0, TITLEHEIGHT, GetImageWidth(aboutImage), GetImageHeight(aboutImage))];
    aboutView.image = aboutImage;
    [self.view addSubview:aboutView];
    [aboutView release];
    
    UILabel *banbenLabel = [[UILabel alloc]initWithFrame:CGRectMake(130, MainViewHeight-100, 40, 20)];
    banbenLabel.backgroundColor = [UIColor clearColor];
    banbenLabel.font = SYSTEMFONT(10);
    banbenLabel.text = @"版本号:";
    [aboutView addSubview:banbenLabel];
    [banbenLabel release];
    
    UILabel *viserLabel = [[UILabel alloc]initWithFrame:CGRectMake(130+40, MainViewHeight-100, 40, 20)];
    viserLabel.backgroundColor = [UIColor clearColor];
    viserLabel.font = SYSTEMFONT(10);
    viserLabel.text = self.viserStr;
    [aboutView addSubview:viserLabel];
    [viserLabel release];
    
    UITextView *textvAbout = [[UITextView alloc]init];
    [textvAbout setFont:SetFontSize(13)];
    [textvAbout setUserInteractionEnabled:NO];
    [textvAbout setTextColor:RGBACOLOR(72, 71, 71, 1)];
    [textvAbout setFrame:CGRectMake(15, 240, MainViewWidth - 30, 150)];
    [textvAbout setBackgroundColor:[UIColor clearColor]];
    [textvAbout setText:@"海澜之家服饰股份有限公司是一家集男装生产、销售为一体的大型服装企业。海澜之家品牌自2002年推出以来，以全国连锁、超大规模、男装自选的全新营销模式引发了中国服装市场的新一轮革命，其高品位、大众价的市场定位，款式多、品种全的货品选择，无干扰、自由自在的\"一站式\" 选购方式迅速赢得了广大消费者的喜爱，海澜之家因此被称为\"男人的衣柜\"。"];
    [self.view addSubview:textvAbout];
    [textvAbout release];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
