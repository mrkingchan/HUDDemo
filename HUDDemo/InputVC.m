//
//  InputVC.m
//  HUDDemo
//
//  Created by Macx on 2018/3/20.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "InputVC.h"
#import "Cell.h"
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface InputVC () <UITableViewDelegate,UITableViewDataSource> {
    UITableView *_tableView;
    CGRect _rect;
}

@end

@implementation InputVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:0];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShowAaction:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHideAction:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyBoardWillHideAction:(NSNotification *)noti {
    [UIView animateWithDuration:0.2 animations:^{
        self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [self.view layoutIfNeeded];
    }];
}

- (void)keyBoardWillShowAaction:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    CGFloat h = kScreenHeight - _rect.origin.y - _rect.size.height - height ;
    if (h < 0) {
        [UIView animateWithDuration:0.2 animations:^{
            self.view.frame = CGRectMake(0, h, kScreenWidth, kScreenHeight);
            [self.view layoutIfNeeded];
        }];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kcellID = @"cell";
    Cell *cell = [tableView dequeueReusableCellWithIdentifier:kcellID];
    if (!cell) {
        cell = [[Cell alloc] initWithStyle:0 reuseIdentifier:kcellID];
    }
    cell.complete = ^(Cell *cell) {
        //转换为self.view中的坐标
        _rect = [cell convertRect:cell.input.frame toView:self.view];
        NSLog(@"rectFrame = %@",NSStringFromCGRect(_rect));
    };
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    for (Cell *cell in _tableView.visibleCells) {
        [cell.input resignFirstResponder];
    }
}
@end
