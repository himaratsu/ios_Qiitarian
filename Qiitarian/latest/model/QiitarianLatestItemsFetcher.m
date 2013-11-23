//
//  QiitarianLatestItemsFetcher.m
//  Qiitarian
//
//  Created by Shoichi Matsuda on 2013/11/22.
//  Copyright (c) 2013年 Shoichi Matsuda. All rights reserved.
//

#import "QiitarianLatestItemsFetcher.h"
#import "QiitarianLatestItem.h"

@implementation QiitarianLatestItemsFetcher

- (void)fetch:(void (^)(NSArray *))onFinishAccess {
    NSURL *url = [NSURL URLWithString:@"http://qiita.com/api/v1/items"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (data == nil) {
            NSLog(@"Can't catch data");
            return;
        }
        
        //JSONを変換する
        NSError *tempError;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&tempError];
        
        //データオブジェクトの配列に変換する
        NSMutableArray *dataList = @[].mutableCopy;
        for (NSDictionary *dict in jsonArray) {
            QiitarianLatestItem *item = [[QiitarianLatestItem alloc] initWithKeyValueMap:dict];
            [dataList addObject:item];
        }
        
        onFinishAccess(dataList.copy);
    }];
}

@end
