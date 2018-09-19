//
//  ScrollMenuView.m
//  FFScrollMenuView
//
//  Created by mac on 2018/9/19.
//  Copyright © 2018年 healifeGroup. All rights reserved.
//

#import "ScrollMenuView.h"
#import <Masonry.h>
#import "TagTitleCell.h"

#import <JQCollectionViewAlignLayout.h>

#define kHexColor(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kTagBtnTag      9583049
#define kScreenWidth      self.bounds.size.width

@interface ScrollMenuView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,JQCollectionViewAlignLayoutDelegate>


@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UIView *maskView;


@property (nonatomic,strong) UIView *shadowView;


@property (nonatomic,strong) UIButton *openBtn;

@property (nonatomic,strong) UIView *indicatorLine;


@property (nonatomic,assign) CGFloat defaultHeight;

@property (nonatomic,assign) NSInteger selectedIndex;

@property (nonatomic,strong) TagTitleCell *selectedCell;

@property (nonatomic,strong) UIButton *selectedBtn;





@end

@implementation ScrollMenuView

-(instancetype)initWithFrame:(CGRect)frame superView:(UIView *)superView{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.defaultHeight = CGRectGetHeight(frame);
        
        if (superView) {
            [superView addSubview:self.maskView];
            
            [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(superView).insets(UIEdgeInsetsMake(CGRectGetMaxY(frame), 0, 0, 0));
            }];
        }
        
        [self addSubview:self.collectionView];
        
        [self addSubview:self.shadowView];
        self.shadowView.frame = CGRectMake(0, 0, CGRectGetWidth(frame), self.defaultHeight);
        
        [self addSubview:self.openBtn];
        [self addSubview:self.scrollView];
        

        [self.openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.right.equalTo(self);
            make.width.and.height.mas_equalTo(CGRectGetHeight(frame));
        }];

        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.equalTo(self);
            make.right.equalTo(self.openBtn.mas_left);
            make.height.mas_equalTo(CGRectGetHeight(frame));
        }];

        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(CGRectGetHeight(frame), 0, 0, 0));
        }];
        
        
    }
    return self;
}

-(void)openBtnAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    
    self.maskView.hidden = !sender.selected;
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.frame;
        if (sender.selected) {
            CGFloat h = self.collectionView.contentSize.height;
            frame.size.height = h + self.defaultHeight;
        }else{
            frame.size.height = self.defaultHeight;
        }
        self.frame = frame;
    }];
    
    
    [UIView animateWithDuration:0.2 animations:^{
        [self layoutIfNeeded];
    }];
}

-(void)maskViewTap:(UITapGestureRecognizer *)sender{
    [self hiddenMenuView];
}

- (void)hiddenMenuView{
    
    self.maskView.hidden = YES;
    self.openBtn.selected = NO;
    
    CGRect frame = self.frame;
    frame.size.height = self.defaultHeight;
    self.frame = frame;
    [UIView animateWithDuration:0.2 animations:^{
        [self layoutIfNeeded];
    }];
}

-(void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    [self.collectionView reloadData];
}

///计算标题宽度
-(CGFloat)calculateString:(NSString *)str Width:(NSInteger)font{
    CGSize size = [str boundingRectWithSize:CGSizeMake(kScreenWidth, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:font]} context:nil].size;
    return size.width;
}

-(void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    [self.collectionView reloadData];
    
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
        self.selectedBtn = nil;
    }];
    
    CGFloat marginX = 15;
    CGFloat marginY = 10;
    CGFloat height = 30;
    
    for (int i = 0; i < dataArr.count; i++) {
        CGFloat width =  [self calculateString:dataArr[i] Width:14] + 20;
        UIButton * tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        tagBtn.tag = kTagBtnTag + i;
        [tagBtn setTitle:dataArr[i] forState:UIControlStateNormal];
        [tagBtn setTitleColor:kHexColor(0x838899) forState:UIControlStateNormal];
        [tagBtn setTitleColor:kHexColor(0x0078FF) forState:UIControlStateSelected];
        tagBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        tagBtn.frame = CGRectMake(marginX, marginY, width, height);
        
        marginX = marginX + width + 15;
        
        if (i == _selectedIndex) {
            [self.scrollView addSubview:self.indicatorLine];
            self.indicatorLine.frame = CGRectMake(CGRectGetMidX(tagBtn.frame) - 10, CGRectGetMaxY(tagBtn.frame), 20, 2.0);
            [self updateSelectedBtn:tagBtn];
        }
        
        [tagBtn addTarget:self action:@selector(clickTo:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.scrollView addSubview:tagBtn];
    }
    
    self.scrollView.contentSize = CGSizeMake(marginX, 50);
}

