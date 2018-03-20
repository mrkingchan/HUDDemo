//
//  NetTool.m
//  HUDDemo
//
//  Created by Macx on 2018/3/20.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "NetTool.h"

@implementation NetTool

+ (NSURLSessionDataTask  *)innerRequestWithHttpMethod:(NSString *)method
                                              urlPath:(NSString *)path
                                           parameters:(NSDictionary *)parameters
                                               sucess:(sucess)success
                                              failure:(failure)failure {
    //构建网络请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:path]];
    request.HTTPMethod = method;
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:parameters
                                                       options:kNilOptions
                                                         error:nil];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                                     if (error) {
                                                                         failure(error);
                                                                     } else {
                                                                         //转为json
                                                                         if (data.length) {
                                                                             NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                                                             if (success) {
                                                                                 success(json);
                                                                             }
                                                                         }
                                                                     }
                                                                 }];
    [task resume];
    return  task;
}
@end
