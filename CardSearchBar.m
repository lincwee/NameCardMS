//
//  CardSearchBar.m
//  NameCardMS
//
//  Created by 郝 林巍 on 15/5/24.
//  Copyright (c) 2015年 lincwee. All rights reserved.
//

#import "CardSearchBar.h"
#import "BDSuggestLabel.h"
#import "AppDelegate.h"
#import "DetailInfoViewConteroller.h"
#import "ServerHelper.h"

#define kXMargin 8
#define kYMargin 4
#define kIconSize 16

#define kSearchBarHeight 32

@implementation CardSearchBar
@synthesize searchDisplayController_, suggestItems, searchBar_, resultItems, m_pSqlmanager, originIndex, m_pInputText, m_pJsonDic;

- (void)setDefaults {
    resultItems = [[NSMutableArray alloc] init];
    suggestItems = [[NSMutableData alloc]init];
    originIndex = [[NSMutableArray alloc]init];
    
    //    [suggestItems addObject:@"teacher wang, i am a good student!"];
    //    [suggestItems addObject:@"teacher wang"];
    //    [suggestItems addObject:@"teacher wang is fill"];
    //    [suggestItems addObject:@"teacher wang has leaved"];
//    [suggestItems addObject:@"a"];
//    [suggestItems addObject:@"我是"];
//    [suggestItems addObject:@"我的"];
//    [suggestItems addObject:@"我有"];
//    [suggestItems addObject:@"我是什么"];
    
    
    
    searchBar_ = [[UISearchBar alloc] initWithFrame:CGRectMake(0.f, 0.f, 200.f, 40.f)];
    searchBar_.delegate = self;
    //[searchBar_ setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    searchBar_.showsCancelButton = NO;
    [searchBar_ sizeToFit];
    //searchBar_.hidden = YES;
    //searchBar_.barTintColor = [UIColor greenColor];
    searchBar_.searchBarStyle = UISearchBarStyleMinimal;
    
    [self addSubview:searchBar_];
    
     [searchDisplayController_.searchContentsController.navigationController setNavigationBarHidden:NO animated:NO];

    m_pSqlmanager = [[SqliteManage alloc]init];
    [m_pSqlmanager loadData];
}

-(void) initUISearchView:(UIViewController *)ViewController
{
    searchDisplayController_ = [[UISearchDisplayController alloc] initWithSearchBar:searchBar_ contentsController:ViewController];
    searchDisplayController_.delegate = self;
    [searchDisplayController_ setSearchResultsDataSource:self];
    [searchDisplayController_ setSearchResultsDelegate:self];
}

- (id)initWithFrame:(CGRect)frame
{
    
    CGRect newFrame = frame;
    frame = newFrame;
    frame.size.height = kSearchBarHeight;
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaults];
    }
    return self;
}

-(void) setDataSource:(NSArray *)data
{
//    if ([suggestItems count] > 0) {
//        //[suggestItems removeAllObjects];
//        for (int i = 0; i < [data count]; ++i) {
//            [suggestItems addObject:[data objectAtIndex:i]];
//        }
//        return;
//    }
//    if ([suggestItems count] > 0) {
//        [suggestItems removeAllObjects];
//    }
    if (data) {
        suggestItems = data;
    }
}

#pragma mark Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == searchDisplayController_.searchResultsTableView)
    {
        return [suggestItems count];
    }
    else
    {
        return [resultItems count];
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailInfoViewConteroller *detailView = [[DetailInfoViewConteroller alloc]init];
    detailView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    //[self.navigationController pushViewController:detailView animated:NO];
    [((AppDelegate *)([UIApplication sharedApplication].delegate)).m_pNavViewController pushViewController:detailView animated:YES];
    detailView.view.backgroundColor = [UIColor whiteColor];
    //detailView.m_state = DETAIL_INFO_VIEW_STATE_SAVE;
    [detailView setViewState:DETAIL_INFO_VIEW_STATE_EDIT];
    
    NSString *originIndexString = [originIndex objectAtIndex:[indexPath row]];
    int trueIndex = [originIndexString intValue];
    NSMutableArray *perData = [[NSMutableArray alloc]init];
    NSMutableArray *corData = [[NSMutableArray alloc]init];
    [m_pSqlmanager loadPersonDataWithArray:perData];
    [m_pSqlmanager loadCorDataWithArray:corData];
    PerClass *person = [perData objectAtIndex:trueIndex];
    CorClass *cor = [corData objectAtIndex:trueIndex];
    
//    m_pAppNameLabel.text = [NSString stringWithFormat:@"%@",person->perName];
//    m_pAppNameLabel.hidden = NO;
    
    
    [detailView setPersonDate:person AndCordate:cor];
    self.RootAppDelegate.m_pLeftOpsBTN.hidden = YES;
    self.RootAppDelegate.m_pRightOpsBTN.hidden = YES;
    self.RootAppDelegate.m_pAppNameLabel.text = [NSString stringWithFormat:@"%@", person->perName];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [((AppDelegate *)([UIApplication sharedApplication].delegate)).slideViewController hideSideFinish:nil];
            NSLog(@"page exchange success!");
    });
}

