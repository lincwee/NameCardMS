//
//  ServerHelper.m
//  NameCardMS
//
//  Created by 郝 林巍 on 15/5/30.
//  Copyright (c) 2015年 lincwee. All rights reserved.
//

#import "ServerHelper.h"
@interface ServerHelper() <NSURLConnectionDataDelegate>
{
    NSMutableData *m_pData;
}
@end

@implementation ServerHelper

+(ServerHelper *)shareControl
{
    static ServerHelper *instance;
    @synchronized(self){
        if (!instance) {
            instance = [[ServerHelper alloc]init];
        }
    }
    return instance;
}

+(void)startGETConnection:(NSString *)URL
{
    if (URL) {
        [[ServerHelper shareControl] startGETConnection:URL];
    }
}
-(void)startGETConnection:(NSString *)URL
{
    NSURL *url = [NSURL URLWithString:URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:request delegate:self];
    
    [conn start];
}

+(NSMutableData *)getGetData
{
    return [[ServerHelper shareControl] getGetData];
}

-(NSMutableData *)getGetData
{
    if (m_pData) {
        return m_pData;
    }
    return nil;
}

+(void)startPOSTConnection:(NSString *)URL OpsID:(NSInteger) ID
{
    if (URL) {
        [[ServerHelper shareControl]startPOSTConnection:URL OpsID:ID];
    }
}

-(void)startPOSTConnection:(NSString *)URL OpsID:(NSInteger) ID
{
//        NSString *requestStr = [NSString stringWithFormat:@"http://192.168.0.21:8080/MyTestServer/login"];
//        NSString *requestStr = [NSString stringWithFormat:requestStr];
        NSURL *url = [NSURL URLWithString:URL];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        request.timeoutInterval = 5;
        
        // 设置为post方式请求
        request.HTTPMethod = @"POST";
        
        // 设置请求头
        [request setValue:@"ios" forHTTPHeaderField:@"User-Agent"];
        
        // 设置请求体
        NSString *param = [NSString stringWithFormat:@"user=000000&ID=%d",ID];
        request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
        NSURLConnection *conn = [NSURLConnection connectionWithRequest:request delegate:self];
        [conn start];
        NSLog(@"执行POST");
    
        
//        // 发送请求
//        // 使用主线程来处理UI刷新
//        NSOperationQueue *queue = [NSOperationQueue mainQueue];
//        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//            
//        }];
    
    
}

#pragma mark -
#pragma mark Connection DelegateMethod

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"收到回应");
    if (!m_pData)
    {
        m_pData = [NSMutableData data];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"收到数据");
    [m_pData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *output = [[NSString alloc] initWithData:m_pData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", output);
    
    m_pData = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    assert(error);
}

@end
