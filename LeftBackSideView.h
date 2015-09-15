//
//  LeftBackSideView.h
//  NameCardMS
//
//  Created by 郝 林巍 on 15/4/19.
//  Copyright (c) 2015年 lincwee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SqliteManage.h"

@interface LeftBackSideView : UIViewController<UIAlertViewDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) UITableView *m_pTableView;
@property (strong, nonatomic) UIView *m_pTopView;
@property (strong, nonatomic) UIView *m_pAlphaView;
@property (strong, nonatomic) UIActivityIndicatorView * m_pActivityView;
@property (strong, nonatomic) UILabel *m_pOnRecognitionLable;
@property (strong, nonatomic) NSDictionary *jsonData;
@property (strong, nonatomic) SqliteManage *m_pSqlmanager;

@property (strong, nonatomic) NSData *m_pCardImage;

-(void) setName:(NSString *)name :(NSInteger)age;
@end
