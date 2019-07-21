//
//  ViewController.m
//  新闻类界面框架
//
//  Created by 吴伟毅 on 18/12/1.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "SlideViewController.h"

static NSInteger titleBtnTagMask = 11314;

@interface SlideViewController ()<UIScrollViewDelegate>

/** 标题滚动视图. */
@property (nonatomic,strong) UIScrollView *titleScrollView;
/** 内容滚动视图. */
@property (nonatomic,strong) UIScrollView *contentScrollView;
/** 上一次点击的标题按钮. */
@property (nonatomic,strong) UIButton *selectedBtn;
/** 标题按钮数组. */
@property (nonatomic,strong) NSMutableArray *titleBtns;
/** 标示是否第一次进来. */
@property (nonatomic,assign) BOOL isInitialize;
/** 当前选中的下标. */
@property (nonatomic,assign) NSInteger currenSelectIndex;

@end

@implementation SlideViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // 关闭iOS9的滚动视图预留可滚动区域
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 1.配置标题滚动视图
    [self setupTitleScrollView];
    
    // 2.配置内容滚动视图
    [self setupContentScrollView];
    
    self.scalingRatio = 1.3;
    self.currenSelectIndex = 0;
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if(_isInitialize == NO) {
        
        // 配置标题按钮
        [self setupTitleBtn];
        _isInitialize = YES;
        
    }
}

#pragma mark - 设置子控制器
-(void)setupChildControllers:(NSArray *)childControllers Titles:(NSArray *)titles {
    for(int i = 0; i < childControllers.count; i++) {
        UIViewController *childVc = childControllers[i];
        [childVc setTitle:titles[i]];
        [self addChildViewController:childVc];
    }
}


