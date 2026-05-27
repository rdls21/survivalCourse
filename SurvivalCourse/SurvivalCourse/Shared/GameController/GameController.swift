//
//  GameController.swift
//  SurvivalCourse
//
//  Created by rdls on 5/25/26.
//

import GameplayKit

final class GameController {
    // Super view that will present everithing contained here
    unowned let view: SKView
    // Managers
    // Instead of an inline declaration, how would you initialize this lazy property inside the init?
    private var inputManager: InputManager!
    // State Machine
    private var stateMachine: GKStateMachine!
    // States for the state machine
    private(set) lazy var mainMenuState: MainMenuState = .init(gameController: self)
    private(set) lazy var gameplayState: GameplayState = .init(gameController: self)
    private(set) lazy var creditsState: CreditsState = .init(gameController: self)
    // Initializer
    init(view: SKView) {
        self.view = view
        // Once Self is ready, create the state machine
        setupStateMachine()
        // Setup Game Controller
        inputManager = .init(with: self)
    }
    // Setup
    private func setupStateMachine() {
        // Setup the State Machine
        stateMachine = GKStateMachine(states: [
            mainMenuState,
            gameplayState,
            creditsState
        ])
        self.enterState(GameplayState.self)
    }
    // Public functions
    // State Transitions
    func enterState(_ state: AnyClass) {
        // Avoid trying to enter to prohibeted cases
        if stateMachine.canEnterState(state) == false { return }
        stateMachine.enter(state)
    }
    /// Function intended for the GameManager State Machine
    func presentScene(_ scene: SKScene, with transition: SKTransition = .fade(withDuration: 0.25)) {
        view.presentScene(scene, transition: transition)
    }
    
    // Controller Relay
    func setNewDirection(from vector: CGVector) {
        guard let currentState = stateMachine.currentState else { return }
        if (!currentState.isEqual(gameplayState)) { return }
        // Get current scene, must be
        guard let scene = view.scene as? GameScene else { return }
        // Pass the new vector
        scene.updateDirectionalStick(from: vector)
    }
    func shoot() {
        guard let currentState = stateMachine.currentState else { return }
        if (!currentState.isEqual(to: gameplayState)) { return }
        guard let scene = view.scene as? GameScene else { return }
        scene.shoot()
    }
}
