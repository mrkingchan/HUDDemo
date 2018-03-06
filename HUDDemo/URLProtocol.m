//
//  URLProtocol.m
//  HUDDemo
//
//  Created by Macx on 2018/3/6.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "URLProtocol.h"

@implementation URLProtocol


+(NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    [mutableRequest setValue:@"token" forHTTPHeaderField:@"token"];
    return  mutableRequest;
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    //防止无线递归
    if ([[self class] propertyForKey:NSStringFromClass([self class]) inRequest:request]) {
        return NO;
    } else {
        return YES;
    }
}

- (void)startLoading {
    NSMutableURLRequest *request = [[self request] mutableCopy];
    NSURLSessionConfiguration *configure = [NSURLSessionConfiguration defaultSessionConfiguration];
    [[self class] setProperty:@(YES) forKey:NSStringFromClass([self class]) inRequest:request];
    _session = [NSURLSession sessionWithConfiguration:configure
                                             delegate:self
                                        delegateQueue:[NSOperationQueue new]];
    _task = [_session dataTaskWithRequest:request];
    [_task resume];
}

- (void)stopLoading {
    [_session invalidateAndCancel];
    _session = nil;
    
    [_task cancel];
    _task = nil;
}

#pragma mark  -- NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [self.client URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    [self.client  URLProtocol:self didFailWithError:error];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:0];
    completionHandler(NSURLSessionResponseAllow);
}

//TODO: 重定向
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)newRequest completionHandler:(void (^)(NSURLRequest *))completionHandler {
    NSMutableURLRequest * redirectRequest;
    redirectRequest = [newRequest mutableCopy];
    [[self class] removePropertyForKey:NSStringFromClass([self  class]) inRequest:redirectRequest];
    [[self client] URLProtocol:self wasRedirectedToRequest:redirectRequest redirectResponse:response];
    [self.task cancel];
    [[self client] URLProtocol:self didFailWithError:[NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:nil]];
}

@end