#pragma mark - 标题居中
- (void)setupTitleInCenter:(UIButton *)sender {
    
    // 计算偏移量
    CGFloat offsetX = sender.center.x - kScreenWidth * 0.5;
    CGFloat maxOffsetX = self.titleScrollView.contentSize.width - kScreenWidth;
    // 处理左边偏移
    if(offsetX < 0) {
        offsetX = 0;
    }
    // 处理右边偏移
    if(offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    // 修改标题滚动视图的偏移量
    [self.titleScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

#pragma mark - 配置标题按钮
- (void)setupTitleBtn {
    // 子控制器总数
    NSInteger count = self.childViewControllers.count;
    // 标题按钮宽度
    CGFloat btnW = kScreenWidth * 1.0/count;
    
    for(int i = 0; i < count; i++) {
        
        UIViewController *vc = self.childViewControllers[i];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(i * btnW, 0, btnW, _titleScrollView.frame.size.height)];
        btn.tag = titleBtnTagMask + i;
        [btn setTitle:vc.title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(didSelectTitleBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_titleScrollView addSubview:btn];
        
        if(0 == i) {
            
            // 默认选中第一个标题按钮
            [self didSelectTitleBtn:btn];
            
        }
        // 将标题按钮添加到数组中
        [self.titleBtns addObject:btn];
    }
    
    // 设置标题滚动视图的可滚动范围
    _titleScrollView.contentSize = CGSizeMake(count * btnW, 0);
    
    // 设置内容滚动视图的可滚动范围
    _contentScrollView.contentSize = CGSizeMake(count * kScreenWidth, 0);
}

#pragma mark - 添加子控制器的View
- (void)AddViewOfChildViewController:(NSInteger )index {
    
    // 1.拿到对应的ChildViewController
    UIViewController *vc = self.childViewControllers[index];
    
    // 如果已经添加过该子视图，就不需要再次添加了
    if(nil != vc.view.superview) {
        return;
    }
    
    // 2.配置vc的View
    [vc.view setFrame:CGRectMake(index * kScreenWidth, 0, kScreenWidth, _contentScrollView.bounds.size.height)];
    
    // 3.添加到内容滚动视图上
    [_contentScrollView addSubview:vc.view];
}
#pragma mark - 标题按钮点击处理
- (void)didSelectTitleBtn:(UIButton *)sender {
    
    // 获取角标
    NSInteger index = sender.tag - titleBtnTagMask;
    _currenSelectIndex = index;
    
    if(_selectedBtn != sender) {
        // 回复之前点击的按钮
        [_selectedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _selectedBtn.transform = CGAffineTransformIdentity;
    }
    
    // 1.改变标题颜色
    [sender setTitleColor:MainColor forState:UIControlStateNormal];
    
    // 2.添加对应的子视图
    [self AddViewOfChildViewController:index];
    
    // 3.标题居中
    [self setupTitleInCenter:sender];
    
    // 4.标题大小
    sender.transform = CGAffineTransformMakeScale(_scalingRatio, _scalingRatio);
    
    // 5.修改内容滚动视图偏移量
    _contentScrollView.contentOffset = CGPointMake(index * kScreenWidth, 0);
    
    _selectedBtn = sender;

}

#pragma mark - 配置标题滚动视图

- (void)setupTitleScrollView {
    
    UIScrollView *titleScrollView = [[UIScrollView alloc] init];
    titleScrollView.frame = CGRectMake(0, 0, kScreenWidth,ScaleH(44));
    titleScrollView.backgroundColor = [UIColor whiteColor];
    titleScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:titleScrollView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleScrollView.frame) - 1, kScreenWidth, 1)];
    line.backgroundColor = ColorRGBAll(230);
    [titleScrollView addSubview:line];
    
    _titleScrollView = titleScrollView;
    
}
#pragma mark - 配置内容滚动视图

- (void)setupContentScrollView {
    
    CGFloat height = CGRectGetMaxY(_titleScrollView.frame);
    
    UIScrollView *contentScrollView = [[UIScrollView alloc] init];
    contentScrollView.frame = CGRectMake(0,height, kScreenWidth,kScreenHeight - height);
    // 开启分页效果
    contentScrollView.pagingEnabled = YES;
    // 关闭弹簧效果
    contentScrollView.bounces = NO;
    // 关闭侧边条
    contentScrollView.showsHorizontalScrollIndicator = NO;
    contentScrollView.delegate = self;
    [self.view addSubview:contentScrollView];

    _contentScrollView = contentScrollView;
    
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if(scrollView == _contentScrollView) {
        // 滚动完成调用
        
        NSInteger i = scrollView.contentOffset.x / kScreenWidth;
        
        UIButton *btn = self.titleBtns[i];
        // 选中按钮
        [self didSelectTitleBtn:btn];
        // 添加对应的视图到内容滚动视图上
        [self AddViewOfChildViewController:i];
        // 标题居中
        [self setupTitleInCenter:btn];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if(scrollView == _contentScrollView) {
    
        // 获取左边按钮
        NSInteger leftI = scrollView.contentOffset.x / kScreenWidth;
        UIButton *leftBtn = _titleBtns[leftI];
        
        // 获取右边按钮
        NSInteger rightI = leftI + 1;
        UIButton *rightBtn;
        if(rightI < _titleBtns.count) {
            rightBtn = _titleBtns[rightI];
        }
        
        // 还原非这两个按钮的状态
        if(rightBtn) {
            for(UIButton *btn in _titleBtns) {
                if(btn != leftBtn && btn != rightBtn) {
                    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    btn.transform = CGAffineTransformIdentity;
                }
            }
        }
        
        // 获取左边缩放比例
        CGFloat scaleR = scrollView.contentOffset.x * 1.0 / kScreenWidth;
        scaleR -= leftI;
        // 获取右边缩放比例
        CGFloat scaleL = 1 - scaleR;

        /// 字体渐变
        
        // 获取缩放比例的整型部分
        NSInteger integer = self.scalingRatio;
        // 获取缩放比例的浮点部分
        CGFloat f = self.scalingRatio - integer;
        // 使用动画
        leftBtn.transform = CGAffineTransformMakeScale(scaleL*f + integer, scaleL*f + integer);
        rightBtn.transform = CGAffineTransformMakeScale(scaleR*f + integer, scaleR*f + integer);

        
        /// 颜色渐变 r:红 g:绿 b:蓝
        CGFloat red = scaleL * 96/255.0;
        CGFloat green  = scaleL * 170/255.0;
        CGFloat blue = scaleL * 252/255.0;

        [leftBtn setTitleColor:[UIColor colorWithRed:red green:green blue:blue alpha:1] forState:UIControlStateNormal];
        
        red = scaleR * 96/255.0;
        green  = scaleR * 170/255.0;
        blue = scaleR * 252/255.0;
        
        [rightBtn setTitleColor:[UIColor colorWithRed:red green:green blue:blue alpha:1] forState:UIControlStateNormal];

    }
}

#pragma mark - setter

-(NSMutableArray *)titleBtns {
    if(nil == _titleBtns) {
        _titleBtns = [NSMutableArray array];
    }
    return _titleBtns;
}

-(void)setTopTitle:(NSString *)topTitle {
    // 设置标题
    self.title = topTitle;
}

-(void)setScalingRatio:(CGFloat)scalingRatio {
    
    if(scalingRatio >= 2.0) {
        scalingRatio = 1.999;
    }
    // 注意，此时不能使用self.scalingRatio进行赋值，否则会造成坏内存访问，因为一只在调用set方法。
    _scalingRatio = scalingRatio;
    
}

- (CGFloat)getTotalHeight {
    return CGRectGetMaxY(_contentScrollView.frame);
}
@end
