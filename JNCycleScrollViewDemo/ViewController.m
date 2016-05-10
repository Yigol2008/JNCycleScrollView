//
//  ViewController.m
//  JNCycleScrollViewDemo
//
//  Created by Yigol on 16/5/10.
//  Copyright © 2016年 Injoinow. All rights reserved.
//

#import "ViewController.h"
#import "JNCycleScrollView.h"

@interface ViewController ()<JNCycleScrollViewDelegate>
{
    JNCycleScrollView *cycleScrollView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *imagesURL = @[@"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                           @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                           @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"];
    
    
    cycleScrollView = [JNCycleScrollView cycleScrollViewWithFrame:CGRectMake(5, 64, self.view.bounds.size.width - 20, 200) imageURLs:imagesURL];
    cycleScrollView.delegate = self;
    cycleScrollView.autoScrollTimeInterval = 3;
    
    [self.view addSubview:cycleScrollView];
    
}

- (void)cycleScrollview:(JNCycleScrollView *)cycleScrollview didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"-------------- %ld",(long)index);
}

@end
