//
//  BaseGameState.swift
//  SurvivalCourse
//
//  Created by rdls on 5/25/26.
//

import SpriteKit
import GameplayKit

class BaseGameState: GKState {
    // Properties
    /// GameController property
    /// 
    /// Unowned property means that this object is not created by this class
    /// but will always exist during the lifecycle of this class.
    /// BaseGameState does not owns the object and might be nil.
    unowned let gameScene: GameController
    /// Current scene being displayed
    var sceneName: String {
        fatalError("[BaseGameScene] Subclass must override sceneName!")
    }
    // Initialization
    init(gameController: GameController) {
        self.gameScene = gameController
        super.init()
    }
    // GKState State Machine
    override func isValidNextState(_ stateClass: AnyClass) -> Bool { true }
    // Handling State Transitions and Updates
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        // Present the Scene
        presentScene()
        // Play state-specific background music
        playStateMusic()
    }
    // We can also use update(deltaTime), but for this use case it's not needed
    override func willExit(to nextState: GKState) {
        super.willExit(to: nextState)
    }
    // Scene presentation and sound effects.
    private func presentScene() {
        let scene = getScene()
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFit
        // Present the scene
        gameScene.presentScene(scene)
    }
    // Music logic
    func playStateMusic() {
        fatalError("[BaseGameScene] Subclass must override playStateMusic()!")
    }
    // Scene logic
    func getScene() -> SKScene {
        fatalError("[BaseGameScene] Subclass must override getScene()!")
    }
}
