//
//  MXPhotoView.m
//  MXImageSelectView
//
//  Created by maxin on 16/4/27.
//  Copyright © 2016年 maxin. All rights reserved.
//

#import "MXPhotoView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "MXBasePhotoView.h"

#define kWindowWidth   [UIScreen mainScreen].bounds.size.width
#define kWindowHeight  [UIScreen mainScreen].bounds.size.height

//调整间隙
#define SPACES 10

@interface MXPhotoView ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, MXBasePhotoViewDelegate>
{
    UIImagePickerController *_imagePickerController;
    NSInteger count;
    CGFloat _viewDefaultHeight;
    UIImageView *mxImageV;
    NSInteger curPhotoNum;
}

@end

@implementation MXPhotoView

//初始化 布局
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        //初始化图片视图 加手势 点击弹框提示选择拍照or相册
        mxImageV = [[UIImageView alloc] initWithFrame:CGRectMake(SPACES+5, SPACES+5, 70, 70)];
        _viewDefaultHeight = frame.size.height;
        _imageWidth = 80;
        _imageHeight = 80;
        mxImageV.tag = 100;
        mxImageV.image = [UIImage imageNamed:@"choose_add"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageToSelect:)];
        mxImageV.userInteractionEnabled = YES;
        [mxImageV addGestureRecognizer:tap];
        [self addSubview:mxImageV];
        
        //初始化图片选择控制器
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        _imagePickerController.allowsEditing = YES;
        
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //会自动掉[self initWithFrame]初始化,所以这里不需要设置什么
        self.frame = CGRectMake(0, 0, kWindowWidth, 200);
        _viewDefaultHeight = 200;
    }
    return self;
}

//点击弹框
- (void)clickImageToSelect:(UITapGestureRecognizer *)tap
{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *photo = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectImageFromAlbum];
    }];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectImageFromCamera];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:photo];
    [alertController addAction:camera];
    [alertController addAction:cancel];
    [_photoViewDele presentViewController:alertController animated:YES completion:nil];
    
}

#pragma mark 从摄像头获取图片或视频
- (void)selectImageFromCamera
{
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    //录制视频时长，默认10s
    _imagePickerController.videoMaximumDuration = 15;
    
    //相机类型（拍照、录像...）字符串需要做相应的类型转换
    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:(NSString *)kUTTypeImage, nil];
    if (self.isNeedMovie)
    {
        [arr addObject:(NSString *)kUTTypeMovie];
    }
    _imagePickerController.mediaTypes = arr;
    
    //视频上传质量
    //UIImagePickerControllerQualityTypeHigh高清
    //UIImagePickerControllerQualityTypeMedium中等质量
    //UIImagePickerControllerQualityTypeLow低质量
    //UIImagePickerControllerQualityType640x480
    _imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    
    //设置摄像头模式（拍照，录制视频）为录像模式
    _imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    [_photoViewDele presentViewController:_imagePickerController animated:YES completion:nil];
}

#pragma mark 从相册获取图片或视频
- (void)selectImageFromAlbum
{
    //NSLog(@"相册");
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [_photoViewDele presentViewController:_imagePickerController animated:YES completion:nil];
}

#pragma mark UIImagePickerControllerDelegate
//该代理方法仅适用于只选取图片时
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    NSLog(@"选择完毕----image:%@-----info:%@",image,editingInfo);
}

//适用获取所有媒体资源，只需判断资源类型
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        [self layoutMxSubviewsWithType:0 andInfo:info];
        //如果是图片
        //压缩图片
        NSData *fileData = UIImageJPEGRepresentation(info[UIImagePickerControllerEditedImage], 1.0);
        //保存图片至相册
//        UIImageWriteToSavedPhotosAlbum(info[UIImagePickerControllerEditedImage], self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        //        上传图片
        if (_delegate && [_delegate respondsToSelector:@selector(upLoadVideoWithData:)]) {
            [_delegate upLoadVideoWithData:fileData];
        }
    }else{
        //如果是视频
        NSURL *url = info[UIImagePickerControllerMediaURL];
        [self layoutMxSubviewsWithType:1 andInfo:info];
        //保存视频至相册（异步线程）
        NSString *urlStr = [url path];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr))
            {
//                UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
            }
        });
        NSData *videoData = [NSData dataWithContentsOfURL:url];
        //视频上传
        if (_delegate && [_delegate respondsToSelector:@selector(upLoadVideoWithData:)]) {
            [_delegate upLoadVideoWithData:videoData];
        }
    }
    [_photoViewDele dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 图片保存完毕的回调
- (void) image: (UIImage *) image didFinishSavingWithError:(NSError *) error contextInfo: (void *)contextInf{
    NSLog(@"保存完毕");
}

#pragma mark 视频保存完毕的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInf{
    if (error) {
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    }else{
        NSLog(@"视频保存成功.");
    }
}

