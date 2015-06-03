//
//  DetailInfoViewConteroller.m
//  NameCardMS
//
//  Created by 郝 林巍 on 15/5/3.
//  Copyright (c) 2015年 lincwee. All rights reserved.
//

#import "DetailInfoViewConteroller.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "MacroFile.h"
#import <QuartzCore/QuartzCore.h>
#import <sqlite3.h>
#import "PerClass.h"
#import "CorClass.h"
#import "MacroFile.h"
#import "SJABHelper.h"


@implementation DetailInfoViewConteroller

@synthesize
m_pSavaButton,
m_pScrollView,
//person
m_pNameField,
m_pMobileField,
m_pPositionField,
m_pPerTelField,
m_pPerEmailField,
m_pPerIntroduceTextView,
//Cor
m_pCorNameField,
m_pCorAddressField,
m_pCorTelField,
m_pCorFaxField,
m_pCorIntroduceTextView,
m_pSqlManager,
m_pPerson,
m_pCor,
m_pCardImage,
m_pTelPhoneButton,
m_pMobileMsgButton,
m_pMobilePhoneButton,
m_pMailButton,
m_pMapsButton,
m_pAddressBookButton,
m_pTitleLabel;


- (void)viewDidLoad
{
   [super viewDidLoad];
   
   //self.view.backgroundColor = [UIColor whiteColor];
   [self initView];
   [self initButton];
   [self initDelegate];
   m_pSqlManager = [[SqliteManage alloc]init];
   [m_pSqlManager loadData];
   [self setViewState:m_state];
   
   UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
   //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
   tapGestureRecognizer.cancelsTouchesInView = NO;
   //将触摸事件添加到当前view
   [self.view addGestureRecognizer:tapGestureRecognizer];
   
   UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"back1" style:UIBarButtonItemStylePlain target:nil action:nil];
   self.navigationItem.backBarButtonItem = backItem;
   
//   m_pTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.navigationController.view.center.x, 30.f, 120.f, OPS_BUTTON_TEXT_HEIGHT)];
//   m_pTitleLabel.text = @"123123123";
//   m_pTitleLabel.center = CGPointMake(self.navigationController.view.bounds.size.width / 2, 45.f);
//   m_pTitleLabel.textAlignment = UITextAlignmentCenter;
//   m_pTitleLabel.adjustsFontSizeToFitWidth = YES;
//   m_pTitleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
//   [self.navigationController.view addSubview:self.m_pTitleLabel];
   //self.view.backgroundColor = MOON_WHITE;
}

-(void)viewDidDisappear:(BOOL)animated
{
   //((AppDelegate *)([UIApplication sharedApplication].delegate)).m_pAppNameLabel.hidden = YES;
   m_pSavaButton.hidden = YES;
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
   [m_pNameField  resignFirstResponder];
   [m_pPositionField resignFirstResponder];
   [m_pPerTelField resignFirstResponder];
   [m_pPerEmailField resignFirstResponder];
   [m_pMobileField resignFirstResponder];
   [m_pPerIntroduceTextView resignFirstResponder];
   
   [m_pCorNameField resignFirstResponder];
   [m_pCorAddressField resignFirstResponder];
   [m_pCorFaxField resignFirstResponder];
   [m_pCorTelField resignFirstResponder];
   [m_pCorIntroduceTextView resignFirstResponder];
}

-(void) initView
{
   //self.view.backgroundColor = MOON_WHITE;
   //sava button
   m_pSavaButton = [[UIButton alloc]initWithFrame:CGRectMake(205.f, 20.f, 140.f, 45.f)];
   //[m_pSavaButton setTitle:@"保存" forState:UIControlStateNormal];
   [m_pSavaButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
   
   [m_pSavaButton addTarget:self action:@selector(buttonFunction) forControlEvents:UIControlEventTouchUpInside];
   [self.navigationController.view addSubview:m_pSavaButton];
   //self.navigationItem.hidesBackButton = YES;
   
   //scrollview
   m_pScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.f, 65.f, kScrollViewWidth, kScrollViewHeigh)];
   //m_pScrollView.backgroundColor = [UIColor redColor];
   m_pScrollView.delegate = self;
   m_pScrollView.contentSize = CGSizeMake(kScrollViewWidth, kScrollViewContentSizeHeigh);
   [self.view addSubview:m_pScrollView];
   
