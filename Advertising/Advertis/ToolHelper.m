//
//  ToolHelper.m
//  Advertising
//
//  Created by hht on 2018/5/22.
//  Copyright © 2018年 hht. All rights reserved.
//

#import "ToolHelper.h"

@implementation ToolHelper

/** 往userDefault中存放内容 */
+ (void)saveToDefaultWithObj:(id)obj forKey:(NSString *)key;
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:obj forKey:key];
    [userDefaults synchronize];
}

/** 从userDefault中取内容 */
+ (id)getFromDefaultWithKey:(NSString *)key;
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:key];
}
/** 从userDefault中删除key的值 */
+ (void)removeFromDefaultWithKey:(NSString *)key{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}

@end
