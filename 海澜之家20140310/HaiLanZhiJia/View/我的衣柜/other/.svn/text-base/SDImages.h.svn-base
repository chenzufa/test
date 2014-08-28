//
//  SDImages.h
//  HaiLanZhiJia
//
//  Created by chenzufa on 13-12-4.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDImages;
@protocol SDImagesDelegate <NSObject>
@optional
- (void)deleteImageIn:(SDImages*)view andIndex:(NSInteger)index;

@end

@interface SDImages : UIView

@property(nonatomic , retain)id<SDImagesDelegate> delegate;
@property(nonatomic , retain)NSMutableArray* imgArray;
@property(nonatomic , retain)NSMutableArray* imgViewArray;
@property(nonatomic , assign)NSInteger count; //记录上次图片数量。
@property(nonatomic , assign)CGPoint point;
@property(nonatomic , assign)CGRect rect;

- (void)refreshData;
- (void)initViewsWithArray:(NSArray*)array;
@end