- (void)clickTo:(UIButton *)sender{
    
    [self updateSelectedBtn:sender];
    
    [self resetTabScrollViewContentOffset:sender];
    
    if (self.didSelectedIndexBlock) {
        self.didSelectedIndexBlock(self,_selectedIndex);
    }
}

///更新选中的标签
- (void)updateSelectedBtn:(UIButton *)sender{
    if (sender == self.selectedBtn) {
        return;
    }
    
    self.selectedBtn.selected = NO;
    sender.selected = YES;
    self.selectedBtn = sender;
    
    NSInteger tag = sender.tag - kTagBtnTag;
    self.selectedIndex = tag;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.indicatorLine.frame = CGRectMake(CGRectGetMidX(sender.frame) - 10, CGRectGetMaxY(sender.frame), 20, 2.0);
    }];
    
}

///点击item 修改tabScrollView的偏移量 滚动到中心
- (void)resetTabScrollViewContentOffset:(UIButton *)sender{
    
    //计算中间位置的偏移量
    CGFloat offSetX = sender.center.x - self.scrollView.bounds.size.width * 0.5;
    if (offSetX < 0) {
        offSetX = 0;
    }
    
    CGFloat maxOffset = self.scrollView.contentSize.width - self.scrollView.bounds.size.width;
    if (offSetX > maxOffset) {
        offSetX = maxOffset;
    }
    
    //滚动ScrollView
    [self.scrollView setContentOffset:CGPointMake(offSetX, 0) animated:YES];
}

- (JQCollectionViewItemAlignment)layout:(JQCollectionViewAlignLayout *)layout itemAlignmentInSection:(NSInteger)section{
    return JQCollectionViewItemAlignmentLeft;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TagTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TagTitleCell" forIndexPath:indexPath];

    cell.titleLabel.text = self.dataArr[indexPath.item];
    if (indexPath.item == _selectedIndex) {
        cell.titleLabel.textColor = [UIColor whiteColor];
        cell.titleLabel.backgroundColor = kHexColor(0x0078FF);
        self.selectedCell = cell;
    }else{
        cell.titleLabel.textColor = kHexColor(0x838899);
        cell.titleLabel.backgroundColor = kHexColor(0xf4f4f4);
    }
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat w = (kScreenWidth - 20 - 3 * 10) / 4.0;
    return CGSizeMake(w, 30);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    _selectedIndex = indexPath.item;
    
    TagTitleCell *cell = (TagTitleCell *)[collectionView cellForItemAtIndexPath:indexPath];
    self.selectedCell.titleLabel.textColor = kHexColor(0x838899);
    self.selectedCell.titleLabel.backgroundColor = kHexColor(0xf4f4f4);
    
    cell.titleLabel.textColor = [UIColor whiteColor];
    cell.titleLabel.backgroundColor = kHexColor(0x0078FF);
    
    self.selectedCell = cell;
    
    [self hiddenMenuView];
    
    UIButton *sender = (UIButton *)[self.scrollView viewWithTag:kTagBtnTag + indexPath.item];
    [self updateSelectedBtn:sender];
    [self resetTabScrollViewContentOffset:sender];
    
    if (self.didSelectedIndexBlock) {
        self.didSelectedIndexBlock(self,_selectedIndex);
    }
}

-(UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor whiteColor];
    }
    return _scrollView;
}

-(UICollectionView *)collectionView{
    if (_collectionView == nil) {
        JQCollectionViewAlignLayout *layout = [[JQCollectionViewAlignLayout alloc] init];
        layout.delegate = self;
        layout.minimumLineSpacing = 15;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(20, 10, 20, 10);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[TagTitleCell class] forCellWithReuseIdentifier:@"TagTitleCell"];
    }
    return _collectionView;
}

-(UIView *)maskView{
    if (_maskView == nil) {
        _maskView = [UIView new];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.3;
        _maskView.hidden = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskViewTap:)];
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}

-(UIButton *)openBtn{
    if (_openBtn == nil) {
        _openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _openBtn.backgroundColor = [UIColor orangeColor];
        [_openBtn addTarget:self action:@selector(openBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openBtn;
}

-(UIView *)indicatorLine{
    if (_indicatorLine == nil) {
        _indicatorLine = [UIView new];
        _indicatorLine.backgroundColor = kHexColor(0x0078FF);
        _indicatorLine.layer.cornerRadius = 1.0;
        _indicatorLine.clipsToBounds = YES;
    }
    return _indicatorLine;
}

-(UIView *)shadowView{
    if (_shadowView == nil) {
        _shadowView = [UIView new];
        _shadowView.backgroundColor = [UIColor whiteColor];
        _shadowView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        _shadowView.layer.shadowOffset = CGSizeMake(2.0, 2.0);
        _shadowView.layer.shadowRadius = 3.0;
        _shadowView.layer.shadowOpacity = 0.5;
    }
    return _shadowView;
}

@end
