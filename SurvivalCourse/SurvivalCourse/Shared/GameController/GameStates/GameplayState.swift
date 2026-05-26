//
//  GameplayState.swift
//  SurvivalCourse
//
//  Created by rdls on 5/25/26.
//

import SpriteKit

final class GameplayState: BaseGameState {
    // Override sceneName property
    override var sceneName: String { "GameScene" }
    // Control logic flow with GKState State Machine with state validation.
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        // For this state, we will only allow transitions to the MainMenuState or the CreditsState.
        stateClass == CreditsState.self || stateClass == MainMenuState.self
    }
    // Override the get scene function to return an instance of type MainMenuScene
    override func getScene() -> SKScene {
        guard let scene = SKScene(fileNamed: sceneName) as? GameScene else {
            fatalError("[GameplayState] Unable to find GameplayScene!")
        }
        return scene
    }
    // Override the Music function
    override func playStateMusic() {
        SoundManager.shared.playBackgroundMusic(.gameplayTheme)
    }
}
