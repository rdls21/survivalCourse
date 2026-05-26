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
    }
    
    @objc func controllerDisconnected(notification: NSNotification) {
        
    }
}
