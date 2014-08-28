//
//  MiaoShaVC.h
//  HaiLanZhiJia
//
//  Created by 蒋遂明 on 13-11-25.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "CommonViewController.h"
#import "MiaoShaCell.h"

#import "DSRequest.h"
#import "SpecialBuyListEntity.h"
#import "MIaoShaTuanGouDetailVC.h"

#import "PullTableView.h"

@interface MiaoShaVC : CommonViewController<DSRequestDelegate,UITableViewDataSource,UITableViewDelegate,MiaoShaTuanGouCellDelegate,PullTableViewDelegate>
{
    int _currentPage;
}

// warning 记得做分页
@property (nonatomic,retain)DSRequest   *aRequest;
@property (nonatomic,retain)SpecialBuyListEntity* buyListEntity;

@property (nonatomic,retain)PullTableView     *myTableView;
@property (nonatomic,retain)NSMutableArray  *myEntitiesArr;
@property (nonatomic)BOOL isMiaoSha;
@property (nonatomic,copy)NSString *specialId;
@property (nonatomic,retain)UIView *failView;

@end
