//
//  GameScene.swift
//  SurvivalCourse
//
//  Created by rdls on 5/25/26.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    // ECS
    private var agentSystem = GKComponentSystem(componentClass: AgentComponent.self)
    // Enemies Entities
    private var enemyEntities: [GKEntity] = []
    // Player Entity
    private var playerEntity: GKEntity?
    // Update Cycle
    private var lastUpdateTime: TimeInterval = 0
    // Input Management
    private var shootRequested: Bool = false
    // Stage Elements
    private var backgroundNode: SKSpriteNode!
    private var pauseButton: SKSpriteNode!
    private var healthBar: SKSpriteNode!
    // Collectable Entities
    private var collectableEntities: [GKEntity] = []
    // Default elements on screen
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    // SpriteKit Lifecycle
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        // The UI Needs to be ready before anything else
        setupStage()
        // ECS Setup
        setupPlayer()
        setupEnemies()
        // Items Animation
        setupCollectable()
        
        // Stage Objects -> Moved into Setup Player
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
        // Physics world configuration
        self.physicsWorld.contactDelegate = self
    }
    
    // Entity Setup
    // Main Character Entity Setup
    private func setupPlayer() {
        guard let node = self.childNode(withName: "//SpaceShip") as? SKSpriteNode else { return }
        let entity = GKEntity()
        //entity.addComponent(TransformComponent(node: node))
        // Add visual component
        let movingAtlas: SpriteAtlasData = .init(atlasName: "ship_moving", textureNames: ["ship_0", "ship_1"])
        let spriteComponent = SpriteComponent(node: node, damageName: "ship_damage", spriteAtlas: movingAtlas)
        entity.addComponent(spriteComponent)
        // Agent component (for simplified game logic)
        let agent = AgentComponent()
        agent.position = vector_float2(Float(node.position.x), Float(node.position.y))
        agent.rotation = Float(node.zRotation)
        agent.maxSpeed = 200.0
        agent.maxAcceleration = 300.0
        agent.radius = Float(max(node.size.width, node.size.height)) / 2
        entity.addComponent(agent)
        // Movement Component
        entity.addComponent(MovementComponent())
        // Shooting Component
        entity.addComponent(ShootingComponent(scene: self.scene!, bulletName: "bullet"))
        // Health Entity
        entity.addComponent(HealthComponent(maxHealth: 100.0, healthBar: healthBar))
        playerEntity = entity
        agentSystem.addComponent(agent)
    }
    // Enemy setup
    private func setupEnemies() {
        // Get the player agent, so the enemies will know how to approach it
        guard let playerAgent = playerEntity?.component(ofType: AgentComponent.self) else { return }
        self.enumerateChildNodes(withName: "//enemy") { [weak self] node, _ in
            guard let strongSelf = self else { return }
            guard let spriteNode = node as? SKSpriteNode else { return }
            // Create the entity for our Enemy
            let entity = GKEntity()
            // Add visual component
            entity.addComponent(SpriteComponent(node: spriteNode, damageName: "enemy_damage"))
            // Agent Component (simplified version of the game where all AI decisions take place)
            let agent = AgentComponent()
            agent.position = vector_float2(Float(spriteNode.position.x), Float(spriteNode.position.y))
            agent.rotation = Float(spriteNode.zRotation)
            agent.maxSpeed = 100.0
            agent.maxAcceleration = 200.0
            agent.radius = Float(max(spriteNode.size.width, spriteNode.size.width)) / 2
            entity.addComponent(agent)
            // Movement Component
            entity.addComponent(MovementComponent())
            // Shooting Component
            entity.addComponent(ShootingComponent(scene: strongSelf, bulletName: "bullet_enemy"))
            // Health Entity
            entity.addComponent(HealthComponent(maxHealth: 40.0))
            // AI Behaviour component
            entity.addComponent(EnemyAIComponent(target: playerAgent))
            // Load them into the class variables
            strongSelf.enemyEntities.append(entity)
            strongSelf.agentSystem.addComponent(agent)
        }
    }
    
    private func setupStage() {
        backgroundNode = self.childNode(withName: "backgroundNode") as? SKSpriteNode
        backgroundNode.physicsBody = SKPhysicsBody(edgeLoopFrom: backgroundNode.frame)
        pauseButton = self.childNode(withName: "//pauseButton") as? SKSpriteNode
        healthBar = self.childNode(withName: "//playerHealthBar") as? SKSpriteNode
    }
    
    private func setupCollectable() {
        self.enumerateChildNodes(withName: "//collectable") { [weak self](node, _) in
            node.physicsBody?.collisionBitMask = 1
            node.name = "collectable"
            guard let strongSelf = self else { return }
            guard let spriteNode = node as? SKSpriteNode else { return }
            // Create the atlas reference
            let spriteAtlasData: SpriteAtlasData = .init(
                atlasName: "collectable",
                textureNames: [
                    "collectable_0",
                    "collectable_1",
                    "collectable_2",
                    "collectable_3",
                    "collectable_4",
                    "collectable_5",
                    "collectable_6",
                    "collectable_7",
                    "collectable_8",
                    "collectable_9"
                ]
            )
            // Create an entity for the collectables
            let entity = GKEntity()
            let spriteComponent = SpriteComponent(node: spriteNode, spriteAtlas: spriteAtlasData)
            entity.addComponent(spriteComponent)
            spriteComponent.startAnimating()
            strongSelf.collectableEntities.append(entity)
        }
    }
    
    // Input Public functions
    func updateDirectionalStick(from vector: CGVector) {
        playerEntity?.component(ofType: MovementComponent.self)?.currentInput = vector
        if vector.dy > 0 {
            playerEntity?.component(ofType: SpriteComponent.self)?.startAnimating()
        } else {
            playerEntity?.component(ofType: SpriteComponent.self)?.stopAnimating()
        }
    }
    func shoot() {
        guard let player = playerEntity?.component(ofType: SpriteComponent.self)?.node else { return }
        playerEntity?.component(ofType: ShootingComponent.self)?.shoot(from: player)
    }
    
    // Gameloop
    override func update(_ currentTime: TimeInterval) {
        // Delta Time
        if lastUpdateTime == 0 { lastUpdateTime = currentTime }
        let deltaTime: TimeInterval = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        // Update the player agent manually
        // Update the movement component
        playerEntity?.component(ofType: MovementComponent.self)?.update(deltaTime: deltaTime)
        // Update all agents
        agentSystem.update(deltaTime: deltaTime)
        // Iretate trough all enemyEntities
        //for entity in self.enemyEntities {
            //entity.component(ofType: MovementComponent.self)?.update(deltaTime: deltaTime)
        //}
        // Called before each frame is rendered
        // Camera Smooth Following
        guard let player = self.playerEntity?.component(ofType: SpriteComponent.self)?.node as? SKSpriteNode else { return }
        let xOffset = player.position.x - (camera?.position.x)!+40
        camera?.position.x += ((xOffset-40)/40)
        let yOffset = player.position.y - (camera?.position.y)!
        camera?.position.y += ((yOffset)/30)
    }
    // UI Interaction
    // Supresses the keyboard default behaviour
    override func keyDown(with event: NSEvent) {}
    // Physics Delegate
}
