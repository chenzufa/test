//
//  MYAlertView.m
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-12-2.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "MYAlertView.h"
#define JianGe 15
@implementation MYAlertView
{
    UIImageView *imgViewBack;
    UIButton *cancelButton;
    UIImageView *imgViewLine;
    UIImage *imgbtn;
    UIButton *anotherButton;
//    NSArray *images;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)dealloc
{
    self.delegate = nil;
    self.labMessage = nil;
    self.labTitle = nil;
    self.activi = nil;
    self.imgViewContents = nil;
    self.coverViewContents = nil;
    [imgViewBack release];
    [imgViewLine release];
//    [images release];
    [super dealloc];
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message image:(NSString *)image delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle anotherButtonTitle:(NSString *)anotherButtonTitle
{
    self = [super initWithFrame:CGRectMake(0, 0, MainViewWidth, MainViewHeight)];
    if (self) {
        
//        images = [NSArray arrayWithObjects:@"icon_share_message.png",@"icon_share_sina.png",@"icon_share_weixin.png",@"icon_share_tx.png", nil];
//        images = [[NSArray alloc]initWithObjects:@"icon_share_message.png",@"icon_share_sina.png",@"icon_share_weixin.png",@"icon_share_tx.png", nil];
        
        self.delegate = delegate;
        //      黑色半透明背景
        UIView *backView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [backView setBackgroundColor:[UIColor blackColor]];
        [backView setAlpha:0.5];
        [self addSubview:backView];
        
        //      白色圆角背景
        UIImage *imgBack = [GetImage(@"语音搜索弹出框背景.png") resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        imgViewBack = [[UIImageView alloc]initWithImage:imgBack];
        [imgViewBack setFrame:CGRectMake(0, 0, imgViewBack.image.size.width, imgViewBack.image.size.height)];
        [imgViewBack setCenter:CGPointMake(self.center.x, self.center.y)];
        [imgViewBack setUserInteractionEnabled:YES];
        [self addSubview:imgViewBack];
        
        //      标题
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake( 10, JianGe, imgViewBack.frame.size.width - 20, FontSize15)];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:FontSize15]];
        [titleLabel setTextColor:[UIColor blackColor]];
        self.labTitle = titleLabel;
        
        [imgViewBack addSubview:self.labTitle];
        
        //      标题下面的线
        imgViewLine = [[UIImageView alloc]initWithImage:GetImage(@"home_lin2.png")];
        [imgViewLine setFrame:CGRectMake(0, titleLabel.frame.origin.y + titleLabel.frame.size.height + JianGe, imgViewLine.image.size.width, imgViewLine.frame.size.height)];
//        [imgViewBack addSubview:imgViewLine];
        
        //      提示信息
        UILabel *messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, imgViewLine.frame.origin.y + JianGe, titleLabel.frame.size.width, titleLabel.frame.size.height)];
        [messageLabel setBackgroundColor:[UIColor clearColor]];
        [messageLabel setTextAlignment:NSTextAlignmentCenter];
        [messageLabel setFont:SetFontSize(FontSize15)];
        [messageLabel setTextColor:[UIColor blackColor]];
        self.labMessage = messageLabel;
        
        [imgViewBack addSubview:self.labMessage];
        
        
        //      展示图片
        UIImageView *imgview = [[UIImageView alloc]init];//WithImage:GetImage(image)];
//        [imgview setClipsToBounds:YES];
        self.imgViewContents = imgview;
        [imgViewBack addSubview:self.imgViewContents];
        
        //////////////////////////////      覆盖在展示图片上面的图片
        UIView *coverView = [[UIView alloc]init];           //父层
        [coverView setClipsToBounds:YES];
        self.coverViewContents = coverView;
        [imgViewBack addSubview:self.coverViewContents];
                                                            //子层图片
        UIImageView *upImgView = [[UIImageView alloc]initWithImage:GetImage(@"语音icon通话.png")];
        [upImgView setFrame:CGRectMake(0, 0, upImgView.image.size.width, upImgView.image.size.height)];
        upImgView.tag = 88;
        [self.coverViewContents addSubview:upImgView];
        [self.coverViewContents setHidden:YES];
        
        ///////////////////////////////
        
        
        
        //      旋转的菊花
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.activi = activity;
        [imgViewBack addSubview:self.activi];
        
        //      取消按钮
        imgbtn = GetImage(@"按钮背景.png");
        cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.tag = 0;
        [cancelButton addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton.titleLabel setFont:SetFontSize(FontSize15)];
