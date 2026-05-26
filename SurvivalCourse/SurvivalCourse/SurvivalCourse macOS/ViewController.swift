//
//  ViewController.swift
//  SurvivalCourse
//
//  Created by rdls on 5/25/26.
//

import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController {
    @IBOutlet var skView: SKView!
    private var gameController: GameController!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.skView {
            // Confugure the Game Manager
            gameController = GameController(view: view)
            // Ignores sibling and transversal order, if yes must use Z-Position.
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsPhysics = true
            view.showsNodeCount = true
        }
    }
}