//   UILabel *PerTextlabel = [[UILabel alloc]initWithFrame:CGRectMake(0.f, -60.f, kScrollViewWidth, 40.f)];
//   PerTextlabel.textAlignment = NSTextAlignmentRight;
//   PerTextlabel.text = @"----------------------------个人信息";
//   [m_pScrollView addSubview:PerTextlabel];
   
   UILabel *namelabel = [[UILabel alloc]initWithFrame:CGRectMake(10.f, SCROLL_VIEW_PERSON_START_HEIGHT, 80.f, 40.f)];
   namelabel.text = @"姓名";
   namelabel.textAlignment = NSTextAlignmentLeft;
   namelabel.textColor = DEEP_SKY_BLUE;
   [m_pScrollView addSubview:namelabel];
   m_pNameField = [self creatTextFieldCGRect:CGRectMake(20.f, SCROLL_VIEW_PERSON_START_HEIGHT + 30.f, 180.f, 35.f)];
   
   
   
   UILabel *posLabel = [[UILabel alloc]initWithFrame:CGRectMake(10.f, SCROLL_VIEW_PERSON_START_HEIGHT + SCROLL_VIEW_TEXT_HEIGHT_OFFSET, 80.f, 40.f)];
   posLabel.text = @"职位";
   posLabel.textAlignment = NSTextAlignmentLeft;
   posLabel.textColor = DEEP_SKY_BLUE;
   [m_pScrollView addSubview:posLabel];
   m_pPositionField = [self creatTextFieldCGRect:CGRectMake(20.f, SCROLL_VIEW_PERSON_START_HEIGHT + 30.f + SCROLL_VIEW_TEXT_HEIGHT_OFFSET , 180.f, 35.f)];
   
   UILabel *mobileLabel = [[UILabel alloc]initWithFrame:CGRectMake(10.f, SCROLL_VIEW_PERSON_START_HEIGHT +  SCROLL_VIEW_TEXT_HEIGHT_OFFSET * 2, 80.f, 40.f)];
   mobileLabel.text = @"手机号";
   mobileLabel.textAlignment = NSTextAlignmentLeft;
   mobileLabel.textColor = DEEP_SKY_BLUE;
   [m_pScrollView addSubview:mobileLabel];
   m_pMobileField = [self creatTextFieldCGRect:CGRectMake(20.f, SCROLL_VIEW_PERSON_START_HEIGHT + 30.f + SCROLL_VIEW_TEXT_HEIGHT_OFFSET * 2, 180.f, 35.f)];
   
   UILabel *telLabel = [[UILabel alloc]initWithFrame:CGRectMake(10.f, SCROLL_VIEW_PERSON_START_HEIGHT + SCROLL_VIEW_TEXT_HEIGHT_OFFSET * 3, 80.f, 40.f)];
   telLabel.text = @"电话号码";
   telLabel.textAlignment = NSTextAlignmentLeft;
   telLabel.textColor = DEEP_SKY_BLUE;
   [m_pScrollView addSubview:telLabel];
   m_pPerTelField = [self creatTextFieldCGRect:CGRectMake(20.f, SCROLL_VIEW_PERSON_START_HEIGHT + 30.f + SCROLL_VIEW_TEXT_HEIGHT_OFFSET * 3, 180.f, 35.f)];
   
   UILabel *emailLabel = [[UILabel alloc]initWithFrame:CGRectMake(10.f, SCROLL_VIEW_PERSON_START_HEIGHT + SCROLL_VIEW_TEXT_HEIGHT_OFFSET * 4, 80.f, 40.f)];
   emailLabel.text = @"电子邮件";
   emailLabel.textAlignment = NSTextAlignmentLeft;
   emailLabel.textColor = DEEP_SKY_BLUE;
   [m_pScrollView addSubview:emailLabel];
   m_pPerEmailField = [self creatTextFieldCGRect:CGRectMake(20.f, SCROLL_VIEW_PERSON_START_HEIGHT + 30.f + SCROLL_VIEW_TEXT_HEIGHT_OFFSET * 4, 180.f, 35.f)];
   
   UILabel *introduceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10.f, SCROLL_VIEW_PERSON_START_HEIGHT + SCROLL_VIEW_TEXT_HEIGHT_OFFSET * 5, 80.f, 40.f)];
   introduceLabel.text = @"个人简介";
   introduceLabel.textAlignment = NSTextAlignmentLeft;
   introduceLabel.textColor = DEEP_SKY_BLUE;
   [m_pScrollView addSubview:introduceLabel];
   m_pPerIntroduceTextView = [[UITextView alloc]initWithFrame:CGRectMake(20.f, SCROLL_VIEW_PERSON_START_HEIGHT + 30.f + SCROLL_VIEW_TEXT_HEIGHT_OFFSET * 5, 260.f, 100.f)];
   m_pPerIntroduceTextView.delegate = self;
   m_pPerIntroduceTextView.backgroundColor = [UIColor clearColor];
   [m_pScrollView addSubview:m_pPerIntroduceTextView];
//   m_pPerIntroduceTextView.layer.borderColor = [UIColor grayColor].CGColor;
//   m_pPerIntroduceTextView.layer.borderWidth =1.f;
//   m_pPerIntroduceTextView.layer.cornerRadius =5.f;
   m_pPerIntroduceTextView.editable = NO;
   
