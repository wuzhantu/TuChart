//
//  TuLineChart.m
//  ChartLineDemo
//
//  Created by LianXiang on 2019/12/28.
//  Copyright © 2019 lianxiang. All rights reserved.
//

#import "TuLineChart.h"
#import "NSString+LXExtension.h"

#define LXHexColor(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0 green:((float)((hexValue & 0xFF00) >> 8)) / 255.0 blue:((float)(hexValue & 0xFF)) / 255.0 alpha:1.0f]
#define LXHexColorWithAlpha(hexValue, a) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0 green:((float)((hexValue & 0xFF00) >> 8)) / 255.0 blue:((float)(hexValue & 0xFF)) / 255.0 alpha:a]

@interface TuLineChart()
{
    CGFloat _trendViewHeight;
    CGFloat _volumeViewHeight;
    CGFloat _rightTimeWidth;
    CGFloat _perWidth;
    CGFloat _lineGap;
    CGFloat _lineWidth;
    CGFloat _trendTopMargin;
    CGFloat _trendBottomMargin;
    CGFloat _volumeTopMargin;
    CGFloat _volumeBottomMargin;
    CGPoint _panStartPoint;
}
@property (nonatomic, assign) CGFloat maxValue;
@property (nonatomic, assign) CGFloat minValue;
@property (nonatomic, assign) CGFloat maxVolume;
@property (nonatomic, assign) CGFloat minVolume;

@property (nonatomic, strong) UIView *mainView;

@property (nonatomic, strong) CAShapeLayer *strokeLayer;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) CAShapeLayer *fillLayer;

@property (nonatomic, strong) UIView *rightVBgiew;

@property (nonatomic, strong) UILabel *YLabelOne;
@property (nonatomic, strong) UILabel *YLabelTwo;
@property (nonatomic, strong) UILabel *YLabelThree;
@property (nonatomic, strong) UILabel *YLabelFour;

@property (nonatomic, strong) UILabel *YVolumeLabelOne;
@property (nonatomic, strong) UILabel *YVolumeLabelTwo;
@property (nonatomic, strong) UILabel *YVolumeLabelThree;

@property (nonatomic, strong) UILabel *label_t_0;
@property (nonatomic, strong) UILabel *label_t_1;
@property (nonatomic, strong) UILabel *label_t_2;
@property (nonatomic, strong) UILabel *label_t_3;
@property (nonatomic, strong) UILabel *label_t_4;
@property (nonatomic, strong) UILabel *label_t_5;
@property (nonatomic, strong) UILabel *label_t_6;

@property (nonatomic, strong) UILabel *selectedVolumeLabel;

@property (nonatomic, strong) UIView *rowLine;
@property (nonatomic, strong) UIView *columnLine;
@property (nonatomic, strong) UILabel *selectedClosePriceLabel;
@property (nonatomic, strong) UILabel *selectedTimeLab;

@property (nonatomic, strong) UIView *dottedLine;
@property (nonatomic, strong) UILabel *latestClosePriceLabel;

@property (nonatomic, strong) NSMutableArray *volumeViewCacheArr;
@end

@implementation TuLineChart

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _trendViewHeight = 203 / 310.0 * frame.size.height;
        _volumeViewHeight = (310 - 203) / 310.0 * frame.size.height;
        _rightTimeWidth = 44.f;
        _trendTopMargin = 20;
        _trendBottomMargin = 20;
        _volumeTopMargin = 22.f;
        _volumeBottomMargin = 25.f;
        [self addGestureRecognizer];
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    for (NSInteger i = 0; i < 4; i++) {
        UIView *rowLine = [[UIView alloc] initWithFrame:CGRectMake(0, (i + 1) / 5.0 * _trendViewHeight, self.frame.size.width - _rightTimeWidth, .5)];
        rowLine.backgroundColor = LXHexColor(0xECECEC);
        [self addSubview:rowLine];
    }
    
    for (NSInteger j = 0; j < 2; j++) {
        UIView *columnLine = [[UIView alloc] initWithFrame:CGRectMake(0, _trendViewHeight + (j + 1) / 3.0 * (_volumeViewHeight - _volumeBottomMargin), self.frame.size.width - _rightTimeWidth, .5)];
        columnLine.backgroundColor = LXHexColor(0xECECEC);
        [self addSubview:columnLine];
    }
    
    [self addSubview:self.dottedLine];
    
    [self addSubview:self.mainView];
    
    [self addSubview:self.rightVBgiew];
    
    [self.rightVBgiew addSubview:self.YLabelOne];
    [self.rightVBgiew addSubview:self.YLabelTwo];
    [self.rightVBgiew addSubview:self.YLabelThree];
    [self.rightVBgiew addSubview:self.YLabelFour];
    
    [self.rightVBgiew addSubview:self.YVolumeLabelOne];
    [self.rightVBgiew addSubview:self.YVolumeLabelTwo];
    [self.rightVBgiew addSubview:self.YVolumeLabelThree];
    
    [self addSubview:self.selectedVolumeLabel];
    
    [self addSubview:self.label_t_0];
    [self addSubview:self.label_t_1];
    [self addSubview:self.label_t_2];
    [self addSubview:self.label_t_3];
    [self addSubview:self.label_t_4];
    [self addSubview:self.label_t_5];
    [self addSubview:self.label_t_6];
    
    [self addSubview:self.latestClosePriceLabel];
    
    UIView *topRowLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, .5)];
    topRowLine.backgroundColor = LXHexColor(0xDEDEDE);
    [self addSubview:topRowLine];
    
    UIView *middleRowLine = [[UIView alloc] initWithFrame:CGRectMake(0, _trendViewHeight, self.frame.size.width, .5)];
    middleRowLine.backgroundColor = LXHexColor(0xDEDEDE);
    [self addSubview:middleRowLine];
    
    UIView *bottomRowLine = [[UIView alloc] initWithFrame:CGRectMake(0, _trendViewHeight + _volumeViewHeight - _volumeBottomMargin + 2, self.frame.size.width - _rightTimeWidth, .5)];
    bottomRowLine.backgroundColor = LXHexColor(0xDEDEDE);
    [self addSubview:bottomRowLine];
    
    UIView *rightColumnLine = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - _rightTimeWidth, 0, 0.5, _trendViewHeight + _volumeViewHeight - _volumeBottomMargin + 2 + 0.5)];
    rightColumnLine.backgroundColor = LXHexColor(0xDEDEDE);
    [self addSubview:rightColumnLine];
}

