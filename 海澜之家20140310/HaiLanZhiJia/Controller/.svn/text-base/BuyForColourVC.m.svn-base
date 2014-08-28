//
//  BuyForColourVC.m
//  HaiLanZhiJia
//
//  Created by creaver on 13-11-26.
//  Copyright (c) 2013年 donson. All rights reserved.
//
#define SECONDS_BTWEEN 5                    // 几秒发送一次请求
#define SECONDS_COLOR 0.5                   // 几秒更新颜色值

#import "BuyForColourVC.h"
#import <ImageIO/ImageIO.h>
#import "UIButton+WebCache.h"
#import "ShangPingDetailVC.h"
@interface BuyForColourVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,NetImageViewDelegate>
{
    UITableView *viewTable;
    
    NSMutableArray *array1;
    NSMutableArray *buttons;
    
    BOOL ispause;
    AVCaptureSession *capSession;
	AVAssetWriter *assetWriter;
	AVAssetWriterInput *assetWriterAudioIn;
	AVAssetWriterInput *assetWriterVideoIn;
	dispatch_queue_t movieWritingQueue;
    BOOL readyToRecordVideo;
    dispatch_queue_t videoDataOutputQueue;
    AVCaptureStillImageOutput *stillImageOutput;
    AVCaptureVideoDataOutput *videoDataOutput;
    AVCaptureVideoPreviewLayer *videoPreviewLayer;
    UILabel *myLabel;
    BOOL shouldRefreshBackground;
    
    NSTimer *myTimer;
    UIColor *myColor;
    UILabel *_colorLabel;
    
    int  _red;
    int  _green;
    int  _blue;
    int  _alp;
    
    int LeiMuindex;
    
    int myIndex;
    
    UIColor *oldColour;
    UIColor *newColour;
    
    
    int waitSeconds;
   
}

@property (nonatomic) BOOL isCapturingVideo, isUsingFrontFacingCamera;
@property(nonatomic,retain)UIView *videoPreview;

@property(nonatomic,retain)NSMutableArray *goodListAry;

@property(nonatomic,retain)NSMutableArray *allCategaty;//所有分类的数组
@property(nonatomic,retain)NSMutableArray *categatyIdAry;//所有分类id的数组
@property(nonatomic,retain)DSRequest *aRequest;




@end

@implementation BuyForColourVC

//- (void)dealloc
//{
//    [myTimer invalidate];
//    myTimer = nil;
//    //停摄像头
//    [capSession stopRunning];//(不停会崩溃)
//    [capSession release];
//    capSession = nil;
//    self.aRequest.delegate = nil;
//    self.aRequest = nil;
//    self.videoPreview = nil;
//    self.goodListAry = nil;
//    self.allCategaty = nil;
//    self.categatyIdAry = nil;
//
//    [super dealloc];
//}

-(void)leftAction
{
    //------------------------------------------------------------------------------------------------//
    self.aRequest.delegate = nil;
    self.aRequest = nil;
    [myTimer invalidate];
    myTimer = nil;
    //停摄像头
    [[videoDataOutput connectionWithMediaType:AVMediaTypeVideo] setEnabled:NO];
    if (capSession.isRunning) {
        [capSession stopRunning];//(不停会崩溃)
    }
    [capSession release];
    capSession = nil;
    
    self.videoPreview = nil;
    self.goodListAry = nil;
    self.allCategaty = nil;
    self.categatyIdAry = nil;
    [self popViewController];
    //------------------------------------------------------------------------------------------------//
}

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
    
    myIndex = 0;
    BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    if(!isCamera)
    {
        [WCAlertView showAlertWithTitle:@"提示" message:@"您的设备没有摄像头" customizationBlock:^(WCAlertView *alertView) {
            alertView.style = WCAlertViewStyleWhite;
            alertView.labelTextColor=[UIColor blackColor];
            alertView.buttonTextColor=[UIColor blueColor];
        } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
            nil;
        } cancelButtonTitle:nil otherButtonTitles:@"确认", nil];

    }

    
    self.categatyIdAry = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];   //jiangsuiming 2013-12-28
    
    [self allCategayDate];//先获得所有类目
    
    LeiMuindex = 0;
    array1 = [[NSMutableArray alloc]initWithCapacity:0];
    buttons = [[NSMutableArray alloc]initWithCapacity:0];
    
    _videoPreview = [[UIView alloc]initWithFrame:CGRectMake(0, TITLEHEIGHT, MainViewWidth, MainViewHeight)];//非摄像的区域
    _videoPreview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_videoPreview];
    [self.view sendSubviewToBack:self.videoPreview];
    
    [self setTitleString:@"颜色购"];
    [self createMyButtonWithTitleAndImage];
    self.rightButton.hidden = NO;
    [self setMyRightButtonBackGroundImageView:@"mall_icon_list.png" hightImage:nil];
    [self initMidView];//准心
    
    [self setupAVCapture];//调用摄像头
 //   [self startVidio];
    [self performSelector:@selector(startVidio) withObject:nil afterDelay:0.2];
    
    [self initView];
 

   }


