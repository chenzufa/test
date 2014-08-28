//
//  MiaoShaCell.m
//  HaiLanZhiJia
//
//  Created by 蒋遂明 on 13-11-25.
//  Copyright (c) 2013年 donson. All rights reserved.
//
#define INT_TO_String(a) [NSString stringWithFormat:@"%d",a]
#define TIME_COUNT      0x500
#import "MiaoShaCell.h"
#import <QuartzCore/QuartzCore.h>

@interface MiaoShaCell()
{
//    dispatch_source_t _atimer;
}
@property (nonatomic,assign)BOOL isStart0To1;
@property (nonatomic,assign)BOOL isStart0To1AndFinished;
@end
@implementation MiaoShaCell

@synthesize isMiaoSha;
@synthesize buyEntity;
@synthesize started;

-(void)resetTimer
{
    dispatch_source_cancel(_atimer);
    dispatch_release(_atimer);
}
-(void)dealloc
{
    
    self.delegate = nil;
    self.atimer = nil;
//    [self resetTimer];
//    dispatch_release(self.atimer);
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubviews];
        if (!self.started) {
            [self timeCounts];
            self.started = YES;
            _isStart0To1=NO;
            _isStart0To1AndFinished=NO;
        }
    
        
    }
    return self;
}

-(void)createSubviews
{
    for (UIView *view in [self.contentView subviews]) {
        [view removeFromSuperview];
    }
    // 秒杀界面
    do {
        UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(15, 15, 290, 183)];
        myView.layer.cornerRadius =3;
        myView.layer.masksToBounds = YES;
        myView.layer.borderWidth = 0.5;
        myView.layer.borderColor = RGBCOLOR(153, 153, 153).CGColor;
        myView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:myView];
        [myView release];
    } while (0);
    // 添加倒计时背景
    do {
        UIImage *myImg = GetImage(@"sale_bg_on.png");
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(MainViewWidth/2 - myImg.size.width/2, 10, myImg.size.width, myImg.size.height)];
        imageView.image = myImg;
        imageView.tag = TIME_COUNT;
        
        
        // 倒计时
        if (self.buyEntity.timeleft<=0) {
            imageView.image = GetImage(@"sale_bg_over.png");
            UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, myImg.size.width, myImg.size.height)];
            myLabel.backgroundColor = [UIColor clearColor];
            myLabel.numberOfLines = 1;
            myLabel.textAlignment = NSTextAlignmentCenter;
            myLabel.textColor = RGBCOLOR(135,135,135);
            myLabel.font = SYSTEMFONT(16);
            if (self.isMiaoSha) {
                [myLabel setText:@"秒杀已结束"];
            }else{
                [myLabel setText:@"团购已结束"];
            }
            
            [imageView addSubview:myLabel];
            [myLabel release];
            
            [self.contentView addSubview:imageView];
            [imageView release];
        }else{
            UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(16.0, 0.0, 260, myImg.size.height)];
            myLabel.backgroundColor = [UIColor clearColor];
            myLabel.numberOfLines = 2;
            myLabel.textColor = RGBCOLOR(46, 46, 46);
            myLabel.font = SYSTEMFONT(16);
            if (self.buyEntity.isstart) {
                [myLabel setText:@"距离结束:              :        :"];
            }else{
                [myLabel setText:@"距离开始:              :        :"];
            }
            
            [imageView addSubview:myLabel];
            [myLabel release];
            
            //        int seconds = [self.buyEntity.timeleft intValue];
            int seconds = 0;
            int h;
            int m;
            int s;
            s = seconds%60;
            m = seconds/60;
            h = m/60;
            m = m % 60;
            
            int  h1 = (h % 1000)/100;
            int  h2 = (h % 100)/10;
            int  h3 = (h % 10)/1;
            int m1 = (m % 100)/10;
            int m2 = (m % 10)/1;
            int s1 = (s % 100)/10;
            int s2 = (s % 10)/1;
            
            NSArray *myarr = [NSArray arrayWithObjects:INT_TO_String(h1),INT_TO_String(h2),INT_TO_String(h3),INT_TO_String(m1),INT_TO_String(m2),INT_TO_String(s1),INT_TO_String(s2), nil];
            int currentX = 0;
            for (int i=0; i<7; i++) {
                UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
                UIImage *myIMG = GETIMG(@"sale_bg_time.png");
                [myButton setBackgroundImage:GETIMG(@"sale_bg_time.png") forState:UIControlStateNormal];
                myButton.tag = i+TIME_COUNT+10;
                myButton.enabled = NO;
                [myButton setTitle:[myarr objectAtIndex:i] forState:UIControlStateNormal];
                [myButton setTitleColor:RGBCOLOR(46, 46, 46) forState:UIControlStateNormal];
                myButton.frame = CGRectMake(90+currentX,7,myIMG.size.width,myIMG.size.height);
                [imageView addSubview:myButton];
                if (i==2||i==4) {
                    currentX +=25;
                }else{
                    currentX +=18;
                }
            }
            
            [self.contentView addSubview:imageView];
            [imageView release];
        }
        
    } while (0);
    // 商品标题
    do {
        UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(25.0, 50.0, 260, 40.0)];
        myLabel.backgroundColor = [UIColor clearColor];
        myLabel.numberOfLines = 2;
        myLabel.textColor = TEXT_GRAY_COLOR;
        myLabel.font = SYSTEMFONT(14);
        [myLabel setText:self.buyEntity.goodsname];
        
        [self.contentView addSubview:myLabel];
        [myLabel release];
    } while (0);
    // 图片背景
    do {
        UIImage *myImg = GetImage(@"sale_photo_moren1.png");
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 98, 90, 90)];
        imageView.image = myImg;
        [imageView setImageWithURL:[NSURL URLWithString:self.buyEntity.goodsimg]];
        [self.contentView addSubview:imageView];
        [imageView release];
    } while (0);
    // 原价
    do {
        if (self.isMiaoSha) {
            UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(120.0, 120.0, 150, 18.0)];
            myLabel.backgroundColor = [UIColor clearColor];
            myLabel.numberOfLines = 1;
            if (self.buyEntity.timeleft<=0) {
                myLabel.textColor = ColorFontgray;
            }else myLabel.textColor = ColorFontBlack;
            myLabel.font = SYSTEMFONT(14);
            [myLabel setText:[NSString stringWithFormat:@"原价： ¥%@",self.buyEntity.originprice]];
            
            [self.contentView addSubview:myLabel];
            [myLabel release];
        }else{
            UILabel *manNumber = [[UILabel alloc]initWithFrame:CGRectMake(120.0, 100, 150, 18.0)];
            manNumber.backgroundColor = [UIColor clearColor];
            manNumber.numberOfLines = 1;
            manNumber.textColor = TEXT_GRAY_COLOR;
            manNumber.font = SYSTEMFONT(14);
            [manNumber setText:[NSString stringWithFormat:@"%d人已参团 ",self.buyEntity.joincount]];
            [self.contentView addSubview:manNumber];
            [manNumber release];
            
            UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(120.0, 120.0, 150, 18.0)];
            myLabel.backgroundColor = [UIColor clearColor];
            myLabel.numberOfLines = 1;
            if (self.buyEntity.timeleft<=0) {
                myLabel.textColor = ColorFontgray;
            }else myLabel.textColor = ColorFontBlack;
            myLabel.font = SYSTEMFONT(14);
            [myLabel setText:[NSString stringWithFormat:@"原价： ¥%@",self.buyEntity.originprice]];
            [self.contentView addSubview:myLabel];
            [myLabel release];
        }
        
        
    } while (0);
    // 我要秒
    do {
        UIImage *myImg = GetImage(@"sale_bg_button.png");
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(120, 150, 189, 39)];
        imageView.userInteractionEnabled = YES;
        imageView.image = myImg;
        
        UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 150, 39)];
        myLabel.backgroundColor = [UIColor clearColor];
        myLabel.numberOfLines = 1;
        myLabel.textColor = [UIColor whiteColor];
        myLabel.font = SYSTEMFONT(16);
        [myLabel setText:[NSString stringWithFormat:@"¥ %@",self.buyEntity.currentprice]];
        [imageView addSubview:myLabel];
        [myLabel release];
        
        // 秒杀
        UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *myIMG = GETIMG(@"sale_button2_press.png");
        if (self.buyEntity.store >0 && self.buyEntity.timeleft>0 &&self.buyEntity.isstart==1)
        {
            if (self.isMiaoSha) {
                [myButton setBackgroundImage:GETIMG(@"sale_button2.png") forState:UIControlStateNormal];
                [myButton setBackgroundImage:GETIMG(@"sale_button2_press.png") forState:UIControlStateHighlighted];
                [myButton setBackgroundImage:GETIMG(@"sale_button1.png") forState:UIControlStateDisabled];
                [myButton addTarget:self action:@selector(miaoSha:) forControlEvents:UIControlEventTouchUpInside];
            }// 团购
            else
            {
                [myButton setBackgroundImage:GETIMG(@"sale_button4.png") forState:UIControlStateNormal];
                [myButton setBackgroundImage:GETIMG(@"sale_button4_press.png") forState:UIControlStateHighlighted];
                [myButton setBackgroundImage:GETIMG(@"sale_button3.png") forState:UIControlStateDisabled];
                [myButton addTarget:self action:@selector(miaoSha:) forControlEvents:UIControlEventTouchUpInside];
            }
        }else{
            if (self.isMiaoSha) {
                [myButton setBackgroundImage:GETIMG(@"sale_button1.png") forState:UIControlStateDisabled];
                myButton.enabled = NO;
            }// 团购
            else
            {
                [myButton setBackgroundImage:GETIMG(@"sale_button3.png") forState:UIControlStateDisabled];
                myButton.enabled = NO;
            }
        }
        
        
        myButton.frame = CGRectMake(108,3,myIMG.size.width,myIMG.size.height);
        
        
        [imageView addSubview:myButton];
        
        [self.contentView addSubview:imageView];
        [imageView release];
        
    } while (0);
    int aTime = [[NSDate date]timeIntervalSinceDate:self.buyEntity.timeWhenReceive];
    _timeLeft = self.buyEntity.timeleft -aTime;
    [self refreshTimeCountBySeconds:_timeLeft];
}

