//
//  NameCardView.m
//  NameCardMS
//
//  Created by 郝 林巍 on 15/4/26.
//  Copyright (c) 2015年 lincwee. All rights reserved.
//

#import "NameCardView.h"

@implementation NameCardView

-(void) viewDidLoad
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(150.f, 200.f, 200.f, 200.f)];
    [label setText:@"this is information view"];
    [self.view addSubview:label];    
}

@end