- (AppDelegate *) RootAppDelegate
{
    return ((AppDelegate *)([UIApplication sharedApplication].delegate));
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    if(tableView == searchDisplayController_.searchResultsTableView)
    {
        //        NSLog(@"indexPath.row :%d", indexPath.row);
        for(UIView * elem in [cell.contentView subviews])
        {
            if([elem isKindOfClass:[BDSuggestLabel class]])
            {
                //NSLog(@"remove");
                [elem removeFromSuperview];
            }
        }
        BDSuggestLabel * richTextLabel = [[BDSuggestLabel alloc] initWithFrame:CGRectMake(10, 10, 300, 25)];
        PerClass *person = [suggestItems objectAtIndex:indexPath.row];
        richTextLabel.text = person->perName;
        richTextLabel.keyWord = searchBar_.text;//设置当前搜索的关键字
        richTextLabel.backgroundColor = [UIColor clearColor];
        richTextLabel.font = [UIFont systemFontOfSize:17.0f];
        richTextLabel.textColor = [UIColor grayColor];
        [cell.contentView addSubview:richTextLabel];
    }
    else
    {
        cell.textLabel.text = [suggestItems objectAtIndex:indexPath.row];
    }
    
    return cell;
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
//    NSString *temp = @"我是干啥子的啊";
//    NSRange rangInputText = [temp rangeOfString:searchText];
//    NSLog(@"输入的字符:%@ 在string中的起始点index为: %d",searchText, rangInputText.location);
    m_pInputText = searchText;
    [self RankArrayWithInputText:searchText];
    [searchDisplayController_.searchResultsTableView reloadData];
    //NSLog(@"%@", searchText);
}

-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
//    view1.frame = CGRectMake(20.f, 0.f, 240.f, 40.f);
}
#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller{
    /*
     Bob: Because the searchResultsTableView will be released and allocated automatically, so each time we start to begin search, we set its delegate here.
     */
    [searchDisplayController_.searchResultsTableView setDelegate:self];
     // [self.RootAppDelegate.m_pNavViewController setNavigationBarHidden:NO];
    
}

-(void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
//    searchBar_.showsCancelButton = NO;
//    for(id cc in [searchBar_ subviews])
//    {
//        if([cc isKindOfClass:[UIButton class]])
//        {
//            UIButton *btn = (UIButton *)cc;
//            [btn setTitle:@"取消"  forState:UIControlStateNormal];
//        }
//    }
    [m_pSqlmanager loadData];
    NSMutableArray *perData = [[NSMutableArray alloc]init];
    [m_pSqlmanager loadPersonDataWithArray:perData];
    [self setDataSource:perData];
    //[searchDisplayController_.searchResultsTableView reloadData];
    //[searchDisplayController_]
}



- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
    
    [searchBar_ resignFirstResponder];
}
- (void) searchDisplayControllerWillEndSearch
{
    NSLog(@"123");
}
-(void) searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView
{
    NSLog(@"123");
}