- (void)addGestureRecognizer {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.mainView addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [self.mainView addGestureRecognizer:longPress];

    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
    [self.mainView addGestureRecognizer:pinch];

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [self.mainView addGestureRecognizer:pan];
}

- (void)setVolumeArr:(NSArray *)volumeArr {
    _volumeArr = [volumeArr copy];
    
    self.rowLine.hidden = YES;
    self.columnLine.hidden = YES;
    
    self.selectedClosePriceLabel.hidden = YES;
    self.selectedTimeLab.hidden = YES;
    
    self.selectedVolumeLabel.text = [NSString stringWithFormat:@"%@：%@", NSLocalizedString(@"成交量", nil), [NSString lx_unitPrice:volumeArr[volumeArr.count - 1]]];
    
    _lineGap = (self.frame.size.width - _rightTimeWidth) / (self.closePriceArr.count * 4 + 1);
    _perWidth = (self.frame.size.width - _rightTimeWidth - _lineGap * 3 - _lineGap * 2) / (self.closePriceArr.count - 1);
    _lineWidth = _perWidth - _lineGap;
    
    CGFloat max = 0;
    CGFloat min = MAXFLOAT;
    CGFloat maxVolume = 0;
    CGFloat minVolume = MAXFLOAT;
    
    for (NSInteger i = 0; i < self.closePriceArr.count; i++) {
        NSString *priceStr = self.closePriceArr[i];
        max = [priceStr floatValue] > max ? [priceStr floatValue] : max;
        min = [priceStr floatValue] < min ? [priceStr floatValue] : min;
        
        NSString *volumeStr = self.volumeArr[i];
        maxVolume = [volumeStr floatValue] > maxVolume ? [volumeStr floatValue] : maxVolume;
        minVolume = [volumeStr floatValue] < minVolume ? [volumeStr floatValue] : minVolume;
    }
    self.maxValue = max;
    self.minValue = min;
    
    self.maxVolume = maxVolume;
    self.minVolume = minVolume;
    
    [self drawTrendView];
    [self drawVolumeView];
    [self setLabData];
    [self drawDottedLine];
}

- (void)drawTrendView {
    //数据换算成坐标
    NSMutableArray *pointYArr = [NSMutableArray array];
    CGFloat highPointY = _trendTopMargin;
    CGFloat lowPointY = _trendViewHeight - _trendBottomMargin;
    CGFloat perValue = (_maxValue - _minValue) / (lowPointY - highPointY);
    
    UIBezierPath *strokePath = [UIBezierPath bezierPath];
    UIBezierPath *fillPath = [UIBezierPath bezierPath];
    [fillPath moveToPoint:CGPointMake(_lineGap + _lineWidth * 0.5, _trendViewHeight)];
    
    for (NSInteger i = 0; i < self.closePriceArr.count; i++) {
        CGFloat closePrice = [self.closePriceArr[i] floatValue];
        
        CGFloat pointY = 0.0;
        if (perValue > 0) {
            pointY = highPointY + (_maxValue - closePrice) / perValue;
        }
        
        [pointYArr addObject:@(pointY)];
        CGFloat pointX = _lineGap + _lineWidth * 0.5 + _perWidth * i;
        CGPoint point = CGPointMake(pointX, pointY);
        if (i == 0) {
            [strokePath moveToPoint:point];
        } else {
            [strokePath addLineToPoint:point];
        }
        [fillPath addLineToPoint:point];
    }
    
    [fillPath addLineToPoint:CGPointMake(self.frame.size.width - _rightTimeWidth - _lineGap - _lineWidth * 0.5, _trendViewHeight)];
    [fillPath closePath];
    
    self.strokeLayer.path = strokePath.CGPath;
    self.fillLayer.path = fillPath.CGPath;
}

