//
//  ViewController.m
//  NameCardMS
//
//  Created by 郝 林巍 on 15/4/15.
//  Copyright (c) 2015年 lincwee. All rights reserved.
//

#import "ViewController.h"
#import "MacroFile.h"
#import "ShortenInfoCell.h"
#import "DetailInfoViewConteroller.h"
#import "SqliteManage.h"
#import "PerClass.h"
#import "CardSearchBar.h"
#import "SSSearchBar.h"


//#import "Tesseract.h"


#define RGBA(R/*红*/, G/*绿*/, B/*蓝*/, A/*透明*/) \
[UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:A]



@interface ViewController ()

@end

@implementation ViewController
@synthesize m_pTableView, /*m_pAppNameLabel,*/ m_pRefreshFooter, m_pDataList, m_pLeftOpsBTN, m_pRightOpsBTN, m_pSqlmanager, m_pDataCorList, m_pDataCloudList, m_pDataCloudCorList, m_pNaviMenu, m_pProgressHUD;
- (void)viewDidLoad {
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"this is ver1.0.1");
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor colorWithRed:25.f/255.f green:25.f/255.f blue:112.f/255.f alpha:1.f];
    //self.view.backgroundColor = [self ColorRGBWithRED:160.f GREEN:216.f BLUE:223.f];
    
    m_pSqlmanager = [[SqliteManage alloc]init];
    [m_pSqlmanager loadData];
    [self initView];
    [self initNavigationMenuView];
    
    //菊花转
    m_pProgressHUD = [[MBProgressHUD alloc]initWithView:self.view];
    [((AppDelegate *)([UIApplication sharedApplication].delegate)).window addSubview:m_pProgressHUD];
    m_pProgressHUD.delegate = self;
   	m_pProgressHUD.labelText = @"数据加载中...";
    m_pProgressHUD.dimBackground = YES;

}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [m_pDataList removeAllObjects];
//    [m_pDataCorList removeAllObjects];
//    [m_pSqlmanager loadPersonDataWithArray:m_pDataList];
//    [m_pSqlmanager loadCorDataWithArray:m_pDataCorList];
    if (m_pNaviMenu.getIndexNow == 0) {
        [self didSelectLocalData];
    }
    else if(m_pNaviMenu.getIndexNow == 1){
        [self didSelectCloudData];
    }
    self.RootAppDelegate.m_pAppNameLabel.text = @"名片管理系统";
    self.RootAppDelegate.m_pAppNameLabel.hidden = YES;
    
    self.RootAppDelegate.m_pLeftOpsBTN.hidden = NO;
    self.RootAppDelegate.m_pRightOpsBTN.hidden = NO;
    [m_pTableView setEditing:NO];
    //[self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void) viewDidDisappear:(BOOL)animated
{
    
}

