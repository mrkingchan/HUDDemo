//
//  URLProtocol.h
//  HUDDemo
//
//  Created by Macx on 2018/3/6.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLProtocol : NSURLProtocol<NSURLSessionDataDelegate>

@property(nonatomic,strong)NSURLSession *session;

@property(nonatomic,strong)NSURLSessionDataTask *task;

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request;


@end
