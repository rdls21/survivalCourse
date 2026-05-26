//
//  SoundManager.swift
//  SurvivalCourse
//
//  Created by rdls on 5/25/26.
//

import SpriteKit
import AVFAudio

/// Enum that holds all background music for this game
enum BackgroundMusic: String, CaseIterable {
    case mainTheme = "mainTheme"
    case gameplayTheme = "gameplayTheme"
    case creditsTheme
}

/// Enum that holds all background music for this game
enum SoundEffect: String, CaseIterable {
    case fart = "fartSoundEffect"
}

/// Class that implements the singleton pattern to have a single global instance
/// Will manage all sound effects, including background music and sound effects.
final class SoundManager {
    /// Shared SoundManager that can be accesed globally
    /// This instance is initialized lazily (only when needed) and  only once.
    ///
    /// A static type property is the default method for creating singletons.
    static let shared: SoundManager = .init()
    /// Prevent external instantiation
    private init() {}
    /// Inner properties to play audio files.
    ///
    // Public background music functions
    func playBackgroundMusic(_ music: BackgroundMusic) {
        
    }
    // Public sound effects functions
    func playSoundEffect(_ sound: SoundEffect, node: SKNode?) {
        
    }
}
