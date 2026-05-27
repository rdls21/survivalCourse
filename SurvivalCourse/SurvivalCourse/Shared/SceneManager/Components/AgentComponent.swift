//
//  AgentComponent.swift
//  SurvivalCourse
//
//  Created by rdls on 5/26/26.
//

import GameplayKit

final class AgentComponent: GKAgent2D {
    // Update Life Cycle
    override func update(deltaTime seconds: TimeInterval) {
        guard let node = entity?.component(ofType: SpriteComponent.self)?.node else { return }
        // Sync agent to node
        position = vector_float2(Float(node.position.x), Float(node.position.y))
        rotation = Float(node.zRotation + .pi / 2)
        // Break if we are trying to set the input for the main character.
        if entity?.component(ofType: SpriteComponent.self)?.node.name == "SpaceShip" { return }
        // Get GameplayKit integrate velocity/posiiton from behaviour/goals
        super.update(deltaTime: seconds)
        // Force the node to agent's position and rotation
        node.position.x = CGFloat(position.x)
        node.position.y = CGFloat(position.y)
        node.zRotation = CGFloat(rotation - .pi / 2)
    }
}
