//
//  MoreCollectionViewCell.m
//  Advertising
//
//  Created by hht on 2018/5/30.
//  Copyright © 2018年 hht. All rights reserved.
//

#import "MoreCollectionViewCell.h"

@implementation MoreCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imagev];
        [self addSubview:self.deleteButton];
    }
    return self;
}

- (UIImageView *)imagev{
    if (!_imagev) {
        self.imagev = [[UIImageView alloc] initWithFrame:self.bounds];
        //        _imagev.backgroundColor = [UIColor blueColor];
    }
    return _imagev;
}
- (UIButton *)deleteButton{
    if (!_deleteButton) {
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.frame = CGRectMake(CGRectGetWidth(self.bounds)-20, 0, 20, 20);
        [_deleteButton setBackgroundImage:[UIImage imageNamed:@"common_del_circle@3x"] forState:UIControlStateNormal];
    }
    return _deleteButton;
}


@end