#pragma mark - addOrDelete Method
//根据回调类型重新布局
- (void)layoutMxSubviewsWithType:(NSInteger)type andInfo:(NSDictionary*)info
{
    curPhotoNum++;
    [self addImageLayoutSubviews];
    count++;
    if (type == 0)
    {
        MXBasePhotoView *imageView = [[MXBasePhotoView alloc] initWithFrame:CGRectMake(SPACES, SPACES, _imageWidth, _imageHeight)];
        imageView.tag = 100+count;
        NSLog(@"%ld", imageView.tag);
        imageView.photoDelegate = self;
        imageView.showImageView.image = info[UIImagePickerControllerEditedImage];
        [self addSubview:imageView];
    }
    else
    {
        AVPlayerViewController *movieController = [[AVPlayerViewController alloc] init];
        movieController.view.frame = CGRectMake(SPACES, SPACES, _imageWidth, _imageHeight);
        movieController.view.tag = 100+count;
        NSLog(@"%ld", movieController.view.tag);
        [self addSubview:movieController.view];
        NSURL *url = info[UIImagePickerControllerMediaURL];
        AVPlayer *player = [AVPlayer playerWithURL:url];
        movieController.player = player;
        [movieController.player play];
        [_photoViewDele addChildViewController:movieController];
    }
}

//删除照片的点击事件
- (void)clickDeleBtToDelePhotoWithView:(UIView *)view
{
    curPhotoNum --;
    NSLog(@"%ld", view.tag);
    __weak typeof(self) ws = self;
    //记录删除视图的标签
    NSInteger tag = view.tag;
    //记录删除视图的frame
    __block CGRect frame = view.frame;
    //从父视图中删除
    [view removeFromSuperview];
    //调整布局
    [UIView animateWithDuration:0.3 animations:^{
        for (int i = (int)tag-1; i>= 100; i--)
        {
            UIView *vw = [ws viewWithTag:i];
            CGRect tempFrame = vw.frame;
            if (i == 100)
            {
                mxImageV.hidden = NO;
                frame.size.width = frame.size.width-SPACES;
                frame.size.height = frame.size.height-SPACES;
                frame.origin.x = frame.origin.x+5;
                frame.origin.y = frame.origin.y+5;
            }
            vw.frame = frame;
            frame = tempFrame;
        }
    }];
    UIView *imgV = [self viewWithTag:100];
    __block CGRect sframe = self.frame;
    //调整默认自身高度
    [UIView animateWithDuration:0.3 animations:^{
        if (imgV.frame.origin.y-5+_imageHeight*2+2*SPACES < ws.frame.size.height && ws.frame.size.height-_imageHeight-SPACES >= _viewDefaultHeight)
        {
            sframe.size.height = sframe.size.height-_imageHeight-SPACES;
            ws.frame = sframe;
        }
 
    }];
    //减小tag count 防止出鬼
    for (int i = (int)tag+1; i<=100+count; i++)
    {
         UIView *vw = [self viewWithTag:i];
        vw.tag = vw.tag-1;
    }
    count--;
}

- (void)addImageLayoutSubviews
{
    __block CGFloat height = 0.0;
    __weak typeof(self) ws = self;
    [UIView animateWithDuration:0.5 animations:^{
        //添加图片，已经存在的图片后移 最新添加的现实在最前面
        for (UIView *view in ws.subviews)
        {
            CGRect frame = view.frame;
            //默认的图片和选择的图片要分开处理 尺寸不同
            CGFloat x = 0.f;
            if (view.tag == 100)
            {
                x = frame.origin.x-5;
            }
            else
            {
                x = frame.origin.x;
            }
            
            //做换行处理
            if (x+_imageWidth*2+SPACES*2>ws.frame.size.width)
            {
                if (view.tag == 100)
                {
                    frame.origin.x = SPACES+5;
                }
                else
                {
                    frame.origin.x = SPACES;
                }
                frame.origin.y = frame.origin.y+_imageHeight+SPACES;
            }
            else
            {
                frame.origin.x = frame.origin.x+_imageWidth+SPACES;
            }
            //记录高度
//            if (frame.origin.y + _imageHeight+SPACES > height) {
//                height = frame.origin.y + _imageHeight+SPACES;
//            }
            view.frame = frame;
            if (view == mxImageV) {
                if (curPhotoNum > 3) {
                    mxImageV.hidden = YES;
                }
            }
        }
        //根据前面纪录的高度调整视图高度
//        if (height > ws.frame.size.height)
//        {
//            CGRect frame = ws.frame;
//            frame.size.height = frame.size.height + _imageHeight +SPACES;
//            ws.frame = frame;
//        }
        
    }];

}


#pragma mark - system Method -- setMethod
- (void)setShowNum:(NSInteger)showNum
{
    _showNum = showNum;
    _imageWidth = (kWindowWidth-SPACES*(_showNum+1))/_showNum;
    _imageHeight = _imageWidth;
    [self layoutMxImageView];
}

- (void)setImageWidth:(CGFloat)imageWidth
{
    _imageWidth = imageWidth;
    [self layoutMxImageView];
}

- (void)setImageHeight:(CGFloat)imageHeight
{
    _imageHeight = imageHeight;
    [self layoutMxImageView];
}

- (void)layoutMxImageView
{
    UIView *view = [self viewWithTag:100];
    CGRect frame = view.frame;
    frame.size.width = _imageWidth-SPACES;
    frame.size.height = _imageHeight-SPACES;
    view.frame = frame;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
