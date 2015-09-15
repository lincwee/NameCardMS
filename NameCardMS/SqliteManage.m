//
//  SqliteManage.m
//  NameCardMS
//
//  Created by 郝 林巍 on 15/5/14.
//  Copyright (c) 2015年 lincwee. All rights reserved.
//

#import "SqliteManage.h"
#import "MacroFile.h"

@implementation SqliteManage
@synthesize m_pPerDataDic;

-(void) loadData
{
    [super init];
    NSString *documents = LOCAL_PATH;
    NSString *database_path = [documents stringByAppendingPathComponent:DBNAME];
    
    if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
    }
    
//    NSString *sqlQuery = @"SELECT * FROM personTable";
//    sqlite3_stmt * statement;
//    int i = 0;
//    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
//        while (sqlite3_step(statement) == SQLITE_ROW) {
//            char *name = (char*)sqlite3_column_text(statement, 0);
//            NSString *nsNameStr = [[NSString alloc]initWithUTF8String:name];
//            
//            char *age = sqlite3_column_text(statement, 1);
//            
//            char *address = (char*)sqlite3_column_text(statement, 2);
//            NSString *nsAddressStr = [[NSString alloc]initWithUTF8String:address];
//            NSString *fuck =[[NSString alloc]initWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
//            
//            NSLog(@"name:%@  age:%s  address:%@ time:%d",nsNameStr,age, fuck, i++);
//        }
//    }
//    sqlite3_close(db);
    
    [self createPersonTable];
    [self createCorTable];
//    NSString *delSql = @"drop table personTable";
//    [self execSql:delSql];
//    NSString *delSql2 = @"drop table corTable";
//    [self execSql:delSql2];
}

#pragma -mark >>Sqlite
-(BOOL) createPersonTable
{
    NSString *sqlCreatePerTable = @"create table if not exists personTable (PID char(20) primary key, CID char(20), Pname char(20), Pmobile char(40), Pposition char(40), Ptel char(40), Pemail char(40), Pintroduce char(200))";
    return [self execSql:sqlCreatePerTable];
}

-(BOOL) insertDataToPersonTable:(PerClass *)person
{
    NSString *insertSql =[NSString stringWithFormat:@"INSERT INTO personTable (PID, CID, Pname, Pmobile, Pposition, Ptel, Pemail, Pintroduce) VALUES ( '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')"
                          , person->PID
                          , person->PID
                          , person->perName
                          , person->perMobile
                          , person->perPosition
                          , person->perTel
                          , person->perEmail
                          , person->perIntroduce];
    return [self execSql:insertSql];
}

-(BOOL) insertSelfDataToPersonTable:(PerClass *)person
{
    return YES;
}

-(BOOL) updateDateToPersonTable:(PerClass *)person
{
    if (person) {
        NSString *updateSql = [NSString stringWithFormat:@"UPDATE personTable set Pname = '%@', Pmobile = '%@', Pposition = '%@', Ptel = '%@', Pemail = '%@', Pintroduce = '%@' WHERE PID = '%@'",person->perName, person->perMobile, person->perPosition, person->perTel, person->perEmail, person->perIntroduce, person->PID];
        return [self execSql:updateSql];
    }
    return  NO;
}

-(BOOL) createCorTable
{
    NSString *sqlCreateCorTable = @"create table if not exists corTable (CID char(20) primary key, Cname char(40), Caddress char(40), Ctel char(40), Cfax char(40), Cintroduce char(200))";
    
    return [self execSql:sqlCreateCorTable];
}

-(BOOL) insertDataToCorTable:(CorClass *)cor
{
    NSString *insertSql =[NSString stringWithFormat:@"INSERT INTO corTable (CID, Cname, Caddress, Ctel, Cfax, Cintroduce) VALUES ( '%@', '%@', '%@', '%@', '%@', '%@')"
                          , cor->CID
                          , cor->corName
                          , cor->corAddress
                          , cor->corTel
                          , cor->corFax
                          , cor->corInteroduce];
    return [self execSql:insertSql];
}

-(BOOL) insertPerDataToCorTable:(CorClass *)cor
{
    return YES;
}

-(BOOL) updateDateToCorTable:(CorClass *)cor
{
    if (cor) {
        NSString *updateSql = [NSString stringWithFormat:@"UPDATE corTable set Cname = '%@', Caddress = '%@', Ctel = '%@', Cfax = '%@', Cintroduce = '%@' WHERE CID = '%@'",cor->corName, cor->corAddress, cor->corTel, cor->corFax, cor->corInteroduce, cor->CID];
        return [self execSql:updateSql];
    }
    return NO;
}

-(const char *) StrTochar:(NSString *)string
{
    char *temp = [string cStringUsingEncoding:NSASCIIStringEncoding];
    //NSLog(@"%s",temp);
    return temp;
}

-(BOOL)deletePersonData:(PerClass*) person
{
    NSString *deleteSqlPer = [NSString stringWithFormat:@"DELETE FROM personTable WHERE Pname = '%@' AND PID = '%@'", person->perName, person->PID];
    NSString *deleteSqlCor = [NSString stringWithFormat:@"DELETE FROM corTable WHERE CID = '%@'", person->PID];
    return ([self execSql:deleteSqlPer]&&[self execSql:deleteSqlCor]);
}

-(BOOL) deleteCorData:(CorClass*) cor
{
    return YES;
}
-(void)loadPersonDataWithArray:(NSMutableArray *)list
{
    NSString *sqlQuery = @"SELECT * FROM personTable";
    [list removeAllObjects];
    sqlite3_stmt * statement;
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
                PerClass *temp = [[PerClass alloc]init];
                temp->PID = [[NSString alloc]initWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
                temp->perName = [[NSString alloc]initWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
                //NSLog(@"%@!!",temp->perName);
                temp->perMobile = [[NSString alloc]initWithCString:(char *)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding];
                temp->perPosition = [[NSString alloc]initWithCString:(char *)sqlite3_column_text(statement, 4) encoding:NSUTF8StringEncoding];
                temp->perTel = [[NSString alloc]initWithCString:(char *)sqlite3_column_text(statement, 5) encoding:NSUTF8StringEncoding];
                temp->perEmail = [[NSString alloc]initWithCString:(char *)sqlite3_column_text(statement, 6) encoding:NSUTF8StringEncoding];
                temp->perIntroduce = [[NSString alloc]initWithCString:(char *)sqlite3_column_text(statement, 7) encoding:NSUTF8StringEncoding];
            
            [list addObject:temp];
        }
    }
}
-(void) loadCorDataWithArray:(NSMutableArray *)list
{
    NSString *sqlQuery = @"SELECT * FROM corTable";
    [list removeAllObjects];
    sqlite3_stmt * statement;
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            CorClass *temp = [[CorClass alloc]init];
            temp->CID = [[NSString alloc]initWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
            temp->corName = [[NSString alloc]initWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
            //NSLog(@"%@!!",temp->perName);
            temp->corAddress = [[NSString alloc]initWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
            temp->corTel = [[NSString alloc]initWithCString:(char *)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding];
            temp->corFax = [[NSString alloc]initWithCString:(char *)sqlite3_column_text(statement, 4) encoding:NSUTF8StringEncoding];
            temp->corInteroduce = [[NSString alloc]initWithCString:(char *)sqlite3_column_text(statement, 5) encoding:NSUTF8StringEncoding];
            
            [list addObject:temp];
        }
    }
}

-(BOOL)execSql:(NSString *)sql
{
    char *err;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库操作数据失败!");
        return false;
    }
    return true;
}
@end
