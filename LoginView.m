//
//  LoginView.m
//  NameCardMS
//
//  Created by 郝 林巍 on 15/6/2.
//  Copyright (c) 2015年 lincwee. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView

@synthesize m_pAccount, m_pPassword;

- (id)init{
    if (self == [super init]) {
        m_pAccount = [[UITextField alloc]initWithFrame:CGRectMake(22, 45, 240, 36)];
        [self addSubview: m_pAccount];
        m_pPassword = [[UITextField alloc]initWithFrame:CGRectMake(22, 90, 240, 36)];
        //self.frame = CGRectMake(160.f, 250.f, 150, 280);
    }
    return self;
}

-(void) layoutSubviews
{
    //[super layoutSubviews];     // 当override父类的方法时，要注意一下是否需要调用父类的该方法
    
    for (UIView* view in self.subviews) {
        // 搜索AlertView底部的按钮，然后将其位置下移
        // IOS5以前按钮类是UIButton, IOS5里该按钮类是UIThreePartButton
        if ([view isKindOfClass:[UIButton class]] ||
            [view isKindOfClass:NSClassFromString(@"UIThreePartButton")]) {
            CGRect btnBounds = view.frame;
            btnBounds.origin.y = m_pPassword.frame.origin.y + m_pAccount.frame.size.height + 7;
            view.frame = btnBounds;
        }
    }
    
    // 定义AlertView的大小
    CGRect bounds = self.frame;
    bounds.size.height = 260;
    self.frame = bounds;
}

-(void) drawRect:(CGRect)rect
{
    self.frame = CGRectMake(160.f, 250.f, 150, 280);
}
@end
