//
//  RightBackSideView.m
//  NameCardMS
//
//  Created by 郝 林巍 on 15/4/19.
//  Copyright (c) 2015年 lincwee. All rights reserved.
//

#import "RightBackSideView.h"
#import "AppDelegate.h"
#import "ASIHTTPRequest.h"
#import "DetailInfoViewConteroller.h"
#import "LoginView.h"

@implementation RightBackSideView

@synthesize m_pUserView, m_pNameLabel, m_pPositionLabel, m_pCorAddressLabel, m_pUserDefaults, m_pLoginButton, m_pAccountLabel, m_pAccountText, m_pProgressHUD;

-(void)viewDidLoad{
    [super viewDidLoad];
    m_pUserDefaults = [NSUserDefaults standardUserDefaults];
    [self initView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self savaUserData];
    [self readUserData];
    
    m_pProgressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [((AppDelegate *)([UIApplication sharedApplication].delegate)).window addSubview:m_pProgressHUD];
    m_pProgressHUD.delegate = self;
    m_pProgressHUD.labelText = @"登录中...";
    m_pProgressHUD.dimBackground = YES;
    
//    [HUD showAnimated:YES whileExecutingBlock:^{
//        sleep(3);
//    } completionBlock:^{
//        [HUD removeFromSuperview];
//    }];
    //[m_pProgressHUD show:YES];
}

-(void) viewDidAppear:(BOOL)animated
{
    [self readUserData];
}

-(void) initView
{
    m_pUserView = [[UIView alloc]initWithFrame:CGRectMake(LEFT_BACKSIDE_VIEW_WIDTH - 1.f, 0.f, RIGHT_BACKSIDE_VIEW_WIDTH, RIGHT_BACKSIDE_VIEW_USERVIEW_HEIGHT + 450.f)];
    m_pUserView.backgroundColor = SKY_BLUE;
    [self.view addSubview:m_pUserView];
    
    
//    UILabel *pTopLabel = [[UILabel alloc] initWithFrame:CGRectMake(35.f, 30.f, 80.f, 40.f)];
//    //pTopLabel.center = m_pUserView.center;
//    pTopLabel.text = @"IMAGE";
//    pTopLabel.textColor = [UIColor blackColor];
//    pTopLabel.adjustsFontSizeToFitWidth = YES;
    
    UIImage *image = [UIImage imageNamed:@"Avatar1.png"];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSingleDataView)];
    [imageView addGestureRecognizer:singleTap1];

    imageView.frame = CGRectMake(5.f, 20.f, 115.f, 115.f);
    [m_pUserView addSubview:imageView];
    
    
    m_pNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10.f, 170.f - 40.f, 100.f, 50.f)];
    [m_pUserView addSubview:m_pNameLabel];
    
    m_pPositionLabel = [[UILabel alloc]initWithFrame:CGRectMake(10.f, 200.f - 40.f, 100.f, 50.f)];
    [m_pUserView addSubview:m_pPositionLabel];
    
    m_pCorAddressLabel = [[UILabel alloc]initWithFrame:CGRectMake(10.f, 230.f - 40.f, 100.f, 50.f)];
    [m_pCorAddressLabel setFont:[UIFont systemFontOfSize:14]];
    m_pCorAddressLabel.numberOfLines = 0;
    m_pCorAddressLabel.lineBreakMode = UILineBreakModeWordWrap;
    [m_pUserView addSubview:m_pCorAddressLabel];
    
    
    UILabel *accountString = [[UILabel alloc]initWithFrame:CGRectMake(10.f, 270.f - 40.f, 100.f, 50.f)];
    accountString.text = @"帐号";
    accountString.textColor = [UIColor grayColor];
    [accountString setFont:[UIFont systemFontOfSize:15]];
    [m_pUserView addSubview:accountString];
    
    m_pAccountLabel = [[UILabel alloc]initWithFrame:CGRectMake(10.f, 290.f - 40.f, 100.f, 50.f)];
    [m_pUserView addSubview:m_pAccountLabel];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10.f, 370.f, 90.f, 50.f)];
    button.backgroundColor = [UIColor darkGrayColor];
    [button setTitle:@"ASIHTTPTest" forState:UIControlStateNormal];
    //button.center = m_pUserView.center;
    [button addTarget:self action:@selector(testServer) forControlEvents:UIControlEventTouchUpInside];
    //[m_pUserView addSubview:button];
    //[m_pUserView addSubview:pTopLabel];
    
    m_pLoginButton = [[UIButton alloc] initWithFrame:CGRectMake(20.f, 310.f, 90.f, 50.f)];
    m_pLoginButton.backgroundColor = [UIColor darkGrayColor];
    NSString *loginButtonText = [m_pUserDefaults boolForKey:LOGIN_STATE]?@"退出登录":@"登  录";
    [m_pLoginButton setTitle:loginButtonText forState:UIControlStateNormal];
    //button.center = m_pUserView.center;
    [m_pLoginButton addTarget:self action:@selector(loginOrLogoutAccount) forControlEvents:UIControlEventTouchUpInside];
    [m_pUserView addSubview:m_pLoginButton];
}

