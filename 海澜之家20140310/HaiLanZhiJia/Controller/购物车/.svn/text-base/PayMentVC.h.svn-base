//
//  PayMentVC.h
//  HaiLanZhiJia
//
//  Created by 蒋遂明 on 13-11-29.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "CommonViewController.h"
#import "SubviewInfoDelegate.h"

@interface PayMentVC : CommonViewController<DSRequestDelegate>
{
    int _currentIndex;
}

@property (nonatomic,retain)DSRequest   *aRequest;
@property (nonatomic,assign) id<SubviewInfoDelegate> delegate;
@property (nonatomic,retain)NSArray     *payMentTypeArray;

@property (nonatomic,retain)PayTypeEntity *myEntity;
@property (nonatomic)BOOL isOrderDetail;

@end
