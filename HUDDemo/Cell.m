//
//  Cell.m
//  HUDDemo
//
//  Created by Macx on 2018/3/20.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "Cell.h"

@interface Cell ()<UITextFieldDelegate> {
}

@end

@implementation Cell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _input = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, [UIScreen mainScreen].bounds.size.width - 20, 34)];
        _input.textColor = [UIColor blackColor];
        _input.borderStyle = UITextBorderStyleLine;
        _input.delegate = self;
        [self addSubview:_input];
    }
    return self;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
        if (_complete) {
            _complete(self);
        }
    return YES;
}
@end