-(void)startVidio
{
    myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    [self startVideoCapture];
    

}

#pragma mark ---结果请求
-(void)initDate
{
       
    //l	float	颜色l分量
    //a	float	颜色a分量
    //b	float	颜色b分量
    float L = (0.2126007 * _red) + (0.7151947 * _green) + (0.0722046 * _blue);
    float A = (0.3258962 * _red) - (0.4992596 * _green) + (0.1733409 * _blue) + 128;
    float B = (0.1218128 * _red) + (0.3785610 * _green) - (0.5003738 * _blue) + 128;
    DSRequest *requestObj = [[DSRequest alloc]init];
    self.aRequest = requestObj;
    requestObj.delegate = self;
  //  NSMutableArray *array = [[NSMutableArray alloc]init];//self.categatyIdAry
    [requestObj requestDataWithInterface:GetColorBuySearchResult param:[self GetColorBuySearchResultParam:self.categatyIdAry colorl:L colora:A colorb:B] tag:1];
    [requestObj release];
}


-(void)allCategayDate//刚进来请求所有id
{
    DSRequest *requestObj = [[DSRequest alloc]init];
    self.aRequest = requestObj;
    requestObj.delegate = self;
    [requestObj requestDataWithInterface:ShoppingMallCategory param:[self ShoppingMallCategoryParam] tag:0];
    [requestObj release];
}

#pragma mark --DSRequest delgate
-(void)requestDataSuccess:(id)dataObj tag:(int)tag
{
   
    switch (tag) {
        case 0://类别
        {
            self.allCategaty = (NSMutableArray *)dataObj;
            for(int i=0;i<self.allCategaty.count;i++)
            {
                 MallCategoryEntity* entity = [self.allCategaty objectAtIndex:i];//分类实体
                [self.categatyIdAry addObject:entity.categoryid];
            }
        }
            break;
            
        case 1://扫瞄后的goods
        {
//           self.goodListAry = (NSMutableArray *)dataObj;
//            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeButtonBg) userInfo:nil repeats:YES];

        }
            break;
            
        default:
            break;
    }
}

-(void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError *)error
{
    NSLog(@"失败");
    [self addFadeLabel:error.domain];
    
}

-(void)loadImageFinish:(NetImageView *)imageView
{
    
}

-(void)changeButtonBg
{
    if(myIndex<self.goodListAry.count)
    {
        NetImageView *view = (NetImageView *)[buttons objectAtIndex:myIndex];
        
        GoodEntity *entity = [self.goodListAry objectAtIndex:myIndex];
      //  UIButton *iconButton = (UIButton *)[buttons objectAtIndex:myIndex];
        NSURL *url = [NSURL URLWithString:entity.goodsimg];
     //   [iconButton setBackgroundImageWithURL:url forState:UIControlStateNormal placeholderImage:GetImage(@"列表小图.png")];
        [view setImageWithURL:url placeholderImage:GetImage(@"列表小图.png")];
        myIndex++;
        if(myIndex ==6)
        {
            myIndex = 0;
        }
    }
   
    
}