//   UILabel *CorTextlabel = [[UILabel alloc]initWithFrame:CGRectMake(0.f, SCROLL_VIEW_COR_START_HEIGHT + 10.f, kScrollViewWidth, 40.f)];
//   CorTextlabel.textAlignment = NSTextAlignmentLeft;
//   CorTextlabel.text = @"公司信息----------------------------";
//   [m_pScrollView addSubview:CorTextlabel];
   
   UILabel *corNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10.f, SCROLL_VIEW_COR_START_HEIGHT + SCROLL_VIEW_TEXT_HEIGHT_OFFSET, 80.f, 40.f)];
   corNameLabel.text = @"公司名称";
   corNameLabel.textAlignment = NSTextAlignmentLeft;
   corNameLabel.textColor = DEEP_SKY_BLUE;
   [m_pScrollView addSubview:corNameLabel];
   m_pCorNameField = [self creatTextFieldCGRect:CGRectMake(20.f, SCROLL_VIEW_COR_START_HEIGHT + 30.f + SCROLL_VIEW_TEXT_HEIGHT_OFFSET, 260.f, 35.f)];
   
   UILabel *corAddressLabel = [[UILabel alloc]initWithFrame:CGRectMake(10.f, SCROLL_VIEW_COR_START_HEIGHT + SCROLL_VIEW_TEXT_HEIGHT_OFFSET * 2, 80.f, 40.f)];
   corAddressLabel.text = @"公司地址";
   corAddressLabel.textAlignment = NSTextAlignmentLeft;
   corAddressLabel.textColor = DEEP_SKY_BLUE;
   [m_pScrollView addSubview:corAddressLabel];
   m_pCorAddressField = [self creatTextFieldCGRect:CGRectMake(20.f, SCROLL_VIEW_COR_START_HEIGHT + 30.f + SCROLL_VIEW_TEXT_HEIGHT_OFFSET * 2, 260.f, 35.f)];
   
   UILabel *corTelLabel = [[UILabel alloc]initWithFrame:CGRectMake(10.f, SCROLL_VIEW_COR_START_HEIGHT + SCROLL_VIEW_TEXT_HEIGHT_OFFSET * 3, 80.f, 40.f)];
   corTelLabel.text = @"公司电话";
   corTelLabel.textAlignment = NSTextAlignmentLeft;
   corTelLabel.textColor = DEEP_SKY_BLUE;
   [m_pScrollView addSubview:corTelLabel];
   m_pCorTelField = [self creatTextFieldCGRect:CGRectMake(20.f, SCROLL_VIEW_COR_START_HEIGHT + 30.f + SCROLL_VIEW_TEXT_HEIGHT_OFFSET * 3, 180.f, 35.f)];
   
   UILabel *corFaxLabel = [[UILabel alloc]initWithFrame:CGRectMake(10.f, SCROLL_VIEW_COR_START_HEIGHT + SCROLL_VIEW_TEXT_HEIGHT_OFFSET * 4, 80.f, 40.f)];
   corFaxLabel.text = @"公司传真";
   corFaxLabel.textAlignment = NSTextAlignmentLeft;
   corFaxLabel.textColor = DEEP_SKY_BLUE;
   [m_pScrollView addSubview:corFaxLabel];
   m_pCorFaxField = [self creatTextFieldCGRect:CGRectMake(20.f, SCROLL_VIEW_COR_START_HEIGHT + 30.f + SCROLL_VIEW_TEXT_HEIGHT_OFFSET * 4, 180.f, 35.f)];
   
   UILabel *corIntroduceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10.f, SCROLL_VIEW_COR_START_HEIGHT + SCROLL_VIEW_TEXT_HEIGHT_OFFSET * 5, 80.f, 40.f)];
   corIntroduceLabel.text = @"公司简介";
   corIntroduceLabel.textAlignment = NSTextAlignmentLeft;
   corIntroduceLabel.textColor = DEEP_SKY_BLUE;
   [m_pScrollView addSubview:corIntroduceLabel];
   m_pCorIntroduceTextView = [[UITextView alloc]initWithFrame:CGRectMake(20.f, SCROLL_VIEW_COR_START_HEIGHT + 30.f + SCROLL_VIEW_TEXT_HEIGHT_OFFSET * 5, 260.f, 100.f)];
   m_pCorIntroduceTextView.delegate = self;
   [m_pScrollView addSubview:m_pCorIntroduceTextView];
   m_pCorIntroduceTextView.backgroundColor = [UIColor clearColor];
