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
    lazy var inputManager: InputManager = .init(with: self)
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
    }
    // Setup
    private func setupStateMachine() {
        // Setup the State Machine
        stateMachine = GKStateMachine(states: [
            mainMenuState,
            gameplayState,
            creditsState
        ])
        self.enterState(MainMenuState.self)
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
}
