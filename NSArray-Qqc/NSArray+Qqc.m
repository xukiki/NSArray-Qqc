//
//  NSArray+Qqc.m
//  QqcFramework
//
//  Created by mahailin on 15/8/7.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "NSArray+Qqc.h"

@implementation NSArray (Qqc)

/**
 *  根据给定索引值安全获取数组里的元素，index越界时返回nil，不会造成crash
 *
 *  @param index 元素索引值
 *
 *  @return 指定索引的元素
 */
- (id)safeGetObjectAtIndex:(NSUInteger)index
{
    if (index >= self.count)
    {
        return nil;
    }
    
    return [self objectAtIndex:index];
}

/**
 *  指定两端索引，返回一个新的子数组，会判断传入参数的合理性
 *
 *  @param fromIndex 起始索引值
 *  @param toIndex   结束索引值
 *
 *  @return 原数组的子数组
 */
- (NSArray *)subarrayFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    NSUInteger count = self.count;
    
    if (fromIndex > toIndex || fromIndex >= count)
    {
        return nil;
    }
    
    toIndex = toIndex >= count ? count - 1 : toIndex;
    return [self subarrayWithRange:NSMakeRange(fromIndex, toIndex - fromIndex + 1)];
}

/**
 *  将传入的参数合并到数组，如果传入的是一个数组，将展开一次，注意需要以nil结尾
 *
 *  @param obj 要合并的对象
 *
 *  @return 合并后的数组
 */
- (NSArray *)concatWithObjects:(id)obj, ... NS_REQUIRES_NIL_TERMINATION
{
    if (!obj)
    {
        return self;
    }
    
    NSMutableArray *resultArray = [NSMutableArray arrayWithArray:self];
    va_list valist;
    va_start(valist, obj);
    id paramObj = obj;
    
    do
    {
        if ([paramObj isKindOfClass:[NSArray class]])
        {
            [resultArray addObjectsFromArray:paramObj];
        }
        else
        {
            [resultArray addObject:paramObj];
        }
    }while ((paramObj = va_arg(valist, id)) != nil);
    
    va_end(valist);
    return resultArray;
}

/**
 *  将传入的数组合并到数组，如果数组的子元素是一个数组，将展开一次
 *
 *  @param concatArray 要合并的数组
 *
 *  @return 合并后的数组
 */
- (NSArray *)concatWithArray:(NSArray *)concatArray
{
    if (!concatArray)
    {
        return self;
    }
    
    NSMutableArray *resultArray = [NSMutableArray arrayWithArray:self];
    
    for (id obj in concatArray)
    {
        if ([obj isKindOfClass:[NSArray class]])
        {
           [resultArray addObjectsFromArray:obj];
        }
        else
        {
            [resultArray addObject:obj];
        }
    }
    
    return resultArray;
}

/**
 *  遍历数组查找元素
 *
 *  @param block 查找的条件
 *
 *  @return 返回找到的元素
 */
- (id)find:(BOOL (^)(id obj))block
{
    if (!block)
    {
        return nil;
    }
    
    for (id item in self)
    {
        if (block(item))
        {
            return item;
        }
    }
    
    return nil;
}

/**
 *  遍历数组执行block
 *
 *  @param block 要执行的block
 */
- (void)each:(void (^)(id obj))block
{
    if (!block)
    {
        return;
    }
    
    for (id item in self)
    {
        block(item);
    }
}

/**
 *  根据给定block对当前数组元素进行处理，返回处理之后的新数组，多用于根据原数组生成一套新的数组
 *
 *  @param block 处理数组元素的块
 *
 *  @return 返回新的数组
 */
- (NSArray *)map:(id (^)(id obj, NSUInteger idx))block
{
    if (!block)
    {
        return nil;
    }
    
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:self.count];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [resultArray addObject:block(obj, idx)];
    }];
    
    return resultArray;
}

/**
 *  遍历数组找到符合条件的元素并返回新数组, 如果没有找到任何数据, 则返回空数组
 *
 *  @param block 查找的条件
 *
 *  @return 返回新的数组
 */
- (NSArray *)filter:(BOOL (^)(id obj))block
{
    if (!block)
    {
        return nil;
    }
    
    NSMutableArray *resultArray = [NSMutableArray array];
    
    for (id item in self)
    {
        if (block(item))
        {
            [resultArray addObject:item];
        }
    }
    
    return resultArray;
}

/**
 *  根据给定的block和合并连接字符串返回合并的字符串,该函数是对 componentsJoinedByString: 的扩展，用于数组元素不是NSString成员的时候
 *
 *  @param separator 合并数组元素的连接字符
 *  @param block     处理数组元素的块
 *
 *  @return 返回合并后的字符串
 */
- (NSString *)componentsJoinedByString:(NSString *)separator withBlock:(NSString *(^)(id obj))block
{
    if (!separator || !block || self.count == 0)
    {
        return nil;
    }
    
    NSMutableArray *resultArray = [NSMutableArray array];
    
    for (id item in self)
    {
        NSString *resultString = block(item);
        
        if ([resultString isKindOfClass:[NSString class]])
        {
            [resultArray addObject:resultString];
        }
    }
    
    return [resultArray componentsJoinedByString:separator];
}

@end
