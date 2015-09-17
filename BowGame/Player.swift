//
//  Player.swift
//  Test
//
//  Created by ZhangYu on 9/7/15.
//  Copyright (c) 2015 ZhangYu. All rights reserved.
//

import UIKit
import SpriteKit
class PlayerFactory{
    static func getPlayer(var name : String, size :CGSize) -> Player
    {
        var sheet = ShootAnimation.getInstance()
        name = name.lowercaseString;
        var playerNode = PlayerNode( texture: sheet.Shoot_01())
        var health = Health()
        var position : CGPoint!
        var xScale : CGFloat = 0.4
        if(name == "player1"){
            health.healthbar.position = CGPointMake(size.width*0.05 , size.height * 0.8)
            playerNode.position = CGPointMake(size.width*0.15, size.height/5)
            position = CGPointMake(playerNode.position.x + 10.0,playerNode.position.y + 11.0)
        }
        
        if(name == "player2"){
            health.healthbar.position = CGPointMake(size.width*0.95 - health.healthbar.frame.size.width, size.height * 0.8)
            playerNode.position = CGPointMake((size.width*0.85), size.height/5)
            playerNode.xScale = -1.0
            position = CGPointMake(playerNode.position.x + 10.0,playerNode.position.y + 11.0)
            xScale = -xScale
            
        }
        var player = Player(health: health, playerNode: playerNode)
        player.mBlood.xScale = xScale
        player.mBlood.position = position
        player.mBlood.yScale = 0.4
        playerNode.mPlay = player
        return player
    }
}
class Player : NSObject
{
    private var mHealth:Health!
    private var mPlayerNode : PlayerNode!
    var scalePara:Float = 1
    var playerName : String!
    var mScene: SKScene!
    var mBlood = SKEmitterNode(fileNamed: "blood.sks")
    func add2Scene(scene: SKScene)
    {
        mScene = scene
        mScene.addChild(mPlayerNode)
        mHealth.add2Scene(scene)
    }
    private init(health: Health, playerNode : PlayerNode)
    {
        mHealth = health
        mPlayerNode = playerNode
    }
    func shoot(impulse: CGVector , scene : SKScene, position: CGPoint)
    {
        
        var shoot = SKAction.animateWithTextures(ShootAnimation.getInstance().Shoot(), timePerFrame: 0.04)
        mPlayerNode.runAction(shoot)
        var bow = Bow()
        var arrow = Arrow(player: self)
        delay(0.64) {
            self.mPlayerNode.scene?.addChild(arrow);
        //        scene.addChild(arrow)
            bow.shoot(impulse, arrow: arrow, scene: scene, position: position)
        }
        
    }
    func shot(arrow : Arrow)
    {
        var xScale : CGFloat!
        var position : CGPoint!
        self.mHealth.getHurt(Float(arrow.getDamage()))
        bleed()
        SoundEffect.getInstance().playScream()
    }
    func bleed()
    {
        var blood = SKEmitterNode(fileNamed: "blood.sks")
        blood.xScale = mBlood.xScale
        blood.position = mBlood.position
        blood.yScale = mBlood.yScale
        mPlayerNode.parent?.addChild(blood)
        let fadeout:SKAction = SKAction.fadeAlphaTo(0.0, duration: 1.0)
        blood.runAction(fadeout, completion: {
            blood.removeFromParent()
        })
        
    }
    
    /* function to delay |input| time */
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }

}
private class Health
{
    var totalHealth:Float = 100
    var currentHealth:Float = 100
    var healthbar:SKShapeNode = SKShapeNode(rect: CGRectMake(0, 0, 120, 10))
    init()
    {
        healthbar.fillColor = SKColor.greenColor()
    }
    func add2Scene(scene: SKScene)
    {
        scene.addChild(healthbar)
    }
    private func updateHealthBar()
    {
        if(currentHealth <= 30){
            healthbar.fillColor = SKColor.redColor()
        }else if(currentHealth <= 60){
            healthbar.fillColor = SKColor.orangeColor()
        }
        healthbar.xScale = CGFloat(currentHealth / totalHealth)
    }
    private func addHealth(val : Float)
    {
        currentHealth += val
        currentHealth = (currentHealth < 0) ? 0 :currentHealth
        currentHealth = totalHealth < currentHealth ? totalHealth:currentHealth
        updateHealthBar()
    }
    func getHurt(val : Float)
    {
        addHealth(-val)
    }
    func recover(val : Float)
    {
        addHealth(val)
    }
}
class PlayerNode: SKSpriteNode
{
    private let mPlayerSize = CGSize(width: 100.0, height: 80.0)
    var mPlay : Player!
    func getPlayer() -> Player
    {
        return mPlay
    }
    private func addPhysicsBody()
    {
        self.physicsBody =
        SKPhysicsBody(rectangleOfSize: self.size)
        self.physicsBody?.dynamic = false
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.categoryBitMask = CollisonHelper.PlayerMask
        self.physicsBody?.contactTestBitMask = CollisonHelper.ArrowMask
        self.physicsBody?.collisionBitMask = 0x0
    
    }
    private init(texture : SKTexture) {
      //  self.playerName = name
       // let texture = SKTexture(imageNamed: name)
        super.init(texture: texture, color: SKColor.clearColor(),  size: mPlayerSize)
        addPhysicsBody()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
 /*   required init?(coder aDecoder: NSCoder) {
        self.bow = aDecoder.decodeObjectForKey("BOW") as!  Bow
        super.init(coder: aDecoder)
    }
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.bow, forKey: "BOW")
        super.encodeWithCoder(aCoder)
    }*/
}