- (void)startVideoCapture
{
    self.isCapturingVideo = YES;
  
  //页面一呈现下面的颜色view和按钮就显示出来
    if (!myLabel)
    {
        UILabel *aLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 340/2+80/2, 320, 40)];
        aLabel.numberOfLines = 4;
        [aLabel setTextColor:[UIColor redColor]];
        [aLabel setBackgroundColor:[UIColor clearColor]];
        myLabel = aLabel;
        myLabel.userInteractionEnabled = YES;
        UIImage *playImage = GETIMG(@"search_colour_button_pause.png");
        UIButton *stopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        stopBtn.frame = CGRectMake(280/2, 5, playImage.size.width, playImage.size.height);
        [stopBtn setBackgroundImage:playImage forState:UIControlStateNormal];
        [stopBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [stopBtn setBackgroundImage:GETIMG(@"search_colour_button_play.png") forState:UIControlStateSelected];
        [myLabel setBackgroundColor:[UIColor colorWithRed:(_red/255.0) green:(_green/255.0) blue:(_blue/255.0) alpha:1]];
        [myLabel addSubview:stopBtn];
        [self.view addSubview:myLabel];
    }

    movieWritingQueue = dispatch_queue_create("Movie Writing Queue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(movieWritingQueue, ^{
        [[videoDataOutput connectionWithMediaType:AVMediaTypeVideo] setEnabled:self.isCapturingVideo];
    });
}

-(void)goDetail:(UIButton *)btn
{
    GoodEntity *entity = [self.goodListAry objectAtIndex:btn.tag];
    ShangPingDetailVC *vc = [[ShangPingDetailVC alloc]init];
    vc.spId = entity.goodsid;
    [self pushViewController:vc];
    [vc release];
}

-(void)timerFired:(id)sender//每5秒调用
{
    if (!self.isCapturingVideo) {
        return;
    }
    
    NSString *string = [NSString stringWithFormat:@"r:%d,g:%d,b:%d,a:%d",_red,_green,_blue,_alp];
    [myLabel setText:string];
    [myLabel setBackgroundColor:[UIColor colorWithRed:(_red/255.0) green:(_green/255.0) blue:(_blue/255.0) alpha:1]];

//   if(oldColour != newColour)
//   {
//     [self initDate];//请求  
//   }
//    oldColour = newColour;
    waitSeconds++;
    if (waitSeconds>=SECONDS_BTWEEN/SECONDS_COLOR) {
        [self initDate];
        waitSeconds =0;
    }
    
   if (shouldRefreshBackground)
   {
       shouldRefreshBackground = NO;
   }
    //图片背景改变

}


-(void)delayData
{
    [self initDate];
}


dispatch_queue_t movieWritingQueue;
AVAssetWriter *assetWriter;
AVCaptureVideoDataOutput *videoDataOutput;


