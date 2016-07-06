//
//  XBVideoSubjectViewController.m
//  eLite
//
//  Created by 常小哲 on 16/4/15.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBVideoSubjectViewController.h"
#import "XHMessageVideoConverPhotoFactory.h"
#import "XBVideoRecordController.h"
#import "XBPlayVideoController.h"
#import "GetVideoSubjectReq.h"
#import "XBVideoHistoryListController.h"

@interface XBVideoSubjectViewController ()<XBVideoRecordControllerFinishDelegate> {
    NSString *_videoPath;
    BOOL  isCompleteVideo;
}
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *playerButton;
@property (weak, nonatomic) IBOutlet UIImageView *videoThumb;
@property (nonatomic,strong)NSArray  *array;

@end

@implementation XBVideoSubjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self rightBtn];
    self.playerButton.hidden = YES;
    typeof(self) __weak weakSelf = self;
    [GetVideoSubjectReq do:^(id req) {
        GetVideoSubjectReq *re =req;
        re.userid = [NSString stringWithFormat:@"%@",[XBUserDefault sharedInstance].resModel.userid];
    } Res:^(id res) {
        GetVideoSubjectRes *resq =res;
        if (resq.code==0) {
            if(resq.data.count>0)
            {
                _array = resq.data;
                GetVideoSubjectModel *model = resq.data[0];
                self.titleLabel.text = [NSString stringWithFormat:@"请录制一段视频，相关人员会给您做出相关建议：%@",model.title];
            }
            else
            {
                [XBShowViewOnce showHUDText:resq.msg inVeiw:weakSelf.view];
            }
        }
        else
        {
           [XBShowViewOnce showHUDText:resq.msg inVeiw:weakSelf.view];
        }
    } ShowHud:YES];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    NSString *strUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    _videoPath = [NSString stringWithFormat:@"%@/test.mov", strUrl];
    if (isCompleteVideo) {
        self.playerButton.hidden = NO;
        UIImage *thumb = [XHMessageVideoConverPhotoFactory videoConverPhotoWithVideoPath:USER_CacheFilePath(@"test.mov")];
        if (thumb) {
            [_videoThumb setImage:thumb];
        }
    }
}

- (void)rightBtn {
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 60, 30);
    rightBtn.titleLabel.font = Font_System(15);
    [rightBtn setTitle:@"历史记录" forState:UIControlStateNormal];
    [rightBtn setTitleColor:ColorHex(0x00C71F) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(pressHistoryListButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
}

#pragma mark-   touch action

- (void)pressHistoryListButtonAction:(UIButton *)sender {
    [self.navigationController pushViewController:[XBVideoHistoryListController new] animated:YES];
}

- (IBAction)player:(id)sender {
    XBPlayVideoController *vc = [[XBPlayVideoController alloc] init];
    [vc addLocationPath:USER_CacheFilePath(@"test.mov")];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)recording:(id)sender {
    XBVideoRecordController *RecordVC = [[XBVideoRecordController alloc] init];
    RecordVC.delagate = self;
    GetVideoSubjectModel*model = _array[0];
    RecordVC.subjects =model._id;
    [self.navigationController pushViewController:RecordVC animated:YES];
}
-(void)completeVideo
{
    isCompleteVideo = YES;
}

@end