- (void)drawVolumeView {

    CGFloat highPointY = _trendViewHeight + _volumeTopMargin;
    CGFloat lowPointY = _trendViewHeight + _volumeViewHeight - _volumeBottomMargin;
    CGFloat perValue = (_maxVolume - 0) / (lowPointY - highPointY);
    
    for (UIView *view in self.volumeViewCacheArr) {
        if (view.superview) {
            [view removeFromSuperview];
        }
    }
    
    for (NSInteger i = 0; i < self.volumeArr.count; i++) {
        CGFloat volume = [self.volumeArr[i] floatValue];
        
        CGFloat pointY = 0.0, lineHeight = 0.0;
        if (perValue > 0) {
            pointY = highPointY + (_maxVolume - volume) / perValue;
            lineHeight = lowPointY - pointY;
        }
        
        UIView *line;
        if (i < self.volumeViewCacheArr.count) {
            line = self.volumeViewCacheArr[i];
        } else {
            line = [[UIView alloc] init];
            [self.volumeViewCacheArr addObject:line];
        }
        
        line.frame = CGRectMake(_lineGap + (_lineGap + _lineWidth) * i, pointY, _lineWidth, lineHeight);
        line.backgroundColor = LXHexColor(0x4697ED);
        [self.mainView addSubview:line];
    }
}

- (void)setLabData {
    
    {
        CGFloat highPointY = _trendTopMargin;
        CGFloat lowPointY = _trendViewHeight - _trendBottomMargin;
        CGFloat perValue = (_maxValue - _minValue) / (lowPointY - highPointY);
        
        self.YLabelOne.text = [NSString stringWithFormat:@"%.2f", _maxValue + (highPointY - self.YLabelOne.frame.origin.y - 6.5) * perValue];
        self.YLabelTwo.text = [NSString stringWithFormat:@"%.2f", _maxValue + (highPointY - self.YLabelTwo.frame.origin.y - 6.5) * perValue];
        self.YLabelThree.text = [NSString stringWithFormat:@"%.2f", _maxValue + (highPointY - self.YLabelThree.frame.origin.y - 6.5) * perValue];
        self.YLabelFour.text = [NSString stringWithFormat:@"%.2f", _maxValue + (highPointY - self.YLabelFour.frame.origin.y - 6.5) * perValue];
    }
    
    {
        CGFloat highPointY = _trendViewHeight + _volumeTopMargin;
        CGFloat lowPointY = _trendViewHeight + _volumeViewHeight - _volumeBottomMargin;
        CGFloat perValue = (_maxVolume - 0) / (lowPointY - highPointY);
        self.YVolumeLabelOne.text = [NSString lx_unitPrice:@(_maxVolume + (highPointY - self.YVolumeLabelOne.frame.origin.y - 6.5) * perValue)];
        self.YVolumeLabelTwo.text = [NSString lx_unitPrice:@(_maxVolume + (highPointY - self.YVolumeLabelTwo.frame.origin.y - 6.5) * perValue)];
    }
    
    CGFloat timeWidth = 30.0f;
    CGFloat gap = (self.frame.size.width -_rightTimeWidth - timeWidth * 7 - 2 - 2) / 6;

    NSUInteger count = self.timestamp.count;
    CGFloat gapNum = count / 6.0;
    CGFloat timeLabOriginY = self.frame.size.height - 19;
    self.label_t_0.frame = CGRectMake(2, timeLabOriginY, timeWidth, 13);
    self.label_t_0.textAlignment = NSTextAlignmentLeft;
    self.label_t_0.text = [self lx_timeWithFormat:self.timestamp.firstObject];
    
    self.label_t_1.frame = CGRectMake(CGRectGetMaxX(self.label_t_0.frame)+gap, timeLabOriginY, timeWidth, 13);
    self.label_t_1.textAlignment = NSTextAlignmentCenter;
    self.label_t_1.text = [self lx_timeWithFormat:self.timestamp[(NSUInteger)gapNum]];
    
    self.label_t_2.frame = CGRectMake(CGRectGetMaxX(self.label_t_1.frame)+gap, timeLabOriginY, timeWidth, 13);
    self.label_t_2.textAlignment = NSTextAlignmentCenter;
    self.label_t_2.text = [self lx_timeWithFormat:self.timestamp[(NSUInteger)(gapNum * 2)]];
    
    self.label_t_3.frame = CGRectMake(CGRectGetMaxX(self.label_t_2.frame)+gap, timeLabOriginY, timeWidth, 13);
    self.label_t_3.textAlignment = NSTextAlignmentCenter;
    self.label_t_3.text = [self lx_timeWithFormat:self.timestamp[(NSUInteger)(gapNum * 3)]];
    
    self.label_t_4.frame = CGRectMake(CGRectGetMaxX(self.label_t_3.frame)+gap, timeLabOriginY, timeWidth, 13);
    self.label_t_4.textAlignment = NSTextAlignmentCenter;
    self.label_t_4.text = [self lx_timeWithFormat:self.timestamp[(NSUInteger)(gapNum * 4)]];
    
    self.label_t_5.frame = CGRectMake(CGRectGetMaxX(self.label_t_4.frame)+gap, timeLabOriginY, timeWidth, 13);
    self.label_t_5.textAlignment = NSTextAlignmentCenter;
    self.label_t_5.text = [self lx_timeWithFormat:self.timestamp[(NSUInteger)(gapNum * 5)]];
    
    self.label_t_6.frame = CGRectMake(CGRectGetMaxX(self.label_t_5.frame)+gap, timeLabOriginY, timeWidth, 13);
    self.label_t_6.textAlignment = NSTextAlignmentRight;
    self.label_t_6.text = [self lx_timeWithFormat:self.timestamp.lastObject];
    
}

