//
//  MJPhotoToolbar.m
//  FingerNews
//
//  Created by mj on 13-9-24.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MJPhotoToolbar.h"
#import "MJPhoto.h"
#import "MBProgressHUD+Add.h"

@interface MJPhotoToolbar()
{
    // 显示页码
    UILabel *_indexLabel;
    UIButton *_saveImageBtn;
    UIButton *_backBtn;
}
@end

@implementation MJPhotoToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // 创建导航条背景图片
        
    }
    return self;
}

- (id)init{
    if (self = [super init]) {
        UIImage *image = [UIImage imageNamed:@"bg_nav bar@2x.jpg"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(0, 0, 320, 45);
        imageView.userInteractionEnabled = YES;
        [self addSubview:imageView];
    }
    return self;
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    //if (_photos.count > 1) {
        _indexLabel = [[UILabel alloc] init];
        //_indexLabel.font = [UIFont boldSystemFontOfSize:20];
        _indexLabel.frame =CGRectMake(0, 0, 320, self.bounds.size.height); //self.bounds;
        _indexLabel.backgroundColor = [UIColor clearColor];
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_indexLabel];
   // }
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *bgImage = [UIImage imageNamed:@"icon_back@2x.png"];
    [_backBtn setFrame:CGRectMake(10,11,28,22)];
    [_backBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"icon_back_press@2x.png"] forState:UIControlStateHighlighted];
    _backBtn.backgroundColor = [UIColor clearColor];
    [_backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_backBtn];
    
    // 保存图片按钮
    //_saveImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //_saveImageBtn.frame = CGRectMake(250,2, 60, 40);
    //[_saveImageBtn setBackgroundImage:[UIImage imageNamed:@"button1@2x.png"] forState:UIControlStateNormal];
    //[_saveImageBtn setBackgroundImage:[UIImage imageNamed:@"button1@2x.png"] forState:UIControlStateHighlighted];
    //[_saveImageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[_saveImageBtn setTitle:@"保存" forState:UIControlStateNormal];
    //_saveImageBtn.backgroundColor = [UIColor redColor];
    //[_saveImageBtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    //[self addSubview:_saveImageBtn];
}

- (void)saveImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        MJPhoto *photo = _photos[_currentPhotoIndex];
        UIImageWriteToSavedPhotosAlbum(photo.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [MBProgressHUD showSuccess:@"保存失败" toView:nil];
    } else {
        MJPhoto *photo = _photos[_currentPhotoIndex];
        photo.save = YES;
        //_saveImageBtn.enabled = NO;
        [MBProgressHUD showSuccess:@"成功保存到相册" toView:nil];
    }
}

- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex
{
    _currentPhotoIndex = currentPhotoIndex;
    
    // 更新页码
    _indexLabel.text = [NSString stringWithFormat:@"%d / %d", _currentPhotoIndex + 1, _photos.count];
    
    MJPhoto *photo = _photos[_currentPhotoIndex];
    // 按钮
    _saveImageBtn.enabled = photo.image != nil && !photo.save;
}

-(void)back:(UIButton*)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(MJPhotoToolbarForBack)]) {
        [self.delegate MJPhotoToolbarForBack];
    }
}
@end
