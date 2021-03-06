//
//  BUBMyScene.m
//  bubbles
//
//  Created by Gavin Anderegg on 10/21/2013.
//  Copyright (c) 2013 Gavin Anderegg. All rights reserved.
//

#import "BUBMyScene.h"

@implementation BUBMyScene

static const uint32_t worldCategory = 0x1 << 0;
static const uint32_t bubbleCategory = 0x1 << 1;

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsBody.categoryBitMask = worldCategory;
        self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);
        self.physicsWorld.contactDelegate = self;
        self.preBubbles = [NSMutableArray array];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSDate *now = [NSDate date];
    
    for (UITouch *touch in touches) {
        SKTexture *bubbleTexture = [SKTexture textureWithImageNamed:@"bub"];
        bubbleTexture.filteringMode = SKTextureFilteringNearest;
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:bubbleTexture size:CGSizeMake(32.0, 32.0)];
        sprite.blendMode = SKBlendModeAdd;
        sprite.alpha = 0.3;
        CGPoint touchLocation = [touch locationInNode:self];
        sprite.position = touchLocation;
        
        [self addChild:sprite];
        
        NSDictionary *preBubble = @{@"time": now, @"touch": touch, @"sprite": sprite};
        [self.preBubbles addObject:preBubble];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        for (NSDictionary *preBubble in self.preBubbles) {
            if (preBubble[@"touch"] == touch) {
                [preBubble[@"sprite"] setPosition:[touch locationInNode:self]];
            }
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        SKSpriteNode *sprite;
        NSMutableArray *toDelete = [NSMutableArray array];
        for (NSDictionary *preBubble in self.preBubbles) {
            if (preBubble[@"touch"] == touch) {
                [preBubble[@"sprite"] removeFromParent];
                [toDelete addObject:preBubble];
                
                SKTexture *bubbleTexture = [SKTexture textureWithImageNamed:@"bub"];
                bubbleTexture.filteringMode = SKTextureFilteringNearest;
                sprite = [SKSpriteNode spriteNodeWithTexture:bubbleTexture size:[preBubble[@"sprite"] size]];
            }
        }
        [self.preBubbles removeObjectsInArray:toDelete];
        
        CGPoint touchLocation = [touch locationInNode:self];
        
        sprite.blendMode = SKBlendModeAdd;
        sprite.alpha = 0.9;
        sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.size.width/2];
        sprite.physicsBody.dynamic = YES;
        sprite.physicsBody.affectedByGravity = NO;
        sprite.physicsBody.categoryBitMask = bubbleCategory;
        sprite.physicsBody.contactTestBitMask = bubbleCategory;
        
        sprite.position = touchLocation;
        
        UIBezierPath *sine = [[UIBezierPath alloc] init];
        [sine moveToPoint:CGPointMake(0.0, 0.0)];
        
        float bezLeft = (rand() % (-50 - -150)) + -150;
        float bezRight = (rand() % (150 - 50)) + 50;
        float bezTop = (rand() % (200 - 100)) + 100;
        float bezMid = bezTop / 2;
        
        if ((rand() % 2) > 0) {
            float temp = bezLeft;
            bezLeft = bezRight;
            bezRight = temp;
        }
        
        [sine addCurveToPoint:CGPointMake(0.0, bezTop) controlPoint1:CGPointMake(bezLeft, bezMid) controlPoint2:CGPointMake(bezRight, bezMid)];
        CGPathRef sinePath = sine.CGPath;
        
        SKAction *followTrack = [SKAction followPath:sinePath asOffset:YES orientToPath:NO duration:1.0];
        [sprite runAction:[SKAction repeatActionForever:followTrack]];
        
        [self addChild:sprite];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    if ([self.children count] > 0) {
        for (SKSpriteNode *sprite in self.children) {
            if ((sprite.position.y + (sprite.size.height / 2.0)) > self.view.scene.size.height - 64.0) {
                SKAction *fadeOut = [SKAction fadeOutWithDuration:0.2];
                [sprite runAction:fadeOut completion:^{
                    [sprite removeFromParent];
                }];
            }
        }
    }
    
    for (NSDictionary *preBubble in self.preBubbles) {
        NSTimeInterval offset = 32.0 + ([preBubble[@"time"] timeIntervalSinceNow] * -100.0);
        
        if (offset > 180.0) {
            offset = 180.0;
        }
        
        CGFloat newSize = offset;
        NSLog(@"%f", newSize);
        [preBubble[@"sprite"] setSize:CGSizeMake(newSize, newSize)];
    }
}

- (void)didBeginContact:(SKPhysicsContact *)contact {
    NSLog(@"Bonk!");
}


@end
