//
//  XBSuggestionsViewController.m
//  eLite
//
//  Created by 常小哲 on 16/4/20.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBSuggestionsViewController.h"
#import "CXZSelectAvatarController.h"
#import "MXImagePhotoView/MXPhotoView.h"

@interface XBSuggestionsViewController ()<UITextViewDelegate> {
    
    __weak IBOutlet UITextField *_contactStyle;
    __weak IBOutlet UILabel *_placeholder;
    __weak IBOutlet UITextView *textView;

    __weak IBOutlet UIScrollView *scrollview;
}


@end

@implementation XBSuggestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"意见反馈";
    
    MXPhotoView *photoView = [[MXPhotoView alloc] initWithFrame:CGRectMake(0, textView.bottom, Screen_Width, 90)];
    photoView.photoViewDele = self;
    photoView.isNeedMovie = NO;
    photoView.showNum = 4;
    [scrollview addSubview:photoView];
    
    NSLog(@"%@", NSStringFromCGRect(photoView.frame));
}

#pragma mark-   touch action

- (IBAction)pressSubmitButtonAction:(id)sender {
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    _placeholder.hidden = YES;
}

@end
