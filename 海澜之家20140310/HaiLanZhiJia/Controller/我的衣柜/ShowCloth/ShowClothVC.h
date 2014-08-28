//
//  ShowClothVC.h
//  HaiLanZhiJia
//
//  Created by chenzufa on 13-12-2.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "CommonViewController.h"
#import "PKCollectionView.h"
#import "PullPsCollectionView.h"
#import "DSRequest.h"

@interface ShowClothVC : CommonViewController<DSRequestDelegate,PKCollectionViewDelegate,PKCollectionViewDataSource,UIScrollViewDelegate,PullPsCollectionViewDelegate>

@property (nonatomic , retain) PullPsCollectionView *collectionView;  //瀑布流列表 UI
@property (nonatomic , retain) DSRequest* request;

@end
