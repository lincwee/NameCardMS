//
//  LeftBackSideView.m
//  NameCardMS
//
//  Created by 郝 林巍 on 15/4/19.
//  Copyright (c) 2015年 lincwee. All rights reserved.
//

#import "LeftBackSideView.h"
#import "AppDelegate.h"
#import "HWCloudsdk.h"
#import "DetailInfoViewConteroller.h"
#import "CardSearchBar.h"


@implementation LeftBackSideView

//m_pTableView may be not used
@synthesize m_pTableView, m_pTopView, m_pAlphaView, m_pActivityView, m_pOnRecognitionLable, jsonData, m_pSqlmanager, m_pCardImage;
-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(150, 40, 20.f, 20.f)];
//    button.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:button];
//    [button addTarget:self action:@selector(hideSide) forControlEvents:UIControlEventTouchUpInside];
    
//    m_pTableView = [[UITableView alloc]initWithFrame:CGRectMake(10.f, 40.f, 100.f, 400.f)];
//    [m_pTableView setDelegate:self];
//    [self.view addSubview:m_pTableView];
//    m_pTableView.separatorColor = [UIColor blackColor];
    
    
}

-(void) initView
{
    m_pTopView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, LEFT_BACKSIDE_VIEW_WIDTH, LEFT_BACKSIDE_VIEW_TOPVIEW_HEIGHT)];
    m_pTopView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = MOON_WHITE;
    [self.view addSubview:m_pTopView];
    
    
    UILabel *pTopLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.f, 30.f, 120.f, 30.f)];
    pTopLabel.center = m_pTopView.center;
    pTopLabel.text = @"名片信息操作";
    pTopLabel.textColor = [UIColor blackColor];
    pTopLabel.adjustsFontSizeToFitWidth = YES;
    [m_pTopView addSubview:pTopLabel];

    [self.view addSubview:[self addButtonWithString:@"手动添加" AndFrame:CGRectMake(0.f, LEFT_BACKSIDE_VIEW_BUTTON_TOP1_POSY, LEFT_BACKSIDE_VIEW_WIDTH, LEFT_BACKSIDE_VIEW_BUTTON_HEIGHT)andAction:@selector(addDataBySelf)]];
    
    
    [self.view addSubview:[self addButtonWithString:@"自动添加" AndFrame:CGRectMake(0.f, LEFT_BACKSIDE_VIEW_BUTTON_TOP1_POSY + LEFT_BACKSIDE_VIEW_BUTTON_BUTTON_OFFSET, LEFT_BACKSIDE_VIEW_WIDTH, LEFT_BACKSIDE_VIEW_BUTTON_HEIGHT)andAction:@selector(chooseImage:)]];
    
//    [self.view addSubview:[self addButtonWithString:@"" AndFrame:CGRectMake(0.f, LEFT_BACKSIDE_VIEW_BUTTON_TOP1_POSY + LEFT_BACKSIDE_VIEW_BUTTON_BUTTON_OFFSET * 2, LEFT_BACKSIDE_VIEW_WIDTH, LEFT_BACKSIDE_VIEW_BUTTON_HEIGHT)andAction:@selector(null)]];
    
    CardSearchBar *searchBar = [[CardSearchBar alloc]initWithFrame:CGRectMake(0.f, LEFT_BACKSIDE_VIEW_BUTTON_TOP1_POSY - LEFT_BACKSIDE_VIEW_BUTTON_BUTTON_OFFSET, LEFT_BACKSIDE_VIEW_WIDTH, LEFT_BACKSIDE_VIEW_BUTTON_HEIGHT)];
    //searchBar.delegate = self;
    //[searchBar setDataSource:nil];
    [searchBar initUISearchView:self];
    [self.view addSubview: searchBar];
    m_pSqlmanager = [[SqliteManage alloc]init];
    [m_pSqlmanager loadData];
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    [m_pSqlmanager loadPersonDataWithArray:tempArray];
//    for (int i = 0 ; i < [tempArray count]; ++i) {
//        PerClass *temp = [tempArray objectAtIndex:i];
//        [stringArray addObject:temp->perName];
//    }
//    [searchBar setDataSource:tempArray];
//    [self.view addSubview:[self addButtonWithString:@"" AndFrame:CGRectMake(0.f, LEFT_BACKSIDE_VIEW_BUTTON_TOP1_POSY + LEFT_BACKSIDE_VIEW_BUTTON_BUTTON_OFFSET * 3, LEFT_BACKSIDE_VIEW_WIDTH, LEFT_BACKSIDE_VIEW_BUTTON_HEIGHT)andAction:nil]];

}


