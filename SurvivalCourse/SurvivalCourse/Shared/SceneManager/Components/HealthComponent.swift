//
//  HealthComponent.swift
//  SurvivalCourse
//
//  Created by rdls on 5/26/26.
//

import GameplayKit

class HealthComponent: GKComponent {
    let maxHealth: Float
    private(set) var currentHealth: Float
    var isAlive: Bool { currentHealth.isFinite && currentHealth > 0 }
    var percentageHealth: Float { currentHealth / maxHealth }
    unowned private let healthBar: SKSpriteNode?
    
    init(maxHealth: Float, healthBar: SKSpriteNode? = nil) {
        self.maxHealth = maxHealth
        self.currentHealth = maxHealth
        self.healthBar = healthBar
        super.init()
    }
    required init?(coder: NSCoder) {
        fatalError("[HealthComponent] init(coder:) has not been implemented")
    }
    func takeDamage(_ amount: Float) {
        currentHealth = max(currentHealth - amount, 0)
        if !isAlive {
            entity?.component(ofType: SpriteComponent.self)?.node.removeFromParent()
        }
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else { return }
        spriteComponent.receiveDamage()
        updateHealthOverlay()
    }
    func heal(_ amount: Float) {
        currentHealth = min(currentHealth + amount, maxHealth)
        updateHealthOverlay()
    }
    // Health Bar Controll
    /// Sets a new health status for the overlay
    private func updateHealthOverlay() {
        guard let healthBar else { return }
        let health: Int = Int(percentageHealth * 100)
        switch health {
        case 0..<1:
            healthBar.texture = SKTexture(imageNamed: "health bar_0%")
        case 1..<25:
            healthBar.texture = SKTexture(imageNamed: "health bar_25%")
        case 25..<50:
            healthBar.texture = SKTexture(imageNamed: "health bar_50%")
        case 50..<75:
            healthBar.texture = SKTexture(imageNamed: "health bar_75%")
        case 75..<100:
            healthBar.texture = SKTexture(imageNamed: "health bar_100%")
        default:
            healthBar.texture = SKTexture(imageNamed: "health bar_0%")
        }
    }
}
