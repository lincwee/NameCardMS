//
//  SlideSideView.m
//  NameCardMS
//
//  Created by 郝 林巍 on 15/4/15.
//  Copyright (c) 2015年 lincwee. All rights reserved.
//

#import "SlideSideView.h"
#import "MacroFile.h"
#import "DetailInfoViewConteroller.h"


typedef NS_ENUM(NSInteger, ANIMATION_TYPE) {
    ANIMATION_SHOW_LEFT,
    ANIMATION_SHOW_RIGHT,
    ANIMATION_HIDE_SIDE,
    ANIMATION_SHOW_DETAIL_INFO,
};



typedef NS_ENUM(NSInteger, SIDE_TYPE){
    SIDE_LEFT,
    SIDE_RIGHT,
    SIDE_DETAIL_INFO,
};



@interface SlideSideView()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic, readonly) CALayer *m_pCenterLayer;
@property (nonatomic, readonly) CALayer *m_pLeftLayer;
@property (nonatomic, readonly) CALayer *m_pRightLayer;

@property (nonatomic, readonly) UIView *m_pCenterView;
@property (nonatomic, readonly) UIView *m_pLeftView;
@property (nonatomic, readonly) UIView *m_pRightView;

@property (nonatomic, weak) UIView *m_pSideView;

@property (nonatomic, assign) CGFloat touchX;
@property (nonatomic, assign) BOOL isStartAnimation;
@property (nonatomic, assign) CFTimeInterval lastTimeOffSet;
@property (nonatomic, assign) CGFloat ratio;

@property (nonatomic, strong) UIButton *centerButton;

@end

@implementation SlideSideView

-(instancetype)initWithCenterViewController:(UIViewController *)centerViewController{
    self = [super init];
    if (self) {
        
        self.centerViewController = centerViewController;
        //[self.centerViewController.view setCenter:CGPointMake(200.f, 300.f)];
        //self.centerViewController.view.backgroundColor = [UIColor redColor];
        self.maxLeftSideWidth = 190;
        self.maxRightSideWidth = 100;
        self.zoomScale = 0.7;
        self.duration = 0.2;
        self.isStartAnimation = NO;
        self.status = M_STATUS_CENTER;
        self.isDrag = YES;
    }
    return self;
}

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
}

#pragma mark - controller

-(void)showLeftSideFinish:(void (^)())finish{
    [self addAnimation:ANIMATION_SHOW_LEFT finish:finish];
}

-(void)hideSideFinish:(void (^)())finish{
    [self addAnimation:ANIMATION_HIDE_SIDE finish:finish];
}

-(void)showRightSideFinish:(void (^)())finish{
    [self addAnimation:ANIMATION_SHOW_RIGHT finish:finish];
}

-(void)showDetailSideFinish:(void(^)())finish{
    [self addAnimation:ANIMATION_SHOW_DETAIL_INFO finish:finish];
}

