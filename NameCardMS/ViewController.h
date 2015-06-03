//
//  ViewController.h
//  NameCardMS
//
//  Created by 郝 林巍 on 15/4/15.
//  Copyright (c) 2015年 lincwee. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SlideSideView.h"
#import "AppDelegate.h"
#import "SDRefresh.h"
#import "SqliteManage.h"
#import "SINavigationMenuView.h"
@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, SINavigationMenuDelegate>
{
    NSMutableArray *m_pDataList;
}

@property (strong, nonatomic) SlideSideView *slideViewController;
@property (strong, nonatomic) UITableView *m_pTableView;
//本地数据
@property (strong, nonatomic) NSMutableArray *m_pDataList;
@property (strong, nonatomic) NSMutableArray *m_pDataCorList;
//云端数据
@property (strong, nonatomic) NSMutableArray *m_pDataCloudList;
@property (strong, nonatomic) NSMutableArray *m_pDataCloudCorList;

//@property (strong, nonatomic) UILabel *m_pAppNameLabel;

@property (strong, nonatomic) UIButton *m_pRightOpsBTN;
@property (strong, nonatomic) UIButton *m_pLeftOpsBTN;

@property (strong, nonatomic) SDRefreshFooterView *m_pRefreshFooter;
@property (strong, nonatomic) SqliteManage *m_pSqlmanager;
- (AppDelegate *) RootAppDelegate;
-(void) initView;

@end

