//
//  QiitarianLatestItemList.m
//  Qiitarian
//
//  Created by Shoichi Matsuda on 2013/11/25.
//  Copyright (c) 2013年 Shoichi Matsuda. All rights reserved.
//

#import "QiitarianLatestItemList.h"

@implementation QiitarianLatestItemList

- (QiitarianLatestItemList *)initWithQiitarianList:(NSArray *)itemList {
    _itemList = itemList;
    return self;
}

- (QiitarianLatestItemList *) mergeToLast:(QiitarianLatestItemList *)itemList {
    return NULL;
}
- (QiitarianLatestItemList *) mergeToHead:(QiitarianLatestItemList *)itemList {
    return NULL;
}

@end
