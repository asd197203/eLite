//
//  XBVoiceDoneViewController.m
//  eLite
//
//  Created by 常小哲 on 16/5/11.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBVoiceDoneViewController.h"
#import "XBStudyReq.h"
#import "NSData+category.h"
@interface XBVoiceDoneViewController ()

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectCount;
@property (nonatomic, strong) UIButton *leftBtn;

@end

@implementation XBVoiceDoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _scoreLabel.text = [NSString stringWithFormat:@"%ld", _score];
    _subjectCount.text = [NSString stringWithFormat:@"共%ld道题得分", _allSubjectCount];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftBtn];
     __weak typeof(self) weakSelf = self;
    [XBHomeworkVoiceSubmitReq do:^(id req) {
        XBHomeworkVoiceSubmitReq *re = req;
        re.file1 = [[NSMutableArray alloc]initWithCapacity:20];
        for (int i=0; i<self.voiceArray.count; i++) {
            NSData *data = self.voiceArray[i];
            data.fileType =@"voice";
            data.fileName =[NSString stringWithFormat:@"file%d",i+1];
            [re.file1 addObject:data];
        }
        re.userid = [NSString stringWithFormat:@"%@",[XBUserDefault sharedInstance].resModel.userid];
        re.score =[NSString stringWithFormat:@"%ld", _score];
        re.subjects = weakSelf.allSubjectID;
    } Res:^(id res) {
        XBHomeworkVoiceSubmitRes *resq = res;
        if (resq.code==0) {
            if ([resq.data integerValue]==0) {
                [XBShowViewOnce showHUDText:@"提交成功" inVeiw:weakSelf.view];
            }
            else if([resq.data integerValue]==1)
            {
                [XBShowViewOnce showHUDText:@"恭喜进入下一关" inVeiw:weakSelf.view];
            }
            else
            {
                [XBShowViewOnce showHUDText:@"恭喜你已满级" inVeiw:weakSelf.view];
            }
        }
        
    } ShowHud:NO];
}

- (UIButton *)leftBtn {
    if (_leftBtn) {
        return _leftBtn;
    }
    
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.frame = CGRectMake(0, 0, 60, 30);
    _leftBtn.titleLabel.font = Font_System(15);
    [_leftBtn setTitle:@"返回" forState:UIControlStateNormal];
    [_leftBtn setTitleColor:Color_White forState:UIControlStateNormal];
    [_leftBtn setImage:Image_Named(@"return_clearColor_button") forState:UIControlStateNormal];
    [_leftBtn  setImageEdgeInsets : UIEdgeInsetsMake ( 0 , - 30 , 0 , 0 )];
    [_leftBtn  setTitleEdgeInsets : UIEdgeInsetsMake ( 0 , - 20 , 0 , 0 )];
    [_leftBtn addTarget:self action:@selector(backMyHomework:) forControlEvents:UIControlEventTouchUpInside];
    
    return _leftBtn;
}

- (IBAction)backMyHomework:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
