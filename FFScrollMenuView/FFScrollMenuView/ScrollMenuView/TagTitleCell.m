//
//  TagTitleCell.m
//  FFScrollMenuView
//
//  Created by mac on 2018/9/19.
//  Copyright © 2018年 healifeGroup. All rights reserved.
//

#import "TagTitleCell.h"
#import <Masonry.h>

#define kHexColor(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation TagTitleCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsZero);
        }];
        
    }
    return self;
}

-(UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = kHexColor(0x838899);
        _titleLabel.backgroundColor = kHexColor(0xf4f4f4);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.layer.cornerRadius = 15;
        _titleLabel.clipsToBounds = YES;
    }
    return _titleLabel;
}

@end
