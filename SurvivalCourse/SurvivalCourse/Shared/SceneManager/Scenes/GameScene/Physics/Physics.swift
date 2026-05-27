//
//  Physics.swift
//  SurvivalCourse
//
//  Created by rdls on 5/26/26.
//

import SpriteKit
import GameplayKit

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA: SKPhysicsBody = contact.bodyA
        let bodyB: SKPhysicsBody = contact.bodyB
        // Handle the item collision
        if let collectable = bodyA.node?.name == "collectable" ? bodyA.node : bodyB.node?.name == "collectable" ? bodyB.node : nil,
           let target = bodyA.node?.name == "SpaceShip" ? bodyA.node : bodyB.node?.name == "SpaceShip" ? bodyB.node : nil {
            collectable.removeFromParent()
            // Get the health component for the target
            if let entity = target.entity, let health = entity.component(ofType: HealthComponent.self) {
                health.heal(50)
            }
        }
        // Handle the projectile colision
        guard let projectile = bodyA.node?.name == "projectile" ? bodyA.node : bodyB.node, let target = (bodyA.node?.name == "enemy" || bodyA.node?.name == "SpaceShip") ? bodyA.node : bodyB.node else { return }
        projectile.removeFromParent()
        
        if let entity = target.entity, let health = entity.component(ofType: HealthComponent.self) {
            health.takeDamage(14)
        }
    }
}
