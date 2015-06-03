//
//  ShortenInfoCell.m
//  NameCardMS
//
//  Created by 郝 林巍 on 15/5/3.
//  Copyright (c) 2015年 lincwee. All rights reserved.
//

#import "ShortenInfoCell.h"
#import "MacroFile.h"

@implementation ShortenInfoCell
@synthesize m_pCorName, m_pPersonName, m_pCorAddress, m_pImageView;
-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
     self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = MOON_WHITE;
        m_pPersonName = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width / 2 - 60.f, 0.f, 150.f, 40.f)];
        m_pPersonName.font = [UIFont systemFontOfSize:20.f];
        m_pCorName = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width / 2 - 60.f, 28.f, 220.f, 40.f)];
        m_pCorAddress = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width / 2 - 60.f, 48.f, 220.f, 40.f)];
        [m_pCorAddress setFont:[UIFont systemFontOfSize:13.f]];
        m_pCorAddress.textColor = [UIColor grayColor];
        [self addSubview:m_pCorName];
//        m_pCorName.center = self.center;
        [self addSubview:m_pPersonName];
        [self addSubview:m_pCorAddress];
        UIImage *image;
        if (!pngPath) {
            image = [UIImage imageNamed:@"Avatar2.jpg"];
        }
        else
            image = [UIImage imageNamed:pngPath];
        m_pImageView = [[UIImageView alloc] initWithImage:image];
        m_pImageView.frame = CGRectMake(15.f, -7.f, 70.f, 93.f);
        [self addSubview:m_pImageView];
    }
    return self;
}
-(void) setPersonName:(NSString *) name Position:(NSString *) Corname CorAddress:(NSString *)corAddress
{
    m_pPersonName.text = name;
    m_pCorName.text = Corname;
    m_pCorAddress.text = corAddress;
}
-(void) setAvatar:(NSString *)imgPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imgPath];   // 保存文件的名称
    UIImage *img = [UIImage imageWithContentsOfFile:filePath];
       CGAffineTransform rotation = CGAffineTransformMakeRotation( -M_PI / 2);
    [m_pImageView setTransform:rotation];
    [m_pImageView setImage:img];
}
@end