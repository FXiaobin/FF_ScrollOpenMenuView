//
//  ScrollMenuView.h
//  FFScrollMenuView
//
//  Created by mac on 2018/9/19.
//  Copyright © 2018年 healifeGroup. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ScrollMenuView : UIView

@property (nonatomic,strong) UICollectionView *collectionView;


@property (nonatomic,strong) NSArray *dataArr;


@property (nonatomic,copy) void (^didSelectedIndexBlock) (ScrollMenuView *aMenuView,NSInteger index);



-(instancetype)initWithFrame:(CGRect)frame superView:(UIView *)superView;

@end