- (void)drawDottedLine {
    
    CGFloat highPointY = _trendTopMargin;
    CGFloat lowPointY = _trendViewHeight - _trendBottomMargin;
    CGFloat perValue = (_maxValue - _minValue) / (lowPointY - highPointY);
    
    CGFloat closePrice = [self.closePriceArr[self.closePriceArr.count - 1] floatValue];
    CGFloat pointY = highPointY + (_maxValue - closePrice) / perValue;
    
    self.dottedLine.frame = CGRectMake(0, pointY, self.frame.size.width - _rightTimeWidth, .5);
    
    self.latestClosePriceLabel.frame = CGRectMake(CGRectGetMaxX(self.dottedLine.frame), pointY - 7.5, 44, 15);
    self.latestClosePriceLabel.text = [NSString stringWithFormat:@" %.2f", closePrice];
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    [self printState:tap];
    CGPoint point = [tap locationInView:self.mainView];
    
//    if (point.x > self.frame.size.width - _rightTimeWidth || point.y > self.frame.size.height - _volumeBottomMargin) {
//        return;
//    }
    
    NSInteger index = 0;
    if (point.x < _lineGap) {
        index = 0;
    } else if (point.x > self.frame.size.width - _rightTimeWidth - _lineGap) {
        index = _closePriceArr.count - 1;
    } else {
        index = (NSInteger)((point.x - _lineGap) / (_lineWidth + _lineGap));
        CGFloat offSetX = (point.x - _lineGap) - (_lineWidth + _lineGap) * index;
        if (offSetX > _lineWidth + _lineGap * 0.5) {
            index += 1;
        }
    }
    
    NSLog(@"point: %@ index: %ld", NSStringFromCGPoint(point), index);
    
    self.selectedVolumeLabel.text = [NSString stringWithFormat:@"%@：%@", NSLocalizedString(@"成交量", nil), [NSString lx_unitPrice:self.volumeArr[index]]];
    
    self.rowLine.hidden = !self.rowLine.hidden;
    self.columnLine.hidden = !self.columnLine.hidden;
    
    self.selectedClosePriceLabel.hidden = !self.selectedClosePriceLabel.hidden;
    self.selectedTimeLab.hidden = !self.selectedTimeLab.hidden;
    
    self.rowLine.frame = CGRectMake(self.rowLine.frame.origin.x, point.y, self.rowLine.frame.size.width, self.rowLine.frame.size.height);
    CGPoint columnLineConvertOrigin = [self.mainView convertPoint:CGPointMake(_lineGap + _lineWidth * 0.5 + _perWidth * index, self.columnLine.frame.origin.y) toView:self];
    self.columnLine.frame = CGRectMake(columnLineConvertOrigin.x, columnLineConvertOrigin.y, self.columnLine.frame.size.width, self.columnLine.frame.size.height);
    
    if (point.y <= _trendViewHeight) {
//        self.selectedClosePriceLabel.text = [NSString stringWithFormat:@" %.2f", [self.closePriceArr[index] floatValue]];
        CGFloat highPointY = _trendTopMargin;
        CGFloat lowPointY = _trendViewHeight - _trendBottomMargin;
        CGFloat perValue = (_maxValue - _minValue) / (lowPointY - highPointY);
        
        self.selectedClosePriceLabel.text = [NSString stringWithFormat:@" %.2f", _maxValue + (highPointY - point.y) * perValue];
    } else {
//        self.selectedClosePriceLabel.text = [NSString lx_unitPrice:(NSNumber *)self.volumeArr[index]];
        CGFloat highPointY = _trendViewHeight + _volumeTopMargin;
        CGFloat lowPointY = _trendViewHeight + _volumeViewHeight - _volumeBottomMargin;
        CGFloat perValue = (_maxVolume - 0) / (lowPointY - highPointY);
        self.selectedClosePriceLabel.text = [NSString stringWithFormat:@" %@", [NSString lx_unitPrice:@(_maxVolume + (highPointY - point.y) * perValue)]];
    }
    
    CGFloat selectedClosePriceLabelPointY = self.rowLine.frame.origin.y - self.selectedClosePriceLabel.frame.size.height * 0.5;
//    if (selectedClosePriceLabelPointY < 0) {
//        selectedClosePriceLabelPointY = 0;
//    }
    self.selectedClosePriceLabel.frame = CGRectMake(CGRectGetMaxX(self.rowLine.frame), selectedClosePriceLabelPointY, self.selectedClosePriceLabel.frame.size.width, self.selectedClosePriceLabel.frame.size.height);
    
    NSNumber *timestampNumber = self.timestamp[index];
    self.selectedTimeLab.text = [[NSString stringWithFormat:@"%f", timestampNumber.floatValue / 1000] lx_timeWithFormat:@"YYYY/MM/dd HH:mm"];
    CGFloat selectedTimeLabPointX = self.columnLine.frame.origin.x - self.selectedTimeLab.frame.size.width * 0.5;
    if (selectedTimeLabPointX < 0) {
        selectedTimeLabPointX = 0;
    }
    self.selectedTimeLab.frame = CGRectMake(selectedTimeLabPointX, CGRectGetMaxY(self.columnLine.frame), self.selectedTimeLab.frame.size.width, self.selectedTimeLab.frame.size.height);
}

