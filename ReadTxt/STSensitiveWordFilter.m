//
//  STSensitiveWordFilter.m
//  敏感词过滤
//
//  Created by 向伟 on 2019/4/1.
//  Copyright © 2019 中泰荣科. All rights reserved.
//

#import "STSensitiveWordFilter.h"

#define EXIST @"isExists"
@interface STSensitiveWordFilter ()

@property (nonatomic, strong) NSMutableDictionary *root;
@property (nonatomic, assign) BOOL isFilterClose;

@end

@implementation STSensitiveWordFilter

+ (instancetype)shared {
    static STSensitiveWordFilter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[STSensitiveWordFilter alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.root = [NSMutableDictionary dictionary];
        [self initFilter];
    }
    return self;
}

- (void)initFilter {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"filterContent" ofType:@"txt"];
    NSError *error = nil;
    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    if (!error) {
        NSArray *arrays = [content componentsSeparatedByString:@"\n"];
        for (NSString *string in arrays) {
            NSString *filterStr = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [self insertFilters:filterStr];
        }
    }
}

- (void)insertFilters:(NSString *)words {
    NSMutableDictionary *node = self.root;
    @autoreleasepool {
        for (int i = 0; i < words.length; i ++) {
            NSString *word = [words substringWithRange:NSMakeRange(i, 1)];
            if (node[word] == nil) {
                node[word] = [NSMutableDictionary dictionary];
            }
            node = node[word];
        }
    }
    node[EXIST] = [NSNumber numberWithInt:1];
}

- (NSString *)filter: (NSString *)content replaceString: (NSString *)replaceChar {
    if (self.isFilterClose || !self.root) {
        return content;
    }
    NSMutableString *filterResult = [content mutableCopy];
    @autoreleasepool {
        for (int i = 0; i < content.length; i ++) {
            NSString *subString = [content substringFromIndex:i];
            NSMutableDictionary *node = [self.root mutableCopy];
            int num = 0;
            
            for (int j = 0; j < subString.length; j ++) {
                NSString *word = [subString substringWithRange:NSMakeRange(j, 1)];
                if (node[word] == nil) {
                    break;
                } else {
                    num ++;
                    node = node[word];
                }
                
                // 敏感词匹配成功
                if ([node[EXIST] integerValue] == 1) {
                    NSMutableString *replaceString = [NSMutableString string];
                    for (int k = 0; k < num; k ++) {
                        [replaceString appendString:replaceChar];
                    }
                    [filterResult replaceCharactersInRange:NSMakeRange(i, num) withString:replaceString];
                    i += j;
                    break;
                }
            }
        }
    }
    return  filterResult;
}

- (void)freeFilter {
    self.root = nil;
}

- (void)stopFilter:(BOOL)stop {
    self.isFilterClose = stop;
}
@end
