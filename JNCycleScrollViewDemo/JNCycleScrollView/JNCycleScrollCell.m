//
//  JNCycleScrollCell.m
//  JNCycleScrollViewDemo
//
//  Created by Yigol on 16/5/10.
//  Copyright © 2016年 Injoinow. All rights reserved.
//

#import "JNCycleScrollCell.h"

@implementation JNCycleScrollCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _jnImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self.contentView addSubview:_jnImageView];
}

@end
