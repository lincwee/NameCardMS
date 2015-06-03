//
//  ServerHelper.h
//  NameCardMS
//
//  Created by 郝 林巍 on 15/5/30.
//  Copyright (c) 2015年 lincwee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ServerHelper : NSObject

+(void)startGETConnection:(NSString *)URL;
+(NSMutableData *)getGetData;

+(void)startPOSTConnection:(NSString *)URL OpsID:(NSInteger) ID;
+(NSMutableData *)getPostData;
@end