-(void) HavonSDKtest
{
    HWCloudsdk *sdk = [[HWCloudsdk alloc]init];

    m_pActivityView.center = self.view.center;
    //[((AppDelegate *)([UIApplication sharedApplication].delegate)).slideViewController.view addSubview:activityIndicatorView];

    //[activityIndicatorView startAnimating];
    UIImage *cardImg = [UIImage imageNamed:@"cardimage.jpg"];
    
    [NSThread detachNewThreadSelector:@selector(alertShowOrNot) toTarget:self withObject:nil];
    //NSThread* myThread = [[NSThread alloc] initWithTarget:self selector:@selector(doSomething) object:nil];
    //[myThread start];
    
    //apiKey 需要您到developer.hanvon.com 自行申请
    NSString *apiKey = @"95648fde-a075-4a88-86b5-47d842cf7a5b";
    NSString *str = [sdk cardLanguage:@"chns" cardImage:cardImg apiKey:apiKey];
    //NSString *str1 = [sdk cardLanguage:@"chns" imagePath:@"cardimage.jpg" apiKey:apiKey];
    NSLog(@"返回的结果是 : %@",str);
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"识别结果" message:str delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //[activityIndicatorView stopAnimating];
    [alert show];
    if (m_pActivityView) {
        [m_pActivityView stopAnimating];
    }
    if (m_pAlphaView) {
        m_pAlphaView.hidden = YES;
    }
    if (m_pOnRecognitionLable) {
        m_pOnRecognitionLable.hidden = YES;
    }
    
}

-(void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex) {
        [self alertShowOrNot];
    }
}

-(void) alertShowOrNot
{
    static BOOL flag = YES;
    if (!m_pAlphaView) {
        m_pAlphaView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, self.view.bounds.size.width, self.view.bounds.size.height)];
        m_pAlphaView.backgroundColor = [UIColor blackColor];
        m_pAlphaView.alpha = 0.6f;
        [((AppDelegate *)([UIApplication sharedApplication].delegate)).slideViewController.view  addSubview:m_pAlphaView];
        
        m_pActivityView = [ [ UIActivityIndicatorView  alloc ]
                           initWithFrame:CGRectMake(0.0,0.0,40.0,40.0)];
        m_pActivityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        m_pActivityView.hidesWhenStopped = YES;
        m_pActivityView.center = m_pAlphaView.center;
        [((AppDelegate *)([UIApplication sharedApplication].delegate)).slideViewController.view addSubview:m_pActivityView];
        m_pOnRecognitionLable = [[UILabel alloc]initWithFrame:CGRectMake(0.f, 200.f, 320.f, 50.f)];
        m_pOnRecognitionLable.textAlignment = UITextAlignmentCenter;
        m_pOnRecognitionLable.text = @"正在识别.....";
        m_pOnRecognitionLable.font = [UIFont systemFontOfSize:24.0f];
        m_pOnRecognitionLable.alpha = 1.f;
        m_pOnRecognitionLable.textColor = [UIColor whiteColor];
        [((AppDelegate *)([UIApplication sharedApplication].delegate)).slideViewController.view addSubview: m_pOnRecognitionLable];
    }
    if (flag) {
        [m_pActivityView startAnimating];
        m_pAlphaView.hidden = NO;
        m_pOnRecognitionLable.hidden = NO;
        flag = NO;
    }
    else
    {
        //[view1 removeFromSuperview];
        flag = YES;
    }

}

