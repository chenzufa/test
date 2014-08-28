//
//  OrderFormVC.h
//  HaiLanZhiJia
//
//  Created by 蒋遂明 on 13-11-28.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "CommonViewController.h"
#import "GoodsListCell.h"
#import "ShangPingDetailVC.h"

#import "AddressManagerVC.h"
#import "PayMentVC.h"
#import "DeliverVC.h"
#import "BillVC.h"
#import "XianJinQuanVC.h"
#import "DiYongQuanVC.h"
#import "BeizhuVC.h"
#import "OrderSuccessVC.h"

#import "DSRequest.h"
#import "PayTypeEntity.h"
#import "OrderDetailCell.h"
@interface OrderFormVC : CommonViewController<UITableViewDataSource,UITableViewDelegate,DSRequestDelegate,SubviewInfoDelegate,UIAlertViewDelegate,ClickedImageDelegate>
{
    DSRequest *_addressRequest;
    DSRequest *_payTypeRequest;
    DSRequest *_getDeliverFeeRequest;
    
    DSRequest *_commitFormRequest;
    
//    DSRequest *_addressRequest;
}

@property (nonatomic,retain)UIView *headerTableView;
@property (nonatomic,retain)UIView *footerTableView;
@property (nonatomic,retain)UITableView *myTableView;
@property (nonatomic,retain)GoodsSettleUpEntity  *mySetupEntity;
@property (nonatomic,retain)NSArray *payMentArray;
@property (nonatomic,retain)NSArray *myOrderList;

@property (nonatomic,retain)SpecialBuyDetailEntity *specialBuyEntity;
@property (nonatomic)int orderType; //1.购物车普通商品2.团购 3.秒杀
@property (nonatomic,retain)StatusEntity* deliverStates;
@end
