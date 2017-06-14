//
//  StatisticsChartViewController.h
//  Final_Work
//
//  Created by Chang Hao Chao on 2017/6/14.
//  Copyright © 2017年 Chang Hao Chao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RootViewController.h"

#import <charts/Charts-Swift.h>


@interface StatisticsChartViewController : UIViewController
@property (weak) RootViewController* rootViewController;


@property (nonatomic, strong) IBOutlet PieChartView *chartView;


@end
