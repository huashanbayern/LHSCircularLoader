//
//  LHSCircularLoader.h
//  LHSCircularLoader
//
//  Created by huashan on 16/7/26.
//  Copyright © 2016年 LiHuashan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHSCircularLoader : UIView

@property (nonatomic, assign) CGFloat progress;

@required
- (void)revealAnimation;

@optional
- (void)reset;

@end
