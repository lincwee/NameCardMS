//
//  DetailInfoViewConteroller.h
//  NameCardMS
//
//  Created by 郝 林巍 on 15/5/3.
//  Copyright (c) 2015年 lincwee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SqliteManage.h"

@interface DetailInfoViewConteroller : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIAlertViewDelegate>
{
    @public
    int m_state;
}
@property (nonatomic, strong) UIButton *m_pSavaButton;
@property (nonatomic, strong) UIScrollView *m_pScrollView;

//textfield -> personal information
@property (nonatomic, retain) UITextField *m_pNameField;    //名字
@property (nonatomic, strong) UITextField *m_pMobileField;     //电话
@property (nonatomic, strong) UITextField *m_pPositionField;    //职位
@property (nonatomic, strong) UITextField *m_pPerTelField;    //电话号码
@property (nonatomic, strong) UITextField *m_pPerEmailField;    //电子邮箱
@property (nonatomic, strong) UITextView *m_pPerIntroduceTextView;    //个人简介，可以default，非必须填写

//textfield -> corporation information 除了公司名称，其他的都可以default
@property (nonatomic, strong) UITextField *m_pCorNameField;     //公司名称
@property (nonatomic, strong) UITextField *m_pCorAddressField;  //公司地址
@property (nonatomic, strong) UITextField *m_pCorTelField;      //公司官方电话
@property (nonatomic, strong) UITextField *m_pCorFaxField;      //公司传真号码
@property (nonatomic, strong) UITextView *m_pCorIntroduceTextView;     //公司简介
@property (nonatomic, strong) SqliteManage *m_pSqlManager;
@property (nonatomic) int m_state;
@property (nonatomic, strong) PerClass *m_pPerson;
@property (nonatomic, strong) CorClass *m_pCor;

@property (nonatomic, strong) NSData *m_pCardImage;

@property (nonatomic, strong) UIButton *m_pTelPhoneButton;
@property (nonatomic, strong) UIButton *m_pMobilePhoneButton;
@property (nonatomic, strong) UIButton *m_pMobileMsgButton;
@property (nonatomic, strong) UIButton *m_pMailButton;
@property (nonatomic, strong) UIButton *m_pMapsButton;
@property (nonatomic, strong) UIButton *m_pAddressBookButton;
@property (nonatomic, strong) UILabel *m_pTitleLabel;

-(void) setPersonalName:(NSString *)name Position:(NSString *)position Mobile:(NSString *)mobile TEL:(NSString *)tel Email:(NSString *)email CorpName:(NSString *)corname Andress:(NSString *)address FAX:(NSString *)fax;

-(void) setCardImageData:(NSData *)image;

typedef NS_ENUM(int, DetailInfoViewState)
{
    DETAIL_INFO_VIEW_STATE_EDIT = 0,
    DETAIL_INFO_VIEW_STATE_SAVE,
    DETAIL_INFO_VIEW_STATE_UPDATE,
    DETAIL_INFO_VIEW_STATE_SAVE_SELF,
};

-(void) setViewState:(DetailInfoViewState )state;
-(void) setPersonDate:(PerClass *)person AndCordate:(CorClass *)cor;

@end
