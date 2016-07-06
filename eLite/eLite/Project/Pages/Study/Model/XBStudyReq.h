//
//  XBStudyReq.h
//  eLite
//
//  Created by 常小哲 on 16/4/30.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "SBaseReq.h"

#pragma mark-  学霸推荐

@interface XBRecommendListReq : SBaseReq<GET>

@property (nonatomic, copy) NSString *userid;
@property (nonatomic, assign) NSInteger page;

@end

@interface XBRecommendListModel : JSONModel

@property (nonatomic, copy) NSString *_id;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString <Optional>*title;
@property (nonatomic, copy) NSString <Optional>*audio;
@property (nonatomic, copy) NSString <Optional>*video;
@property (nonatomic, copy) NSString <Optional>*img;
@property (nonatomic, assign) NSInteger __v;
@property (nonatomic, copy) NSString *time;

@end
@interface XBRecommendListRes : SBaseRes

@property (nonatomic, strong) NSArray *data;

@end

#pragma mark-  我的作业

// 关卡信息
@interface XBHomeworkLevelReq : SBaseReq<GET>

@property (nonatomic, copy) NSString *userid;

@end

@interface XBLevelInfoModel : JSONModel

@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *textcount;
@property (nonatomic, copy) NSString *textperscore;
@property (nonatomic, copy) NSString *audiocount;
@property (nonatomic, copy) NSString *audioperscore;
@property (nonatomic, copy) NSString *videocount;

@end

@interface XBHomeworkLevelRes : SBaseRes

@property (nonatomic, strong) NSDictionary *data;

@end

// 获取文字题目
@interface XBHomeworkWordReq : SBaseReq<GET>

@property (nonatomic, copy) NSString *userid;

@end

@interface XBHomeworkWordInfoModel : JSONModel

@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *answer;
@property (nonatomic, strong) NSArray *option;

@end

@interface XBHomeworkWordRes : SBaseRes

@property (nonatomic, strong) NSArray *data;

@end

// 提交文字题目

@interface XBHomeworkWordSubmitReq : SBaseReq<POST>

@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *wrong;

@end

@interface XBHomeworkWordSubmitRes : SBaseRes

@property (nonatomic, copy) NSNumber<Optional> *data;

@end


typedef NS_ENUM(NSUInteger, HistorySubjectType) {
    HistorySubjectType_Word = 1,
    HistorySubjectType_Audio,
    HistorySubjectType_Video,
};

// 获取历史记录
@interface XBHomeworkHistoryReq : SBaseReq<GET>

@property (nonatomic, copy) NSString *userid;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger page;

@end

@interface XBHomeworkHistoryItemInfoModel : JSONModel
//@property(nonatomic,strong)NSDictionary *item;
@property(nonatomic, copy) NSString *_id;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *answer;
@property(nonatomic, strong) NSArray *option;
@property(nonatomic, copy ) NSString *comment;
@property(nonatomic, copy) NSString *path;
@end
@protocol XBHomeworkHistoryItemInfoModel <NSObject>

@end
@interface XBHomeworkHistoryInfoModel : JSONModel
@property(nonatomic, strong) NSDictionary *level;
@property(nonatomic, strong) NSNumber <Optional>*score;
@property(nonatomic, copy) NSString *date;
@property(nonatomic, strong) NSArray <XBHomeworkHistoryItemInfoModel,Optional>*subjects;
@end
@protocol XBHomeworkHistoryInfoModel <NSObject>
@end
@interface XBHomeworkHistoryRes : SBaseRes

@property (nonatomic, strong) NSArray<XBHomeworkHistoryInfoModel,Optional> *data;

@end


// 获取语音题
@interface XBHomeworkVoiceReq : SBaseReq<GET>

@property (nonatomic, copy) NSString *userid;

@end

@interface XBHomeworkVoiceInfoModel : JSONModel

@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *title;

@end

@interface XBHomeworkVoiceRes : SBaseRes

@property (nonatomic, strong) NSArray *data;

@end

// 提交语音题

@interface XBHomeworkVoiceSubmitReq : SBaseReq<POST>

@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *subjects;
@property (nonatomic, strong) NSMutableArray<NSData*> *file1;

@end

@interface XBHomeworkVoiceSubmitRes : SBaseRes

@property (nonatomic, copy) NSString <Optional>*data;

@end

#pragma mark-  教师评估

// 教师列表
@interface XBEvaluationReq : SBaseReq<GET>

@property (nonatomic, copy) NSString *userid;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, copy) NSString *key;

@end

@interface XBTeacherInfoModel : JSONModel

@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *upcount;

@end

@interface XBEvaluationRes : SBaseRes

@property (nonatomic, strong) NSArray *data;

@end



// 教师详情
@interface XBTeacherDetailInfoReq : SBaseReq<GET>

@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *teacherid;

@end

@interface XBTeacherDetailInfoModel : XBTeacherInfoModel

@property (nonatomic, strong) NSNumber *isfav;
@property (nonatomic, copy) NSString *style;
@property (nonatomic, copy) NSString *des;

@end

@interface XBTeacherDetailInfoRes : SBaseRes

@property (nonatomic, strong) NSDictionary *data;

@end

// 教师点赞
@interface XBTeacherUpReq : SBaseReq<PUT>
@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *teacherid;
@end

@interface XBTeacherUpRes : SBaseRes

@end


// 教师收藏
@interface XBTeacherFavourReq : SBaseReq<PUT>

@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *teacherid;
@property (nonatomic, assign) BOOL fav;
@end

@interface XBTeacherFavourRes : SBaseRes

@end
