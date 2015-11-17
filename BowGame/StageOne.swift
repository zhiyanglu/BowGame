//
//  StageOne.swift
//  BowGame
//
//  Created by Zhiyang Lu on 10/23/15.
//  Copyright © 2015 Antonis papantoniou. All rights reserved.
//

import UIKit
import SpriteKit

class StageOne: StageGameScene {
    
    override func addBackground()
    {
        let backgroundTexture =  SKTexture(imageNamed:BackgroundImage)
        let background = SKSpriteNode(texture:backgroundTexture, color: SKColor.clearColor(), size: CGSizeMake(self.frame.width * 2, self.frame.height))
        background.zPosition = -100;
        background.position = CGPointMake(size.width,  size.height*0.5)
        self.world.addChild(background)
    }
    
    override func addGround()
    {
        let groundTexture = SKTexture(imageNamed: GroundTexture1)
        let ground : Ground = Ground(texture: groundTexture, size: CGSizeMake(size.width * 2, size.height / 3), position: CGPointMake(0, 0))
        ground.position = CGPointMake(size.width, 0)
        self.world.addChild(ground)
        
        let collisionframe = CGRectInset(frame, -frame.width*0.2, -frame.height*0.5)
        physicsBody = SKPhysicsBody(edgeLoopFromRect: collisionframe)
        self.physicsBody?.categoryBitMask = CollisonHelper.ShotableMask
        self.physicsBody?.contactTestBitMask = CollisonHelper.ArrowMask
        self.physicsBody?.collisionBitMask = CollisonHelper.ArrowMask
        
    }
    
    override func addBoss()
    {
        let bossposition = CGPointMake(self.size.width * 2 * 0.9, self.size.height / 6)
        self.boss = Boss(name: "firstboss", scene: self, UI: self.UI, world: self.world, position: bossposition)
        boss.add2Scene()
    }
    
    
    override func addObstacle() {
        let woodBoard = WoodBoard(size: CGSizeMake(20, 200), position: CGPointMake(self.size.width * 0.8, self.size.height/6), flag:true)
        woodBoard.add2Scene(self, world: self.world)
        let woodBoard2 = WoodBoard(size: CGSizeMake(20, 240), position: CGPointMake(self.size.width * 1.5, self.size.height/6), flag:true)
        woodBoard2.add2Scene(self, world: self.world)
    }
    
    override func addArrowPanel()
    {
        super.addArrowPanel()
        panel.setArrowNum(10, bomb: 1, flappy: 0, split: 2, ignore: 10)
    }
    
    override func restartGame() {
        let gameScene = StageOne(size: self.size, mainmenu: self.mainmenu, localPlayer: "temp", multiPlayerON: false, selectionScene : self.selectionScene, stage: self.stage)
        let transitionType = SKTransition.flipHorizontalWithDuration(1.0)
        view?.presentScene(gameScene,transition: transitionType)
        self.removeFromParent()
    }

}
