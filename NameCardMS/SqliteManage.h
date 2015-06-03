//
//  SqliteManage.h
//  NameCardMS
//
//  Created by 郝 林巍 on 15/5/14.
//  Copyright (c) 2015年 lincwee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "PerClass.h"
#import "CorClass.h"

@interface SqliteManage : NSObject
{
    sqlite3 *db;
}

@property (strong, nonatomic) NSDictionary *m_pPerDataDic;
-(void) loadData;
-(BOOL) createPersonTable;
-(BOOL) insertDataToPersonTable:(PerClass *)person;
-(BOOL) updateDateToPersonTable:(PerClass *)person;

-(BOOL) createCorTable;
-(BOOL) insertDataToCorTable:(CorClass *)cor;
-(BOOL) updateDateToCorTable:(CorClass *)cor;

-(void) loadPersonDataWithArray:(NSMutableArray *)list;
-(void) loadCorDataWithArray:(NSMutableArray *)list;
-(BOOL) deletePersonData:(PerClass*) person;
-(BOOL) deleteCorData:(CorClass*) cor;
@end