// 自减时间
-(void)timeCounts
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    self.atimer = _timer;
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        if(_timeLeft<=0)
        { //倒计时结束，关闭
//            dispatch_source_cancel(_timer);
//            dispatch_release(_timer);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //
//                [self refreshTimeCountBySeconds:_timeLeft];
//            });
            if (self.buyEntity.isstart==1&&_isStart0To1AndFinished==NO)
            {
               // _isStart0To1AndFinished=YES;
               // self.buyEntity.timeleft=0;
               // [self createSubviews];
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                //
                _timeLeft --;
                [self refreshTimeCountBySeconds:_timeLeft];
            });
        }
    });  
    dispatch_resume(_timer);
//    dispatch_release(_timer);
    
}
/*
if(_timeLeft<=0){ //倒计时结束，关闭
    dispatch_source_cancel(_timer);
    dispatch_release(_timer);
    dispatch_async(dispatch_get_main_queue(), ^{
        //
        [self refreshTimeCountBySeconds:_timeLeft];
    });
}else{
    dispatch_async(dispatch_get_main_queue(), ^{
        //
        _timeLeft --;
        [self refreshTimeCountBySeconds:_timeLeft];
    });
}
});
 */

// 每隔一段时间重新刷新时间
-(void)refreshToRightTime
{
    _timeLeft = 88888;
}

