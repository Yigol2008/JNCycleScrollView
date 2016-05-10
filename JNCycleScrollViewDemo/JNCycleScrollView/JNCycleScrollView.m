//
//  JNCycleScrollView.m
//  JNCycleScrollViewDemo
//
//  Created by Yigol on 16/5/10.
//  Copyright © 2016年 Injoinow. All rights reserved.
//

#import "JNCycleScrollView.h"
#import "JNCycleScrollCell.h"
#import "UIImageView+WebCache.h"


static NSString *cellID = @"JNCycleCellIdentifier";
static const CGFloat kPageControlHeight = 30.0f;
static const CGFloat kItemsCoefficient = 500.0f;
static const NSTimeInterval kDefaultAutoScrollTimeInterval = 3.0f;


@interface JNCycleScrollView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *mainView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSArray *imageUrlsArray;
@property (nonatomic, assign) NSInteger totalItemsCount;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;


@end

@implementation JNCycleScrollView

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame imageURLs:(NSArray *)imageURLs
{
    JNCycleScrollView *cycleScrollView = [[JNCycleScrollView alloc] initWithFrame:frame];
    cycleScrollView.imageUrlsArray = imageURLs;
    return cycleScrollView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initCustomViews];
    }
    return self;
}

- (void)initCustomViews
{
    
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _flowLayout.itemSize = self.frame.size;
    _flowLayout.sectionInset = UIEdgeInsetsZero;
    _flowLayout.minimumLineSpacing = 0;
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _mainView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:_flowLayout];
    _mainView.delegate = self;
    _mainView.dataSource = self;
    _mainView.pagingEnabled = YES;
    _mainView.showsVerticalScrollIndicator = NO;
    _mainView.showsHorizontalScrollIndicator = NO;
    _mainView.backgroundColor = [UIColor lightGrayColor];
    [self.mainView registerClass:[JNCycleScrollCell class] forCellWithReuseIdentifier:cellID];
    [self addSubview:_mainView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.bounds.size.height + kPageControlHeight, self.bounds.size.width,kPageControlHeight)];
    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    //    _pageControl.backgroundColor = [UIColor redColor];
    [self addSubview:_pageControl];
    
    _autoScrollTimeInterval = kDefaultAutoScrollTimeInterval;
}

- (void)setImageUrlsArray:(NSArray *)imageUrlsArray
{
    _imageUrlsArray = imageUrlsArray;
    
    if (imageUrlsArray.count > 1) {
        _totalItemsCount = imageUrlsArray.count * kItemsCoefficient;
    } else {
        _totalItemsCount = imageUrlsArray.count;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _mainView.contentInset = UIEdgeInsetsZero;
    
    if (!self.imageUrlsArray.count) {
        return;
    }
    
    [self.mainView reloadData];
    
    self.pageControl.numberOfPages = self.imageUrlsArray.count;
    
    if (self.imageUrlsArray.count == 1) {
        self.mainView.scrollEnabled = NO;
        return;
    }
    
    if (self.mainView.contentOffset.x == 0 && self.totalItemsCount) {
        // 首先滚动到中间，方便以后的向前 向后滑动
        [self.mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.totalItemsCount/2 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    // 最小时间间隔为0.3s
    if (self.autoScrollTimeInterval >= 0.3) {
        [self setupTimer];
    }
}

- (void)setupTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:_autoScrollTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)automaticScroll
{
    if (!self.totalItemsCount) {
        return;
    }
    
    NSInteger currentIndex = self.mainView.contentOffset.x / self.bounds.size.width;
    NSInteger targetIndex = currentIndex + 1;
    //当滚动到最后一个的时候，马上回到中间
    if (targetIndex == self.totalItemsCount) {
        targetIndex = self.totalItemsCount/2;
        [self.mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
    [self.mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.totalItemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JNCycleScrollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    [cell.jnImageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrlsArray[indexPath.item % self.imageUrlsArray.count]]];
    self.pageControl.currentPage = indexPath.item % self.imageUrlsArray.count;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cycleScrollview:didSelectItemAtIndex:)]) {
        [self.delegate cycleScrollview:self didSelectItemAtIndex:indexPath.item % self.imageUrlsArray.count];
    }
}

#pragma mark - viewsMethod
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (_timer) {
        if (_timer.isValid) {
            [_timer invalidate];
            _timer = nil;
        }
    }
}

- (void)dealloc
{
    _mainView.delegate = nil;
    _mainView.dataSource = nil;
}

@end