-(void) showSingleDataView
{    NSLog(@"add single data touched!");
        //[((AppDelegate *)([UIApplication sharedApplication].delegate)).slideViewController hideSideFinish:nil];
        DetailInfoViewConteroller *detailView = [[DetailInfoViewConteroller alloc]init];
            [detailView setViewState:DETAIL_INFO_VIEW_STATE_SAVE_SELF];
    
        //detailView.view.backgroundColor = [UIColor whiteColor];
        detailView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [((AppDelegate *)([UIApplication sharedApplication].delegate)).m_pNavViewController pushViewController:detailView animated:YES];

        detailView.view.backgroundColor = MOON_WHITE;
//    [detailView setPersonalName:[m_pUserDefaults stringForKey:@"name"] Position:[m_pUserDefaults stringForKey:@"position"]Mobile:[m_pUserDefaults stringForKey:PER_MOBILE] TEL:[m_pUserDefaults stringForKey:@"perTel"] Email:@"" CorpName:@"" Andress:@"" FAX:@""];
    [self addSingleData:detailView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [((AppDelegate *)([UIApplication sharedApplication].delegate)).slideViewController hideSideFinish:nil];
            
        });
}

-(void) addSingleData:(DetailInfoViewConteroller *)detailView
{
    PerClass *person = [[PerClass alloc]init];
    person->perName = [m_pUserDefaults stringForKey:PER_NAME];
    person->perMobile = [m_pUserDefaults stringForKey:PER_MOBILE];
    person->perPosition = [m_pUserDefaults stringForKey:PER_POSITION];
    person->perIntroduce = [m_pUserDefaults stringForKey:PER_INTRODUCE];
    person->perTel = [m_pUserDefaults stringForKey:PER_TEL];
    person->perEmail = [m_pUserDefaults stringForKey:PER_EMAIL];
    CorClass *cor = [[CorClass alloc]init];
    cor->corName = [m_pUserDefaults stringForKey:COR_NAME];
    cor->corAddress = [m_pUserDefaults stringForKey:COR_ADDRESS];
    cor->corFax = [m_pUserDefaults stringForKey:COR_FAX];
    cor->corTel = [m_pUserDefaults stringForKey:COR_TEL];
    cor->corInteroduce = [m_pUserDefaults stringForKey:COR_INTRODUCE];
    [detailView setPersonDate:person AndCordate:cor];
}

-(void) loginOrLogoutAccount
{
    BOOL loginState = [m_pUserDefaults boolForKey:LOGIN_STATE];
    if (loginState) {
        [self logoutAccount];
    }
    else{
        [self loginAcount];
    }
}

