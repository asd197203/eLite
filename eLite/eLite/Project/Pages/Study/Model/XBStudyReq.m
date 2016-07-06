//
//  XBStudyReq.m
//  eLite
//
//  Created by 常小哲 on 16/4/30.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBStudyReq.h"

#pragma mark-  学霸推荐

@implementation XBRecommendListReq

- (NSString *)url {
    return @"/recommend/list";
}

@end

@implementation XBRecommendListModel

@end

@implementation XBRecommendListRes

@end

#pragma mark-  我的作业

// 关卡信息
@implementation XBHomeworkLevelReq

- (NSString *)url {
    return @"/level/info";
}

@end

@implementation XBLevelInfoModel

@end

@implementation XBHomeworkLevelRes

@end


// 获取文字题目
@implementation XBHomeworkWordReq

- (NSString *)url {
    return @"/level/text";
}

@end

@implementation XBHomeworkWordInfoModel

@end

@implementation XBHomeworkWordRes

@end

@implementation XBHomeworkWordSubmitReq
- (NSString *)url {
    return @"/level/text";
}

@end

@implementation XBHomeworkWordSubmitRes
@end
// 获取历史记录
@implementation XBHomeworkHistoryReq

- (NSString *)url {
    return @"/level/history";
}

@end
@implementation XBHomeworkHistoryItemInfoModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"item._id":@"_id",
                                                      @"item.title":@"title",
                                                      @"item.answer":@"answer",
                                                      @"item.option":@"option"}];
}
@end
@implementation XBHomeworkHistoryInfoModel


@end

@implementation XBHomeworkHistoryRes

@end

// 获取语音题

@implementation XBHomeworkVoiceReq

- (NSString *)url {
    return @"/level/audio";
}
@end

@implementation XBHomeworkVoiceInfoModel

@end

@implementation XBHomeworkVoiceRes  

@end


// 提交语音题

@implementation XBHomeworkVoiceSubmitReq
- (NSString *)url {
    return @"/level/audio";
}
@end

@implementation XBHomeworkVoiceSubmitRes

@end

#pragma mark-  教师评估
// 教师列表
@implementation XBEvaluationReq

- (NSString *)url {
    return @"/teacher/list";
}

@end

@implementation XBTeacherInfoModel
@end

@implementation XBEvaluationRes

@end

// 教师详情
@implementation XBTeacherDetailInfoReq

- (NSString *)url {
    return @"/teacher/info";
}

@end

@implementation XBTeacherDetailInfoModel

@end

@implementation XBTeacherDetailInfoRes

@end

// 教师点赞
@implementation XBTeacherUpReq

- (NSString *)url {
    return @"/teacher/up";
}

@end

@implementation XBTeacherUpRes

@end


// 教师收藏
@implementation XBTeacherFavourReq

- (NSString *)url {
    return @"/teacher/fav";
}

@end

@implementation XBTeacherFavourRes

@end