-(void)refreshTimeCountBySeconds:(int)seconds
{
    int h;
    int m;
    int s;
    s = seconds%60;
    m = seconds/60;
    h = m/60;
    m = m % 60;
    
    int  h1 = (h % 1000)/100;
    int  h2 = (h % 100)/10;
    int  h3 = (h % 10)/1;
    int m1 = (m % 100)/10;
    int m2 = (m % 10)/1;
    int s1 = (s % 100)/10;
    int s2 = (s % 10)/1;
    NSArray *myarr = [NSArray arrayWithObjects:INT_TO_String(h1),INT_TO_String(h2),INT_TO_String(h3),INT_TO_String(m1),INT_TO_String(m2),INT_TO_String(s1),INT_TO_String(s2), nil];
    
    UIView *myView = [self.contentView viewWithTag:TIME_COUNT];
    for (int i = 0; i<7; i++) {
        UIButton *myBtn = (UIButton *)[myView viewWithTag:(i+TIME_COUNT+10)];
        [myBtn setTitle:[myarr objectAtIndex:i] forState:UIControlStateNormal];
    }
    if (self.buyEntity.isstart==0&&seconds==0&&_isStart0To1==NO)
    {
        _isStart0To1=YES;
        if (self.buyEntity.timelast>=0)
        {
            self.buyEntity.timeleft = self.buyEntity.timelast;
            self.buyEntity.isstart = 1;
            [self createSubviews];
        }
    }
//    NSLog(@"%@ timeleft%li--timelast%li",self.buyEntity.goodsid,self.buyEntity.timeleft,self.buyEntity.timelast);
}

-(void)miaoSha:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(SelectedIndex:)]) {
        [self.delegate SelectedIndex:self.cellIndex];
    }
}

-(void)resetViewByEntity:(SpecialBuyEntity **)entity
{
    self.buyEntity = *entity;
    [self createSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