-(void) loginAcount
{
    UIAlertView *customAlertView;
    if (customAlertView==nil) {
        customAlertView = [[UIAlertView alloc] initWithTitle:@"登  录" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil, nil];
    }
    [customAlertView setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    
    UITextField *nameField = [customAlertView textFieldAtIndex:0];
    nameField.placeholder = @"帐号";
    
    UITextField *passwordField = [customAlertView textFieldAtIndex:1];
    [passwordField setSecureTextEntry:YES];
    passwordField.placeholder = @"密码";
    //urlField.text = @"http://";
    
    [customAlertView show];
}

-(void) logoutAccount
{
    [m_pUserDefaults setBool:NO forKey:LOGIN_STATE];
    [m_pLoginButton setTitle:@"登  录" forState:UIControlStateNormal];
    [m_pUserDefaults setObject:@"" forKey:PER_ACCOUNT];
    m_pAccountLabel.text = @"";
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录" message:@"退出登录" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alert show];
}

-(void)testServer{
    //[ServerHelper startGETConnection:@"http://www.baidu.com/s?wd=nihao&rsv_spt=1&issp=1&rsv_bp=0&ie=utf-8&tn=baiduhome_pg&rsv_sug3=3&rsv_sug=0&rsv_sug1=3&rsv_sug4=36"];
    [ServerHelper startGETConnection:@"http://192.168.1.103:8080/MavenJavaWebDemo/myservlet?username=zdw&password=admin"];
    [ServerHelper setDelegate:self];
}

#pragma mark -ServerHelperDelegate
-(void)didReceiveMsg
{
    NSMutableData *data= [ServerHelper getGetData];
    NSString *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [m_pProgressHUD hide:YES];
    NSLog(@"收到结果%@", output);
    if ([output isEqualToString:@"true"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录" message:@"登录成功" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        [m_pUserDefaults setBool:YES forKey:LOGIN_STATE];
        [m_pLoginButton setTitle:@"退出登录" forState:UIControlStateNormal];
        [m_pUserDefaults setObject:m_pAccountText forKey:PER_ACCOUNT];
        m_pAccountLabel.text = [m_pUserDefaults stringForKey:PER_ACCOUNT];
    }
    else if([output isEqualToString:@"false"])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录" message:@"登录失败" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录" message:@"网络连接失败" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void) didNotReceiveMsg
{
    [m_pProgressHUD hide:YES];
}

-(void) savaUserData
{
    //NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [m_pUserDefaults setObject:@"haolinwei" forKey:PER_NAME];
//    [m_pUserDefaults setObject:@"2" forKey:PER_POSITION];
//    [m_pUserDefaults setObject:@"3" forKey:COR_ADDRESS];
    //[userDefaults setObject:nil forKey:PER_NAME];
}


-(void) readUserData
{
    //NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    m_pNameLabel.text = [m_pUserDefaults stringForKey:PER_NAME];
    m_pPositionLabel.text = [m_pUserDefaults stringForKey:PER_POSITION];
    m_pCorAddressLabel.text = [m_pUserDefaults stringForKey:COR_ADDRESS];
    m_pAccountLabel.text = [m_pUserDefaults stringForKey:PER_ACCOUNT];
}

#pragma mark -alertView
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        UITextField *accountField = [alertView textFieldAtIndex:0];
        UITextField *passwordField = [alertView textFieldAtIndex:1];
        //TODO
        NSLog(@"account:%@", accountField.text);
        NSLog(@"password:%@", passwordField.text);
        m_pAccountText = accountField.text;
        NSString *sendMsg = [NSString stringWithFormat:@"http://192.168.1.100:8080/MavenJavaWebDemo/myservlet?Type=0&username=%@&password=%@",accountField.text, passwordField.text];
        //@"http://192.168.1.103:8080/MavenJavaWebDemo/myservlet?username=zdw&password=admin"
        [ServerHelper startGETConnection:sendMsg];
        [ServerHelper setDelegate:self];
        [m_pProgressHUD show:YES];
        [m_pProgressHUD hide:YES afterDelay:10];
//        [m_pProgressHUD showAnimated:YES whileExecutingBlock:^{
//            sleep(10);
//        } completionBlock:^{
//            [m_pProgressHUD hide:YES];
//        }];
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录成功" message:@"登录公司账户成功" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
//        NSString *sendUrl = [NSString stringWithFormat:@"%@,%@",accountField.text,passwordField.text];
//        [alert show];
    }
    
}
@end
