//
//  EnemyAIComponent.swift
//  SurvivalCourse
//
//  Created by rdls on 5/26/26.
//

import GameplayKit

final class EnemyAIComponent: GKComponent {
    let target: GKAgent2D
    init(target: GKAgent2D) {
        self.target = target
        super.init()
    }
    required init?(coder: NSCoder) {
        fatalError("[EnemyAIComponent] init(coder:) has not been implemented")
    }
    // GKComponent life-cycle
    override func didAddToEntity() {
        // The current entity must contain an agent component
        guard let agent = entity?.component(ofType: AgentComponent.self) else { return }
        let seek = GKGoal(toSeekAgent: target)
        //agent.behavior = GKBehavior(goals: [seek])
        agent.behavior = GKBehavior(goal: seek, weight: 1.0)
        // Start shooting after a delay of 5 seconds
        guard let shootingComponent = self.entity?.component(ofType: ShootingComponent.self) else { return }
        guard let node = self.entity?.component(ofType: SpriteComponent.self)?.node else { return }
        node.run(SKAction.sequence([
            .wait(forDuration: 5),
            .run { shootingComponent.shoot(from: node) },
            .repeatForever(SKAction.sequence([
                .wait(forDuration: 1),
                .run { shootingComponent.shoot(from: node) }
            ]))
        ]))
    }
}
