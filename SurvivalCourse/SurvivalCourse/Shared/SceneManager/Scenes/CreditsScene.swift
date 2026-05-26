//
//  CreditsScene.swift
//  SurvivalCourse
//
//  Created by rdls on 5/25/26.
//

import SpriteKit

final class CreditsScene: SKScene {
    /// In this case, we will use weak,
    /// this means that the class CreditsScene does not own the object and might be nil.
    weak var gameController: GameController?
    // Private properties
    private var homeButton: SKNode!
    // Required Initializer
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.isUserInteractionEnabled = true
    }
    // Public Helper Methods
    // Pro-tip: Use the delegate pattern
    func setGameController(_ controller: GameController) {
        self.gameController = controller
    }
    // SKScene Life-Cycle
    override func didMove(to view: SKView) {
        self.homeButton = self.childNode(withName: "//homeButton")
    }
    // User Interaction
    override func mouseUp(with event: NSEvent) {
        let position = event.location(in: self)
        guard (homeButton != nil) else { return }
        if homeButton.contains(position) {
            gameController?.enterState(MainMenuState.self)
        }
    }
}