//        [cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
        [cancelButton setBackgroundImage:imgbtn forState:UIControlStateNormal];
        [cancelButton setBackgroundImage:GetImage(@"按钮选中背景.png") forState:UIControlStateHighlighted];
        [imgViewBack addSubview:cancelButton];
                
        //      另一个按钮
        UIImage *imgDoneBtn = GetImage(@"语音搜索确定.png");
        anotherButton = [UIButton buttonWithType:UIButtonTypeCustom];
        anotherButton.tag = 1;
        [anotherButton addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
        [anotherButton.titleLabel setFont:SetFontSize(FontSize15)];
        [anotherButton setBackgroundImage:imgDoneBtn forState:UIControlStateNormal];
        [anotherButton setBackgroundImage:GetImage(@"语音搜索确定_选中.png") forState:UIControlStateHighlighted];
        [imgViewBack addSubview:anotherButton];
        [anotherButton setHidden:YES];
        
        [self setSubViewsTitle:title message:message image:image otherButton:anotherButtonTitle];
        
        [imgview release];
        [messageLabel release];
        [titleLabel release];
        [backView release];
        [activity release];
        [coverView release];
        [upImgView release];
    }
    
    
    
    return self;
}

- (void)setSubViewsTitle:(NSString *)title message:(NSString *)message image:(NSString *)image otherButton:(NSString *)anotherButtonTitle
{
//    [self.activi setHidden:YES];
    [self.labTitle setText:title];
    
    [self.labMessage setText:message];
    
    if (![image isEqualToString:@"有图片"]) {
        [self.imgViewContents setImage:GetImage(image)];
    }
    
    if (message) {
        [self.labMessage setHidden:NO];
        [self.imgViewContents setFrame:CGRectMake(0, self.labMessage.frame.origin.y + self.labMessage.frame.size.height + JianGe, self.imgViewContents.image.size.width, self.imgViewContents.image.size.height)];
        if ([title isEqualToString:@"请说话"]) {
            
            [self.coverViewContents setHidden:NO];
        }else {
            [self.coverViewContents setHidden:YES];
        }
        
    }else {
        [self.labMessage setHidden:YES];
        [self.imgViewContents setFrame:CGRectMake(0, imgViewLine.frame.origin.y + JianGe,self.imgViewContents.image.size.width, self.imgViewContents.image.size.height)];
        if ([title isEqualToString:@"请说话"]) {
            
            [self.coverViewContents setHidden:NO];
        }else {
            [self.coverViewContents setHidden:YES];
        }
    }
    
    [self.imgViewContents setCenter:CGPointMake(imgViewBack.image.size.width/2, self.imgViewContents.center.y)];
    int hhh = 105 - self.iVolume * 2.5;  //hhh 为根据音量显示的高度
    [self.coverViewContents setFrame:CGRectMake(self.imgViewContents.frame.origin.x, self.imgViewContents.frame.origin.y + hhh, self.imgViewContents.frame.size.width, self.imgViewContents.frame.size.height - hhh)];  
    UIImageView *imgv = (UIImageView *)[self.coverViewContents viewWithTag:88];  
    [imgv setCenter:CGPointMake(self.coverViewContents.frame.size.width / 2 , self.imgViewContents.frame.size.height / 2 - hhh)];
    
    
    if (image) {
        [self.imgViewContents setHidden:NO];
        [cancelButton setFrame:CGRectMake(107, self.imgViewContents.frame.origin.y + self.imgViewContents.frame.size.height + JianGe, imgbtn.size.width, imgbtn.size.height)];
    }else {
        [self.imgViewContents setHidden:YES];
        [cancelButton setFrame:CGRectMake(107, self.labMessage.frame.origin.y + self.labMessage.frame.size.height + JianGe, imgbtn.size.width, imgbtn.size.height)];
    }
    
    if (!self.activi.isHidden) {
        [self.activi setCenter:self.imgViewContents.center];
        [self.activi startAnimating];
        [self.imgViewContents setHidden:YES];
    }else {
        [self.imgViewContents setHidden:NO];
        [self.activi stopAnimating];
    }
    
    //      根据其他控件的高度改变白色背景的高度
    [imgViewBack setFrame:CGRectMake(imgViewBack.frame.origin.x, imgViewBack.frame.origin.y, imgViewBack.frame.size.width, cancelButton.frame.origin.y + cancelButton.frame.size.height + 20)];
    
    if (anotherButtonTitle) {
        [anotherButton setTitle:anotherButtonTitle forState:UIControlStateNormal];
        [anotherButton setFrame:CGRectMake(33, cancelButton.frame.origin.y, imgbtn.size.width, imgbtn.size.height)];
        [cancelButton setCenter:CGPointMake(anotherButton.center.x + 118, cancelButton.center.y)];
        [anotherButton setHidden:NO];
    }else {
        [anotherButton setHidden:YES];
        [cancelButton setCenter:CGPointMake(imgViewBack.image.size.width / 2, cancelButton.center.y)];
    }
    
}

