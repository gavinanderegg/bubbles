//
//  BUBMyScene.m
//  bubbles
//
//  Created by Gavin Anderegg on 10/21/2013.
//  Copyright (c) 2013 Gavin Anderegg. All rights reserved.
//

#import "BUBMyScene.h"

@implementation BUBMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint touchLocation = [touch locationInNode:self];
        
        SKTexture *bubbleTexture = [SKTexture textureWithImageNamed:@"bub"];
        bubbleTexture.filteringMode = SKTextureFilteringNearest;
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:bubbleTexture size:CGSizeMake(32.0, 32.0)];
        sprite.blendMode = SKBlendModeAdd;
        sprite.alpha = 0.9;
        
        sprite.position = touchLocation;
        
        UIBezierPath *sine = [[UIBezierPath alloc] init];
        [sine moveToPoint:CGPointMake(0.0, 0.0)];
        [sine addCurveToPoint:CGPointMake(0.0, 200.0) controlPoint1:CGPointMake(-100.0, 100.0) controlPoint2:CGPointMake(100.0, 100.0)];
        CGPathRef sinePath = sine.CGPath;
        
        SKAction *followTrack = [SKAction followPath:sinePath asOffset:YES orientToPath:NO duration:1.0];
        [sprite runAction:[SKAction repeatActionForever:followTrack]];
        
        [self addChild:sprite];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    if ([self.children count] > 0) {
        for (SKSpriteNode *sprite in self.children) {
            if (sprite.position.y > self.view.scene.size.height - 64.0) {
                SKAction *fadeOut = [SKAction fadeOutWithDuration:0.2];
                [sprite runAction:fadeOut completion:^{
                    [sprite removeFromParent];
                }];
            }
        }
    }
}

@end