-(void) initView
{

    m_pTableView = [[UITableView alloc]initWithFrame:CGRectMake(0.f, 0.f, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];

    m_pDataList = [[NSMutableArray alloc]init];
    m_pDataCorList = [[NSMutableArray alloc]init];
    m_pDataCloudList = [[NSMutableArray alloc]init];
    m_pDataCloudCorList = [[NSMutableArray alloc]init];
    [m_pSqlmanager loadPersonDataWithArray:m_pDataList];
    [m_pSqlmanager loadCorDataWithArray:m_pDataCorList];
//    NSArray *list = [NSArray arrayWithObjects:@"武汉",@"上海",@"北京",@"深圳",@"广州",@"重庆",@"香港",@"台海",@"天津", nil];
    //m_pDataList = list;
    [m_pTableView setDelegate:self];
    [m_pTableView setDataSource:self];
    [self.view addSubview:m_pTableView];
    m_pRefreshFooter = [SDRefreshHeaderView refreshView];
    [m_pRefreshFooter addToScrollView:m_pTableView];
    [m_pRefreshFooter addTarget:self refreshAction:@selector(lalala)];
    
    
    //导航栏中back键的文字和颜色
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    //菊花转
    m_pProgressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [((AppDelegate *)([UIApplication sharedApplication].delegate)).window addSubview:m_pProgressHUD];
    //[self.view addSubview:m_pProgressHUD];
    //[self.view insertSubview:m_pProgressHUD atIndex:999];
    //m_pProgressHUD.mode = MBProgressHUDModeAnnularDeterminate;
    
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    m_pProgressHUD.delegate = self;
    
    // Show the HUD while the provided method executes in a new thread
   	m_pProgressHUD.labelText = @"登录中...";
}
- (AppDelegate *) RootAppDelegate
{
    return ((AppDelegate *)([UIApplication sharedApplication].delegate));
}

-(void) initNavigationMenuView
{
    CGRect frame = CGRectMake(0.0, 0.0, 200.0, self.navigationController.navigationBar.bounds.size.height);
    m_pNaviMenu = [[SINavigationMenuView alloc] initWithFrame:frame title:@"本地名片"];

    [m_pNaviMenu displayMenuInView:self.view];
    m_pNaviMenu.items = @[@"本地名片", @"云端名片"];
    m_pNaviMenu.delegate = self;
    self.navigationItem.titleView = m_pNaviMenu;
}

- (void)didSelectItemAtIndex:(NSUInteger)index
{
    //NSLog(@"did selected item at index %d", index);
    switch (index) {
        case 0:
        {
            [self didSelectLocalData];
        }
            break;
        case 1:
        {
            [self didSelectCloudData];
        }
            break;
        default:
            break;
    }
    [m_pProgressHUD showAnimated:YES whileExecutingBlock:^{
        [self myTask];
    } completionBlock:^{
        //[m_pProgressHUD hide:YES];
        [m_pTableView reloadData];
    }];
}

-(void) myTask
{
    sleep(4);
}
-(void) didSelectLocalData
{
    [m_pDataList removeAllObjects];
    [m_pDataCorList removeAllObjects];
    [m_pSqlmanager loadPersonDataWithArray:m_pDataList];
    [m_pSqlmanager loadCorDataWithArray:m_pDataCorList];
    [m_pTableView reloadData];
}

-(void) didSelectCloudData
{
    [m_pDataList removeAllObjects];
    [m_pDataCorList removeAllObjects];
    
    NSString *sendMsg = [NSString stringWithFormat:@"http://192.168.1.100:8080/MavenJavaWebDemo/myservlet?Type=1"];
    //@"http://192.168.1.103:8080/MavenJavaWebDemo/myservlet?username=zdw&password=admin"
    [ServerHelper startGETConnection:sendMsg];
    [ServerHelper setDelegate:self];
}

-(void) didReceiveMsg
{
    NSMutableData *data= [ServerHelper getGetData];
    NSString *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSString *finalName = [output stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
    //NSLog(@"%@",finalName);
//    NSString * path = [[NSBundle mainBundle]pathForResource:@"Notes" ofType:@"json" ];
//    NSData * jsonData = [[NSData alloc] initWithContentsOfFile:path];
    
    NSError * error ;
    id jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (!jsonData || error) {
        NSLog(@"JSON解析失败");
    }
    NSArray *px = [[NSMutableArray alloc]init];
    px = [jsonData objectForKey:@"CloudData"];
//    NSString *fuck = [NSString stringWithFormat:@"%@", [px objectAtIndex:0]];
    if(px)
    {
        for (int i = 0; i < [px count]; i++) {
            PerClass *temp = [[PerClass alloc]init];
            NSMutableDictionary * dict = [px objectAtIndex:i];
            temp->perName = [dict objectForKey:PER_NAME];
            temp->perMobile = [dict objectForKey:PER_MOBILE];
            temp->perPosition = [dict objectForKey:PER_POSITION];
            temp->perTel = [dict objectForKey:PER_TEL];
            temp->perEmail = [dict objectForKey:PER_EMAIL];
            [m_pDataList addObject:temp];
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            CorClass *temp1 = [[CorClass alloc]init];
            temp1->corName = [userDefaults stringForKey:COR_NAME];
            temp1->corAddress = [userDefaults stringForKey:COR_ADDRESS];
            temp1->corFax = [userDefaults stringForKey:COR_FAX];
            temp1->corTel = [userDefaults stringForKey:COR_TEL];
            temp1->corInteroduce = [userDefaults stringForKey:COR_INTRODUCE];
            [m_pDataCorList addObject:temp1];
        }
        
    }
    [m_pTableView reloadData];
    [m_pProgressHUD hide:YES];
//    NSData *data1 = [output dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *pError;
//    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableContainers error:&pError];
//    NSArray *px = [jsonData objectForKey:@"CloudData"];
//    NSString *fuck = [NSString stringWithFormat:@"%@", [px objectAtIndex:0]];
    
}

-(void)didNotReceiveMsg
{
    NSLog(@"没有接受到数据");
    [m_pProgressHUD hide:YES];
}

-(void) lalala
{
//    static int freshTime = 1;
//    if (freshTime < 10) {
//        m_pAppNameLabel.text = [NSString stringWithFormat:@"下拉刷新次数:%d",freshTime++];
//    }
//    else {
//        m_pAppNameLabel.text = @"名片管理系统";
//        freshTime = 1;
//    }
    [m_pTableView reloadData];
    [m_pRefreshFooter endRefreshing];
}

-(UIColor *) ColorRGBWithRED:(float)Red GREEN:(float)Green BLUE:(float)Blue
{
    return [UIColor colorWithRed:Red / 255.f green:Green / 255.f blue:Blue / 255.f alpha:1.f];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void) viewWillLayoutSubviews{
//    //[self performSelector:@selector(hideNavBar) withObject:nil afterDelay:0.0];
//}
//
//-(void) hideNavBar {
//    if (self.navigationController.navigationBar.hidden == NO)
//    {
//        [self.navigationController setNavigationBarHidden:YES animated:YES];
//    }
//}

-(void)showLeft{
    [((AppDelegate *)([UIApplication sharedApplication].delegate)).slideViewController showLeftSideFinish:nil];
}

-(void)showRight{
    [((AppDelegate *)([UIApplication sharedApplication].delegate)).slideViewController showRightSideFinish:nil];
}

#pragma mark -tableView

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShortenInfoCell *cell = nil;
    if ([tableView isEqual:m_pTableView]) {
        cell = [[ShortenInfoCell alloc]init];
//        static NSString *tableViewCellIdentifier = @"MyCells";//设置Cell标识
//        cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier];
        PerClass *person = [m_pDataList objectAtIndex:[indexPath row]];
        CorClass *cor = [m_pDataCorList objectAtIndex:[indexPath row]];
        [cell setPersonName:person->perName Position:person->perPosition CorAddress:cor->corAddress];
        if ([m_pNaviMenu getIndexNow] == 0) {
            [cell setAvatar:[NSString stringWithFormat:@"%@.png",person->PID]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tag = [indexPath row];
        //NSLog(@"%d", cell.tag);
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    //[m_pDataList removeObjectAtIndex:row];//bookInfo为当前table中显示的array
    
    //[tableView deleteRowsAtIndexPaths:[NSArrayarrayWithObject:indexPath]withRowAnimation:UITableViewRowAnimationLeft];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSInteger row = [indexPath row];
        NSArray *visiblecells = [m_pTableView visibleCells];
        for(ShortenInfoCell *cell in visiblecells)
        {
            if (cell.tag == row) {
                //NSLog(@"cell.tag is %d", cell.tag);
                PerClass *temp = [m_pDataList objectAtIndex:[cell tag]];
                if([m_pSqlmanager deletePersonData:temp]){
                    [self deleteSandBoxPhoto:temp->PID];
                    NSLog(@"delete %@ successful", temp->perName);
                }
                [m_pDataList removeObjectAtIndex:[cell tag]];
                [m_pDataCorList removeObjectAtIndex:[cell tag]];
                //刷新需要放到一个新的线程里面才能保证在刷新的时候tableview显示的数据不会发生变化
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [m_pTableView reloadData];
                    
                });
                break;
            }
        }
        //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
        // 数据源也要相应删除一项
    }
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"m_classList count :%d", [self.m_pDataList count]);
    return [self.m_pDataList count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailInfoViewConteroller *detailView = [[DetailInfoViewConteroller alloc]init];
    detailView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    //[self.navigationController pushViewController:detailView animated:NO];
    [((AppDelegate *)([UIApplication sharedApplication].delegate)).m_pNavViewController pushViewController:detailView animated:YES];
    detailView.view.backgroundColor = MOON_WHITE;
    //detailView.m_state = DETAIL_INFO_VIEW_STATE_SAVE;
    [detailView setViewState:DETAIL_INFO_VIEW_STATE_EDIT];
    PerClass *person = [m_pDataList objectAtIndex:[indexPath row]];
    CorClass *cor = [m_pDataCorList objectAtIndex:[indexPath row]];
    NSLog(@"-------need PID: %@-------",person->PID);
    self.RootAppDelegate.m_pAppNameLabel.text = [NSString stringWithFormat:@"%@",person->perName];
    self.RootAppDelegate.m_pAppNameLabel.hidden = NO;
    
    //20150528230126
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",person->PID]];   // 保存文件的名称
    UIImage *img = [UIImage imageWithContentsOfFile:filePath];
    NSData *imgData = UIImageJPEGRepresentation(img, 1.f);
    //当在云端名片的时候，就不出现图片
    if ([m_pNaviMenu getIndexNow]==0) {
        [detailView setCardImageData:imgData];
    }
    NSLog(@"-------length:%d--------",imgData.length);
    [detailView setPersonDate:person AndCordate:cor];
    self.RootAppDelegate.m_pLeftOpsBTN.hidden = YES;
    self.RootAppDelegate.m_pRightOpsBTN.hidden = YES;
}

-(void) deleteSandBoxPhoto:(NSString *)name
{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    //文件名
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",name]];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (!blHave) {
        NSLog(@"删除的图片并不存在");
        return ;
    }else {
        NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
        if (blDele) {
            NSLog(@"删除图片成功");
        }else {
            NSLog(@"删除图片失败");
        }
        
    }
}
@end
