//
//  ShufflingScrollView.m
//  ShufflingScrollView
//
//  Created by suhengxian on 16/4/19.
//  Copyright © 2016年 Sugar. All rights reserved.
//

#import "ShufflingScrollView.h"
#import "SDWebImage/UIImageView+WebCache.h"

#define kURL(a)  [NSURL URLWithString:[NSString stringWithFormat:@"%@",a]]
#define DefaultImg [UIImage imageNamed:@""]
#define TIMEINTERVAL 3.0
#define FrameSizeWidth frame.size.width
#define FrameSizeHeight frame.size.height

@interface ShufflingScrollView ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIImageView *lastImgView;
@property (nonatomic,strong) UIImageView *currentImgView;
@property (nonatomic,strong) UIImageView *nextImgView;
@property (nonatomic,strong) NSMutableArray *showImgArrM;
@property (nonatomic,copy)   NSString *currentUrlStr;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger index;

@property (nonatomic,strong)UIPageControl *pageControl;
@end

@implementation ShufflingScrollView

- (instancetype)initWithFrame:(CGRect)frame withUrlArr:(NSArray *)arr{
    if (self=[super initWithFrame:frame]) {
        _urlStrArrM=[NSMutableArray arrayWithArray:arr];
        _showImgArrM=[NSMutableArray array];
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollView_Action_Click:)];
        [self addGestureRecognizer:tap];
  
        [self initSubViews];
        [self initData];
    }
    return self;
}

- (void)dealloc{
    if (_timer) {
        [_timer invalidate];
        _timer=nil;
    }
}

- (void)setUrlStrArrM:(NSMutableArray *)urlStrArrM{
    _urlStrArrM=[NSMutableArray arrayWithArray:urlStrArrM];
    [self initData];
}



