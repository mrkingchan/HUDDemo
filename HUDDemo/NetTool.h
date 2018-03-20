//
//  NetTool.h
//  HUDDemo
//
//  Created by Macx on 2018/3/20.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^sucess)(NSDictionary *repsonseDic);
typedef void(^failure)(NSError *error);

@interface NetTool : NSObject

/**
 @param method 请求方法
 @param path 请求路径
 @param parameters 请求参数
 @param complete 成功回调
 @param failure 失败回调
 @return  task对象
 */

+ (NSURLSessionDataTask *)innerRequestWithHttpMethod:(NSString*)method
                                              target:(id)target
                                             urlPath:(NSString*)path
                                          parameters:(NSDictionary *)parameters
                                              sucess:(sucess)success
                                             failure:(failure)failure;


@end
