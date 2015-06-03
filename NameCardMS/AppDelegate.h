//
//  AppDelegate.h
//  NameCardMS
//
//  Created by 郝 林巍 on 15/4/15.
//  Copyright (c) 2015年 lincwee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "SlideSideView.h"
#import "MacroFile.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) UIButton *m_pRightOpsBTN;
@property (strong, nonatomic) UIButton *m_pLeftOpsBTN;

@property (strong, nonatomic) SlideSideView *slideViewController;
@property (strong, nonatomic) UINavigationController *m_pNavViewController;
@property (strong, nonatomic) UILabel *m_pAppNameLabel;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