- (void)initSubViews{
    _scrollView=[[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.delegate=self;
    _scrollView.contentSize=CGSizeMake(self.FrameSizeWidth*3, 0);
    _scrollView.showsVerticalScrollIndicator=NO;
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.scrollEnabled=NO;
    _scrollView.pagingEnabled=YES;
    [self addSubview:_scrollView];

    _lastImgView=[[UIImageView alloc] initWithFrame:_scrollView.bounds];
    _lastImgView.userInteractionEnabled=YES;
    [_scrollView addSubview:_lastImgView];
    
    _currentImgView=[[UIImageView alloc] initWithFrame:CGRectMake( _scrollView.FrameSizeWidth,0, _scrollView.FrameSizeWidth, _scrollView.FrameSizeHeight)];
    _currentImgView.userInteractionEnabled=YES;
    [_scrollView addSubview:_currentImgView];
    
    _nextImgView=[[UIImageView alloc] initWithFrame:CGRectMake( _scrollView.FrameSizeWidth*2, 0, _scrollView.FrameSizeWidth, _scrollView.FrameSizeHeight)];
    _nextImgView.userInteractionEnabled=YES;
    [_scrollView addSubview:_nextImgView];
    
    _pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(0,_scrollView.FrameSizeHeight-30, _scrollView.FrameSizeWidth, 20)];
    _pageControl.pageIndicatorTintColor=[UIColor whiteColor];
    _pageControl.currentPageIndicatorTintColor=[UIColor grayColor];
    _pageControl.userInteractionEnabled=NO;
    _pageControl.highlighted=YES;
    _pageControl.currentPage=0;
    [self addSubview:_pageControl];

}




- (void)initData{
    [_showImgArrM removeAllObjects];
    if (_urlStrArrM.count>1) {
         _pageControl.numberOfPages=_urlStrArrM.count;
        _pageControl.currentPage=0;
        _pageControl.hidden=NO;
    }else{
        _pageControl.hidden=YES;
    }
   
    
    
    if (_urlStrArrM.count==0) {
        _scrollView.scrollEnabled=NO;
        [_lastImgView sd_setImageWithURL:kURL(@"") placeholderImage:DefaultImg];
     
    }
    
    else if (_urlStrArrM.count==1){
        _scrollView.scrollEnabled=NO;
        for (NSInteger i=0; i<3; i++) {
            [_showImgArrM addObject:[_urlStrArrM firstObject]];
        }
        [self refreshImg];
    }
    
    else if (_urlStrArrM.count==2){
        _scrollView.scrollEnabled=YES;
        [_showImgArrM addObject:[_urlStrArrM lastObject]];
        [_showImgArrM addObject:[_urlStrArrM firstObject]];
        [_showImgArrM addObject:[_urlStrArrM lastObject]];
        _currentUrlStr=[_urlStrArrM firstObject];
        [self refreshImg];
    }
    
    else if (_urlStrArrM.count>2){
       _scrollView.scrollEnabled=YES;
        [_showImgArrM addObject:[_urlStrArrM lastObject]];
        [_showImgArrM addObject:[_urlStrArrM firstObject]];
        [_showImgArrM addObject:_urlStrArrM[1]];
       _currentUrlStr=[_urlStrArrM firstObject];
       [self refreshImg];
    }
    
    if (_scrollView.scrollEnabled) {
        if (_timer) {
            [_timer invalidate];
            _timer=nil;
        }
        [self setTimer];
    }
}

- (void)setTimer{
    _timer=[NSTimer scheduledTimerWithTimeInterval:TIMEINTERVAL target:self selector:@selector(scrollViewShuffling) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}


#pragma mark --scrolleView滚动相关

- (void)scrollViewShuffling{
    [_scrollView setContentOffset:CGPointMake(self.FrameSizeWidth*2, 0) animated:YES];
}

- (void)refreshImg{
    [_lastImgView sd_setImageWithURL:kURL(_showImgArrM[0]) placeholderImage:DefaultImg];
    [_currentImgView sd_setImageWithURL:kURL(_showImgArrM[1]) placeholderImage:DefaultImg];
    [_nextImgView sd_setImageWithURL:kURL(_showImgArrM[2]) placeholderImage:DefaultImg];
    [_scrollView setContentOffset:CGPointMake(self.FrameSizeWidth, 0) animated:NO];
}


- (NSString *)urlStrArrMNextORLastObj:(NSString *)obj isNext:(BOOL)isNext{
    NSString *urlStr=nil;
    for (NSInteger i=0; i<_urlStrArrM.count; i++) {
        if ([_urlStrArrM[i] isEqualToString:obj]) {
            if (isNext) {
                if(i==_urlStrArrM.count-1){
                    urlStr=[_urlStrArrM firstObject];
                }else{
                    urlStr=_urlStrArrM[i+1];
                }
            }else{
                if (i==0) {
                    urlStr=[_urlStrArrM lastObject];
                }else{
                    urlStr=_urlStrArrM[i-1];
                }
            }
            _index=i;
            _pageControl.currentPage=_index;
            return urlStr;
            break;
        }
    }
    return urlStr;
    
}


- (void)scrollViewMove{
    NSInteger count=(NSInteger)_scrollView.contentOffset.x/(NSInteger)_scrollView.FrameSizeWidth;
    if (count==0) {
        _currentUrlStr=[_showImgArrM firstObject];
    }
    else if(count==2){
        _currentUrlStr=[_showImgArrM lastObject];
    }
    [_showImgArrM replaceObjectAtIndex:1 withObject:_currentUrlStr];
    [_showImgArrM replaceObjectAtIndex:2 withObject:[self urlStrArrMNextORLastObj:_currentUrlStr isNext:YES]];
    [_showImgArrM replaceObjectAtIndex:0 withObject:[self urlStrArrMNextORLastObj:_currentUrlStr isNext:NO]];
    [self refreshImg];
}


#pragma mark --事件点击

- (void)scrollView_Action_Click:(UITapGestureRecognizer *)tap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shufflingScrollViewClick:)] && _urlStrArrM.count){
        [self.delegate shufflingScrollViewClick:_index];
    }
}



#pragma mark --ScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView==_scrollView) {
        [self scrollViewMove];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (scrollView==_scrollView) {
        [self scrollViewMove];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView==_scrollView && _timer) {
        [_timer invalidate];
        _timer=nil;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView==_scrollView && _timer==nil) {
        [self setTimer];
    }
}





@end
