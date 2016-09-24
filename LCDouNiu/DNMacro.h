//
//  DNMacro.h
//  LCDouNiu
//
//  Created by Max on 16/9/21.
//  Copyright © 2016年 Max. All rights reserved.
//

#ifndef DNMacro_h
#define DNMacro_h

#define  DN_SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width) //屏幕宽度
#define  DN_SCREEN_HEIGHT   ([UIScreen mainScreen].bounds.size.height)//屏幕高度

#define RGBAColor(r,g,b,a)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGBColor(r,g,b)     RGBAColor(r,g,b,1.0)
#define RGBColorC(c)        RGBColor((((int)c) >> 16),((((int)c) >> 8) & 0xff),(((int)c) & 0xff))

#endif /* DNMacro_h */
