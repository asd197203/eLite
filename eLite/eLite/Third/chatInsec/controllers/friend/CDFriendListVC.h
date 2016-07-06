//
//  CDContactListController.h
//  LeanChat
//
//  Created by Qihe Bian on 7/27/14.
//  Copyright (c) 2014 LeanCloud. All rights reserved.
//

#import "CDBaseTableVC.h"

@interface CDFriendListVC : CDBaseTableVC
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSMutableArray *headerSectionDatas;
@property(nonatomic,strong)NSMutableArray *indexArray;
@property(nonatomic,strong)NSMutableArray *letterResultArr;
@property(nonatomic,strong)UISearchController *searchController;
@property(nonatomic,strong)AVUser *deleteUser;
@property (nonatomic, strong) NSArray *searchResult;
@property (nonatomic, strong) NSMutableArray *searchArray;
- (void)refresh;
@end