- (void)longPressAction:(UILongPressGestureRecognizer *)longPress {
    [self printState:longPress];
}

- (void)pinchAction:(UIPinchGestureRecognizer *)pinch {
    [self printState:pinch];
    if (pinch.state == UIGestureRecognizerStateChanged) {
        if (self.mainView.frame.size.width * pinch.scale < self.frame.size.width - _rightTimeWidth) {
            pinch.scale = (self.frame.size.width - _rightTimeWidth) / self.mainView.frame.size.width;
        }
        
        self.mainView.transform = CGAffineTransformScale(self.mainView.transform, pinch.scale, 1);

        //左边拉伸边界处理
        if (self.mainView.frame.origin.x > 0) {
            self.mainView.frame = CGRectMake(0, self.mainView.frame.origin.y, self.mainView.frame.size.width, self.mainView.frame.size.height);
        }
        
        //右边拉伸边界处理
        if (CGRectGetMaxX(self.mainView.frame) < self.frame.size.width - _rightTimeWidth) {
            self.mainView.frame = CGRectMake(self.frame.size.width - _rightTimeWidth - self.mainView.frame.size.width, self.mainView.frame.origin.y, self.mainView.frame.size.width, self.mainView.frame.size.height);
        }
        
        NSInteger sIndex = [self leftIndex:-self.mainView.frame.origin.x];
        NSInteger eIndex = [self rightIndex:self.frame.size.width - _rightTimeWidth - self.mainView.frame.origin.x];
        [self pinchDraw:sIndex end:eIndex];
    }
    pinch.scale = 1;
}

- (void)panAction:(UIPanGestureRecognizer *)pan {
    [self printState:pan];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        _panStartPoint = self.mainView.frame.origin;
    }
    
    if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint translationPoint = [pan translationInView:self];
        CGFloat newX = _panStartPoint.x + translationPoint.x;
        newX = MIN(newX, 0);
        self.mainView.frame = CGRectMake(newX , self.mainView.frame.origin.y, self.mainView.frame.size.width, self.mainView.frame.size.height);
        
        if (CGRectGetMaxX(self.mainView.frame) < self.frame.size.width - _rightTimeWidth) {
            self.mainView.frame = CGRectMake(self.frame.size.width - _rightTimeWidth - self.mainView.frame.size.width , self.mainView.frame.origin.y, self.mainView.frame.size.width, self.mainView.frame.size.height);
        }
    }
    
    NSInteger sIndex = [self leftIndex:-self.mainView.frame.origin.x];
    NSInteger eIndex = [self rightIndex:self.frame.size.width - _rightTimeWidth - self.mainView.frame.origin.x];
    [self pinchDraw:sIndex end:eIndex];
}

- (NSInteger)leftIndex:(CGFloat)originX {
    
    CGFloat _lineGap = (self.mainView.frame.size.width) / (self.closePriceArr.count * 4 + 1);
    CGFloat _perWidth = (self.mainView.frame.size.width - _lineGap * 3 - _lineGap * 2) / (self.closePriceArr.count - 1);
    CGFloat _lineWidth = _perWidth - _lineGap;
    NSInteger index = (NSInteger)floor(originX / _perWidth);
    CGFloat shengyuX = originX - index * _perWidth;
    NSInteger currentIndex = index;
    if (shengyuX < _lineGap + _lineWidth * 0.5) {
        currentIndex = index - 1;
    } else {
        currentIndex = index;
    }
    return MAX(currentIndex, 0);
}

- (NSInteger)rightIndex:(CGFloat)originX {
    CGFloat _lineGap = (self.mainView.frame.size.width) / (self.closePriceArr.count * 4 + 1);
    CGFloat _perWidth = (self.mainView.frame.size.width - _lineGap * 3 - _lineGap * 2) / (self.closePriceArr.count - 1);
    CGFloat _lineWidth = _perWidth - _lineGap;
    NSInteger index = (NSInteger)floor(originX / _perWidth);
    CGFloat shengyuX = originX - index * _perWidth;
    NSInteger currentIndex = index;
    if (shengyuX <= _lineGap + _lineWidth * 0.5) {
        currentIndex = index;
    } else {
        currentIndex = index + 1;
    }
    return MIN(self.closePriceArr.count - 1, currentIndex);
}

