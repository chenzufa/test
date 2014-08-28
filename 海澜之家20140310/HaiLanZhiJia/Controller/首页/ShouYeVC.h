//
//  ShouYeVC.h
//  HaiLanZhiJia
//
//  Created by 蒋遂明 on 13-11-20.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "CommonViewController.h"

#import "NetImageView.h"
#import "SwipeView.h"
#import "LunBoView.h"
#import "AdLinkVC.h"
#import "MiaoShaVC.h"
#import "HuoDongListVC.h"
#import "SinglePicVC.h"
#import "GongGeVC.h"
#import "DSRequest.h"
#import "GoodEntity.h"
#import "FocusInfoEntity.h"
#import "SpecialEntity.h"


#import "MiaoShaVC.h"
@interface ShouYeVC : CommonViewController<SwipeViewDataSource,SwipeViewDelegate,LunBoViewDelegate,DSRequestDelegate>

@property(nonatomic,retain)SwipeView *oneScroView;
@property(nonatomic,retain)LunBoView * lunBoView;
@property (nonatomic,retain)DSRequest   *aRequest;
@end
