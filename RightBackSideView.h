//
//  RightBackSideView.h
//  NameCardMS
//
//  Created by 郝 林巍 on 15/4/19.
//  Copyright (c) 2015年 lincwee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RightBackSideView : UIViewController<UIAlertViewDelegate>

@property (strong, nonatomic) UIView *m_pUserView;
@property (strong, nonatomic) UILabel *m_pNameLabel;
@property (strong, nonatomic) UILabel *m_pPositionLabel;
@property (strong, nonatomic) UILabel *m_pAccountLabel;
@property (strong, nonatomic) UILabel *m_pCorAddressLabel;
@property (strong, nonatomic) NSUserDefaults *m_pUserDefaults;
@property (strong, nonatomic) UIButton *m_pLoginButton;
@end
