//
//  DeliverVC.h
//  HaiLanZhiJia
//
//  Created by 蒋遂明 on 13-12-2.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "CommonViewController.h"
#import "SubviewInfoDelegate.h"

@interface DeliverVC : CommonViewController<DSRequestDelegate>
{
    int _currentIndex;
}
@property (nonatomic,assign) id<SubviewInfoDelegate> delegate;
@property (nonatomic,retain) DeliverEntity *myEntity;
@property (nonatomic,retain) DSRequest *aRequest;

@end
