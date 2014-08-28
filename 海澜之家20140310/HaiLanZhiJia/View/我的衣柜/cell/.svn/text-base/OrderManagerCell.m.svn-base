//
//  OrderManagerCell.m
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-11-21.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "OrderManagerCell.h"

@implementation OrderManagerCell
{
    UILabel *labOrderNum;   // 订单号
    UILabel *labMoney;      // 订单金额
    UILabel *labIsDeliverPay;   // 货到付款
    UILabel *labOrderTime;  // 下单时间
    
    UILabel *labState;      // 订单状态
    
    UIButton *btnCancel;    // 取消订单按钮
    UIButton *btnPay;       // 在线支付按钮
    
//    int currType;
}



- (void)dealloc
{
    [labOrderNum release];
    [labMoney release];
    [labIsDeliverPay release];
    [labOrderTime release];
    
    [labState release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        UIEdgeInsets inset = UIEdgeInsetsMake(10, 10, 10, 10);
        UIImage *backImg = GetImage(@"bg_list.png");
//        UIImage *selectBackImg = GetImage(@"bg_list_press.png");
        backImg = [backImg resizableImageWithCapInsets:inset];
//        selectBackImg = [selectBackImg resizableImageWithCapInsets:inset];
        self.backgroundView = [[[UIImageView alloc]initWithImage:backImg]autorelease];
//        self.selectedBackgroundView = [[[UIImageView alloc]initWithImage:selectBackImg]autorelease];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    labOrderNum = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 250, FontSize15)];
    [self.contentView addSubview:labOrderNum];
    [labOrderNum setFont:SetFontSize(FontSize15)];
    [labOrderNum setTextColor:ColorFontBlack];
    
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(labOrderNum.frame.origin.x, labOrderNum.frame.origin.y + 18, 75, FontSize15)];
    [self.contentView addSubview:lab1];
    [lab1 setFont:SetFontSize(FontSize15)];
    [lab1 setText:@"订单金额："];
    [lab1 setTextColor:ColorFontBlack];
    
    labMoney = [[UILabel alloc]initWithFrame:CGRectMake(lab1.frame.origin.x + lab1.frame.size.width, lab1.frame.origin.y, 200, FontSize15)];
    [self.contentView addSubview:labMoney];
    [labMoney setFont:SetFontSize(FontSize15)];
    [labMoney setTextColor:ColorFontRed];
    
    labIsDeliverPay = [[UILabel alloc]initWithFrame:CGRectMake(lab1.frame.origin.x + lab1.frame.size.width, lab1.frame.origin.y, 200, FontSize15)];
    labIsDeliverPay.hidden = YES;
    [labIsDeliverPay setText:@"(货到付款)"];
    [self.contentView addSubview:labIsDeliverPay];
    [labIsDeliverPay setFont:SetFontSize(FontSize15)];
    [labIsDeliverPay setTextColor:ColorFontBlack];
    
    
    labOrderTime = [[UILabel alloc]initWithFrame:CGRectMake(labOrderNum.frame.origin.x, labMoney.frame.origin.y + 18, labOrderNum.frame.size.width, FontSize15)];
    [self.contentView addSubview:labOrderTime];
    [labOrderTime setFont:SetFontSize(FontSize15)];
    [labOrderTime setTextColor:ColorFontBlack];
    
    UIImageView *lineView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"segmentation_line.png"]];
    [lineView setFrame:CGRectMake(0, labOrderTime.frame.origin.y + labOrderTime.frame.size.height + 10, lineView.image.size.width, lineView.image.size.height)];
    [self.contentView addSubview:lineView];
    
    labState = [[UILabel alloc]initWithFrame:CGRectMake(labOrderNum.frame.origin.x, lineView.frame.origin.y , self.frame.size.width - 30, 50)];
    [self.contentView addSubview:labState];
    [labState setFont:SetFontSize(FontSize12)];
    [labState setBackgroundColor:[UIColor clearColor]];
    [labState setUserInteractionEnabled:YES];
    [labState setTextColor:[UIColor colorWithRed:0.471 green:0.471 blue:0.471 alpha:1]];        //用label盖住下半部分  使其点击无效 海澜傻逼提的脑残需求
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:nil];
    [labState addGestureRecognizer:tap];
    [tap release];
    
    btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCancel setImage:GetImage(@"user_button_cansel.png") forState:UIControlStateNormal];
    [btnCancel setImage:GetImage(@"user_button_cansel_press.png") forState:UIControlStateHighlighted];
    [btnCancel setFrame:CGRectMake(130, lineView.frame.origin.y + 11, btnCancel.imageView.image.size.width, btnCancel.imageView.image.size.height)];
    [self.contentView addSubview:btnCancel];
    [btnCancel addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    btnCancel.tag = 0;
    
    btnPay = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnPay setImage:GetImage(@"user_button_pay.png") forState:UIControlStateNormal];
    [btnPay setImage:GetImage(@"user_button_pay_press.png") forState:UIControlStateHighlighted];
    [btnPay setFrame:CGRectMake(btnCancel.frame.origin.x + btnCancel.frame.size.width + 15, lineView.frame.origin.y + 11, btnPay.imageView.image.size.width, btnPay.imageView.image.size.height)];
    [self.contentView addSubview:btnPay];
    btnPay.tag = 1;
    [btnPay addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    
//    UIImageView *arrowImgView = [[UIImageView alloc]initWithImage:GetImage(@"icon_next.png")];
//    [arrowImgView setFrame:CGRectMake(283, labMoney.frame.origin.y, arrowImgView.image.size.width, arrowImgView.image.size.height)];
//    [self.contentView addSubview:arrowImgView];
    
    [self setArrowCenterY:labMoney.center.y];
    
    [lab1 release];
    [lineView release];
//    [arrowImgView release];
}

