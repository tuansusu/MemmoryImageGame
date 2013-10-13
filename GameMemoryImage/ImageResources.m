//
//  ImageResources.m
//  GameMemoryImage
//
//  Created by VTIT on 10/12/13.
//  Copyright (c) 2013 VTIT. All rights reserved.
//

#import "ImageResources.h"

@implementation ImageResources

static NSArray* imageAlls;
-(NSArray*) getAllImages{
    
    static dispatch_once_t onceToken=0;
    dispatch_once(&onceToken, ^{
        imageAlls = [NSArray arrayWithObjects:@"Baseball.png",@"Blocks.png",@"Checkers.png",@"Confetti.png",@"Dinner.png",@"MathGraph.png", nil];
    });
    return imageAlls;
}

@end
