//
//  FirstView.m
//  JNScrollView
//
//  Created by admin on 2019/3/12.
//  Copyright © 2019 Jhinn1n. All rights reserved.
//

#import "FirstView.h"

@interface FirstView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation FirstView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
 
    }
    return self;
}



@end
