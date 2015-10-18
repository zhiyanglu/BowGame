//
//  Arrow.swift
//  Test
//
//  Created by ZhangYu on 9/8/15.
//  Copyright (c) 2015 ZhangYu. All rights reserved.
//

import UIKit
import SpriteKit

class ArrowFactory
{
    static func createArrow(player: Player)->Arrow
    {
       // return NonStopArrow(player: player)
        let arrowitem = DataCenter.getInstance().getArrowItem()
        if(arrowitem.name == "FlappyArrow"){
            return FlappyArrow(player: player)
        }
        return Arrow(player: player)
    }
}
class Arrow: SKSpriteNode, Attacker{
    
    private var damage :Int!
    private var host : Player!
    private var isFlying:UInt8 = 1
    
    func getDamage()-> Int
    {
        return damage;
    }
    func getHost()-> Player
    {
        return host
    }
    func afterAttack()
    {
        if isFlying == 0{
            GameController.getInstance().afterArrowDead()
        }
    }
    func tryStop(){
        stop()
    }
    func stop()
    {
        //OSAtomicTestAndClear(0, &self.isFlying)
        isFlying = 0
        print(self.isFlying)
        self.physicsBody = nil
        let fadeout: SKAction = SKAction.fadeAlphaTo(0.0, duration: 1.0)
        runAction(fadeout, completion: {
            self.removeFromParent()
        })
    }
    
    func slowDown() {
        self.physicsBody?.velocity.dx *= 0.4
        self.physicsBody?.velocity.dy *= 0.4
        
    }
    
    func isFrom(player : Player)->Bool
    {
        return player == self.host;
    }
    init(player : Player) {
        host = player
        let spriteSize = CGSize(width: 30.0, height: 10.0)
        let texture = SKTexture(imageNamed: ArrowImage)
        //println(DataCenter.getInstance().getArrowItem().damage.shortValue)
        damage = Int(DataCenter.getInstance().getArrowItem().damage.shortValue) + player.getPower()
        super.init(texture: texture, color: SKColor.clearColor(), size: spriteSize)
        addPhysicsBody()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func addPhysicsBody()
    {
        self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.size.width, self.size.height - 5))
        self.physicsBody?.dynamic = true
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.categoryBitMask = CollisonHelper.ArrowMask
        self.physicsBody?.contactTestBitMask = CollisonHelper.ShotableMask
        self.physicsBody?.collisionBitMask = 0x0
    }

    func go(impulse : CGVector, position : CGPoint){
        if(impulse.dx < 0) {
            self.xScale = -1
        }
        self.position = position
        physicsBody!.applyImpulse(impulse)
       // self.physicsBody?.applyForce(CGVectorMake(100, 100))
        //physicsBody!.velocity = velocity
        //let action1 = SKAction.rotateByAngle(CGFloat(M_PI), duration:5)
        //let action2 = SKAction.moveToX(scene.size.width, duration: 1)
        // arrow.runAction(SKAction.repeatActionForever(action1))
        //arrow.runAction(action2)
       
    }
    private func isValid()->Bool
    {
       return  parent != nil && position.x >= 0 && position.x <= CGFloat(1.5) * parent!.frame.width && position.y >= 0 && CGFloat(1.5) * position.y <= parent!.frame.height
    }
    func update()->Bool
    {
        if !isValid() {
           // removeFromParent()
           // GameController.getInstance().afterArrowDead()
        }
        if isFlying != 0 && physicsBody != nil{
            let val = (physicsBody!.velocity.dy) / (physicsBody!.velocity.dx)
            self.zRotation = atan(val)
        }
        return isFlying != 0
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
class FlappyArrow : Arrow
{
    override func go(impulse: CGVector, position: CGPoint)
    {
        var dx = CGFloat(1)
        if(impulse.dx < 0) {
            dx = CGFloat(-1.0)
        }
        super.go(CGVectorMake(dx, 5), position: position)
    }
    func flappy()
    {
        if isFlying != 0 && physicsBody != nil{
            physicsBody!.velocity.dy = 400
            if(physicsBody!.velocity.dx > 0){
                physicsBody!.velocity.dx = 100
            }
            if(physicsBody!.velocity.dx < 0){
                physicsBody!.velocity.dx = -100
            }
        }
    }
    
}
class NonStopArrow : Arrow
{
    override func tryStop(){
    }
    override func slowDown() {
    }

}