//   m_pCorIntroduceTextView.layer.borderColor = [UIColor grayColor].CGColor;
//   m_pCorIntroduceTextView.layer.borderWidth =1.f;
//   m_pCorIntroduceTextView.layer.cornerRadius =5.f;
   
   //   UIImageView *imageView = [[UIImageView alloc]initWithImage:m_pCardImage];
   //   imageView.frame = CGRectMake(110.f, SCROLL_VIEW_COR_START_HEIGHT + SCROLL_VIEW_TEXT_HEIGHT_OFFSET * 7, 180.f, 160.f);
   //   [m_pScrollView addSubview:imageView];
   
   m_pNameField.placeholder = @"添加姓名";
   m_pPositionField.placeholder = @"添加职位信息";
   m_pMobileField.placeholder = @"添加手机号";
   m_pPerTelField.placeholder = @"添加座机号";
   m_pPerEmailField.placeholder = @"添加电子邮箱";
   
   m_pCorNameField.placeholder = @"添加公司姓名";
   m_pCorAddressField.placeholder = @"添加公司地址";
   m_pCorTelField.placeholder = @"添加公司电话";
   m_pCorFaxField.placeholder = @"添加传真号";
}

-(void) initButton
{
   m_pMobilePhoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
   m_pMobilePhoneButton.frame = CGRectMake(275.f, SCROLL_VIEW_PERSON_START_HEIGHT + 25.f + SCROLL_VIEW_TEXT_HEIGHT_OFFSET * 2, 40.f, 40.f);
   [m_pMobilePhoneButton setImage:[UIImage imageNamed:@"mobile.png"] forState:UIControlStateNormal];
   [m_pMobilePhoneButton addTarget:self action:@selector(callMobilePhone) forControlEvents:UIControlEventTouchUpInside];
   [m_pScrollView addSubview:m_pMobilePhoneButton];
   
   
   m_pMobileMsgButton = [UIButton buttonWithType:UIButtonTypeCustom];
   m_pMobileMsgButton.frame = CGRectMake(230.f, SCROLL_VIEW_PERSON_START_HEIGHT + 25.f + SCROLL_VIEW_TEXT_HEIGHT_OFFSET * 2, 40.f, 40.f);
   [m_pMobileMsgButton setImage:[UIImage imageNamed:@"message.png"] forState:UIControlStateNormal];
   [m_pMobileMsgButton addTarget:self action:@selector(callMessage) forControlEvents:UIControlEventTouchUpInside];
   [m_pScrollView addSubview:m_pMobileMsgButton];
   
   
   m_pTelPhoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
   m_pTelPhoneButton.frame = CGRectMake(275.f, SCROLL_VIEW_PERSON_START_HEIGHT + 25.f + SCROLL_VIEW_TEXT_HEIGHT_OFFSET * 3, 40.f, 40.f);
   [m_pTelPhoneButton setImage:[UIImage imageNamed:@"mobile.png"] forState:UIControlStateNormal];
   [m_pTelPhoneButton addTarget:self action:@selector(callTelPhone) forControlEvents:UIControlEventTouchUpInside];
   [m_pScrollView addSubview:m_pTelPhoneButton];
   
   
   m_pMailButton = [UIButton buttonWithType:UIButtonTypeCustom];
   m_pMailButton.frame = CGRectMake(275.f, SCROLL_VIEW_PERSON_START_HEIGHT + 25.f + SCROLL_VIEW_TEXT_HEIGHT_OFFSET * 4, 40.f, 40.f);
   [m_pMailButton setImage:[UIImage imageNamed:@"mail.png"] forState:UIControlStateNormal];
   [m_pMailButton addTarget:self action:@selector(callMail) forControlEvents:UIControlEventTouchUpInside];
   [m_pScrollView addSubview:m_pMailButton];
   
   
   m_pMailButton = [UIButton buttonWithType:UIButtonTypeCustom];
   m_pMailButton.frame = CGRectMake(275.f, SCROLL_VIEW_COR_START_HEIGHT + 25.f + SCROLL_VIEW_TEXT_HEIGHT_OFFSET * 2, 40.f, 40.f);
   [m_pMailButton setImage:[UIImage imageNamed:@"map.png"] forState:UIControlStateNormal];
   [m_pMailButton addTarget:self action:@selector(callMaps) forControlEvents:UIControlEventTouchUpInside];
   [m_pScrollView addSubview:m_pMailButton];
   
   m_pAddressBookButton = [[UIButton alloc]initWithFrame:CGRectMake(200.f, SCROLL_VIEW_PERSON_START_HEIGHT, 120.f, 40.f)];
   UIImage *image = [UIImage imageNamed:@"contacts.png"];
   UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
   imageView.frame = CGRectMake(0.f, 0.f, 40.f, 40.f);
   [m_pAddressBookButton addSubview:imageView];
   [m_pAddressBookButton addTarget:self action:@selector(addressBookOps) forControlEvents:UIControlEventTouchUpInside];
   UILabel *addbLabel = [[UILabel alloc]initWithFrame:CGRectMake(40.f, 0.f, 80, 40.f)];
   addbLabel.text = @"添加通讯录";
   addbLabel.adjustsFontSizeToFitWidth = YES;
   addbLabel.textColor = [UIColor grayColor];
   [m_pAddressBookButton addSubview:addbLabel];
   [m_pScrollView addSubview:m_pAddressBookButton];
   
}

