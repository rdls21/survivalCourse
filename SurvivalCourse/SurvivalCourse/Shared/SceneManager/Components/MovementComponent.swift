//
//  MovementComponent.swift
//  SurvivalCourse
//
//  Created by rdls on 5/26/26.
//

import GameplayKit

final class MovementComponent: GKComponent {
    // Properties
    var currentInput: CGVector = .zero
    let rotationFactor: CGFloat = 0.001
    let maxSpeed: CGFloat = 200
    let maxAngularSpeed: CGFloat = .pi
    private var velocity: CGVector = .zero
    // Private Properties
    private var spriteComponent: SpriteComponent? {
        entity?.component(ofType: SpriteComponent.self)
    }
    // Update Loop
    override func update(deltaTime seconds: TimeInterval) {
        guard let node = spriteComponent?.node, let physicsBody = node.physicsBody  else { return }
        let intendedSpeed = currentInput.dy
        let intendedRotation = currentInput.dx * rotationFactor
        let currentAngle = node.zRotation + .pi / 2
        // Controll the max trust, so it wont surpass the max speed
        let speed = sqrt(pow(physicsBody.velocity.dx, 2) + pow(physicsBody.velocity.dy, 2))
        let scaleFactor: CGFloat = 1 - (speed / maxSpeed)
        // Trust in facing direction
        let transformedInput: CGVector = CGVector(
            dx: scaleFactor * intendedSpeed * cos(currentAngle),
            dy: scaleFactor * intendedSpeed * sin(currentAngle)
        )
        physicsBody.applyImpulse(transformedInput)
        physicsBody.applyAngularImpulse(intendedRotation)
        // Clamp angular velocity
        if abs(physicsBody.angularVelocity) > maxAngularSpeed {
            let scale: CGFloat = maxAngularSpeed / abs(physicsBody.angularVelocity)
            physicsBody.angularVelocity *= scale
        }
    }
}
