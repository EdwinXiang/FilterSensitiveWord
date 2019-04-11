//
//  STSensitiveWordFilter.h
//  敏感词过滤
//
//  Created by 向伟 on 2019/4/1.
//  Copyright © 2019 中泰荣科. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface STSensitiveWordFilter : NSObject

+ (instancetype)shared;

- (NSString *)filter: (NSString *)content replaceString: (NSString *)replaceChar;
@end

NS_ASSUME_NONNULL_END