-(void) callMobilePhone
{
   NSString *useNum = [@"tel://" stringByAppendingString:m_pMobileField.text];
   NSString *finalPhoneNumber = [useNum stringByReplacingOccurrencesOfString:@" " withString:@""];
   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:finalPhoneNumber]];
}

-(void) callTelPhone
{
   NSString *useNum = [@"tel://" stringByAppendingString:m_pPerTelField.text];
   NSString *finalPhoneNumber = [useNum stringByReplacingOccurrencesOfString:@" " withString:@""];
   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:finalPhoneNumber]];
}

-(void) callMessage
{
   NSString *useNum = [@"sms://" stringByAppendingString:m_pMobileField.text];
   NSString *finalPhoneNumber = [useNum stringByReplacingOccurrencesOfString:@" " withString:@""];
   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:finalPhoneNumber]];
}

-(void) callMail
{
   NSString *useNum = [@"mailto://" stringByAppendingString:m_pPerEmailField.text];
   NSString *finalPhoneNumber = [useNum stringByReplacingOccurrencesOfString:@" " withString:@""];
   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:finalPhoneNumber]];
}

-(void) callMaps
{
   NSString *strHospitalAddress = m_pCorAddressField.text;
   NSString *finalMapUrl = [strHospitalAddress stringByReplacingOccurrencesOfString:@" " withString:@""];
   NSString *strHospitalMap = @"http://maps.apple.com/?q=";
   NSURL *searchMap = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", strHospitalMap,
                                            [finalMapUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
   [[UIApplication sharedApplication] openURL:searchMap];
}

-(void)addressBookOps
{
   NSString *finalName = [m_pNameField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
   NSString *finalMobile = [m_pMobileField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
   NSString *finalIntruduce = [m_pPerIntroduceTextView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
   NSString *finalEmail = [m_pPerEmailField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
   NSString *finalAddress = [m_pCorAddressField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
   if([SJABHelper existPhone:finalMobile] == ABHelperNotExistSpecificContact)
   {
      [SJABHelper addContactName:finalName phoneNum:finalMobile Label:@"手机" Email:finalEmail Address:finalAddress];
   }
}

-(void) functionButtonShowOrNot
{
   m_pMobilePhoneButton.hidden = (m_pMobileField.text.length == 0?YES:NO);
   m_pMobileMsgButton.hidden = m_pMobileField.text.length == 0?YES:NO;
   m_pTelPhoneButton.hidden = m_pPerTelField.text.length == 0?YES:NO;
   m_pMailButton.hidden = m_pPerEmailField.text.length == 0?YES:NO;
   m_pMapsButton.hidden = m_pCorAddressField.text.length == 0?YES:NO;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
   
   [textField resignFirstResponder];
   return YES;
}

-(void) initDelegate
{
   m_pNameField.delegate = self;
   m_pMobileField.delegate = self;
   m_pPositionField.delegate = self;
   m_pPerTelField.delegate = self;
   m_pPerEmailField.delegate = self;
   m_pPerIntroduceTextView.delegate = self;
   
   m_pCorNameField.delegate = self;
   m_pCorAddressField.delegate = self;
   m_pCorTelField.delegate = self;
   m_pCorFaxField.delegate = self;
   m_pCorIntroduceTextView.delegate = self;
}

-(void)animateTextField:(UITextField *)textField up:(BOOL)up
{
   const int movementDistance = 100;
   const float movementDuration = 0.3f;
   NSLog(@"%f", textField.frame.origin.y);
   if (textField.frame.origin.y > 250.f) {
      int movement = (up?-movementDistance:movementDistance);
      [UIScrollView beginAnimations:@"anim" context:nil];
      [UIScrollView setAnimationBeginsFromCurrentState:YES];
      [UIScrollView setAnimationDuration:movementDuration];
      self.view.frame = CGRectOffset(self.view.frame, 0, movement);
      [UIScrollView commitAnimations];
   }
   else
   {
      
   }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
   [self animateTextField:textView up:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
   [self animateTextField:textView up:NO];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
   [self animateTextField:textField up:YES];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
   [self animateTextField:textField up:NO];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
   if (range.length > 10) {
      return NO;
   }
   return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
   [m_pNameField  resignFirstResponder];
   [m_pPositionField resignFirstResponder];
   [m_pPerTelField resignFirstResponder];
   [m_pPerEmailField resignFirstResponder];
   [m_pMobileField resignFirstResponder];
   [m_pPerIntroduceTextView resignFirstResponder];
   
   [m_pCorNameField resignFirstResponder];
   [m_pCorAddressField resignFirstResponder];
   [m_pCorFaxField resignFirstResponder];
   [m_pCorTelField resignFirstResponder];
   [m_pCorIntroduceTextView resignFirstResponder];
}

-(UITextField *) creatTextFieldCGRect:(CGRect)rect
{
   UITextField *temp = [[UITextField alloc]initWithFrame:rect];
   [m_pScrollView addSubview:temp];
   //   temp.borderStyle = UITextBorderStyleRoundedRect;
   //   temp.layer.borderColor = [UIColor grayColor].CGColor;
   //   temp.layer.borderWidth =1.0;
   //   temp.layer.cornerRadius =5.0;
   temp.backgroundColor = [UIColor clearColor];
   return temp;
}
-(void) initData
{
   
}

- (void) viewDidAppear:(BOOL)animated
{
   [super viewDidAppear:animated];
   ((AppDelegate *)([UIApplication sharedApplication].delegate)).m_pRightOpsBTN.hidden = YES;
   ((AppDelegate *)([UIApplication sharedApplication].delegate)).m_pLeftOpsBTN.hidden = YES;
   //[self.navigationController setNavigationBarHidden:YES animated:NO];
}


-(void) setPersonalName:(NSString *)name Position:(NSString *)position Mobile:(NSString *)mobile TEL:(NSString *)tel Email:(NSString *)email CorpName:(NSString *)corname Andress:(NSString *)address FAX:(NSString *)fax
{
   m_pNameField.text = name;
   m_pPositionField.text = position;
   m_pMobileField.text = mobile;
   m_pPerTelField.text = tel;
   m_pPerEmailField.text = email;
   m_pCorNameField.text = corname;
   m_pCorAddressField.text = address;
   m_pCorFaxField.text = fax;
   
   [self functionButtonShowOrNot];

}

-(void) setCardImageData:(NSData *)image
{
   
   UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(115.f, 0.f, 220.f, 120.f)];
   label.text = @"无照片";
   label.textColor = [UIColor blackColor];
   label.adjustsFontSizeToFitWidth = YES;
   label.font = [UIFont systemFontOfSize:35];
   [self.m_pScrollView addSubview:label];
   
//   UILabel *corTelLabel = [[UILabel alloc]initWithFrame:CGRectMake(10.f, SCROLL_VIEW_COR_START_HEIGHT + SCROLL_VIEW_TEXT_HEIGHT_OFFSET * 3, 80.f, 40.f)];
//   corTelLabel.text = @"无照片";
//   corTelLabel.textAlignment = NSTextAlignmentLeft;
//   corTelLabel.textColor = [UIColor];
//   [m_pScrollView addSubview:corTelLabel];
   if (image) {
      label.hidden = YES;
      m_pCardImage = image;
      UIImage *image1 = [UIImage imageWithData:m_pCardImage];
      CGAffineTransform rotation = CGAffineTransformMakeRotation( -M_PI / 2);
      UIImageView *imageView = [[UIImageView alloc]initWithImage:image1];
      imageView.frame = CGRectMake(40.f, -105.f, 240.f, 320.f);
      //NSLog(@"-------width is:%f  %f------", image1.size.width / 10.f, image1.size.height / 10.f);
      [imageView setTransform:rotation];
      [m_pScrollView addSubview:imageView];
   }
}
-(void) buttonFunction
{
   if (m_state == DETAIL_INFO_VIEW_STATE_EDIT) {
      [self setViewState:DETAIL_INFO_VIEW_STATE_UPDATE];
      UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"现在可以点击文本编辑已有项目或添加信息至通讯录" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil , nil];
      [alert show];
      return;
   }
   if (m_state == DETAIL_INFO_VIEW_STATE_UPDATE) {
      UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"更新" message:@"是否更新信息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
      [alert show];
      return;
   }
   if (m_state == DETAIL_INFO_VIEW_STATE_SAVE) {
      UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"保存" message:@"是否保存信息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存", nil];
      [alert show];
      return;
   }
   if (m_state == DETAIL_INFO_VIEW_STATE_SAVE_SELF) {
      UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"保存" message:@"是否保存个人信息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存", nil];
      [alert show];
      return;
   }
}

-(void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
   if (1 == buttonIndex) {
      [self saveOrUpdate];
   }
   else if(0 == buttonIndex)
   {
      if (m_state != DETAIL_INFO_VIEW_STATE_UPDATE) {
         [self setViewState:DETAIL_INFO_VIEW_STATE_EDIT];
      }
      return;
   }
}
-(void)saveOrUpdate{
   PerClass *perData = [[PerClass alloc]init];
   perData->perName = m_pNameField.text;
   perData->perMobile = m_pMobileField.text;
   perData->perPosition = m_pPositionField.text;
   perData->perTel = m_pPerTelField.text;
   perData->perEmail = m_pPerEmailField.text;
   perData->perIntroduce = m_pPerIntroduceTextView.text;
   
   CorClass *corDate = [[CorClass alloc]init];
   corDate->corName = m_pCorNameField.text;
   corDate->corAddress = m_pCorAddressField.text;
   corDate->corFax = m_pCorFaxField.text;
   corDate->corTel = m_pCorTelField.text;
   corDate->corInteroduce = m_pCorIntroduceTextView.text;
   
   NSArray*paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
   NSString *documentsDirectory=[paths objectAtIndex:0];
   
   
   if (m_state == DETAIL_INFO_VIEW_STATE_SAVE) {
      
      NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
      [formatter setDateFormat:@"yyyyMMddHHmmss"];
      NSString *currentTime = [formatter stringFromDate:[NSDate date]];
      perData->PID = currentTime;
      corDate->CID = currentTime;
      if (m_pCardImage) {
         NSString *savedImagePath=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",perData->PID]];
         [m_pCardImage writeToFile:savedImagePath atomically:YES];
      }
      
      if (m_pNameField.text.length == 0) {
         NSLog(@"data wrong");
         return;
      }
      else {
         if ([m_pSqlManager insertDataToPersonTable:perData]) {
            NSLog(@"add person data successful!");
         }
         if([m_pSqlManager insertDataToCorTable:corDate]) {
            NSLog(@"add cor data successful!");
         }
      }
      [[self navigationController] popViewControllerAnimated:YES];
      return;
   }
   
   if (m_state == DETAIL_INFO_VIEW_STATE_SAVE_SELF) {
      NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
      [userDefaults setObject:m_pNameField.text forKey:PER_NAME];
      [userDefaults setObject:m_pMobileField.text forKey:PER_MOBILE];
      [userDefaults setObject:m_pPositionField.text forKey:PER_POSITION];
      [userDefaults setObject:m_pPerTelField.text forKey:PER_TEL];
      [userDefaults setObject:m_pPerEmailField.text forKey:PER_EMAIL];
      [userDefaults setObject:m_pPerIntroduceTextView.text forKey:PER_INTRODUCE];
      
      [userDefaults setObject:m_pCorNameField.text forKey:COR_NAME];
      [userDefaults setObject:m_pCorAddressField.text forKey:COR_ADDRESS];
      [userDefaults setObject:m_pCorTelField.text forKey:COR_TEL];
      [userDefaults setObject:m_pCorFaxField.text forKey:COR_FAX];
      [userDefaults setObject:m_pCorIntroduceTextView.text forKey:COR_INTRODUCE];
      [[self navigationController] popViewControllerAnimated:YES];
      return;
   }
   
   if (m_state == DETAIL_INFO_VIEW_STATE_EDIT) {
      //add something
      //可以无操作
      //m_state = DETAIL_INFO_VIEW_STATE_UPDATE;
      return;
   }
   if (m_state == DETAIL_INFO_VIEW_STATE_UPDATE) {
      //[self setViewState:DETAIL_INFO_VIEW_STATE_UPDATE];
      [self getDataFromTextField:m_pPerson AndCor:m_pCor];
      if ([m_pSqlManager updateDateToPersonTable:m_pPerson]) {
         NSLog(@"update person data successful!");
      }
      if([m_pSqlManager updateDateToCorTable:m_pCor]){
         NSLog(@"update cor data successful!");
      }
      [[self navigationController] popViewControllerAnimated:YES];
      return;
   }
   
}

-(void) setViewState:(DetailInfoViewState )state
{
   if (state == DETAIL_INFO_VIEW_STATE_EDIT) {
      [m_pSavaButton setTitle:DETAIL_BUTTON_TEXT_EDIT forState:UIControlStateNormal];
      [self textFieldisEdit:NO];
      m_pAddressBookButton.hidden = YES;
      m_state = DETAIL_INFO_VIEW_STATE_EDIT;
   }
   if (state == DETAIL_INFO_VIEW_STATE_UPDATE) {
      [m_pSavaButton setTitle:DETAIL_BUTTON_TEXT_UPDATE forState:UIControlStateNormal];
      [self textFieldisEdit:YES];
      m_pAddressBookButton.hidden = NO;
      m_state = DETAIL_INFO_VIEW_STATE_UPDATE;
   }
   if (state == DETAIL_INFO_VIEW_STATE_SAVE) {
      [m_pSavaButton setTitle:DETAIL_BUTTON_TEXT_SAVE forState:UIControlStateNormal];
      [self textFieldisEdit:YES];
      m_pAddressBookButton.hidden = NO;
      m_state = DETAIL_INFO_VIEW_STATE_SAVE;
   }
   if (state == DETAIL_INFO_VIEW_STATE_SAVE_SELF) {
      [m_pSavaButton setTitle:DETAIL_BUTTON_TEXT_SELF forState:UIControlStateNormal];
      m_pAddressBookButton.hidden = YES;
      [self textFieldisEdit:YES];
      //状态并不改变
      m_state = DETAIL_INFO_VIEW_STATE_SAVE_SELF;
   }
}

-(void) textFieldisEdit:(BOOL) isEdit
{
   m_pNameField.enabled = isEdit;
   m_pMobileField.enabled = isEdit;
   m_pPositionField.enabled = isEdit;
   m_pPerTelField.enabled = isEdit;
   m_pPerEmailField.enabled = isEdit;
   m_pPerIntroduceTextView.editable = isEdit;
   
   m_pCorNameField.enabled = isEdit;
   m_pCorAddressField.enabled = isEdit;
   m_pCorTelField.enabled = isEdit;
   m_pCorFaxField.enabled = isEdit;
   m_pCorIntroduceTextView.editable = isEdit;
}
-(void) setPersonDate:(PerClass *)person AndCordate:(CorClass *)cor
{
   if (person) {
      m_pPerson = person;
   }
   if (cor) {
      m_pCor = cor;
   }
   m_pNameField.text = person->perName;
   //m_pSexField.text = person->perSex;
   m_pMobileField.text = person->perMobile;
   m_pPositionField.text = person->perPosition;
   m_pPerTelField.text = person->perTel;
   m_pPerEmailField.text = person->perEmail;
   m_pPerIntroduceTextView.text = person->perIntroduce;
   
   m_pCorNameField.text = cor->corName;
   m_pCorAddressField.text = cor->corAddress;
   m_pCorTelField.text = cor->corTel;
   m_pCorFaxField.text = cor->corFax;
   m_pCorIntroduceTextView.text = cor->corInteroduce;
   if ([person->perEmail isEqual:@"(null)"]) {
      m_pPerEmailField.text = @"空";
   }

   [self functionButtonShowOrNot];
}

-(void) getDataFromTextField:(PerClass *) person AndCor:(CorClass *)cor
{
   person->perName = m_pNameField.text;
   //m_pSexField.text = person->perSex;
   person->perMobile = m_pMobileField.text;
   person->perPosition = m_pPositionField.text;
   person->perTel = m_pPerTelField.text;
   person->perEmail = m_pPerEmailField.text;
   person->perIntroduce = m_pPerIntroduceTextView.text;
   
   cor->corName = m_pCorNameField.text;
   cor->corAddress = m_pCorAddressField.text;
   cor->corTel = m_pCorTelField.text;
   cor->corFax = m_pCorFaxField.text;
   cor->corInteroduce = m_pCorIntroduceTextView.text;
}

- (UIImage *)fixOrientation:(UIImage *)aImage {
   
   // No-op if the orientation is already correct
   if (aImage.imageOrientation == UIImageOrientationUp)
      return aImage;
   
   // We need to calculate the proper transformation to make the image upright.
   // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
   CGAffineTransform transform = CGAffineTransformIdentity;
   
   switch (aImage.imageOrientation) {
      case UIImageOrientationDown:
      case UIImageOrientationDownMirrored:
         transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
         transform = CGAffineTransformRotate(transform, M_PI);
         break;
         
      case UIImageOrientationLeft:
      case UIImageOrientationLeftMirrored:
         transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
         transform = CGAffineTransformRotate(transform, M_PI_2);
         break;
         
      case UIImageOrientationRight:
      case UIImageOrientationRightMirrored:
         transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
         transform = CGAffineTransformRotate(transform, -M_PI_2);
         break;
      default:
         break;
   }
   //
   //   switch (aImage.imageOrientation) {
   //      case UIImageOrientationUpMirrored:
   //      case UIImageOrientationDownMirrored:
   //         transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
   //         transform = CGAffineTransformScale(transform, -1, 1);
   //         break;
   //
   //      case UIImageOrientationLeftMirrored:
   //      case UIImageOrientationRightMirrored:
   //         transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
   //         transform = CGAffineTransformScale(transform, -1, 1);
   //         break;
   //      default:
   //         break;
   //   }
   
   // Now we draw the underlying CGImage into a new context, applying the transform
   // calculated above.
   CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                            CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                            CGImageGetColorSpace(aImage.CGImage),
                                            CGImageGetBitmapInfo(aImage.CGImage));
   CGContextConcatCTM(ctx, transform);
   switch (aImage.imageOrientation) {
      case UIImageOrientationLeft:
      case UIImageOrientationLeftMirrored:
      case UIImageOrientationRight:
      case UIImageOrientationRightMirrored:
         // Grr...
         CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
         break;
         
      default:
         CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
         break;
   }
   
   // And now we just create a new UIImage from the drawing context
   CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
   UIImage *img = [UIImage imageWithCGImage:cgimg];
   CGContextRelease(ctx);
   CGImageRelease(cgimg);
   return img;
}
@end
