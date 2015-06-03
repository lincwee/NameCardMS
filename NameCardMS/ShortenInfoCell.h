//
//  ShortenInfoCell.h
//  NameCardMS
//
//  Created by 郝 林巍 on 15/5/3.
//  Copyright (c) 2015年 lincwee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShortenInfoCell : UITableViewCell
{
    @public
    NSString *pngPath;
}

@property (strong, nonatomic) UILabel *m_pPersonName;
@property (strong, nonatomic) UILabel *m_pCorName;
@property (strong, nonatomic) UILabel *m_pCorAddress;
@property (strong, nonatomic) UIImageView *m_pImageView;
@property (strong, nonatomic) NSString *pngPath;

-(void) setPersonName:(NSString *) name Position:(NSString *) Corname CorAddress:(NSString *)corAddress;
-(void) setAvatar:(NSString *)imgPath;
@end
