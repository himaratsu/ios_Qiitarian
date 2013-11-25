//
//  QiitarianLatestViewController.m
//  Qiitarian
//
//  Created by Shoichi Matsuda on 2013/11/18.
//  Copyright (c) 2013年 Shoichi Matsuda. All rights reserved.
//

#import "QiitarianLatestViewController.h"
#import "QiitarianLatestItemsFetcher.h"
#import "QiitarianLatestItem.h"

@interface QiitarianLatestViewController () {
@private
    int _currentPage;
    BOOL _isUpdating;
}

@property (nonatomic, strong) NSMutableArray *list;

@end

@implementation QiitarianLatestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl = refreshControl;
    [self.refreshControl addTarget:self action:@selector(onRefresh:) forControlEvents:UIControlEventValueChanged];
    
    _list = @[].mutableCopy;
    _currentPage = 1;
    _isUpdating = NO;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    QiitarianLatestItemsFetcher *fetcher = [[QiitarianLatestItemsFetcher alloc] init];
    [fetcher fetch:^(NSArray *array) {
        for (QiitarianLatestItem *item in array) {
            [_list addObject:item.title];
        }
        [self.tableView reloadData];
    }];
}

- (void)onRefresh:(id)sender {
    [self.refreshControl beginRefreshing];
    QiitarianLatestItemsFetcher *fetcher = [[QiitarianLatestItemsFetcher alloc] init];
    [fetcher fetch:^(NSArray *array) {
        NSArray *reversed = [[array reverseObjectEnumerator] allObjects];
        for (QiitarianLatestItem *item in reversed) {
            if ([_list containsObject:item.title] == false) {
                [_list insertObject:item.title atIndex:0];
            }
        }
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Table View用プロトコルの実装
//-------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_list count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"id"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
    }
    
    NSString *title = [_list objectAtIndex:indexPath.row];
    cell.textLabel.text = title;
    return cell;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if(self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.bounds.size.height)) {
        NSLog(@"bottom!!");
        
        if (_isUpdating) {
            return;
        }
        if (10 <= _currentPage) {
            return;
        }
        
        //最下部への記事追加
        _isUpdating = YES;
        QiitarianLatestItemsFetcher *fetcer = [[QiitarianLatestItemsFetcher alloc] init];
        [fetcer fetch:^(NSArray *array) {
            for (QiitarianLatestItem *item in array) {
                if ([_list containsObject:item.title] == false) {
                    [_list addObject:item.title];
                }
            }
            [self.tableView reloadData];
            _isUpdating = NO;
        } index:++_currentPage];
    }
}
//-------------------------

@end
