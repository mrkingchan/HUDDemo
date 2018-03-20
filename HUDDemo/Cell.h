//
//  Cell.h
//  HUDDemo
//
//  Created by Macx on 2018/3/20.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Cell;
typedef void(^complete)(Cell *cell);

@interface Cell : UITableViewCell

@property(nonatomic,strong)UITextField *input;

@property(nonatomic,copy)complete complete;

@end
