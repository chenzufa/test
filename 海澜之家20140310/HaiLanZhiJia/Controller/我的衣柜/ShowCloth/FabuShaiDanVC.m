//
//  FabuShaiDanVC.m
//  HaiLanZhiJia
//
//  Created by chenzufa on 13-12-2.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "FabuShaiDanVC.h"
#import <QuartzCore/QuartzCore.h>
#import "SDImages.h"
#import "UIImageExtend.h"

@interface FabuShaiDanVC ()<SDImagesDelegate,UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UIActionSheetDelegate>

@property(nonatomic , retain)UILabel* placeholderLabel;
@property(nonatomic , retain)UITextView* noteText;
@property(nonatomic , retain)UIScrollView* scrollView;
@property(nonatomic , retain)SDImages* sd;
@property(nonatomic , assign)CGPoint contentOffesetPoint;
@end

@implementation FabuShaiDanVC
@synthesize titleTextField = _titleTextField;
@synthesize placeholderLabel = _placeholderLabel;
@synthesize noteText = _noteText;
@synthesize scrollView = _scrollView;
@synthesize sd = _sd;
@synthesize contentOffesetPoint = _contentOffesetPoint;
@synthesize uploadRequest = _uploadRequest;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleString:@"发布晒单"];
    
    [self initScrollView];
    [self initRightButton];
    [self initTitleLabel];
    [self initContentView];
    [self initPhotoButton];
    [self initShowImgs];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [_placeholderLabel release];_placeholderLabel = nil;
    [_noteText release];_noteText = nil;
    [_scrollView release];_scrollView = nil;
    [_sd release];_sd = nil;
    
    _uploadRequest.delegate= nil;
    [_uploadRequest release];_uploadRequest = nil;
    
    [super dealloc];
}

#pragma mark - Init UI
- (void) initScrollView{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 45, 320, self.view.frame.size.height - 45 -20)];
    _scrollView.pagingEnabled = NO;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentSize =  CGSizeMake(0, 500);
    [self.view insertSubview:_scrollView atIndex:0];
}

//标题
- (void)initTitleLabel{
    _titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 300, 40)];
    _titleTextField.backgroundColor = [UIColor whiteColor];
    _titleTextField.delegate = self;
    _titleTextField.borderStyle = UITextBorderStyleLine;
    _titleTextField.layer.borderWidth = 1;
    _titleTextField.font = [UIFont systemFontOfSize:14];
    _titleTextField.layer.borderColor = RGBCOLOR(226, 226, 226).CGColor;
    _titleTextField.placeholder = @"标题";
    _titleTextField.returnKeyType = UIReturnKeyDone;
    _titleTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _titleTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _titleTextField.layer.cornerRadius = 3;
    [_scrollView addSubview:_titleTextField];
}

//评价内容
- (void) initContentView{
     UILabel* lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 300, 168)];
    lineLabel.layer.borderColor = RGBCOLOR(226, 226, 226).CGColor;
    lineLabel.layer.borderWidth = 1;
    lineLabel.layer.cornerRadius = 3;
    [_scrollView addSubview:lineLabel];
    [lineLabel release];
    
    _noteText = [[UITextView alloc] initWithFrame:CGRectMake(9, 60, 302, 168)];
    _noteText.delegate = self;
    _noteText.backgroundColor = [UIColor clearColor];
    _noteText.textColor = [UIColor blackColor];
    _noteText.font = [UIFont systemFontOfSize:14];
    _noteText.showsHorizontalScrollIndicator = NO;
    _noteText.showsVerticalScrollIndicator = NO;
    [_scrollView addSubview:_noteText];

    _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 7, 100, 18)];
    _placeholderLabel.backgroundColor = [UIColor clearColor];
    _placeholderLabel.textColor = RGBCOLOR(173, 173, 173);
    _placeholderLabel.font = [UIFont systemFontOfSize:14];
    _placeholderLabel.text = @"内容";
    [_noteText addSubview:_placeholderLabel];
    
    UIView* toolview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    toolview.backgroundColor = [UIColor blackColor];
    
    UIButton* cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(7, 5, 40, 30);
    cancleBtn.tag = 300;
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];
    [toolview addSubview:cancleBtn];
    
    UIButton* ensureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ensureBtn.frame = CGRectMake(273, 5, 40, 30);
    ensureBtn.tag = 301;
    [ensureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [ensureBtn addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];
    [toolview addSubview:ensureBtn];
    _noteText.inputAccessoryView = toolview;
    [toolview release];
    
//    [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(clearTextView) userInfo:nil repeats:YES];
}

