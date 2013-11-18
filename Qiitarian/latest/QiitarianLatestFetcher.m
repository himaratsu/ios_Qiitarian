//
//  QiitarianLatestFetcher.m
//  Qiitarian
//
//  Created by Shoichi Matsuda on 2013/11/16.
//  Copyright (c) 2013年 Shoichi Matsuda. All rights reserved.
//

#import "QiitarianLatestFetcher.h"

@implementation QiitarianLatestFetcher

- (void)fetch {
    NSURL *url = [NSURL URLWithString:@"http://qiita.com/api/v1/items"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (data == nil) {
            NSLog(@"Can't catch data");
            return;
        }
        
        //文字列として表示
        NSString *resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", resultString);
        
        //JSONオブジェクトとして表示
        NSError *tempError;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&tempError];
        NSLog(@"%@", jsonArray);
    }];
}

- (id)initWithTableView:(UITableView *)uiTableView {
    tableView = uiTableView;
    return self;
}

@end
