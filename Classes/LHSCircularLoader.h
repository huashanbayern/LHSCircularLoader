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
@property (nonatomic, assign) CGFloat progressWidth;
@property (nonatomic, strong) UIColor *progressColor;
@property (nonatomic, assign) CGFloat revealOriginalRadius;
@property (nonatomic, assign) NSTimeInterval revealAnimationDuration;

- (void)reveal:(BOOL)animated;
- (void)reset;

@end
