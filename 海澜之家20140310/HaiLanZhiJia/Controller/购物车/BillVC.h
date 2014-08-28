//
//  BillVC.h
//  HaiLanZhiJia
//
//  Created by 蒋遂明 on 13-12-2.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "CommonViewController.h"
#import "SubviewInfoDelegate.h"
#import "InvoceEntity.h"

@interface BillVC : CommonViewController<UITextFieldDelegate>
{
    int _currentIndex;
}

@property (nonatomic,assign) id<SubviewInfoDelegate> delegate;
@property (nonatomic,retain) InvoceEntity *myEntity;

@end