#pragma -mark camera
- (void)addDataBySelf
{
    DetailInfoViewConteroller *detailView = [[DetailInfoViewConteroller alloc]init];
    detailView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [detailView setViewState:DETAIL_INFO_VIEW_STATE_SAVE];
    //[self.navigationController pushViewController:detailView animated:NO];
    [((AppDelegate *)([UIApplication sharedApplication].delegate)).m_pNavViewController pushViewController:detailView animated:YES];
    detailView.view.backgroundColor = MOON_WHITE;
    //detailView.view.backgroundColor = [UIColor whiteColor];
    [detailView setCardImageData:nil];
    ((AppDelegate *)([UIApplication sharedApplication].delegate)).m_pLeftOpsBTN.hidden = YES;
    ((AppDelegate *)([UIApplication sharedApplication].delegate)).m_pRightOpsBTN.hidden = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [((AppDelegate *)([UIApplication sharedApplication].delegate)).slideViewController hideSideFinish:nil];
    });
    
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissModalViewControllerAnimated:YES];
    //通过UIImagePickerControllerMediaType判断返回的是照片还是视频
    NSString* type = [info objectForKey:UIImagePickerControllerMediaType];
    //如果返回的type等于kUTTypeImage，代表返回的是照片,并且需要判断当前相机使用的sourcetype是拍照还是相册
    //if ([type isEqualToString:@"UIImagePickerControllerOriginalImage"]) {
    UIImage* original_image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        NSLog(@"fuck");
        UIImageWriteToSavedPhotosAlbum(original_image, self,
                                       @selector(image:didFinishSavingWithError:contextInfo:),
                                       nil);

    }
            //}
    //模态方式退出uiimagepickercontroller
    UIImage* image = [info objectForKey: @"UIImagePickerControllerOriginalImage"];
    
    m_pCardImage =UIImageJPEGRepresentation(image, 0.5);//压缩图片内容，不影响图片的size，得到一个原大小，但更模糊的图片。
    
    HWCloudsdk *sdk = [[HWCloudsdk alloc]init];
    NSString *apiKey = @"5b96228b-10be-4f03-ab5a-67b57ef43612";
    NSString *str = [sdk cardLanguage:@"chns" cardImage:image apiKey:apiKey];
    NSLog(@"%@",str);
    //NSString *str1 = [sdk cardLanguage:@"chns" imagePath:@"cardimage.jpg" apiKey:apiKey];
    NSLog(@"返回的结果是 : %@",str);

    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *pError;
    jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&pError];
    NSArray *px = [jsonData objectForKey:@"comp"];
    NSString *fuck = [NSString stringWithFormat:@"%@", [px objectAtIndex:0]];
    
    NSString *xy = [self combinationStringWithArray:[jsonData objectForKey:@"comp"]];
    fuck = [fuck stringByAppendingString:xy];
    //NSLog(@"%@", jsonData);
    
    //延迟0.5秒显示数据，放置线程中的数据冲突
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self showNewPageWithData]) {
            [((AppDelegate *)([UIApplication sharedApplication].delegate)).slideViewController hideSideFinish:nil];
            NSLog(@"page exchange success!");
        }
        
    });
    

}

//将每一个array中的每一个object都组合起来
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

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo{

//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"识别结果" message:str delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
}

-(IBAction)chooseImage:(id)sender {
    
    UIActionSheet *sheet;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
        
    }
    
    else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
        
    }
    
    sheet.tag = 255;
    
    [sheet showInView:self.view];
    
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                case 0:
                    // 取消
                    return;
                case 1:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                    
                case 2:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.allowsEditing = NO;
        
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
        
    }
}

-(BOOL) showNewPageWithData
{
    if (jsonData) {
        DetailInfoViewConteroller *detailView = [[DetailInfoViewConteroller alloc]init];
        detailView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [detailView setViewState:DETAIL_INFO_VIEW_STATE_SAVE];
        //[self.navigationController pushViewController:detailView animated:NO];
        [((AppDelegate *)([UIApplication sharedApplication].delegate)).m_pNavViewController pushViewController:detailView animated:YES];
        detailView.view.backgroundColor = MOON_WHITE;
        //detailView.view.backgroundColor = [UIColor whiteColor];
        NSLog(@"%@",[NSString stringWithFormat:@"%@",[jsonData objectForKey:@"name"]]);
        [detailView setCardImageData:m_pCardImage];
        [detailView setPersonalName:[self combinationStringWithArray:[jsonData objectForKey:@"name"]]
                           Position:[self combinationStringWithArray:[jsonData objectForKey:@"title"]]
                             Mobile:[self combinationStringWithArray:[jsonData objectForKey:@"mobile"]]
                                TEL:[self combinationStringWithArray:[jsonData objectForKey:@"tel"]]
                              Email:[self combinationStringWithArray:[jsonData objectForKey:@"email"]]
                           CorpName:[self combinationStringWithArray:[jsonData objectForKey:@"comp"]]
                            Andress:[self combinationStringWithArray:[jsonData objectForKey:@"addr"]]
                                FAX:[self combinationStringWithArray:[jsonData objectForKey:@"fax"]]];
        ((AppDelegate *)([UIApplication sharedApplication].delegate)).m_pLeftOpsBTN.hidden = YES;
        ((AppDelegate *)([UIApplication sharedApplication].delegate)).m_pRightOpsBTN.hidden = YES;
        return YES;
    }
    else
        return NO;
}

#pragma -mark faction
-(UIButton *) addButtonWithString:(NSString *)string AndFrame:(CGRect)Frame andAction:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = Frame;
    button.titleLabel.textColor = [UIColor blackColor];
    button.showsTouchWhenHighlighted = YES;
    [button setTitle:string forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.titleLabel.font = [UIFont systemFontOfSize:26];
    button.backgroundColor = [UIColor grayColor];
    return button;
}

@end