//- (void)viewDidUnload
//{
//    [super viewDidUnload];
//    // Release any retained subviews of the main view.
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) RankArrayWithInputText:(NSString *)inputText
{
    int itemsCount = [suggestItems count];
    for (int i = 0; i < itemsCount; ++i) {
        [originIndex addObject:[NSString stringWithFormat:@"%d",i]];
    }
    for (int i = 0 ; i < itemsCount; ++i) {
        for (int j = 0; j < itemsCount; ++j) {
            NSString *objectString1 = ((PerClass *)[suggestItems objectAtIndex:i])->perName;
            NSString *objectString2 = ((PerClass *)[suggestItems objectAtIndex:j])->perName;
            NSRange rangeInputText1 = [objectString1 rangeOfString:inputText];
            NSRange rangeInputText2 = [objectString2 rangeOfString:inputText];
            if (rangeInputText1.length > rangeInputText2.length) {
                id Object1 = [suggestItems objectAtIndex:i];
                id Object2 = [suggestItems objectAtIndex:j];
                NSString *index1 = [originIndex objectAtIndex:i];
                NSString *index2 = [originIndex objectAtIndex:j];
                [suggestItems replaceObjectAtIndex:i withObject:Object2];
                [suggestItems replaceObjectAtIndex:j withObject:Object1];
                //originIndex存储的原始的index，在点击tableViewCell的时候确保点击的是需要的信息
                [originIndex replaceObjectAtIndex:i withObject:index2];
                [originIndex replaceObjectAtIndex:j withObject:index1];
            }
        }
    }
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //按键确定时候的触发事件
    NSLog(@"search button clicked!");
    NSString *finalName = [m_pInputText stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    //m_pInputText
    [ServerHelper startGETConnection:[NSString stringWithFormat:@"http://10.12.67.237:8080/MySQL-JSON-Test/Action?EName=%@", finalName]];
    //[ServerHelper startGETConnection:@"http://10.12.67.237:8080/MySQL-JSON-Test/Action?EName=Serena_Williams"];
    NSMutableData *data= [ServerHelper getGetData];
    NSString *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", output);
    
    if (data) {
        NSError *pError;
        m_pJsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&pError];
        [self showNewPageWithDate:m_pJsonDic];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"查询结果" message:@"云端未查询到相应信息" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
    //NSArray *px = [m_pJsonDic objectForKey:@"comp"];
    //NSString *fuck = [NSString stringWithFormat:@"%@", [px objectAtIndex:0]];
}
-(BOOL) showNewPageWithDate:(NSDictionary *)JsonDic
{
    if (JsonDic) {
        DetailInfoViewConteroller *detailView = [[DetailInfoViewConteroller alloc]init];
        detailView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [detailView setViewState:DETAIL_INFO_VIEW_STATE_SAVE];
        //[self.navigationController pushViewController:detailView animated:NO];
        [((AppDelegate *)([UIApplication sharedApplication].delegate)).m_pNavViewController pushViewController:detailView animated:YES];
        detailView.view.backgroundColor = MOON_WHITE;
        //detailView.view.backgroundColor = [UIColor whiteColor];
        NSLog(@"%@",[NSString stringWithFormat:@"%@",[m_pJsonDic objectForKey:@"name"]]);
        [detailView setCardImageData:nil];
        [detailView setPersonalName:[self combinationStringWithArray:[JsonDic objectForKey:@"name"]]
                           Position:[self combinationStringWithArray:[JsonDic objectForKey:@"title"]]
                             Mobile:[self combinationStringWithArray:[JsonDic objectForKey:@"mobile"]]
                                TEL:[self combinationStringWithArray:[JsonDic objectForKey:@"tel"]]
                              Email:[self combinationStringWithArray:[JsonDic objectForKey:@"email"]]
                           CorpName:[self combinationStringWithArray:[JsonDic objectForKey:@"comp"]]
                            Andress:[self combinationStringWithArray:[JsonDic objectForKey:@"addr"]]
                                FAX:[self combinationStringWithArray:[JsonDic objectForKey:@"fax"]]];
        ((AppDelegate *)([UIApplication sharedApplication].delegate)).m_pLeftOpsBTN.hidden = YES;
        ((AppDelegate *)([UIApplication sharedApplication].delegate)).m_pRightOpsBTN.hidden = YES;
        return YES;
    }
    return NO;
}

-(NSString *) combinationStringWithArray:(NSArray *)array
{
    NSString *temp = @"";
    
    if (array) {
        for (int i = 0; i < [array count]; i ++) {
            temp = [temp stringByAppendingString:[NSString stringWithFormat:@"%@ ", [array objectAtIndex:i]]];
        }
    }
    return temp;
}

@end