- (void)setupAVCapture{
    
    // 1) Set up the AVCapture Session
    // ========================================
    capSession = [[AVCaptureSession alloc] init];
    
    // Keeping it simple, recording at a low quality
    // If you want to record at a higher quality, make sure you check
    // to see if the device supports it
    [capSession setSessionPreset:AVCaptureSessionPresetMedium];
    
    // 2) Set up Capture Device
    // ========================================
    AVCaptureDevice *capDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    
    // 3) Set up Capture Device Input
    // ========================================
    NSError *error = nil;
    AVCaptureDeviceInput *capDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:capDevice error:&error];
    if(error!=nil){
        NSLog(@"There was an error setting up capture input device:\n%@",[error localizedDescription]);
        // [self destroyAVCapture];
    }
    else{
        [capSession beginConfiguration];
        
        //        self.isUsingFrontFacingCamera = NO;
        //        self.isCapturingVideo = NO;
        
        // 4) Add device input to capture session
        // ========================================
        if([capSession canAddInput:capDeviceInput])
        {
            [capSession addInput:capDeviceInput];
        }
        else
        {
            NSLog(@"could not add input");
        }
        
        
        // 5) Create still image output, add it to capture session
        // ========================================
        
        stillImageOutput = [AVCaptureStillImageOutput new];
        [stillImageOutput addObserver:self
                           forKeyPath:@"capturingStillImage"
                              options:NSKeyValueObservingOptionNew
                              context:@"AVCaptureStillImageIsCapturingStillImageContext"];
        
        if([capSession canAddOutput:stillImageOutput])
            [capSession addOutput:stillImageOutput];
        
        
        
        // 6) Create video output, add it to capture session
        // ========================================
        
        videoDataOutput = [AVCaptureVideoDataOutput new];
        
        NSDictionary *rgbOutputSettings = [NSDictionary dictionaryWithObject:
                                           [NSNumber numberWithInt:kCMPixelFormat_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
        [videoDataOutput setVideoSettings:rgbOutputSettings];
        
        [videoDataOutput setAlwaysDiscardsLateVideoFrames:YES];
        
        // create a serial dispatch queue used for the sample buffer delegate as well as when a still image is captured
        // a serial dispatch queue must be used to guarantee that video frames will be delivered in order
        // see the header doc for setSampleBufferDelegate:queue: for more information
        videoDataOutputQueue = dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL);
        [videoDataOutput setSampleBufferDelegate:self queue:videoDataOutputQueue];
        
        if([capSession canAddOutput:videoDataOutput])
            [capSession addOutput:videoDataOutput];
        else
            NSLog(@"Could not add output");
        
        
        // 7) Create Video Preview layer from capture session
        // ========================================
        
        // Set up Preview Layer
        videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:capSession];
        //   videoPreviewLayer.frame = videoPreview.bounds;
        videoPreviewLayer.frame = CGRectMake(0, 0, 320, 340/2);//摄像区域
        videoPreviewLayer.backgroundColor = [UIColor blackColor].CGColor;
        videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
        self.videoPreview.layer.masksToBounds = YES;
        [self.videoPreview.layer addSublayer:videoPreviewLayer];
        
        
        // 8) Commit session configuration
        // 9) Start running capture session
        // ========================================
        [capSession commitConfiguration];
        [capSession startRunning];
        
        
        //Make sure video is not recording
//        [[videoDataOutput connectionWithMediaType:AVMediaTypeVideo] setEnabled:NO];

    }
    
}

//输出
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection{
    
    // Make sure we didn't get here by mistake
    
    if(self.isCapturingVideo){
        if (!shouldRefreshBackground) {
            shouldRefreshBackground= !shouldRefreshBackground;
            myColor = [self imageFromSampleBuffer:sampleBuffer];
        }
    }
}

//的到颜色
// Create a UIImage from sample buffer data
- (UIColor *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
//    size_t width = 360;
//    size_t height = 340/2;

    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    
    
//     UIColor* color = nil;
      float  w =  width;
      float  h = height;

    // Now we can get a pointer to the image data associated with the bitmap
    // context.
      unsigned char* data = CGBitmapContextGetData (context);
    if (data != NULL) {
        //offset locates the pixel in the data from x,y.
        //4 for 4 bytes of data per pixel, w is width of one row of data.
        @try {
             int offset =4*((w*round(h/2))+round(w/2));
            //int alpha =  data[offset];
            //            _red = data[offset];
            //            _green = data[offset+1];
            //            _blue = data[offset+2];
            //            _alp =  data[offset+3];
          
                      
            _blue = data[offset];
            _green = data[offset+1];
            _red = data[offset+2];
            _alp =  data[offset+3];
            newColour = [UIColor colorWithRed:(_red/255.0f) green:(_green/255.0f) blue:(_blue/255.0f) alpha:1];

            return newColour;
          //  return color;
            
            
        }
        @catch (NSException * e) {
            NSLog(@"%@",[e reason]);
        }
        @finally {
        }
    }
    return nil;
}




