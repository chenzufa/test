//
//  OrderSuccessVC.h
//  HaiLanZhiJia
//
//  Created by 蒋遂明 on 13-12-3.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "CommonViewController.h"

@interface OrderSuccessVC : CommonViewController

@property (nonatomic,retain)StatusEntity* statusEntity;
@property (nonatomic,retain)SpecialBuyEntity *buyEntity;

@property (nonatomic,retain)SpecialBuyDetailEntity *specialBuyEntity;
@property (nonatomic)int orderType; //1.购物车普通商品2.团购 3.秒杀

@property (nonatomic,retain)PayTypeEntity *payTypeEntity;
@end
