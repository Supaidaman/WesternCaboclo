//
//  File.swift
//  menu
//
//  Created by Student on 2/3/16.
//  Copyright © 2016 Student. All rights reserved.
//

import Foundation
import SpriteKit


class SecondScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        let button = SKSpriteNode(imageNamed: "play")
        button.position.x = 585
        button.position.y = 270
        button.name = "previousButton"
        button.zPosition = 100
        button.xScale = 2
        button.yScale = 2
        
        self.addChild(button)
        
        
        let background = SKSpriteNode(imageNamed: "menu background")
        background.size = self.frame.size
        self.addChild(background)
        background.position = CGPointMake(self.size.width/2, self.size.height/2)
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>,
        withEvent event: UIEvent?){
            let location = touches.first!.locationInNode(self)
            let node = self.nodeAtPoint(location)
            
            // If previous button is touched, start transition to previous scene
            if (node.name == "previousButton") {
                let gameScene = GameScene(size: self.size)
                let transition = SKTransition.doorsCloseHorizontalWithDuration(0.5)
                gameScene.scaleMode = SKSceneScaleMode.AspectFill
                self.scene!.view?.presentScene(gameScene, transition: transition)
            }
            
    }
    
}