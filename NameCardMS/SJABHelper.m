//
//  SJABHelper.m
//  NameCardMS
//
//  Created by 郝 林巍 on 15/5/29.
//  Copyright (c) 2015年 lincwee. All rights reserved.
//

#import "SJABHelper.h"
#import <AddressBook/AddressBook.h>

@implementation SJABHelper

// 单列模式
+ (SJABHelper*)shareControl
{
    static SJABHelper *instance;
    @synchronized(self) {
        if(!instance) {
            instance = [[SJABHelper alloc] init];
        }
    }
    return instance;
}

+ (BOOL)addContactName:(NSString*)name phoneNum:(NSString*)num Label:(NSString*)label Email:(NSString *)email Address:(NSString *)address
{
    BOOL flag = [[SJABHelper shareControl] addContactName:name phoneNum:num Label:label Email:email Address:address];
    if (flag) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"通讯录" message:@"通讯录添加成功" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil , nil];
        [alert show];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"通讯录" message:@"通讯录添加失败" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil , nil];
        [alert show];
    }
    return flag;
}

// 添加联系人（联系人名称、号码、号码备注标签）
- (BOOL)addContactName:(NSString*)name phoneNum:(NSString*)num Label:(NSString*)label Email:(NSString *)email Address:address
{
    　　// 创建一条空的联系人
    ABRecordRef record = ABPersonCreate();
    CFErrorRef error;
    　　// 设置联系人的名字
    ABRecordSetValue(record, kABPersonFirstNameProperty, (__bridge CFTypeRef)name, &error);
    // 添加联系人电话号码以及该号码对应的标签名
    ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABPersonPhoneProperty);
    ABMultiValueAddValueAndLabel(multi, (__bridge CFTypeRef)num, (__bridge CFTypeRef)label, NULL);
    ABRecordSetValue(record, kABPersonPhoneProperty, multi, &error);
    //添加邮箱
    //ABRecordSetValue(record, kABPersonEmailProperty, (__bridge CFTypeRef)email, &error);
    ABMutableMultiValueRef multiEmail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiEmail, (__bridge CFTypeRef)email, kABWorkLabel, NULL);
    ABRecordSetValue(record, kABPersonEmailProperty, multiEmail, &error);
    
//    CFStringRef name2 = CFSTR("IUKEY");
//    ABMutableMultiValueRef multAddress = ABMultiValueCreateMutable(kABPersonAddressProperty);
//    ABMultiValueAddValueAndLabel(multAddress, (__bridge CFTypeRef)address, kABWorkLabel, NULL);
//    ABRecordSetValue(record, kABPersonAddressProperty, multAddress, &error);
    
    
    ABAddressBookRef addressBook = nil;
    　　// 如果为iOS6以上系统，需要等待用户确认是否允许访问通讯录。
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
    {
        addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        //等待同意后向下执行
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
                                                 {
                                                     dispatch_semaphore_signal(sema);
                                                 });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        //dispatch_release(sema);
    }
    else
    {
        addressBook = ABAddressBookCreate();
        // 如果为iOS6以上系统，需要等待用户确认是否允许访问通讯录。
    }
    　　 // 将新建联系人记录添加如通讯录中
    BOOL success = ABAddressBookAddRecord(addressBook, record, &error);
    if (!success) {
        return NO;
    }else{
        　　　　　// 如果添加记录成功，保存更新到通讯录数据库中
        success = ABAddressBookSave(addressBook, &error);
        return success ? YES : NO;
    }
}

+ (ABHelperCheckExistResultType)existPhone:(NSString *)phoneNum
{
    ABHelperCheckExistResultType type = [[SJABHelper shareControl] existPhone:phoneNum];
    if (type == ABHelperCanNotConncetToAddressBook) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"通讯录" message:@"无法访问通讯录" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil , nil];
        [alert show];
    }
    else if(type == ABHelperExistSpecificContact)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"通讯录" message:@"联系人已存在" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil , nil];
        [alert show];
    }
    return type;
}

// 指定号码是否已经存在
- (ABHelperCheckExistResultType)existPhone:(NSString*)phoneNum
{
    ABAddressBookRef addressBook = nil;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
    {
        addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        //等待同意后向下执行
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
                                                 {
                                                     dispatch_semaphore_signal(sema);
                                                 });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        //dispatch_release(sema);
    }
    else
    {
        addressBook = ABAddressBookCreate();
    }
    CFArrayRef records;
    if (addressBook) {
        　　　　　// 获取通讯录中全部联系人
        records = ABAddressBookCopyArrayOfAllPeople(addressBook);
    }else{
#ifdef DEBUG
        NSLog(@"can not connect to address book");
#endif
        return ABHelperCanNotConncetToAddressBook;
    }
    
    　　// 遍历全部联系人，检查是否存在指定号码
    for (int i=0; i<CFArrayGetCount(records); i++) {
        ABRecordRef record = CFArrayGetValueAtIndex(records, i);
        CFTypeRef items = ABRecordCopyValue(record, kABPersonPhoneProperty);
        CFArrayRef phoneNums = ABMultiValueCopyArrayOfAllValues(items);
        if (phoneNums) {
            for (int j=0; j<CFArrayGetCount(phoneNums); j++) {
                NSString *phone = (NSString*)CFArrayGetValueAtIndex(phoneNums, j);
                if ([phone isEqualToString:phoneNum]) {
                    return ABHelperExistSpecificContact;
                }
            }
        }
    }
    
    CFRelease(addressBook);
    return ABHelperNotExistSpecificContact;
}


@end