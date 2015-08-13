//
//  TouchFilterUIView.h
//  InstructionExample
//
//  Created by im360 immersive on 8/27/13.
//  Copyright (c) 2013 im360 immersive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <im360/im360.h>


@interface TouchFilterUIView : UIView {
    
    IM360View * _im360View;
    bool doswitch;
    
}
@property (nonatomic, retain) IM360View* im360View;

@end
