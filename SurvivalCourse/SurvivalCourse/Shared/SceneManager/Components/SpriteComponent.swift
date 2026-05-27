//
//  MovementComponent.swift
//  SurvivalCourse
//
//  Created by rdls on 5/26/26.
//

import GameplayKit
import SpriteKit

struct SpriteAtlasData {
    let atlasName: String
    let textureNames: [String]
}

final class SpriteComponent: GKComponent {
    // Properties
    let node: SKSpriteNode
    let normalImage: SKTexture?
    let damageName: String?
    let frames: [SKTexture]
    // Initializer
    init(node: SKSpriteNode, damageName: String? = nil, spriteAtlas: SpriteAtlasData? = nil) {
        self.node = node
        self.normalImage = node.texture
        self.damageName = damageName
        var collectableTextures: [SKTexture] = []
        if let spriteAtlas {
            let collectableAtlas: SKTextureAtlas = SKTextureAtlas(named: spriteAtlas.atlasName)
            let textureNames = spriteAtlas.textureNames
            for name in textureNames {
                collectableTextures.append(collectableAtlas.textureNamed(name))
            }
        }
        frames = collectableTextures
        super.init()
    }
    required init?(coder: NSCoder) {
        fatalError("[SpriteComponet] required init?(coder:) has not been implemented")
    }
    // Lifecycle
    override func didAddToEntity() {
        self.node.entity = self.entity
    }
    // Public Functions
    func startAnimating() {
        let timelessAnimation = SKAction.animate(with: frames, timePerFrame: 0.06)
        node.run(SKAction.repeatForever(timelessAnimation), withKey: "\(node.name ?? "Default")_Animation")
    }
    func stopAnimating() {
        node.removeAction(forKey: "\(node.name ?? "Default")_Animation")
        node.texture = normalImage
    }
    func receiveDamage() {
        guard let normalImage else { return }
        guard let damageName else { return }
        node.run(SKAction.sequence([
            SKAction.setTexture(SKTexture(imageNamed: damageName)),
            SKAction.wait(forDuration: 0.5),
            SKAction.setTexture(normalImage)
        ]))
    }
}