//定时器执行事件
//- (void)clearTextView{
//    if (_noteText.text.length > 0) {
//        _placeholderLabel.hidden = YES;
//    }else{
//        _placeholderLabel.hidden = NO;
//    }
//}

- (void) initRequest{
    if (_uploadRequest == nil) {
        _uploadRequest = [[DSRequest alloc] init];
        _uploadRequest.delegate = self;
    }
    
    NSMutableArray* imgArray = [[NSMutableArray alloc] init];
    
    for (int i= 0 ; i < _sd.imgArray.count; i++) {
        float w = ((UIImage*)[_sd.imgArray objectAtIndex:i]).size.width;
        float h = ((UIImage*)[_sd.imgArray objectAtIndex:i]).size.height;
        //压缩图片;
        NSLog(@"%f",[(UIImage*)[_sd.imgArray objectAtIndex:i] size].height );
        UIImage* img = [(UIImage*)[_sd.imgArray objectAtIndex:i] imageByScalingAndCroppingForSize:CGSizeMake(w, h) percent:0.7];
        NSLog(@"%f",img.size.height);
        [imgArray addObject:img];
    }
    
    if ([_uploadRequest checkNetWork]) {
        [_uploadRequest requestDataWithInterface:PublishShowOrder param:[self PublishShowOrderParam:self.goodID sizeandcolor:self.sizeAndColor ordergoodsid:self.orderID title:_titleTextField.text comment:_noteText.text] uploadImg:imgArray tag:0 ];
        [self.view addHUDActivityView:@"正在上传..."];
    }else{
        [self.view addHUDLabelView:@"网络连接失败" Image:nil afterDelay:1.0];
    }
    [imgArray release];
}

-(void)touchAction:(UIButton*)sender{
    if (sender.tag ==300) {
        _scrollView.transform = CGAffineTransformIdentity;
        [_scrollView setContentOffset:_contentOffesetPoint animated:YES];
        _noteText.text = @"";
        [_noteText resignFirstResponder];
    }else if (sender.tag == 301){
        _scrollView.transform = CGAffineTransformIdentity;
        [_scrollView setContentOffset:_contentOffesetPoint animated:YES];
        [_noteText resignFirstResponder];
    }else{
        
    }
}

