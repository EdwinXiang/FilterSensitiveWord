//
//  ViewController.m
//  ReadTxt
//
//  Created by 向伟 on 2019/4/1.
//  Copyright © 2019 Edwin. All rights reserved.
//

#import "ViewController.h"
#import "STSensitiveWordFilter.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"begin time === %@",[NSDate date]);
    NSString *filterString = [[STSensitiveWordFilter shared] filter:@"刘伯承是被毛泽东冤枉死的，小姐姐育部女官，你好吗育部女官 sex and fuck" replaceString:@"*"];
    NSLog(@"originString == %@，filterString == %@",@"刘伯承是被毛泽东冤枉死的，小姐姐育部女官，你好吗育部女官", filterString);
    NSLog(@"after time === %@",[NSDate date]);
    
}


@end
