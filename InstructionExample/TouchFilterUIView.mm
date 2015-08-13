//
//  TouchFilterUIView.m
//  
//
//  This class exists because we are using the unusual
//  layout of two UIViews in the same window, and at the same
//  level. The 'front' UIView will not pass touch input
//  to the 'behind' UIView, even if the touch occurs in
//  an 'empty' are of the front view.
//
//  This class makes the front view pass touch input
//  to the back view, if the touch did not hit
//  any elements of the front view.
//
//
//  Created by im360 immersive on 6/7/13.
//  Copyright (c) 2013 im360 immersive. All rights reserved.
//

#import "TouchFilterUIView.h"

@implementation TouchFilterUIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView * thisViewHit;
    thisViewHit = [super hitTest:point withEvent:event];
    if (thisViewHit == self){
        return [_im360View hitTest:point withEvent:event];
    }
    
    if (thisViewHit){
        return  thisViewHit;
    }
    return [_im360View hitTest:point withEvent:event];
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
     UITouch *touch = [touches anyObject];
            
    // view is the UIView's subclass instance
    if(_im360View){
        [_im360View touchesBegan:touches withEvent:event];
    }
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
