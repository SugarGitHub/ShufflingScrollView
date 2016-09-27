//
//  ShufflingScrollViewController.m
//  ShufflingScrollView
//
//  Created by suhengxian on 16/4/19.
//  Copyright © 2016年 Sugar. rights reserved.
//

#import "ShufflingScrollViewController.h"
#import "ShufflingScrollView.h"
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width


@interface ShufflingScrollViewController ()<ShufflingScrollViewDelegate>
@property (nonatomic,strong) ShufflingScrollView *scrollView;
@end

@implementation ShufflingScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}


- (void)initUI{
    NSArray *arr=@[@"http://a.hiphotos.baidu.com/image/pic/item/08f790529822720eac324afa79cb0a46f21fab36.jpg"];
    _scrollView=[[ShufflingScrollView alloc] initWithFrame:CGRectMake(0, 64+5, SCREEN_WIDTH, SCREEN_HEIGHT-64-80) withUrlArr:arr];
    _scrollView.delegate=self;
    [self.view addSubview:_scrollView];

    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100,SCREEN_HEIGHT-60, 100, 50);
    [btn setTitle:@"四张图片" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [btn addTarget:self action:@selector(btn_Action_Click) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor=[UIColor cyanColor];
    btn.layer.cornerRadius=3.0;
    btn.layer.masksToBounds=YES;
    [self.view addSubview:btn];
}

- (void)btn_Action_Click{
    NSArray *arr=@[@"http://a.hiphotos.baidu.com/image/pic/item/08f790529822720eac324afa79cb0a46f21fab36.jpg",@"http://b.hiphotos.baidu.com/image/pic/item/8d5494eef01f3a29b41f18fa9c25bc315c607c2b.jpg",@"http://a.hiphotos.baidu.com/image/pic/item/d1160924ab18972be4b49efde3cd7b899e510a7e.jpg",@"http://c.hiphotos.baidu.com/image/pic/item/f11f3a292df5e0fe23c7601e5e6034a85fdf72d6.jpg"];
    _scrollView.urlStrArrM=[NSMutableArray arrayWithArray:arr];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --ShufflingScrollViewDelegate
- (void)shufflingScrollViewClick:(NSInteger)index{
    NSLog(@"下标为%zi",index);
}




@end
