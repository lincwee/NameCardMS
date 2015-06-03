//
//  CardSearchBar.h
//  NameCardMS
//
//  Created by 郝 林巍 on 15/5/24.
//  Copyright (c) 2015年 lincwee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SqliteManage.h"

@interface CardSearchBar : UIView<UISearchDisplayDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>
{
    NSMutableArray * suggestItems;
    NSMutableArray * resultItems;
}

@property (nonatomic) UIButton *cancelButton;
@property (nonatomic) UIImageView *searchImageView;
@property (nonatomic) UIView *backgroundView;

@property (nonatomic) UIImage *searchImage;
@property (nonatomic) UITextField *textField;
@property (nonatomic ,strong) UISearchDisplayController * searchDisplayController_;
@property (nonatomic, strong) NSMutableArray *suggestItems;
@property (nonatomic, strong) NSMutableArray *resultItems;
@property (nonatomic, strong) NSMutableArray *originIndex;
@property (nonatomic, strong) UISearchBar * searchBar_;
@property (nonatomic, strong) SqliteManage *m_pSqlmanager;
@property (nonatomic, strong) NSString *m_pInputText;
@property (nonatomic, strong) NSDictionary *m_pJsonDic;
-(void) setDataSource:(NSArray *)data;
-(void) initUISearchView:(UIViewController *)ViewController;
@end
