//
//  SelectGiftVC.h
//  HaiLanZhiJia
//
//  Created by 蒋遂明 on 13-11-28.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "CommonViewController.h"
#import "GiftCell.h"

#import "PresentationEntity.h"
#import "DSRequest.h"

@protocol PresentCommitModifyDelegate <NSObject>

-(void)PresentCommittedReturnInfo:(CommitPresentationEntity *)aEntity;

@end

@interface SelectGiftVC : CommonViewController<DSRequestDelegate,UITableViewDataSource,UITableViewDelegate,GiftSizeColorDelegate>
{
    int currentIndex;   //用于选中状态
}

@property (nonatomic,assign)id <PresentCommitModifyDelegate> delegate;
@property (nonatomic,retain)DSRequest   *aRequest;

@end
