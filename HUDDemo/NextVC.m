//
//  NextVC.m
//  HUDDemo
//
//  Created by Macx on 2018/3/6.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "NextVC.h"

@interface NextVC () {
    UILabel *_showErrorMessage;
}

@end

@implementation NextVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            _showErrorMessage.hidden = NO;
            [self.view  bringSubviewToFront:_showErrorMessage];
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];

    ///错误信息提示
    _showErrorMessage = [[UILabel alloc] init];
    [_showErrorMessage setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [_showErrorMessage setFrame:self.view.bounds];
    _showErrorMessage.numberOfLines = 2;
    _showErrorMessage.textAlignment = NSTextAlignmentCenter;
    [_showErrorMessage setTextColor:[UIColor blackColor]];
    _showErrorMessage.center = self.view.center;
    _showErrorMessage.hidden = true;
    _showErrorMessage.text = @"当前网络连接不稳定,请检查网络配置 \n 下拉可重新加载";
    [self.view addSubview:_showErrorMessage];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    iToastLoading;
    [self loadData];
    _showErrorMessage.hidden = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        iToastHide;
        /*_showErrorMessage.hidden = NO;
        [self.view  bringSubviewToFront:_showErrorMessage];*/
    });
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    iToastHide;
}

#pragma mark  -- loadData
- (void)loadData {
    /*[NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]] queue:[NSOperationQueue new]
                           completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                               
                           }];*/
    /*[[[AFHTTPSessionManager manager] dataTaskWithHTTPMethod:@"GET"
                                                  URLString:@"HTTP://WWW.BAIDU.COM"
                                                 parameters:@""
                                             uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
                                                 //上传
                                                 if (uploadProgress) {
                                                     float percent = uploadProgress.completedUnitCount / uploadProgress.totalUnitCount / 1.00;
                                                     NSLog(@"upload percent =%@%.2f",@"%",percent * 100.0);
                                                 }
                                             } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
                                                 //下载
                                                 if (downloadProgress) {
                                                     float percent = downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
                                                     NSLog(@"download percent = %@%2.f",@"%",percent * 100.0);
                                                 }
                                                 
                                             } success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject) {
                                                 //成功回调
                                                 id json;
                                                 if ([responseObject isKindOfClass:[NSData class]]) {
                                                     //data
                                                     json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
                                                     
                                                     
                                                 } else if ([responseObject isKindOfClass:[NSString class]]) {
                                                     //String
                                                     json = [NSJSONSerialization JSONObjectWithData:[((NSString *)responseObject) dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
                                                 }
                                                 NSLog(@"repsonsejson = %@",json);
                                             } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                                                 //失败回调
                                                 if (error) {
                                                     NSLog(@"error = %@",error.localizedDescription);
                                                 }
                                             }] resume] ;*/
    [[AFHTTPSessionManager manager] POST:@"http://www.baidu.com"
                              parameters:@""
                                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                     
                                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                     
                                 }];
}

@end
