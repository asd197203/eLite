//
//  XBWordDoneController.m
//  eLite
//
//  Created by 常小哲 on 16/5/1.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBWordDoneController.h"
#import "XBCheckWrongViewController.h"

@interface XBWordDoneController () {

    __weak IBOutlet UILabel *_topLabel;
    __weak IBOutlet UILabel *_correctLabel;
    __weak IBOutlet UILabel *_wrongLabel;
    __weak IBOutlet UILabel *_correctRateLabel;
}

@property (nonatomic, strong) UIButton *leftBtn;

@end

@implementation XBWordDoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    typeof(self) __weak weakSelf = self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftBtn];
    
    _correctRateLabel.text = [NSString stringWithFormat:@"%.1f%%", _correctRate * 100.0];
    _topLabel.text = [NSString stringWithFormat:@"共%.f道题正确率", _allSubjectCount];
    _correctLabel.text = [NSString stringWithFormat:@"%ld题", _correctNum];
    _wrongLabel.text = [NSString stringWithFormat:@"%ld题", _wrongNum];
    [XBHomeworkWordSubmitReq do:^(id req) {
        XBHomeworkWordSubmitReq *tmpReq = req;
        tmpReq.userid = USER_ID;
        tmpReq.wrong = _wrongID;
        tmpReq.score = [NSString stringWithFormat:@"%.f", _score];
    } Res:^(id res) {
        XBHomeworkWordSubmitRes *tmpRes = res;
        if (tmpRes.code == 0) {
            if ([tmpRes.data integerValue]==0) {
                [XBShowViewOnce showHUDText:@"提交成功" inVeiw:weakSelf.view];
            }
            else if([tmpRes.data integerValue]==1)
            {
               [XBShowViewOnce showHUDText:@"恭喜进入下一关" inVeiw:weakSelf.view];
            }
            else
            {
              [XBShowViewOnce showHUDText:@"恭喜你已满级" inVeiw:weakSelf.view];
            }
            
        }
        else
        {
          [XBShowViewOnce showHUDText:tmpRes.msg inVeiw:weakSelf.view];
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
    [_leftBtn addTarget:self action:@selector(backToMyWork:) forControlEvents:UIControlEventTouchUpInside];
    
    return _leftBtn;
}

- (IBAction)pressCheckWrongButton:(id)sender {
    if (self.wrongSubjectDict.count > 0) {
        XBCheckWrongViewController *vc = [XBCheckWrongViewController new];
        vc.myWorkResults = self.myWorkResults;
        vc.wrongSubjectDict = self.wrongSubjectDict;
        [self.navigationController pushViewController:vc animated:YES];

    }else {
        ALERT_ONE(@"恭喜你全部答对，没有错题");
    }
}

- (IBAction)backToMyWork:(id)sender {
    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
}

@end