- (void)exChangeOut:(UIView *)changeOutView dur:(CFTimeInterval)dur{
    
    CAKeyframeAnimation * animation;
    
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.duration = dur;
    //animation.delegate = self;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
    
    [changeOutView.layer addAnimation:animation forKey:nil];
    
}

- (void)show
{
    [self exChangeOut:imgViewBack dur:0.4];
    
    UIViewController *vc = (UIViewController *)self.delegate;
    [vc.view.window addSubview:self];
    
}

- (void)beginTalking
{
    [self.activi setHidden:YES]; //隐藏菊花
    [self setState:AlertViewStateBeginTalking];
    [self setSubViewsTitle:@"请说话" message:@"商品名称或类型如：衬衫、秋装" image:@"语音icon_未选中.png" otherButton:nil];
}

- (void)wasIdentificaing    // 正在识别
{
    [self.activi setHidden:NO]; //显示菊花
    [self setState:AlertViewStateWasIdentificaing];
    [self setSubViewsTitle:@"正在识别" message:nil image:@"icon_share_weixin.png" otherButton:nil];
}

- (void)identificaSuccessed:(NSString *)strSpeak // 识别成功
{
    [self.activi setHidden:YES]; //隐藏菊花
    [self setState:AlertViewStateidentificaSuccess];
    NSString *strMessage = [NSString stringWithFormat:@"识别内容：%@",strSpeak];
    [self setSubViewsTitle:@"识别成功" message:strMessage image:nil otherButton:@"确定"];
}

- (void)identificaFailed    // 识别失败
{
    [self.activi setHidden:YES]; //隐藏菊花
    [self setState:AlertViewStateIdentificaFailed];
    [self setSubViewsTitle:@"没有听清楚" message:nil image:@"07-01-01语音搜索错误_03.png" otherButton:@"重说"];
}

//- (void)changeImgViewContents:(int)i
//{
//    
//    NSLog(@"+++++++++++%i  i = %i",images.count,i);
//    NSString *imgName = [images objectAtIndex:i];
//    [self.imgViewContents setImage:GetImage(imgName)];
//
//    
//}

- (void)clicked:(UIButton *)btn
{
    
    if ([self.delegate respondsToSelector:@selector(myAlertView:clickedButtonAtIndex:)]) {
        [self.delegate myAlertView:self clickedButtonAtIndex:btn.tag];
    }
    
    if (![btn.titleLabel.text isEqualToString:@"重说"]) {
        [self removeFromSuperview];
    }
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
