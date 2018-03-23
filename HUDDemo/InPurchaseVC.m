//
//  InPurchaseVC.m
//  HUDDemo
//
//  Created by Macx on 2018/3/23.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "InPurchaseVC.h"
#import <StoreKit/StoreKit.h>

@interface InPurchaseVC ()<SKProductsRequestDelegate,SKRequestDelegate,SKPaymentTransactionObserver> {
    SKProductsRequest *_request;
}

@end

@implementation InPurchaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSSet  *set = [NSSet  setWithArray:@[@"就是你在iTunes Connect上的内购项目的产品ID"]];
    _request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    _request.delegate = self;
    //开始请求 向appstore发送购买请求
    [_request start];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

//接收appstore给的响应
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSLog(@"products = %@",response.products);
    
    for (SKProduct *pro in response.products) {
        NSLog(@"productDetails = %@\n%@\n%@\n%@\n%@\n",
              pro.localizedDescription,
              pro.localizedTitle,
              pro.priceLocale,
              pro.price,
              pro.productIdentifier
              );
        //addPayment 将支付信息添加进苹果的支付队列后，苹果会自动完成后续的购买请求，在用户购买成功或者点击取消购买的选项后回调
        SKPayment *pament = [SKPayment paymentWithProduct:pro];
        [[SKPaymentQueue defaultQueue] addPayment:pament];
    }
}

//购买之后的回调
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    for (SKPaymentTransaction *tran in transactions) {
        switch (tran.transactionState) {
                /*SKPaymentTransactionStatePurchasing,
                SKPaymentTransactionStatePurchased,
                SKPaymentTransactionStateFailed,
                SKPaymentTransactionStateRestored,
                SKPaymentTransactionStateDeferred*/
            case 0 :
                NSLog(@"购买ing");
                break;
                case 1:
                break;
            default:
                break;
        }
    }
}
@end