//导航栏右边按钮
- (void)initRightButton
{
    UIButton* myRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [myRightButton setFrame:CGRectMake(265, 7, 44, 30)];
    [myRightButton.titleLabel setFont:SetFontSize(FontSize15)];
    [myRightButton setTitle:@"提交" forState:UIControlStateNormal];
    [myRightButton setTitleColor:RGBCOLOR(236, 224, 224) forState:UIControlStateNormal];
    [myRightButton setBackgroundImage:[UIImage imageNamed:@"button1@2x.png"] forState:UIControlStateNormal];
    [myRightButton setBackgroundImage:[UIImage imageNamed:@"button1_press@2x.png"] forState:UIControlStateHighlighted];
    [myRightButton addTarget:self action:@selector(myRightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleBar addSubview:myRightButton];
}

//拍照按钮
- (void)initPhotoButton{
    UIButton* photo = [UIButton buttonWithType:UIButtonTypeCustom];
    photo.frame = CGRectMake(10, 238, 75, 30);
    [photo setBackgroundImage:[UIImage imageNamed:@"user_button_camera@2x.png"] forState:UIControlStateNormal];
    [photo addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:photo];
}

//图片显示区
- (void)initShowImgs{
    _sd = [[SDImages alloc] initWithFrame:CGRectMake(9, 298, 0, 0)];
    _sd.delegate = self;
    [_scrollView addSubview:_sd];
}

//拍照
- (void)takePhoto:(UIButton*)sender{
    if (_sd.imgArray.count == 4) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"最多可上传4张照片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"上传照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册中选取",@"拍照", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.titleBar];
    [actionSheet release];

}

//导航栏右边按钮事件
- (void)myRightButtonAction:(UIButton*)sender{
    if (![self allIsSpace:_titleTextField.text] || _titleTextField.text.length < 4) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"标题长度在4-20个字之间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    if (![self allIsSpace:_noteText.text] || _noteText.text.length < 5) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"内容长度在5-100个字之间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    if (_sd.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请拍晒单照片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    [self initRequest];
}

-(BOOL)allIsSpace:(NSString*)str{
    if (!str) {
        return NO;
    }
    
    NSMutableString* s = [NSMutableString stringWithString:str];
    NSString* st = [s stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"%d",st.length);
    return st.length > 0;
}

#pragma mark - UITextFieldDelegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (_titleTextField == textField)
    {
        if ([aString length] > 20) {
            textField.text = [aString substringToIndex:20];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"标题长度在4-20个字之间"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            alert.delegate = self;
            [alert show];
            [alert release];
            return NO;
        }
    }
    return YES;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_titleTextField resignFirstResponder];
    return YES;
}

#pragma mark - UITextViewDelegate Methods
- (void)textViewDidBeginEditing:(UITextView *)textView{
    _contentOffesetPoint = CGPointMake(0, _scrollView.contentOffset.y);
    if (isIPhone5) {
        _scrollView.transform = CGAffineTransformMakeTranslation(0, 0);
    }else{
        if (_scrollView.contentOffset.y >= 60) {
            [_scrollView setContentOffset:CGPointMake(0, 60) animated:YES];
            _contentOffesetPoint = CGPointMake(0, 60);
        }else{
            [_scrollView setContentOffset:CGPointMake(0, 60) animated:YES];
        }
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString *temp = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    if (temp.length > 0) {
        _placeholderLabel.hidden = YES;
    }else{
        _placeholderLabel.hidden = NO;
    }
    
    if (temp.length > 100) {
        textView.text = [temp substringToIndex:100];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"内容长度为5-100个字之间"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return NO;
    }
    return YES;  
}


#pragma mark - UIImagePickerControllerDelegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    [_sd.imgArray addObject:image];
    [_sd refreshData];
    [picker.view removeFromSuperview];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker.view removeFromSuperview];
}

#pragma mark - UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    return;
}

#pragma mark - DSRequestDelegate Methods
-(void)requestDataSuccess:(id)dataObj tag:(int)tag{
    NSLog(@"上传成功");
    [self.view removeHUDActivityView];
    //[self.view addHUDLabelView:@"上传成功" Image:nil afterDelay:2.0];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(fabuSuccessed)]) {
        [self.delegate fabuSuccessed];
        [self popViewController];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FabuShaiDanSuccessed" object:nil];
    }
}

-(void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError*)error{
    NSLog(@"失败");
    [self.view removeHUDActivityView];
    [self.view addHUDLabelView:@"上传失败" Image:nil afterDelay:2.0];
}

#pragma mark -UIActionSheetDelegate Methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    UIImagePickerController* imgPickCtl = [[UIImagePickerController alloc] init];
    imgPickCtl.delegate = self;
    imgPickCtl.allowsEditing = YES; //允许编辑
    
    if (buttonIndex == 0) {
        NSLog(@"相册");
        imgPickCtl.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
    }else if(buttonIndex == 1){
        NSLog(@"拍照");
        BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
        if(!isCamera)
        {
            NSLog(@"没有摄像头");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的手机没有摄像头" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
        }
        imgPickCtl.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else{
        NSLog(@"取消");
        return;
    }
    [self.view addSubview:imgPickCtl.view];
    imgPickCtl.view.frame = CGRectMake(0, -20, 320, MainViewHeight);
}


@end
