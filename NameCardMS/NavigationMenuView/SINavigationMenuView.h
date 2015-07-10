//
//  SINavigationMenuView.h
//  NavigationMenu
//
//  Created by Ivan Sapozhnik on 2/19/13.
//  Copyright (c) 2013 Ivan Sapozhnik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIMenuTable.h"

@protocol SINavigationMenuDelegate <NSObject>

- (void)didSelectItemAtIndex:(NSUInteger)index;

@end

@interface SINavigationMenuView : UIView <SIMenuDelegate>
{
    NSInteger nowIndex;
}

@property (nonatomic, weak) id <SINavigationMenuDelegate> delegate;
@property (nonatomic, strong) NSArray *items;
@property NSInteger nowIndex;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title;
- (void)displayMenuInView:(UIView *)view;
-(NSInteger) getIndexNow;

@end
