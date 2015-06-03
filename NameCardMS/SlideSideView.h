//
//  SlideSideView.h
//  NameCardMS
//
//  Created by 郝 林巍 on 15/4/15.
//  Copyright (c) 2015年 lincwee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideSideView : UIViewController

typedef NS_ENUM(NSInteger, M_STATUS_TYPE){
    M_STATUS_LEFT,
    M_STATUS_RIGHT,
    M_STATUS_CENTER,
    M_STATUS_FULL,
};

@property (nonatomic, strong) UIViewController *centerViewController;
@property (nonatomic, strong) UIViewController *leftSideViewController;
@property (nonatomic, strong) UIViewController *rightSideViewController;
@property (nonatomic, strong) UIViewController *detailInfoViewController;

@property (nonatomic, assign) CGFloat maxLeftSideWidth;
@property (nonatomic, assign) CGFloat maxRightSideWidth;
@property (nonatomic, assign) CGFloat zoomScale;
@property (nonatomic, assign) NSTimeInterval duration;

@property (nonatomic, assign) M_STATUS_TYPE status;
@property (nonatomic, assign) BOOL isDrag;

-(instancetype)initWithCenterViewController:(UIViewController *)centerViewController;

-(void)showLeftSideFinish:(void(^)())finish;
-(void)showRightSideFinish:(void(^)())finish;
-(void)hideSideFinish:(void(^)())finish;
-(void)showDetailSideFinish:(void(^)())finish;

-(void)showDetailInfo:(UIViewController *)detailView;

@end
