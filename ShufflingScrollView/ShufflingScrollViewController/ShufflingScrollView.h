//
//  ShufflingScrollView.h
//  ShufflingScrollView
//
//  Created by suhengxian on 16/4/19.
//  Copyright © 2016年 Sugar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShufflingScrollViewDelegate <NSObject>

- (void)shufflingScrollViewClick:(NSInteger)index;

@end

@interface ShufflingScrollView : UIView
@property (nonatomic,weak) id <ShufflingScrollViewDelegate> delegate;
@property (nonatomic,strong)NSMutableArray *urlStrArrM;

- (instancetype)initWithFrame:(CGRect)frame withUrlArr:(NSArray *)arr;
@end
