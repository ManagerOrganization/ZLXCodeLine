//
//  TodayViewController.m
//  CocoTodayExtension
//
//  Created by Li Xiang on 10/14/14.
//  Copyright (c) 2014 365rili.com. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

#import "CCTodayMonthView.h"
#import "NSDate+Ext.h"
#import "NSString+Ext.h"

#define FeedServiceHost      @"sub.365rili.com"
#define LAST_GET_HOLIDAY_FLAG_DATE @"last_get_holiday_flag_date"

@interface TodayViewController () <NCWidgetProviding>

@property (weak, nonatomic) IBOutlet CCTodayMonthView *monthVw;

@end

@implementation TodayViewController

- (NSMutableDictionary *)getHolidayFlagFrom:(NSDate *)startDate to:(NSDate *)endDate{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/subscribe/listHoliday.do?startdate=%lld&enddate=%lld",
                        FeedServiceHost,[startDate toMilliSecond], [endDate toMilliSecond]];
    NSMutableDictionary *resDict = [[NSMutableDictionary alloc] init];
    
    NSData *data = [self sendRequest:urlStr];
    
    if (data != nil) {
        NSMutableArray *holidayIconArr = (NSMutableArray *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        for (NSDictionary *dict in holidayIconArr)
            [resDict setObject:[dict objectForKey:@"status"] forKey:[dict objectForKey:@"date"]];
        [defaults setObject:resDict forKey:HOLIDAY_FLAG_DICT];
        [defaults synchronize];
        return resDict;
    }
    return nil;
}

- (NSData *)sendRequest:(NSString *)urlStr{
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
    long long timeStamp = [[NSDate date] toMilliSecond];
    NSString *md5Str = [[NSString stringWithFormat:@"%lld%@", timeStamp, urlStr] MD5];
    NSString *sHeader = [NSString stringWithFormat:@"%lld,%@", timeStamp, md5Str];
    [request setValue:sHeader forHTTPHeaderField:@"LKJ8FD9FD345lkj3"];
//    [request setValue:[AppConfig userAgent] forHTTPHeaderField:@"User-Agent"];
    NSHTTPURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSLog(@"%ld",(long)response.statusCode);
    if (response.statusCode == 200) {
        @try {
            id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if ([res isKindOfClass:[NSDictionary class]])
                if ([res objectForKey:@"state"] != nil)
                    return nil;
        }
        @catch (NSException *exception) {
            return nil;
        }
        return data;
    }else{
        return nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.preferredContentSize = CGSizeMake(0, 316);
    [self.monthVw setNeedsDisplay];
    
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(monthVwTapped:)];
    [self.monthVw addGestureRecognizer:gr];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastDayStr = [defaults objectForKey:LAST_GET_HOLIDAY_FLAG_DATE];
    NSString *todayMonthStr = [[NSDate date] fullStyleDateWithSep:@""];
    if (lastDayStr == nil || ![lastDayStr isEqualToString:todayMonthStr]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDate *sDate = [[[NSDate date] getDatePart] dateByAddingTimeInterval:-86400 * 180];
            NSDate *eDate = [sDate dateByAddingTimeInterval:86400 * 540];
            NSMutableDictionary *dict = [self getHolidayFlagFrom:sDate to:eDate];
            if (dict != nil) {
                [defaults setObject:todayMonthStr forKey:LAST_GET_HOLIDAY_FLAG_DATE];
                [defaults synchronize];
                dispatch_async(dispatch_get_main_queue(), ^{    // 成功获取放假安排，更新界面
                    [self.monthVw setNeedsDisplay];
                });
            }
        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)monthVwTapped:(UIGestureRecognizer *)gr {
    [self.extensionContext openURL:[NSURL URLWithString:@"coco://365rili.com"] completionHandler:nil];
}

- (IBAction)add:(id)sender {
    [self.extensionContext openURL:[NSURL URLWithString:@"coco://365rili.com/add"] completionHandler:nil];
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    NSLog(@"viewWillTransitionToSize: %@", NSStringFromCGSize(size));
    if (size.height < 316) {    // 高度不够时绘制周视图，横屏情况
        self.monthVw.showWeek = YES;
        self.preferredContentSize = CGSizeMake(0, 135);
    } else {
        self.monthVw.showWeek = NO;
        self.preferredContentSize = CGSizeMake(0, 316);
    }
    [self.monthVw setNeedsDisplay];
}

#pragma mark - NCWidgetProviding
- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    NSLog(@"%@", NSStringFromUIEdgeInsets(defaultMarginInsets));
    return UIEdgeInsetsMake(defaultMarginInsets.top, defaultMarginInsets.left, 15, defaultMarginInsets.right);
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    [self.monthVw setNeedsDisplay];
    
    completionHandler(NCUpdateResultNoData);
}

@end
