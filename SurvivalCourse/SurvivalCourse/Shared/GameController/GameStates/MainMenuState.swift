//
//  MainMenuState.swift
//  SurvivalCourse
//
//  Created by rdls on 5/25/26.
//

import SpriteKit

final class MainMenuState: BaseGameState {
    // Override sceneName computed property
    override var sceneName: String { "HomeScene" }
    // Control logic flow with GKState State Machine with state validation.
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        // We will only allow transitions to the gameplay state.
        stateClass == GameplayState.self
    }
    // Override the get scene function to return an instance of type MainMenuScene
    override func getScene() -> SKScene {
        guard let scene = SKScene(fileNamed: sceneName) as? HomeScene else {
            fatalError("[MainMenuState] Unable to find MainMenuScene!")
        }
        scene.setGameController(gameScene)
        return scene
    }
    // Override the Music function
    override func playStateMusic() {
        SoundManager.shared.playBackgroundMusic(.mainTheme)
    }
}