-(void)panGestureRecognizer:(UIPanGestureRecognizer *)pan{
    
    CGFloat touchX = [pan locationInView:self.view].x;
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            //NSLog(@"start");
            self.isStartAnimation = YES;
            self.centerLayer.speed = 0;
            self.touchX = touchX;
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            
            self.isStartAnimation = NO;
            self.centerLayer.speed = 1;
            self.centerLayer.timeOffset = 0;
            self.centerLayer.beginTime = 0;
            
            CFTimeInterval pausedTime = self.lastTimeOffSet;
            
            self.centerLayer.beginTime = [self.centerLayer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
            
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            float panDistance = [pan locationInView:self.view].x - self.touchX;
            //NSLog(@"panDistance : %f, isend : %d",panDistance, self.isStartAnimation?1:0);
            //NSLog(@"%d",self.isStartAnimation?1:0);
            if (self.isStartAnimation) {
                self.isStartAnimation = NO;
                switch (self.status) {
                    case M_STATUS_CENTER:
                    {
                        if (panDistance > 0.f && self.touchX < 40.f) {
                            [self addAnimation:ANIMATION_SHOW_LEFT finish:nil];
                        }
                        else if(panDistance < 0.f && self.touchX > MAIN_SCREEN_WIDTH - 60.f)
                        {
                            [self addAnimation:ANIMATION_SHOW_RIGHT finish:nil];
                        }
                        else
                        {
                            
                        }
                        self.ratio = self.maxLeftSideWidth * 5;
                        break;
                    }
                    case M_STATUS_LEFT:
                    {
                        [self addAnimation:ANIMATION_HIDE_SIDE finish:nil];
                        self.ratio = self.maxLeftSideWidth * 5;
                        break;
                    }
                    case M_STATUS_RIGHT:
                    {
                        [self addAnimation:ANIMATION_HIDE_SIDE finish:nil];
                        self.ratio = self.maxRightSideWidth * 5;
                        break;
                    }
                    default:
                        break;
                }
            }
            self.lastTimeOffSet = (touchX - self.touchX)/self.ratio;
            if (self.status == M_STATUS_LEFT) {
                self.lastTimeOffSet = -self.lastTimeOffSet;
            }
            if (self.lastTimeOffSet < 0.015) {
                self.lastTimeOffSet = 0.015;
            }
            self.centerLayer.timeOffset = self.lastTimeOffSet;
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - gesturerecognizer

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer == self.panGestureRecognizer) {
        
        if (!self.isDrag) {
            return NO;
        }
        
        CGFloat touchX = [gestureRecognizer locationInView:self.view].x;
        
        switch (self.status) {
            case M_STATUS_CENTER:
                if (touchX < LEFT_SIDE) {
                    return YES;
                }
                if (touchX > 320.f - LEFT_SIDE) {
                    return YES;
                }
                break;
            case M_STATUS_LEFT:
                return YES;
                break;
            case M_STATUS_RIGHT:
                return YES;
                break;
                
            default:
                break;
        }
        
    }
    return NO;
}

#pragma mark - private

-(void)willShowSide:(SIDE_TYPE)type{
    self.m_pSideView = (type == SIDE_LEFT)?self.leftView:self.rightView;
    if (SIDE_LEFT == type) {
        self.m_pSideView = self.leftView;
    }
    if (SIDE_RIGHT == type)
    {
        self.m_pSideView = self.rightView;
    }
    if (SIDE_DETAIL_INFO == type) {
        self.m_pSideView = self.detailInfoView;
    }
    if (self.m_pSideView) {
        if ([self.view.subviews containsObject:self.m_pSideView]) {
            [self.m_pSideView removeFromSuperview];
        }
        [self.view insertSubview:self.m_pSideView belowSubview:self.centerView];
    }
}

-(void)didShowSide{
    self.centerButton.frame = self.centerView.bounds;
    [self.centerView addSubview:self.centerButton];
}

-(void)didHideSide{
    if (self.m_pSideView) {
        [self.m_pSideView removeFromSuperview];
    }
    [self.centerButton removeFromSuperview];
}

-(void)addAnimation:(ANIMATION_TYPE)type finish:(void(^)())finish{
    
    CGPoint point = self.centerLayer.position;
    CGFloat scale;
    
    NSArray *positions,*scales;
    NSString *identification;
    
    CGFloat view_width = self.view.frame.size.width;
    
    M_STATUS_TYPE status;
    switch (type) {
        case ANIMATION_HIDE_SIDE:
        {
            //scales = @[@(self.zoomScale),@1];
            point.x = view_width / 2;
            identification = kAnimationHideSide;
            status = M_STATUS_CENTER;
        }
            break;
        case ANIMATION_SHOW_LEFT:
        {
            [self willShowSide:SIDE_LEFT];
            //scales = @[@1,@(self.zoomScale)];
            //point.x = self.maxLeftSideWidth + (view_width * self.zoomScale) /2;
            point.x = view_width + view_width / 9;
            identification = kAnimationShowLeft;
            status = M_STATUS_LEFT;
        }
            break;
        case ANIMATION_SHOW_RIGHT:
        {
            [self willShowSide:SIDE_RIGHT];
            identification = kAnimationShowRight;
            //scales = @[@1,@(self.zoomScale)];
            //point.x = view_width - (view_width * self.zoomScale)/2 - self.maxRightSideWidth*2;
            point.x = 0 + view_width / 9;
            status = M_STATUS_RIGHT;
        }
            break;
        case ANIMATION_SHOW_DETAIL_INFO:
        {
            [self willShowSide:SIDE_DETAIL_INFO];
            identification = kAnimationShowDetailInfo;
            point.x = 0;
            status = M_STATUS_FULL;
        }
            break;
        default:
            break;
    }
    
    //scale = [[scales lastObject] floatValue];
    positions = @[NSVALUE_POINT(self.centerLayer.position),NSVALUE_POINT(point)];
    
    CAKeyframeAnimation *moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveAnimation.duration = self.duration;
    moveAnimation.values = positions;
    
    
    scales = @[@1.f, @1.f]; //变形系数为1，即不变形
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = self.duration;
    scaleAnimation.values = scales;
    
    __weak __typeof(self) wself = self;
    void(^Finish)() = ^{
        wself.status = status;
        if (finish) {
            finish();
        }
        if (status == M_STATUS_CENTER) {
            [wself didHideSide];
        }else{
            [wself didShowSide];
        }
    };
    
    scaleAnimation.delegate = self;
    [scaleAnimation setValue:Finish forKey:k_FINISH_BLOCK];
    
    [self.centerLayer addAnimation:moveAnimation forKey:k_POSITION];
    [self.centerLayer addAnimation:scaleAnimation forKey:k_SCALE];
    
    self.centerLayer.position = point;
    
    //self.centerLayer.transform = CATransform3DMakeScale(1.f, 1.f, 1.f);
    //self.centerLayer.transform = CATransform3DMakeScale(scale, scale, scale);
    
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if ([anim valueForKey:k_FINISH_BLOCK]) {
        void(^finish)() = [anim valueForKey:k_FINISH_BLOCK];
        if (finish) {
            finish();
        }
    }
}