- (void)pinchDraw:(NSInteger)sIndex end:(NSInteger)eIndex {
    
    CGFloat max = 0;
    CGFloat min = MAXFLOAT;
    CGFloat maxVolume = 0;
    CGFloat minVolume = MAXFLOAT;

    for (NSInteger i = sIndex; i <= eIndex; i++) {
        NSString *priceStr = self.closePriceArr[i];
        max = [priceStr floatValue] > max ? [priceStr floatValue] : max;
        min = [priceStr floatValue] < min ? [priceStr floatValue] : min;

        NSString *volumeStr = self.volumeArr[i];
        maxVolume = [volumeStr floatValue] > maxVolume ? [volumeStr floatValue] : maxVolume;
        minVolume = [volumeStr floatValue] < minVolume ? [volumeStr floatValue] : minVolume;
    }

    CGFloat trendHighPointY = _trendTopMargin;
    CGFloat trendLowPointY = _trendViewHeight - _trendBottomMargin;
    CGFloat trendPerValue = (max - min) / (trendLowPointY - trendHighPointY);

    CGFloat volumeHighPointY = _trendViewHeight + _volumeTopMargin;
    CGFloat volumeLowPointY = _trendViewHeight + _volumeViewHeight - _volumeBottomMargin;
    CGFloat volumePerValue = (maxVolume - 0) / (volumeLowPointY - volumeHighPointY);
    
    UIBezierPath *strokePath = [UIBezierPath bezierPath];
    UIBezierPath *fillPath = [UIBezierPath bezierPath];
    [fillPath moveToPoint:CGPointMake(_lineGap + _lineWidth * 0.5 + _perWidth * sIndex, _trendViewHeight)];
    
    for (NSInteger i = sIndex; i <= eIndex; i++) {
        CGFloat closePrice = [self.closePriceArr[i] floatValue];
        CGFloat trendPointY = 0.0;
        if (trendPerValue > 0) {
            trendPointY = trendHighPointY + (max - closePrice) / trendPerValue;
        }
        CGFloat trendPointX = _lineGap + _lineWidth * 0.5 + _perWidth * i;
        CGPoint trendPoint = CGPointMake(trendPointX, trendPointY);
        if (i == sIndex) {
            [strokePath moveToPoint:trendPoint];
        } else {
            [strokePath addLineToPoint:trendPoint];
        }
        [fillPath addLineToPoint:trendPoint];
        
        CGFloat volume = [self.volumeArr[i] floatValue];
        CGFloat volumePointY = 0.0, lineHeight = 0.0;
        if (volumePerValue > 0) {
            volumePointY = volumeHighPointY + (maxVolume - volume) / volumePerValue;
            lineHeight = volumeLowPointY - volumePointY;
        }

        UIView *line;
        if (i < self.volumeViewCacheArr.count) {
            line = self.volumeViewCacheArr[i];
        }

        line.frame = CGRectMake(line.frame.origin.x, volumePointY, line.frame.size.width, lineHeight);
    }

    [fillPath addLineToPoint:CGPointMake(self.frame.size.width - _rightTimeWidth - _lineGap - _lineWidth * 0.5, _trendViewHeight)];
    [fillPath closePath];

    CGFloat scale = self.mainView.frame.size.width / (self.frame.size.width - _rightTimeWidth);
    self.strokeLayer.lineWidth = 1 / scale;
    self.strokeLayer.path = strokePath.CGPath;
    self.fillLayer.path = fillPath.CGPath;
}

#pragma mark - getter
- (NSMutableArray *)volumeViewCacheArr {
    if (!_volumeViewCacheArr) {
        _volumeViewCacheArr = [NSMutableArray array];
    }
    return _volumeViewCacheArr;
}

- (UIView *)mainView {
    if (!_mainView) {
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - _rightTimeWidth, _trendViewHeight + _volumeViewHeight - _volumeBottomMargin)];
        _mainView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
    }
    return _mainView;
}

- (CAShapeLayer *)strokeLayer {
    if (!_strokeLayer) {
        _strokeLayer = [CAShapeLayer layer];
        _strokeLayer.strokeColor = LXHexColor(0x4798EE).CGColor;
        _strokeLayer.fillColor = [UIColor clearColor].CGColor;
        _strokeLayer.lineWidth = 1;
        [self.mainView.layer addSublayer:_strokeLayer];
        [self.mainView.layer addSublayer:self.gradientLayer];
    }
    return _strokeLayer;
}

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
//        _gradientLayer.frame = CGRectMake(_lineGap, 0, self.frame.size.width - _lineGap * 2, _trendViewHeight);
        _gradientLayer.frame = CGRectMake(0, 0, self.mainView.frame.size.width, _trendViewHeight);
        _gradientLayer.colors = @[(__bridge id)LXHexColorWithAlpha(0x4798EE, 0.27).CGColor, (__bridge id)LXHexColorWithAlpha(0x4798EE, 0.04).CGColor]; //设置渐变色
        _gradientLayer.locations = @[@(0.0f),@(1.0f)]; // 设置渐变点
        _gradientLayer.startPoint = CGPointMake(0.0, 0.0); // 设置渐变起点
        _gradientLayer.endPoint = CGPointMake(0.0, 1.0);   // 设置渐变终点
        [_gradientLayer setMask:self.fillLayer];
    }
    return _gradientLayer;
}

- (CAShapeLayer *)fillLayer {
    if (!_fillLayer) {
        _fillLayer = [CAShapeLayer layer];
    }
    return _fillLayer;
}

- (UIView *)rowLine {
    if (!_rowLine) {
        _rowLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - _rightTimeWidth + .5, .5)];
        _rowLine.backgroundColor = LXHexColor(0x848484);
        [self addSubview:_rowLine];
    }
    return _rowLine;
}

- (UIView *)columnLine {
    if (!_columnLine) {
        _columnLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, .5, self.frame.size.height - 21)];
        _columnLine.backgroundColor = LXHexColor(0x848484);
        [self addSubview:_columnLine];
    }
    return _columnLine;
}

