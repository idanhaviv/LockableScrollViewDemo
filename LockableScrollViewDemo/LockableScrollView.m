//
//  LockableScrollView.m
//  LockableScrollViewDemo
//
//  Created by Idan Haviv on 20/08/2017.
//  Copyright © 2017 Idan Haviv. All rights reserved.
//

#import "LockableScrollView.h"

@implementation LockableScrollView

- (void)didAddSubview:(UIView *)subview {
    NSLog(@"adding %@", subview);
//    if (subview.frame.origin.y < self.contentOffset.y) {
//        self.contentOffset = CGPointMake(self.contentOffset.x, self.contentOffset.y + subview.frame.size.height);
//    }
}

- (void)willRemoveSubview:(UIView *)subview {
    NSLog(@"removing %@", subview);
}

@end
