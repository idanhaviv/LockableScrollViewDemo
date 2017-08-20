//
//  LockableScrollView.h
//  LockableScrollViewDemo
//
//  Created by Idan Haviv on 20/08/2017.
//  Copyright © 2017 Idan Haviv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LockableScrollView : UIScrollView

- (void)didAddSubview:(UIView *)subview;
- (void)willRemoveSubview:(UIView *)subview;

@end