- (AVCaptureConnection*)setConnectionOrientation:(AVCaptureConnection*)connection{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:orientation];
    [connection setVideoOrientation:avcaptureOrientation];
	[connection setVideoScaleAndCropFactor:1.0f];
    
    return connection;
}

- (AVCaptureVideoOrientation)avOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation{
	AVCaptureVideoOrientation result = deviceOrientation;
	if ( deviceOrientation == UIDeviceOrientationLandscapeLeft )
		result = AVCaptureVideoOrientationLandscapeRight;
	else if ( deviceOrientation == UIDeviceOrientationLandscapeRight )
		result = AVCaptureVideoOrientationLandscapeLeft;
    else if( deviceOrientation == UIDeviceOrientationPortrait)
        result = AVCaptureVideoOrientationPortrait;
    else if( deviceOrientation == UIDeviceOrientationPortraitUpsideDown)
        result = AVCaptureVideoOrientationPortraitUpsideDown;
	return result;
}



-(void)initMidView
{
    UIImage *image = GETIMG(@"search_icon_dian.png");
    UIImageView* imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    imageview.center = CGPointMake(320/2, 170/2+TITLEHEIGHT);
    imageview.image = image;
  //  imageview.userInteractionEnabled = YES;
    [self.view insertSubview:imageview aboveSubview:self.videoPreview];
    [imageview release];

}


-(void)initView
{
   
    
    for (int i=0; i<6; i++)
    {
        
        NetImageView *iconView = [[NetImageView alloc]initWithFrame:CGRectMake(12+(90+15)*(i%3), 572/2-TITLEHEIGHT+20+i/3*(90+10), 90, 90)];
        iconView.delegate = self;
        iconView.userInteractionEnabled = YES;
        iconView.image = GETIMG(@"列表小图.png");
        [iconView setBackgroundColor:[UIColor clearColor]];
        iconView.tag = 20+i;
        [self.view addSubview:iconView];
        
        UIButton * iconButton= [UIButton buttonWithType:UIButtonTypeCustom] ;
        iconButton.tag = i;
        iconButton.frame = CGRectMake(0, 0, 90, 90);
        iconButton.backgroundColor=[UIColor clearColor];
        [iconView addSubview:iconButton];
        [iconButton addTarget:self action:@selector(goDetail:) forControlEvents:UIControlEventTouchUpInside];
        [buttons addObject:iconView];
        
    //    [iconButton setBackgroundImage:GETIMG(@"列表小图.png") forState:UIControlStateNormal];
    //    iconButton.frame = CGRectMake(12+(90+15)*(i%3), 572/2-TITLEHEIGHT+20+i/3*(90+10), 90, 90);
     //   [iconView release];
        
        
    }

}

-(void)clickBtn:(UIButton *)btn
{
   
   
    ispause = !ispause;
    if(ispause)
    {
        btn.selected = YES;
        [self stopVideoCapture];
        ispause = YES;
    }
    else{
        [self startVideoCapture];
        ispause = NO;
        btn.selected = NO;
    }
}




- (void)stopVideoCapture
{
    self.isCapturingVideo = NO;

    [[videoDataOutput connectionWithMediaType:AVMediaTypeVideo] setEnabled:self.isCapturingVideo];
 
}

-(void)myRightButtonAction:(UIButton *)button
{
    SparateVC *sparateView = [[SparateVC alloc]init];
    [self pushViewController:sparateView];
    SAFETY_RELEASE(sparateView);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
     [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(categoryidMethod:) name:@"idName" object:nil];
   
}


-(void)categoryidMethod:(NSNotification *)note
{
     NSDictionary *dic=[note userInfo];
    self.categatyIdAry = [dic objectForKey:@"categayId"];//获得id集合
    
    
}




@end