- (UILabel *)selectedClosePriceLabel {
    if (!_selectedClosePriceLabel) {
        _selectedClosePriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 15)];
        _selectedClosePriceLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:9];
        _selectedClosePriceLabel.textColor = [UIColor whiteColor];
        _selectedClosePriceLabel.textAlignment = NSTextAlignmentCenter;
        _selectedClosePriceLabel.backgroundColor = LXHexColor(0x333333);
        _selectedClosePriceLabel.opaque = 1;
        [self addSubview:_selectedClosePriceLabel];
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(_selectedClosePriceLabel.frame.size.width, 0)];
        [path addLineToPoint:CGPointMake(6, 0)];
        [path addLineToPoint:CGPointMake(0, _selectedClosePriceLabel.frame.size.height * 0.5)];
        [path addLineToPoint:CGPointMake(6, _selectedClosePriceLabel.frame.size.height)];
        [path addLineToPoint:CGPointMake(_selectedClosePriceLabel.frame.size.width, _selectedClosePriceLabel.frame.size.height)];
        [path closePath];
        maskLayer.path = path.CGPath;
        _selectedClosePriceLabel.layer.mask = maskLayer;
    }
    return _selectedClosePriceLabel;
}

- (UILabel *)selectedTimeLab {
    if (!_selectedTimeLab) {
        _selectedTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 96, 18)];
        _selectedTimeLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:9];
        _selectedTimeLab.textColor = [UIColor whiteColor];
        _selectedTimeLab.textAlignment = NSTextAlignmentCenter;
        _selectedTimeLab.backgroundColor = LXHexColor(0x333333);
        _selectedTimeLab.opaque = 1;
        [self addSubview:_selectedTimeLab];
    }
    return _selectedTimeLab;
}

- (UIView *)dottedLine {
    if (!_dottedLine) {
        _dottedLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - _rightTimeWidth, .5)];
        _dottedLine.backgroundColor = [UIColor clearColor];
        [self drawLineOfDashByCAShapeLayer:_dottedLine lineLength:3 lineSpacing:3 lineColor:LXHexColor(0x4798EE) lineDirection:YES];
    }
    return _dottedLine;
}

- (UILabel *)latestClosePriceLabel {
    if (!_latestClosePriceLabel) {
        _latestClosePriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 15)];
        _latestClosePriceLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:9];
        _latestClosePriceLabel.textColor = LXHexColor(0x297DF5);
        _latestClosePriceLabel.textAlignment = NSTextAlignmentCenter;
        _latestClosePriceLabel.backgroundColor = LXHexColor(0xDAECFF);
        _latestClosePriceLabel.opaque = 1;
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(_latestClosePriceLabel.frame.size.width, 0)];
        [path addLineToPoint:CGPointMake(6, 0)];
        [path addLineToPoint:CGPointMake(0, _latestClosePriceLabel.frame.size.height * 0.5)];
        [path addLineToPoint:CGPointMake(6, _latestClosePriceLabel.frame.size.height)];
        [path addLineToPoint:CGPointMake(_latestClosePriceLabel.frame.size.width, _latestClosePriceLabel.frame.size.height)];
        [path closePath];
        maskLayer.path = path.CGPath;
        _latestClosePriceLabel.layer.mask = maskLayer;
    }
    return _latestClosePriceLabel;
}

- (UIView *)rightVBgiew {
    if (!_rightVBgiew) {
        _rightVBgiew = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - _rightTimeWidth, 0, _rightTimeWidth, _trendViewHeight + _volumeViewHeight)];
        _rightVBgiew.backgroundColor = [UIColor whiteColor];
    }
    return _rightVBgiew;
}

- (UILabel *)YLabelOne {
    if (!_YLabelOne) {
        _YLabelOne = [self createYLabel];
        _YLabelOne.frame = CGRectMake(1, 1 / 5.0 * _trendViewHeight - 6.5, _rightTimeWidth - 2, 13);
        _YLabelOne.text = @"0.00";
        _YLabelOne.textAlignment = NSTextAlignmentCenter;
    }
    return _YLabelOne;
}

- (UILabel *)YLabelTwo {
    if (!_YLabelTwo) {
        _YLabelTwo = [self createYLabel];
        _YLabelTwo.frame = CGRectMake(1, 2 / 5.0 * _trendViewHeight - 6.5, _rightTimeWidth - 2, 13);
        _YLabelTwo.text = @"0.00";
        _YLabelTwo.textAlignment = NSTextAlignmentCenter;
    }
    return _YLabelTwo;
}

- (UILabel *)YLabelThree {
    if (!_YLabelThree) {
        _YLabelThree = [self createYLabel];
        _YLabelThree.frame = CGRectMake(1, 3 / 5.0 * _trendViewHeight - 6.5, _rightTimeWidth - 2, 13);
        _YLabelThree.text = @"0.00";
        _YLabelThree.textAlignment = NSTextAlignmentCenter;
    }
    return _YLabelThree;
}

- (UILabel *)YLabelFour {
    if (!_YLabelFour) {
        _YLabelFour = [self createYLabel];
        _YLabelFour.frame = CGRectMake(1, 4 / 5.0 * _trendViewHeight - 6.5, _rightTimeWidth - 2, 13);
        _YLabelFour.text = @"0.00";
        _YLabelFour.textAlignment = NSTextAlignmentCenter;
    }
    return _YLabelFour;
}