#pragma mark - set get
-(void)setCenterViewController:(UIViewController *)centerViewController{
    if (_centerViewController != centerViewController) {
        BOOL hasLast = NO;
        CGPoint point;
        CATransform3D transform;
        if (_centerViewController) {
            point = self.centerLayer.position;
            transform = self.centerLayer.transform;
            hasLast = YES;
        }
        [self.view addSubview:centerViewController.view];
        if (self.centerView){
            [self.centerView removeGestureRecognizer:self.panGestureRecognizer];
            [self.centerView removeFromSuperview];
        }
        _centerViewController = centerViewController;
        [self.centerView addGestureRecognizer:self.panGestureRecognizer];
        if (hasLast) {
            self.centerLayer.position = point;
            self.centerLayer.transform = transform;
        }
    }
    if (self.status != M_STATUS_CENTER) {
        [self hideSideFinish:nil];
    }
}

-(UIPanGestureRecognizer *)panGestureRecognizer{
    if (!_panGestureRecognizer) {
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
        _panGestureRecognizer.delegate = self;
    }
    return _panGestureRecognizer;
}

-(CALayer *)centerLayer{
    if (self.centerViewController){
        return self.centerViewController.view.layer;
    }else{
        return nil;
    }
}
-(CALayer *)leftLayer{
    if (self.leftSideViewController){
        return self.leftSideViewController.view.layer;
    }else{
        return nil;
    }
}
-(CALayer *)rightLayer{
    if (self.rightSideViewController) {
        return self.rightSideViewController.view.layer;
    }else{
        return nil;
    }
}
-(UIView *)centerView{
    if (self.centerViewController) {
        return self.centerViewController.view;
    }else{
        return nil;
    }
}
-(UIView *)leftView{
    if (self.leftSideViewController) {
        return self.leftSideViewController.view;
    }else{
        return nil;
    }
}
-(UIView *)rightView{
    if (self.rightSideViewController) {
        return self.rightSideViewController.view;
    }else{
        return nil;
    }
}

-(UIView *)detailInfoView
{
    if (self.detailInfoViewController) {
        return self.detailInfoViewController.view;
    }
    else
    {
        return nil;
    }
}
-(UIButton *)centerButton{
    if (!_centerButton) {
        _centerButton = [[UIButton alloc] initWithFrame:CGRectNull];
        [_centerButton addTarget:self action:@selector(clickOnCenterButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _centerButton;
}
-(void)clickOnCenterButton{
    [self addAnimation:ANIMATION_HIDE_SIDE finish:nil];
}

#pragma mark -Show DetailInfo
-(void) showDetailInfo:(DetailInfoViewConteroller *)detailView
{
//    CATransition* transition = [CATransition animation];
//    
//    transition.type = kCATransitionMoveIn;//可更改为其他方式
//    transition.subtype = kCATransitionFromRight;//可更改为其他方式
//    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController pushViewController:detailView animated:YES];
}
@end

