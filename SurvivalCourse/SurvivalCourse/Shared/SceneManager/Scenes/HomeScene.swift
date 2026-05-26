//
//  HomeScene.swift
//  SurvivalCourse
//
//  Created by rdls on 5/25/26.
//

import SpriteKit

final class HomeScene: SKScene {
    /// weak means that HomeScene does not own the object and might be nil.
    weak var gameController: GameController?
    // Private properties
    private var playButton: SKNode!
    // Initializer
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    // Public Helper Methods
    // Pro-tip: Use the delegate pattern
    func setGameController(_ controller: GameController) {
        self.gameController = controller
    }
    // SKScene Life-Cycle
    override func didMove(to view: SKView) {
        self.playButton = self.childNode(withName: "//playButton")
    }
    // User Interaction
    override func mouseUp(with event: NSEvent) {
        let position = event.location(in: self)
        guard (playButton != nil) else { return }
        if playButton.contains(position) {
            gameController?.enterState(GameplayState.self)
        }
    }
}
