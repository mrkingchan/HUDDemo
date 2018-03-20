//
//  AppDelegate.m
//  HUDDemo
//
//  Created by Macx on 2018/3/6.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "URLProtocol.h"
#import <AFNetworking.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //拦截所有的网络请求
    [NSURLProtocol registerClass:[URLProtocol class]];
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor whiteColor];
    ViewController *VC = [ViewController new];
    UINavigationController *rootVC = [[UINavigationController alloc] initWithRootViewController:VC];
    _window.rootViewController = rootVC;
    [_window makeKeyAndVisible];
    
    /*1149683958
    1179661258*/
    [self checkUpdateWithAppID:@"1179661258"
                       success:^(NSDictionary *resultDic, BOOL isNewVersion, NSString *newVersion, NSString *currentVersion) {
                           NSURL *downLoadUrl = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/%E9%92%B1%E5%AF%8C%E9%80%9A%E7%90%86%E8%B4%A2/id1163975284?mt=8"];
                           if ([[UIApplication sharedApplication] canOpenURL:downLoadUrl]) {
                               [[UIApplication sharedApplication] openURL:downLoadUrl];
                           }
                          /* NSLog(@"currentVersion = %@ isNewVersion = %d",currentVersion,isNewVersion);
                           NSLog(@"resultDic = %@",resultDic);
                           for ( NSString *key in resultDic.allKeys) {
                               id value = [resultDic objectForKey:key];
                               NSLog(@"value = %@",value);
                               if ([value isKindOfClass:[NSDictionary class]]) {
                                   for (NSString *subKey in ((NSDictionary *)value).allKeys) {
                                       id subValue = [((NSDictionary *)value) objectForKey:subKey];
                                       NSLog(@"subValue = %@",subValue);
                                   }
                               }
                           }*/
                       } failure:^(NSError *error) {
                           NSLog(@"errorDescrption = %@",error.localizedDescription);
                       }];
    return YES;
}

- (void)checkUpdateWithAppID:(NSString *)appID success:(void (^)(NSDictionary *resultDic , BOOL isNewVersion ,NSString * newVersion , NSString * currentVersion))success failure:(void (^)(NSError *error))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    NSString *encodingUrl=[[@"http://itunes.apple.com/lookup?id=" stringByAppendingString:appID]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:encodingUrl parameters:nil progress:^(NSProgress *_Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        //获取AppStore的版本号
        NSString * versionStr =[[[resultDic objectForKey:@"results"]objectAtIndex:0]valueForKey:@"version"];
        
        NSString *versionStr_int= [versionStr stringByReplacingOccurrencesOfString:@"."withString:@""];
        int version=[versionStr_int integerValue];
        //获取本地的版本号
        NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
        
        NSString * currentVersion = [infoDic valueForKey:@"CFBundleShortVersionString"];
        
        NSString *currentVersion_int=[currentVersion stringByReplacingOccurrencesOfString:@"."withString:@""];
        
        int current=[currentVersion_int intValue];
        
        //线上版本>本地版本
        if (version>current) {
            success(resultDic,YES, versionStr,currentVersion);
        }else{
            //线上版本=本地版本 不需要更新
            success(resultDic,NO ,versionStr,currentVersion);
        }
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        failure(error);
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
