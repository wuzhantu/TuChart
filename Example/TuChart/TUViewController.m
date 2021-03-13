//
//  TUViewController.m
//  TuChart
//
//  Created by wuzhantu on 04/26/2020.
//  Copyright (c) 2020 wuzhantu. All rights reserved.
//

#import "TUViewController.h"
#import "TuLineChart.h"
#define LXScreenW [UIScreen mainScreen].bounds.size.width

@interface TUViewController ()
@property (nonatomic, strong) TuLineChart *lineView;
@end

@implementation TUViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"kData" ofType:@"plist"];
    NSArray *kDataArr = [NSArray arrayWithContentsOfFile:path];
    kDataArr = [kDataArr subarrayWithRange:NSMakeRange(0, 20)];
    
    NSMutableArray *timestamp = [NSMutableArray array];
    NSMutableArray *closePriceArr = [NSMutableArray array];
    NSMutableArray *volumeArr = [NSMutableArray array];
    
    for (NSString *str in kDataArr) {
        NSArray *arr = [str componentsSeparatedByString:@","];
        [timestamp addObject:arr.firstObject];
        [closePriceArr addObject:arr[1]];
        [volumeArr addObject:arr.lastObject];
    }
    self.lineView.backgroundColor = [UIColor whiteColor];
    self.lineView.timestamp = timestamp;
    self.lineView.closePriceArr = closePriceArr;
    self.lineView.volumeArr = volumeArr;
    [self.view addSubview:self.lineView];
}

- (TuLineChart *)lineView {
    if (!_lineView) {
        _lineView = [[TuLineChart alloc] initWithFrame:CGRectMake(0, 200, LXScreenW, 310)];
    }
    return _lineView;
}

@end
