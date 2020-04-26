//
//  TuLineChart.h
//  ChartLineDemo
//
//  Created by LianXiang on 2019/12/28.
//  Copyright © 2019 lianxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TuLineChart : UIView
@property (nonatomic, copy) NSArray *timestamp;
@property (nonatomic, copy) NSArray *closePriceArr;
@property (nonatomic, copy) NSArray *volumeArr;
//@property (nonatomic, assign) CGFloat trendViewHeight;
//@property (nonatomic, assign) CGFloat volumeViewHeight;

@end

NS_ASSUME_NONNULL_END
