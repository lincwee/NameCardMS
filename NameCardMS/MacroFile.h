//
//  MacroFile.h
//  NameCardMS
//
//  Created by 郝 林巍 on 15/4/18.
//  Copyright (c) 2015年 lincwee. All rights reserved.
//

#define MAIN_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define MAIN_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define isIos7      ([[[UIDevice currentDevice] systemVersion] floatValue])
#define StatusbarSize ((isIos7 >= 7 && __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1)?20.f:0.f)

//ViewController
#define OPS_BUTTON_TEXT_FONT 20
#define OPS_BUTTON_TEXT_WIDTH 70.f
#define OPS_BUTTON_TEXT_HEIGHT 30.f

//SlideSideView
#define LEFT_SIDE 40.f
#define k_IDENTIFICATION @"identification"
#define k_FINISH_BLOCK @"finish_block"
#define k_POSITION @"position"
#define k_SCALE @"scale"

#define kAnimationShowLeft @"ANIMATION_SHOW_LEFT"
#define kAnimationShowRight @"ANIMATION_SHOW_RIGHT"
#define kAnimationHideSide @"ANIMATION_HIDE_SIDE"
#define kAnimationShowDetailInfo @"ANIMATION_SHOW_DETAIL_INFO"
#define NSVALUE_POINT(point) [NSValue valueWithCGPoint:point]

//LeftBackSideView
#define LEFT_BACKSIDE_VIEW_WIDTH 196.f
#define LEFT_BACKSIDE_VIEW_TOPVIEW_HEIGHT 100.f
#define LEFT_BACKSIDE_VIEW_BUTTON_HEIGHT 48.f
#define LEFT_BACKSIDE_VIEW_BUTTON_BUTTON_OFFSET (LEFT_BACKSIDE_VIEW_BUTTON_HEIGHT+ 4.f)
#define LEFT_BACKSIDE_VIEW_BUTTON_TOP1_POSY LEFT_BACKSIDE_VIEW_TOPVIEW_HEIGHT+5.f

//RightBackSideView
#define RIGHT_BACKSIDE_VIEW_WIDTH 125.f
#define RIGHT_BACKSIDE_VIEW_USERVIEW_HEIGHT 120.f

//DetailInfoView -> ScrollView
#define kScrollViewHeigh 500.f
#define kScrollViewWidth 320.f
#define kScrollViewContentSizeHeigh 1100.f
#define SCROLL_VIEW_TEXT_HEIGHT_OFFSET 60.f
#define SCROLL_VIEW_PERSON_START_HEIGHT 190.f
#define SCROLL_VIEW_COR_START_HEIGHT 620.f

//sqlite
#define LOCAL_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define DBNAME    @"databaseInfo.sqlite"

#define PER_NAME @"perName"
#define PER_MOBILE @"perMobile"
#define PER_POSITION @"perPosition"
#define PER_TEL @"perTel"
#define PER_EMAIL @"perEmail"
#define PER_INTRODUCE @"perIntroduce"

#define COR_NAME @"corName"
#define COR_ADDRESS @"corAddress"
#define COR_TEL @"corTel"
#define COR_FAX @"corFax"
#define COR_INTRODUCE @"corIntroduce"

#define PER_ACCOUNT @"account"
#define LOGIN_STATE @"loginState"  //True代表已登录，False代表未登录

//DetailInfoViewConteroller
#define DETAIL_BUTTON_TEXT_EDIT @"编辑"
#define DETAIL_BUTTON_TEXT_SAVE @"保存"
#define DETAIL_BUTTON_TEXT_UPDATE @"更新"
#define DETAIL_BUTTON_TEXT_SELF @"保存个人信息"


//Color
#define LIGHT_GREEN [UIColor colorWithRed:163.f / 255.f green:226.f / 255.f blue:197.f / 255.f alpha:1.f]
#define LIGHT_SKY_BLUE [UIColor colorWithRed:135.f / 255.f green:206.f / 255.f blue:250.f / 255.f alpha:1.f]
#define SKY_BLUE [UIColor colorWithRed:135.f / 255.f green:206.f / 255.f blue:235.f / 255.f alpha:1.f]
#define DEEP_SKY_BLUE [UIColor colorWithRed:0.f / 255.f green:191.f / 255.f blue:255.f / 255.f alpha:1.f]
#define MOON_WHITE [UIColor colorWithRed:215.f / 255.f green:236.f / 255.f blue:241.f / 255.f alpha:1.f]

