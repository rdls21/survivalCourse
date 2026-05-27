//
//  ShootingComponent.swift
//  SurvivalCourse
//
//  Created by rdls on 5/26/26.
//

import GameplayKit

final class ShootingComponent: GKComponent {
    unowned let scene: SKScene
    let bulletName: String
    
    init(scene: SKScene, bulletName: String) {
        self.scene = scene
        self.bulletName = bulletName
        super.init()
    }
    required init?(coder: NSCoder) {
        fatalError("[EnemyAIComponent] init(coder:) has not been implemented")
    }
    // Public functions
    func shoot(from node: SKNode) {
        // To shoot, it mus be alive
        let healthComponent: HealthComponent? = node.entity?.component(ofType: HealthComponent.self)
        guard let healthComponent, healthComponent.isAlive else { return }
        let characterSize: CGFloat = max(node.frame.width, node.frame.height) + 18
        let offsetVector: CGVector = CGVector(dx: cos(node.zRotation + .pi/2) * (characterSize / 2), dy: sin(node.zRotation + .pi/2) * (characterSize / 2))
        let bullet = SKSpriteNode(imageNamed: bulletName)
        bullet.size = CGSize(width: 16, height: 16)
        bullet.position = CGPoint(x: node.position.x + offsetVector.dx, y: node.position.y + offsetVector.dy)
        bullet.zRotation = node.zRotation
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.frame.size.width / 2)
        bullet.physicsBody?.contactTestBitMask = 1
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.allowsRotation = false
        bullet.physicsBody?.velocity = CGVector(dx: cos(node.zRotation + .pi/2) * 400, dy: sin(node.zRotation + .pi/2) * 400)
        bullet.name = "projectile"
        scene.addChild(bullet)
    }
}
