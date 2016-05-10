//
//  JNCycleScrollView.h
//  JNCycleScrollViewDemo
//
//  Created by Yigol on 16/5/10.
//  Copyright © 2016年 Injoinow. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JNCycleScrollView;

@protocol JNCycleScrollViewDelegate <NSObject>

@optional
- (void)cycleScrollview:(JNCycleScrollView *)cycleScrollview didSelectItemAtIndex:(NSInteger)index;

@end


@interface JNCycleScrollView : UIView

/**
 *  @brief  代理
 */
@property (nonatomic, weak) id <JNCycleScrollViewDelegate> delegate;
/**
 *  @brief  图片循环滚动时间间隔，如果不设置，默认3s；如果设为0，表示不滚动
 */
@property (nonatomic, assign) NSTimeInterval autoScrollTimeInterval;

/**
 *  @brief  类方法创建
 *
 *  @param frame     自身的frame
 *  @param imageURLs 图片链接的数组
 *
 *  @return INCycleScrollView
 */
+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame
                               imageURLs:(NSArray *)imageURLs;


@end
