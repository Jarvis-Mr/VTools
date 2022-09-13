//
//  NSCalendar+Calendar.h
//  SmartCampus
//
//  Created by Jarvis on 2022/5/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSCalendar (Calendar)

/// 获取这个月的第一天
/// @param month Date
- (nullable NSDate *)firstDayOfMonth:(NSDate *)month;
/// 获取这个月的最后一天
/// @param month Date
- (nullable NSDate *)lastDayOfMonth:(NSDate *)month;
/// 获取这周的第一天
/// @param week Date
- (nullable NSDate *)firstDayOfWeek:(NSDate *)week;
/// 获取这周的最后一天
/// @param week Date
- (nullable NSDate *)lastDayOfWeek:(NSDate *)week;
/// 获取这周的中间那天
/// @param week Date
- (nullable NSDate *)middleDayOfWeek:(NSDate *)week;
/// 获取这个月的总天数
/// @param month Date
- (NSInteger)numberOfDaysInMonth:(NSDate *)month;
@end

NS_ASSUME_NONNULL_END
