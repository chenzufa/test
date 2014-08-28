//
//  UserCommentCell.h
//  HaiLanZhiJia
//
//  Created by xiaojiaxi on 13-11-26.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserCommentEntity.h"
#import "SwipeView.h"

@class UserCommentCell;
@protocol UserCommentCellDelegate<NSObject>
- (void)cell:(UserCommentCell *)cell scrollView:(SwipeView*)scrollView clickedAtIndex:(NSInteger)index;
@end

@interface UserCommentCell : UITableViewCell
@property(nonatomic,retain)UserCommentEntity *commentObject;
+(CGFloat)cellHeight:(UserCommentEntity*)entity;
@property(nonatomic,assign)id<UserCommentCellDelegate>delegate;
@end
