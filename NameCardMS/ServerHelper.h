//
//  ServerHelper.h
//  NameCardMS
//
//  Created by 郝 林巍 on 15/5/30.
//  Copyright (c) 2015年 lincwee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ServerHelperDelegate <NSObject>
- (void)didReceiveMsg;
- (void)didNotReceiveMsg;
@end

@interface ServerHelper : NSObject

+(void)startGETConnection:(NSString *)URL;
+(NSMutableData *)getGetData;

+(void)startPOSTConnection:(NSString *)URL OpsID:(NSInteger) ID;
+(NSMutableData *)getPostData;
+(void) setDelegate:(id)delegate;

@property (nonatomic, weak) id <ServerHelperDelegate> serverDelegate;
@end
