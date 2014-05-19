//
//  BUBMyScene.h
//  bubbles
//

//  Copyright (c) 2013 Gavin Anderegg. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BUBMyScene : SKScene <SKPhysicsContactDelegate>

@property (nonatomic, strong) NSMutableArray *preBubbles;

@end