- (UILabel *)YVolumeLabelOne {
    if (!_YVolumeLabelOne) {
        _YVolumeLabelOne = [self createYLabel];
        _YVolumeLabelOne.frame = CGRectMake(1, _trendViewHeight + 1 / 3.0 * (_volumeViewHeight - _volumeBottomMargin) - 6.5, _rightTimeWidth - 2, 13);
        _YVolumeLabelOne.textAlignment = NSTextAlignmentCenter;
    }
    return _YVolumeLabelOne;
}

- (UILabel *)YVolumeLabelTwo {
    if (!_YVolumeLabelTwo) {
        _YVolumeLabelTwo = [self createYLabel];
        _YVolumeLabelTwo.frame = CGRectMake(1, _trendViewHeight + 2 / 3.0 * (_volumeViewHeight - _volumeBottomMargin) - 6.5, _rightTimeWidth - 2, 13);
        _YVolumeLabelTwo.textAlignment = NSTextAlignmentCenter;
    }
    return _YVolumeLabelTwo;
}

- (UILabel *)YVolumeLabelThree {
    if (!_YVolumeLabelThree) {
        _YVolumeLabelThree = [self createYLabel];
        _YVolumeLabelThree.frame = CGRectMake(1, self.frame.size.height - _volumeBottomMargin - 10, _rightTimeWidth - 2, 13);
        _YVolumeLabelThree.text = @"0万";
        _YVolumeLabelThree.textAlignment = NSTextAlignmentCenter;
    }
    return _YVolumeLabelThree;
}

- (UILabel *)label_t_0 {
    if (!_label_t_0) {
        _label_t_0 = [self createYLabel];
    }
    return _label_t_0;
}

- (UILabel *)label_t_1 {
    if (!_label_t_1) {
        _label_t_1 = [self createYLabel];
    }
    return _label_t_1;
}

- (UILabel *)label_t_2 {
    if (!_label_t_2) {
        _label_t_2 = [self createYLabel];
    }
    return _label_t_2;
}

- (UILabel *)label_t_3 {
    if (!_label_t_3) {
        _label_t_3 = [self createYLabel];
    }
    return _label_t_3;
}

- (UILabel *)label_t_4 {
    if (!_label_t_4) {
        _label_t_4 = [self createYLabel];
    }
    return _label_t_4;
}

- (UILabel *)label_t_5 {
    if (!_label_t_5) {
        _label_t_5 = [self createYLabel];
    }
    return _label_t_5;
}

- (UILabel *)label_t_6 {
    if (!_label_t_6) {
        _label_t_6 = [self createYLabel];
    }
    return _label_t_6;
}

- (UILabel *)selectedVolumeLabel {
    if (!_selectedVolumeLabel) {
        _selectedVolumeLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, _trendViewHeight + 4, 189, 14)];
        _selectedVolumeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
        _selectedVolumeLabel.textColor = LXHexColor(0x797979);
        _selectedVolumeLabel.text = [NSString stringWithFormat:@"%@：0.00", NSLocalizedString(@"成交量", nil)];
    }
    return _selectedVolumeLabel;
}

- (UILabel *)createYLabel {
    UILabel *label = [UILabel new];
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:9];
    label.textColor = LXHexColor(0x797979);
    return label;
}

- (NSString *)lx_timeWithFormat:(NSString *)timestamp
{
    NSString *format = @"HH:mm";
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:format];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]]];
    
    return currentDateStr;
}

- (void)printState:(UIGestureRecognizer *)recognizer {

    switch (recognizer.state) {
        case UIGestureRecognizerStatePossible:
            NSLog(@"%@ UIGestureRecognizerStatePossible", recognizer.class);
            break;
        case UIGestureRecognizerStateBegan:
            NSLog(@"%@ UIGestureRecognizerStateBegan", recognizer.class);
            break;
        case UIGestureRecognizerStateChanged:
            NSLog(@"%@ UIGestureRecognizerStateChanged", recognizer.class);
            break;
        case UIGestureRecognizerStateEnded:
            NSLog(@"%@ UIGestureRecognizerStateEnded", recognizer.class);
            break;
        case UIGestureRecognizerStateCancelled:
            NSLog(@"%@ UIGestureRecognizerStateCancelled", recognizer.class);
            break;
        case UIGestureRecognizerStateFailed:
            NSLog(@"%@ UIGestureRecognizerStateFailed", recognizer.class);
            break;
        default:
            break;
    }
}


- (void)drawLineOfDashByCAShapeLayer:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor lineDirection:(BOOL)isHorizonal {
 
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
 
    [shapeLayer setBounds:lineView.bounds];
 
    if (isHorizonal) {
 
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
 
    } else{
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame)/2)];
    }
 
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    if (isHorizonal) {
        [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    } else {
 
        [shapeLayer setLineWidth:CGRectGetWidth(lineView.frame)];
    }
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
 
    if (isHorizonal) {
        CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
    } else {
        CGPathAddLineToPoint(path, NULL, 0, CGRectGetHeight(lineView.frame));
    }
 
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

@end
