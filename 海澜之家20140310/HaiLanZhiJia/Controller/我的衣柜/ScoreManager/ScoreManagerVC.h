//
//  ScoreManagerVC.h
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-11-26.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "CommonViewController.h"
#import "DSRequest.h"
@interface ScoreManagerVC : CommonViewController<DSRequestDelegate>

@property (nonatomic, retain) DSRequest *requestOjb;
@property (nonatomic, retain) ScoreInfoEntity *entiScoreInfo;
@end
