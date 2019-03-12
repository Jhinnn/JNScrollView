//
//  ViewController.m
//  JNScrollView
//
//  Created by admin on 2019/3/12.
//  Copyright © 2019 Jhinn1n. All rights reserved.
//

#import "ViewController.h"
#import "FirstView.h"
#import "View1TableViewCell.h"
#define StatusBarH [[UIApplication sharedApplication] statusBarFrame].size.height
#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H  [UIScreen mainScreen].bounds.size.height
#define SafeAreaBottomHeight (SCREEN_H == 812.0 ? 34 : 0)//底部安全区域的高度
#define kUIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) UIView *homeHeadView;
@property (nonatomic, strong) UIScrollView *topScrollView;
@property (nonatomic, strong) UIView *topBgView;
@property (nonatomic, strong) UILabel *lineLbl;

@property (nonatomic, strong) UIScrollView *bodyScrollView;

@property (nonatomic, strong) UIView *body1View;
@property (nonatomic, strong) UIView *body2View;
@property (nonatomic, strong) UIView *body3View;
@property (nonatomic, strong) UIView *body4View;

@property (nonatomic, strong) UITableView *tableView1;

@end

static const NSInteger kTopScrollViewW = 240;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createBaseData];
    [self createBaseUI];
    [self setUpView1];
}

- (void)createBaseData {
    self.titleArray = @[@"宝贝",@"评价",@"详情",@"推荐"];
}

- (void)createBaseUI {
    self.homeHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, StatusBarH + 44)];
    self.homeHeadView.backgroundColor = kUIColorFromRGB(0xf5f5f5);
    [self.view addSubview:self.homeHeadView];
    
    self.topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake((SCREEN_W - kTopScrollViewW)/2, StatusBarH, kTopScrollViewW, 44)];
    self.topScrollView.showsVerticalScrollIndicator = NO;
    self.topScrollView.showsHorizontalScrollIndicator = NO;
    self.topScrollView.pagingEnabled = YES;
    self.topScrollView.scrollEnabled = NO;
    self.topScrollView.backgroundColor = [UIColor clearColor];
    self.topScrollView.contentSize = CGSizeMake(kTopScrollViewW, 44);
    [self.homeHeadView addSubview:self.topScrollView];
    
    self.topBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kTopScrollViewW, 44)];
    [self.topScrollView addSubview:self.topBgView];
    
    
    for (int i = 0; i < self.titleArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kTopScrollViewW/self.titleArray.count * i, 0, kTopScrollViewW/self.titleArray.count, 40);
        [btn setTitle:self.titleArray[i] forState:UIControlStateNormal];
        btn.tag = 700 + i;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        if (i == 0) {
            [btn setTitleColor:kUIColorFromRGB(0xf04244) forState:UIControlStateNormal];
        }else {
            [btn setTitleColor:kUIColorFromRGB(0x999999) forState:UIControlStateNormal];
            
        }
        [btn addTarget:self action:@selector(headChangeAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor clearColor];
        [self.topBgView addSubview:btn];
    }
    
    self.lineLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 42, 40, 2)];
    self.lineLbl.center = CGPointMake(self.topBgView.frame.size.width / self.titleArray.count / 2, 43);
    self.lineLbl.backgroundColor = kUIColorFromRGB(0xf04244);
    [self.topBgView addSubview:self.lineLbl];
    
    // 内容视图
    self.bodyScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, StatusBarH + 44, SCREEN_W, SCREEN_H - StatusBarH - 44 - SafeAreaBottomHeight)];
    self.bodyScrollView.showsVerticalScrollIndicator = NO;
    self.bodyScrollView.showsHorizontalScrollIndicator = NO;
    self.bodyScrollView.pagingEnabled = YES;
    self.bodyScrollView.delegate = self;
    self.bodyScrollView.contentSize = CGSizeMake(SCREEN_W * self.titleArray.count, SCREEN_H - StatusBarH - 44 - SafeAreaBottomHeight);
    [self.view addSubview:self.bodyScrollView];
    
    
    self.body1View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H - StatusBarH - 44 - SafeAreaBottomHeight)];
    self.body1View.backgroundColor = [UIColor whiteColor];
    [self.bodyScrollView addSubview:self.body1View];
    
    self.body2View = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_W, 0, SCREEN_W, SCREEN_H - StatusBarH - 44 - SafeAreaBottomHeight)];
    self.body2View.backgroundColor = [UIColor blueColor];
    [self.bodyScrollView addSubview:self.body2View];
    
    
    self.body3View = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_W * 2, 0, SCREEN_W, SCREEN_H - StatusBarH - 44 - SafeAreaBottomHeight)];
    self.body3View.backgroundColor = [UIColor brownColor];
    [self.bodyScrollView addSubview:self.body3View];
    
    self.body4View = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_W * (self.titleArray.count - 1), 0, SCREEN_W, SCREEN_H - StatusBarH - 44 - SafeAreaBottomHeight)];
    self.body4View.backgroundColor = [UIColor yellowColor];
    [self.bodyScrollView addSubview:self.body4View];
    
}

- (void)setUpView1 {
    self.tableView1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 100, SCREEN_H - StatusBarH - 44 - SafeAreaBottomHeight) style:UITableViewStylePlain];
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;
    self.tableView1.showsHorizontalScrollIndicator = NO;
    self.tableView1.showsVerticalScrollIndicator = NO;
    self.tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView1.backgroundColor = [UIColor whiteColor];
    [self.tableView1 registerNib:[UINib nibWithNibName:@"View1TableViewCell" bundle:nil] forCellReuseIdentifier:@"View1TableViewCell"];
    self.tableView1.rowHeight = 50;
    [self.body1View addSubview:self.tableView1];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    View1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"View1TableViewCell" forIndexPath:indexPath];
    cell.textLbl.text = [NSString stringWithFormat:@"%ld行",indexPath.row];
    if(self.selectIndex == indexPath.row)
    {
        cell.backgroundColor = kUIColorFromRGB(0xf5f5f5);
        cell.textLbl.textColor = kUIColorFromRGB(0xea413c);
        
    }
    else
    {
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLbl.textColor = kUIColorFromRGB(0x333333);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectIndex=(int)indexPath.row;
    [self.tableView1 reloadData];
    
}

//  减速停止的时候开始执行
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    for (int i = 0; i < self.titleArray.count; i++) {
        UIButton *btn = [self.topBgView viewWithTag:700 + i];
        [btn setTitleColor:kUIColorFromRGB(0x999999) forState:UIControlStateNormal];
    }
    UIButton *btn = [self.topBgView viewWithTag:700 + (self.bodyScrollView.contentOffset.x/SCREEN_W)];
    [btn setTitleColor:kUIColorFromRGB(0xf04244) forState:UIControlStateNormal];
    [UIView animateWithDuration:0.2 animations:^{
        self.lineLbl.center = CGPointMake(btn.center.x, self.lineLbl.center.y);
    }];
}

- (void)headChangeAction:(UIButton *)sender {
    for (int i = 0; i < self.titleArray.count; i++) {
        UIButton *btn = [self.topBgView viewWithTag:700 + i];
        [btn setTitleColor:kUIColorFromRGB(0x999999) forState:UIControlStateNormal];
    }
    [sender setTitleColor:kUIColorFromRGB(0xf04244) forState:UIControlStateNormal];
    [UIView animateWithDuration:0.2 animations:^{
        self.lineLbl.center = CGPointMake(sender.center.x, self.lineLbl.center.y);
    }];
    
    [self.bodyScrollView setContentOffset:CGPointMake((sender.tag - 700) * SCREEN_W, 0)];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