- (void)clicked:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(orderManagerCell:clickedAtButtonIndex:cellType:)]) {
        [self.delegate orderManagerCell:self clickedAtButtonIndex:btn.tag cellType:self.cellType];
    }
}

-(void)setContentsByOrderEntity:(OrderEntity *) entity{
    [labOrderNum setText:[NSString stringWithFormat:@"订单号：%@",entity.ordernumber]];
    [labMoney setText:[NSString stringWithFormat:@"￥%@",entity.amount]];
    [labOrderTime setText:[NSString stringWithFormat:@"下单时间：%@",entity.orderdate]];
    
    
    //orderstatus 订单状态  （0，未确认；1，已确认；2，已取消；3，无效；4，退货；5，锁定；6，解锁；7，完成；8，拒收；9，已合并；10，已拆分；）
    NSMutableArray * myOrderStatusArr = [NSMutableArray arrayWithObjects:@"未确认",@"已确认",@"已取消",@"无效",@"退货",@"锁定",@"解锁",@"完成",@"拒收",@"已合并",@"已拆分", nil];
    NSString *strOrderStatus = @"";
    if (entity.orderstatus >=0 && entity.orderstatus <=10) {
        strOrderStatus = [myOrderStatusArr objectAtIndex:entity.orderstatus];
    }
    
    //paystatus 支付状态；0，未付款；1，付款中；2，已付款；3，已结算
    
    //modified by caijunbo on 2014-02-10
//    NSMutableArray * myPayStautsArr = [NSMutableArray arrayWithObjects:@"未付款",@"付款中",@"已结算", nil];
    NSMutableArray * myPayStautsArr = [NSMutableArray arrayWithObjects:@"未付款",@"付款中",@"已付款",@"已结算", nil];
    //end modifying
    NSString *strPayStatus = @"";
    if (entity.paystatus >=0 && entity.paystatus <=3) {
        strPayStatus = [myPayStautsArr objectAtIndex:entity.paystatus];
    }
    
    //deliverstatus 商品配送情况，0，未发货；1，已发货；2，已收货；3，备货中
    //modified by caijunbo on 2014-02-10
//    NSMutableArray * myDeliverStautsArr = [NSMutableArray arrayWithObjects:@"未发货",@"已发货",@"已收货",nil];
     //end modifying
    NSMutableArray * myDeliverStautsArr = [NSMutableArray arrayWithObjects:@"未发货",@"已发货",@"已收货",@"备货中",nil];
    NSString *strDeliverStatus = @"";
    if (entity.deliverstatus >=0 && entity.deliverstatus <=3) {
        strDeliverStatus = [myDeliverStautsArr objectAtIndex:entity.deliverstatus];
    }
    
    switch (self.cellType) {
        case CellTypeGoing:
            //付款方式 1.在线支付 2.货到付款
            [btnPay setImage:GetImage(@"user_button_pay.png") forState:UIControlStateNormal];
            [btnPay setImage:GetImage(@"user_button_pay_press.png") forState:UIControlStateHighlighted];
            //paytype 1.在线付款，显示的是订单状态和支付状态
            if (entity.paytype ==1)
            {
                labIsDeliverPay.hidden = YES;
                
                if (entity.paystatus == 0) {
                    btnPay.hidden = NO;
                }else btnPay.hidden = YES;
                
                if (entity.deliverstatus == 0) {
                    btnCancel.hidden = NO;
                }else btnCancel.hidden = YES;
                
                if (btnPay.hidden) {
                    [btnCancel setFrame:btnPay.frame];
                }else [btnCancel setFrame:CGRectMake(130, btnCancel.frame.origin.y, btnCancel.frame.size.width, btnCancel.frame.size.height)];
                
                [labState setText:[NSString stringWithFormat:@"%@ %@",strOrderStatus,strPayStatus]];
            }
            // 2.货到付款，显示的是商品配送情况
            else if (entity.paytype ==2)
            {
                //让"(货到付款)"字段自动适应
                NSString *myStr = [NSString stringWithFormat:@"￥%@",entity.amount];
                CGSize mySize = [myStr sizeWithFont:labMoney.font forWidth:CGFLOAT_MAX lineBreakMode:NSLineBreakByCharWrapping];
                [labMoney setFrame:CGRectMake(labMoney.frame.origin.x, labMoney.frame.origin.y, mySize.width, labMoney.frame.size.height)];
                [labIsDeliverPay setFrame:CGRectMake(labMoney.frame.origin.x+mySize.width, labMoney.frame.origin.y, labIsDeliverPay.frame.size.width, labIsDeliverPay.frame.size.height)];
                labIsDeliverPay.hidden = NO;
                
                btnPay.hidden = YES;
                [btnCancel setFrame:CGRectMake(130 + btnCancel.frame.size.width +15, btnCancel.frame.origin.y, btnCancel.frame.size.width, btnCancel.frame.size.height)];
                [labState setText:strDeliverStatus];
                
                //是否可以取消货到付款订单（该字段对于货到付款才有效），0：不能取消 1.可以取消
//                [btnCancel setImage:GetImage(@"user_button_cansel.png") forState:UIControlStateNormal];
//                [btnCancel setImage:GetImage(@"user_button_cansel_press.png") forState:UIControlStateHighlighted];
                if (entity.cancancel ==1) {
                    btnCancel.hidden = NO;
                }else if (entity.cancancel ==0){
                    btnCancel.hidden = YES;
                }
            }
            
            if (entity.deliverstatus > 0) {     // 已发货  隐藏取消订单按钮  显示确认收货按钮    显示已发货状态
                
                btnPay.hidden = NO;
                
//                [labState setText:[NSString stringWithFormat:@"%@ %@",strDeliverStatus,strPayStatus]];
                [btnCancel setHidden:YES];
                [btnPay setImage:GetImage(@"user_button_Confirm.png") forState:UIControlStateNormal];
                [btnPay setImage:GetImage(@"user_button_Confirm_press.png") forState:UIControlStateHighlighted];
                [btnPay setTag:2];
            }else {                                 //未发货
                if (entity.paystatus == 0) {    //未付款
                    btnPay.hidden = NO;
                    [btnCancel setHidden:NO];
                }else {
                    [btnCancel setHidden:YES];
                    btnPay.hidden = YES;
                }
                
//                [labState setText:[NSString stringWithFormat:@"%@ %@",strOrderStatus,strPayStatus]];
                
                [btnPay setImage:GetImage(@"user_button_pay.png") forState:UIControlStateNormal];
                [btnPay setImage:GetImage(@"user_button_pay_press.png") forState:UIControlStateHighlighted];
                [btnPay setTag:1];
            }
            
            if (entity.paystatus == 0) {        //未付款  修改显示状态 如：已确认 未付款
                [labState setText:[NSString stringWithFormat:@"%@ %@",strOrderStatus,strPayStatus]];
            }else {
//                if (entity.deliverstatus > 0) {
                    [labState setText:[NSString stringWithFormat:@"%@ %@",strPayStatus,strDeliverStatus]];
//                }
            }
            
            break;
        case CellTypeFinish:
            
            [labState setText:@"已完成"];
            if (btnCancel.hidden) {
                [btnCancel setHidden:NO];
                [btnPay setHidden:NO];
            }
            [btnCancel setImage:GetImage(@"user_button_comment.png") forState:UIControlStateNormal];
            [btnCancel setImage:GetImage(@"user_button_comment_press.png") forState:UIControlStateHighlighted];
            
            [btnPay setImage:GetImage(@"user_button_share2.png") forState:UIControlStateNormal];
            [btnPay setImage:GetImage(@"user_button_share2_press.png") forState:UIControlStateHighlighted];
            
            if (entity.commentstatus == 0) {
                [btnCancel setHidden:NO];
            }else [btnCancel setHidden:YES];
            
            if (entity.showorderstatus == 0) {
                [btnPay setHidden:NO];
            }else [btnPay setHidden:YES];
            
            if (btnCancel.hidden == NO && btnPay.hidden == YES) {       //  当左边按钮显示而右边按钮隐藏的时候，将左边按钮移至右边
                [btnCancel setFrame:btnPay.frame];
            }else [btnCancel setFrame:CGRectMake(130, btnCancel.frame.origin.y, btnCancel.frame.size.width, btnCancel.frame.size.height)];
            
            break;
        case CellTypeNoService:
            
            [labState setText:@"已取消"];
            [btnCancel setHidden:YES];
            [btnPay setHidden:YES];
            [self setArrowHidden:YES];
            break;
            
        default:
            break;
    }
}


- (NSString *)getOrderState:(int)istate     // 根据订单状态的int型转换成string
{
    NSString *strState= nil;
    switch (istate) {
        case 0:
            strState = @"未发货";
            break;
        case 1:
            strState = @"已发货";
            break;
        case 2:
            strState = @"已收货";
            break;
        case 3:
            strState = @"备货中";
            break;
        default:
            strState = nil;
            break;
    }
    return strState;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
