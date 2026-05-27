//
//  InputManager.swift
//  SurvivalCourse
//
//  Created by rdls on 5/25/26.
/* ABOUT:
 Esta clase deberá ser capaz de leer los cambios de estado del teclado, como presionó teclas de direccion o barra espaciadora y notificar mediante una funcion al game controller.
 */

import GameController

final class InputManager {
    // Properties
    // Direction intent properties
    private var directionalInput: CGVector = .zero
    /// GameController property
    ///
    /// Unowned property means that this object is not created by this class
    /// but will always exist during the lifecycle of this class.
    /// BaseGameState does not owns the object and might be nil.
    unowned let gameScene: GameController
    // Initializer
    init(with gameController: GameController) {
        self.gameScene = gameController
        setupGCObservers()
    }
    // Setup
    private func setupGCObservers() {
        // Get the notification center
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(controllerConnected), name: .GCKeyboardDidConnect, object: nil)
        center.addObserver(self, selector: #selector(controllerDisconnected), name: .GCKeyboardDidConnect, object: nil)
    }
    
    //OBJC Signed functions
    @objc func controllerConnected(notification: NSNotification) {
        guard let controller = notification.object as? GCKeyboard else { return }
        print("Controller connected: \(controller.vendorName ?? "Unknown vendor")")
        // Get the current keyboard input
        guard let input: GCKeyboardInput = controller.keyboardInput else { return }
        weak let weakInputManager = self
        // Create change handlers for each one of the keys
        input.button(forKeyCode: .upArrow)?.pressedChangedHandler = {
            (_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void in
            guard let strongSelf = weakInputManager else { return }
            strongSelf.directionalInput.dy += pressed ? 1 : -1; strongSelf.setNewDirection()
        }
        input.button(forKeyCode: .downArrow)?.pressedChangedHandler = {
            (_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void in
            guard let strongSelf = weakInputManager else { return }
            strongSelf.directionalInput.dy -= pressed ? 1 : -1; strongSelf.setNewDirection()
        }
        input.button(forKeyCode: .leftArrow)?.pressedChangedHandler = {
            (_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void in
            guard let strongSelf = weakInputManager else { return }
            strongSelf.directionalInput.dx += pressed ? 1 : -1; strongSelf.setNewDirection()
        }
        input.button(forKeyCode: .rightArrow)?.pressedChangedHandler = {
            (_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void in
            guard let strongSelf = weakInputManager else { return }
            strongSelf.directionalInput.dx -= pressed ? 1 : -1; strongSelf.setNewDirection()
        }
        // Shoot action
        input.button(forKeyCode: .spacebar)?.pressedChangedHandler = {
            (_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void in
            guard let strongSelf = weakInputManager else { return }
            if pressed { strongSelf.spaceBarPressed() }
        }
    }
    @objc func controllerDisconnected(notification: NSNotification) {
        self.resetInputs()
    }
    
    // Keyboard Observers
    func setNewDirection() {
        gameScene.setNewDirection(from: directionalInput)
    }
    func spaceBarPressed() {
        gameScene.shoot()
    }
    // Helper functions
    func resetInputs() {
        directionalInput = .zero
    }
}
