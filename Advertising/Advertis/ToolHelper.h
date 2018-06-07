//
//  ToolHelper.h
//  Advertising
//
//  Created by hht on 2018/5/22.
//  Copyright © 2018年 hht. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToolHelper : NSObject
/** 往userDefault中存放内容 */
+ (void)saveToDefaultWithObj:(id)obj forKey:(NSString *)key;

/** 从userDefault中取内容 */
+ (id)getFromDefaultWithKey:(NSString *)key;

/** 从userDefault中删除key的值 */
+ (void)removeFromDefaultWithKey:(NSString *)key;

@end
