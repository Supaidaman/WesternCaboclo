//
//  GameOver.swift
//  WesternCaboclo
//
//  Created by Student on 2/2/16.
//  Copyright © 2016 Fullstack.io. All rights reserved.
//

import UIKit
import SpriteKit
class GameOver: SKScene{

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        let button = SKSpriteNode(imageNamed: "Yes")
        button.position.x = self.frame.width/2
        button.position.y = 410
        button.name = "previousButton"
        button.zPosition = 100
        button.xScale = 0.5
        button.yScale = 0.5
        
        
        self.addChild(button)
        
        let ofCourse = SKSpriteNode(imageNamed: "of course")
        ofCourse.position.x = self.frame.width/2
        ofCourse.position.y = 325
        ofCourse.name = "previousButton"
        ofCourse.zPosition = 100
        ofCourse.xScale = 0.5
        ofCourse.yScale = 0.5
        
        self.addChild(ofCourse)
        
        let placa = SKSpriteNode(imageNamed: "game over")
        placa.position = CGPointMake(self.size.width, self.frame.height)
        placa.zPosition = 100
        
        let background = SKSpriteNode(imageNamed: "over magic")
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
