//
//  GameScene.swift
//  //
//
//  C//

import SpriteKit
import AVFoundation
class GameScene: SKScene, SKPhysicsContactDelegate{
    let verticalPipeGap = 150.0
    
    var caboclo:SKSpriteNode!
    var skyColor:SKColor!
    
    var cactusTexture:SKTexture!
    var pipeTextureDown:SKTexture!
    var pituTexture:SKTexture!
    
    var movePipesAndRemove:SKAction!
    var movePitusAndRemove:SKAction!
    var moving:SKNode!
   
    var pipes:SKNode!
    var pitus:SKNode!

    var canRestart = Bool()
    var scoreLabelNode:SKLabelNode!
    var score = NSInteger()
    
    let birdCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1
    let pipeCategory: UInt32 = 1 << 2
    let scoreCategory: UInt32 = 1 << 3
    let pituCategory: UInt32 = 2 << 3
    var jumps = 0
    var groundTexture: SKTexture!
    var backgroundMusicPlayer = AVAudioPlayer()
    let gO:  GameOverViewController = GameOverViewController()
   
    override func didMoveToView(view: SKView) {
        
        canRestart = false
        
        // setup physics
        self.physicsWorld.gravity = CGVector( dx: 0.0, dy: -5.0 )
        self.physicsWorld.contactDelegate = self
        
        // setup background color
        skyColor = SKColor(red: 81.0/255.0, green: 192.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        self.backgroundColor = skyColor
        
        moving = SKNode()
        self.addChild(moving)
        pipes = SKNode()
        pitus = SKNode()
        moving.addChild(pipes)
        moving.addChild(pitus)
        
        // ground
         groundTexture = SKTexture(imageNamed: "land")
        groundTexture.filteringMode = .Nearest // shorter form for SKTextureFilteringMode.Nearest
        
        let moveGroundSprite = SKAction.moveByX(-groundTexture.size().width * 10.0, y: 0, duration: NSTimeInterval(0.02 * groundTexture.size().width * 2.0))
        let resetGroundSprite = SKAction.moveByX(groundTexture.size().width * 10.0, y: 0, duration: 0.0)
        let moveGroundSpritesForever = SKAction.repeatActionForever(SKAction.sequence([moveGroundSprite,resetGroundSprite]))
        
        for var i:CGFloat = 0; i < 10 + self.frame.size.width / ( groundTexture.size().width * 10.0 ); ++i {
            let sprite = SKSpriteNode(texture: groundTexture)
            sprite.setScale(2.0)
            sprite.position = CGPoint(x: i * sprite.size.width, y: sprite.size.height / 2.0)
            sprite.runAction(moveGroundSpritesForever)
            moving.addChild(sprite)
        }
        
        // skyline
        let skyTexture = SKTexture(imageNamed: "background")
        skyTexture.filteringMode = .Nearest
        
        let moveSkySprite = SKAction.moveByX(-skyTexture.size().width * 2.0, y: 0, duration: NSTimeInterval(0.1 * skyTexture.size().width ))
        let resetSkySprite = SKAction.moveByX(skyTexture.size().width * 2.0, y: 0, duration: 0.0)
        let moveSkySpritesForever = SKAction.repeatActionForever(SKAction.sequence([moveSkySprite,resetSkySprite]))
        
        for var i:CGFloat = 0; i < 2.0 + self.frame.size.width / ( skyTexture.size().width * 2.0 ); ++i {
            let sprite = SKSpriteNode(texture: skyTexture)
            sprite.setScale(2.0)
            sprite.zPosition = -20
            sprite.position = CGPoint(x: i * sprite.size.width, y: sprite.size.height / 2.0 + groundTexture.size().height)
            sprite.runAction(moveSkySpritesForever)
            moving.addChild(sprite)
        }
        
        // create the pipes textures
        cactusTexture = SKTexture(imageNamed: "BigCactus")
        cactusTexture.filteringMode = .Nearest
       // pipeTextureDown = SKTexture(imageNamed: "PipeDown")
     //   pipeTextureDown.filteringMode = .Nearest
        
        // create the pipes movement actions
        let distanceToMove = CGFloat(self.frame.size.width + 2.0 * cactusTexture.size().width)
        let movePipes = SKAction.moveByX(-distanceToMove, y:0.0, duration:NSTimeInterval(0.005 * distanceToMove))
        let removePipes = SKAction.removeFromParent()
      movePipesAndRemove = SKAction.sequence([movePipes, removePipes])
        
        
        let spawn = SKAction.runBlock({() in self.spawnCactus()})
        let delay = SKAction.waitForDuration(NSTimeInterval(5.0))
        let spawnThenDelay = SKAction.sequence([spawn, delay])
        let spawnThenDelayForever = SKAction.repeatActionForever(spawnThenDelay)
        self.runAction(spawnThenDelayForever)
        
        //set pitus
        //let distanceToMovePitu = CGFloat(self.frame.size.width + 2.0 * cactusTexture.size().width)
        
        
        //pitu
        
        pituTexture = SKTexture(imageNamed: "pitu")
        pituTexture.filteringMode = .Nearest
        
        // pipeTextureDown = SKTexture(imageNamed: "PipeDown")
        //   pipeTextureDown.filteringMode = .Nearest
        
        // create the pipes movement actions
        let distanceToMovePitu = CGFloat(self.frame.size.width + 2.0 * pituTexture.size().width)
        let movePitus = SKAction.moveByX(-distanceToMovePitu, y:0.0, duration:NSTimeInterval(0.005 * distanceToMovePitu))
        let removePitus = SKAction.removeFromParent()
        movePitusAndRemove = SKAction.sequence([movePitus, removePitus])
        
        
        let spawnPitus = SKAction.runBlock({() in self.spawnPitus()})
        let delayPitus = SKAction.waitForDuration(NSTimeInterval(3.2))
        let spawnThenDelayPitus = SKAction.sequence([spawnPitus, delayPitus])
        let spawnThenDelayForeverPitus = SKAction.repeatActionForever(spawnThenDelayPitus)
        self.runAction(spawnThenDelayForeverPitus)

        
        //pitu
        
        
        // setup our bird
        let birdTexture1 = SKTexture(imageNamed: "run1")
        birdTexture1.filteringMode = .Nearest
        let birdTexture2 = SKTexture(imageNamed: "run2")
        birdTexture2.filteringMode = .Nearest
        
        let anim = SKAction.animateWithTextures([birdTexture1, birdTexture2], timePerFrame: 0.2)
        let runCaboclorun = SKAction.repeatActionForever(anim)
        
        caboclo = SKSpriteNode(texture: birdTexture1)
        caboclo.setScale(2.0)
        var boundingBox: CGRect =
            CGRectMake(caboclo.position.x-caboclo.size.width/6,
                caboclo.position.y-caboclo.size.height/4,
                caboclo.frame.size.width/4,
                caboclo.frame.size.height);
        
        //var radiusBox = CG
        
        caboclo.position = CGPoint(x: self.frame.size.width * 0.35, y:self.frame.size.height * 0.6)
        caboclo.runAction(runCaboclorun, withKey: "run")
      
        //nicesize.width = caboclo.size.width
        //nicesize.height = caboclo.size.height
        caboclo.physicsBody = SKPhysicsBody(rectangleOfSize: boundingBox.size)
       // caboclo.physicsBody = caboclo
        caboclo.physicsBody?.dynamic = true
        caboclo.physicsBody?.allowsRotation = false
        
        caboclo.physicsBody?.categoryBitMask = birdCategory
        caboclo.physicsBody?.collisionBitMask = worldCategory | pipeCategory
        caboclo.physicsBody?.contactTestBitMask = worldCategory | pipeCategory
        
        self.addChild(caboclo)
        
        // create the ground
        var ground = SKNode()
        ground.position = CGPoint(x: 0, y: groundTexture.size().height)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: self.frame.size.width, height: groundTexture.size().height * 2.0))
        ground.physicsBody?.dynamic = false
        ground.physicsBody?.categoryBitMask = worldCategory
        self.addChild(ground)
        
        // Initialize label and create a label which holds the score
        score = 0
        scoreLabelNode = SKLabelNode(fontNamed:"MarkerFelt-Wide")
        scoreLabelNode.position = CGPoint( x: self.frame.origin.x + 50 , y: self.frame.minY + 150)
        scoreLabelNode.zPosition = 100
        scoreLabelNode.text = String(score)
        self.addChild(scoreLabelNode)
        
        
        let swipeUp: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action:"respondToSwipeGesture:")
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        self.view!.addGestureRecognizer(swipeUp)
        
        playBackgroundMusic("faroeste.mp3")
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                print("Swiped right")
            case UISwipeGestureRecognizerDirection.Down:
                print("Swiped down")
            case UISwipeGestureRecognizerDirection.Left:
                print("Swiped left")
            case UISwipeGestureRecognizerDirection.Up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
    //ar backgroundMusicPlayer = AVAudioPlayer()
    
    func playBackgroundMusic(filename: String) {
        let url = NSBundle.mainBundle().URLForResource(filename, withExtension: nil)
        guard let newURL = url else {
            print("Could not find file: \(filename)")
            return
        }
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOfURL: newURL)
            backgroundMusicPlayer.numberOfLoops = -1
            backgroundMusicPlayer.prepareToPlay()
            backgroundMusicPlayer.play()
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    func spawnCactus() {
        let cactus = SKNode()
        cactus.position = CGPoint( x: self.frame.size.width + cactusTexture.size().width * 2, y: groundTexture.size().height - 30)//pipeTextureUp.size().height )
      //  pipePair.zPosition = -10
        
        let height = UInt32( self.frame.size.height / 4)
        let y = Double(height) ;
        
        //let pipeDown = SKSpriteNode(texture: pipeTextureDown)
        //pipeDown.setScale(2.0)
        //pipeDown.position = CGPoint(x: 0.0, y: y + Double(pipeDown.size.height) + verticalPipeGap)
        
        
       // pipeDown.physicsBody = SKPhysicsBody(rectangleOfSize: pipeDown.size)
        //pipeDown.physicsBody?.dynamic = false
        //pipeDown.physicsBody?.categoryBitMask = pipeCategory
        //pipeDown.physicsBody?.contactTestBitMask = birdCategory
        //pipePair.addChild(pipeDown)
        
        let cactusChild = SKSpriteNode(texture: cactusTexture)
        cactusChild.setScale(1.0)
        cactusChild.position = CGPoint(x: 0.0, y: y)
        
        cactusChild.physicsBody = SKPhysicsBody(rectangleOfSize: cactusChild.size)
        cactusChild.physicsBody?.dynamic = false
        cactusChild.physicsBody?.categoryBitMask = pipeCategory
        cactusChild.physicsBody?.contactTestBitMask = birdCategory
        cactus.addChild(cactusChild)
        
        var contactNode = SKNode()
        contactNode.position = CGPoint( x: cactusChild.size.width + caboclo.size.width / 2, y: self.frame.midY )
        contactNode.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize( width: cactusChild.size.width, height: self.frame.size.height ))
        contactNode.physicsBody?.dynamic = false
        contactNode.physicsBody?.categoryBitMask = scoreCategory
        contactNode.physicsBody?.contactTestBitMask = birdCategory
        cactus.addChild(contactNode)
        
        cactus.runAction(movePipesAndRemove)
        pipes.addChild(cactus)
        
    }
    
    func spawnPitus()
    {
        let pitu = SKNode()
        pitu.position = CGPoint( x: self.frame.size.width + pituTexture.size().width * 2, y: groundTexture.size().height - 30)//pipeTextureUp.size().height )
        //  pipePair.zPosition = -10
        
        let height = UInt32( self.frame.size.height / 4)
        let y = Double(height) ;
        
        //let pipeDown = SKSpriteNode(texture: pipeTextureDown)
        //pipeDown.setScale(2.0)
        //pipeDown.position = CGPoint(x: 0.0, y: y + Double(pipeDown.size.height) + verticalPipeGap)
        
        
        // pipeDown.physicsBody = SKPhysicsBody(rectangleOfSize: pipeDown.size)
        //pipeDown.physicsBody?.dynamic = false
        //pipeDown.physicsBody?.categoryBitMask = pipeCategory
        //pipeDown.physicsBody?.contactTestBitMask = birdCategory
        //pipePair.addChild(pipeDown)
        
        let pituBottle = SKSpriteNode(texture: pituTexture)
        pituBottle.setScale(1.0)
        pituBottle.position = CGPoint(x: 0.0, y: y)
        
        pituBottle.physicsBody = SKPhysicsBody(rectangleOfSize: pituBottle.size)
        pituBottle.physicsBody?.dynamic = false
        pituBottle.physicsBody?.categoryBitMask = pituCategory
        pituBottle.physicsBody?.contactTestBitMask = birdCategory
        pitu.addChild(pituBottle)
        
        var contactNode = SKNode()
        contactNode.position = CGPoint( x: pituBottle.size.width + caboclo.size.width / 2, y: self.frame.midY )
        contactNode.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize( width: pituBottle.size.width, height: self.frame.size.height ))
        contactNode.physicsBody?.dynamic = false
        contactNode.physicsBody?.categoryBitMask = scoreCategory
        contactNode.physicsBody?.contactTestBitMask = birdCategory
        pitu.addChild(contactNode)
        
        pitu.runAction(movePitusAndRemove)
        pitus.addChild(pitu)
        
    }
    
    func resetScene (){
        // Move bird to original position and reset velocity
        caboclo.position = CGPoint(x: self.frame.size.width / 2.5, y: self.frame.midY)
        caboclo.physicsBody?.velocity = CGVector( dx: 0, dy: 0 )
        caboclo.physicsBody?.collisionBitMask = worldCategory | pipeCategory
        caboclo.speed = 1.0
        caboclo.zRotation = 0.0
        
        // Remove all existing pipes
        pipes.removeAllChildren()
        pitus.removeAllChildren()
        
        // Reset _canRestart
        canRestart = false
        
        // Reset score
        score = 0
        scoreLabelNode.text = String(score)
                // Restart animation
        moving.speed = 1
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        if moving.speed > 0  {
            
           
            
            for touch: AnyObject in touches {
                //let birdTexture2 = SKTexture(imageNamed: "pulando")
                //bird = SKSpriteNode(texture: birdTexture2)
                //let location = touch.locationInNode(self)
               // caboclo.removeActionForKey("run")
                caboclo.removeAllActions()
                
                
                caboclo.texture = SKTexture(imageNamed: "jumpNewNewAgain")
                caboclo.setScale(2.3)
                if(jumps==0){
                caboclo.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                caboclo.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100))
                    jumps++
                }
            }
        } else if canRestart {
            caboclo.removeAllActions()
            caboclo.setScale(2.0)
            
            self.resetScene()
            
        }
        else if moving.speed == 0
        {
            // setup our bird
            caboclo.setScale(2.0)
            
            let birdTexture1 = SKTexture(imageNamed: "run1")
            birdTexture1.filteringMode = .Nearest
            let birdTexture2 = SKTexture(imageNamed: "run2")
            birdTexture2.filteringMode = .Nearest
            
            let anim = SKAction.animateWithTextures([birdTexture1, birdTexture2], timePerFrame: 0.2)
            let runCaboclorun = SKAction.repeatActionForever(anim)
            
            // caboclo
            
            caboclo.runAction(runCaboclorun, withKey: "run")
            //caboclo.texture = SKTexture(imageNamed: "run1")
            moving.speed = 1
            jumps=0

        }
    }
    
    // TODO: Move to utilities somewhere. There's no reason this should be a member function
    func clamp(min: CGFloat, max: CGFloat, value: CGFloat) -> CGFloat {
        if( value > max ) {
            return max
        } else if( value < min ) {
            return min
        } else {
            return value
        }
    }
    
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    //    bird.zRotation = self.clamp( -1, max: 0.5, value: bird.physicsBody!.velocity.dy * ( bird.physicsBody!.velocity.dy < 0 ? 0.003 : 0.001 ) )
    }
    
    func gameOver()
    {
       // self.view presentScene : GameOverViewController transition:arbitraryTransition;
        
        
        let gameScene:GameOver = GameOver() // create your new scene
        let transition = SKTransition.revealWithDirection(SKTransitionDirection.Down, duration: 0) // create type of transition (you can check in documentation for more transtions)
        gameScene.scaleMode = SKSceneScaleMode.AspectFill
        self.view!.presentScene(gameScene, transition: transition)    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        if moving.speed > 0 {
//            if ( contact.bodyA.categoryBitMask & scoreCategory ) == scoreCategory || ( contact.bodyB.categoryBitMask & scoreCategory ) == scoreCategory {
//                // Bird has contact with score entity
//                score++
//                scoreLabelNode.text = String(score)
//                
//                // Add a little visual feedback for the score increment
//                scoreLabelNode.runAction(SKAction.sequence([SKAction.scaleTo(1.5, duration:NSTimeInterval(0.1)), SKAction.scaleTo(1.0, duration:NSTimeInterval(0.1))]))
//            }
            
            if ( contact.bodyA.categoryBitMask & pipeCategory ) == pipeCategory || ( contact.bodyB.categoryBitMask & pipeCategory ) == pipeCategory {
                print("COLIDIUSZI")
               // caboclo.removeActionForKey("run")
                //self.canRestart = true
                
                //gameOver()
                caboclo.removeAllActions()

                //resetScene()
                let gameScene = GameOver(size: self.size)
                let transition = SKTransition.doorsCloseHorizontalWithDuration(0.5)
                gameScene.scaleMode = SKSceneScaleMode.AspectFill
                self.scene!.view?.presentScene(gameScene, transition: transition)
                moving.speed=0
            }
            
            if ( contact.bodyA.categoryBitMask & pituCategory ) == pituCategory || ( contact.bodyB.categoryBitMask & pituCategory ) == pituCategory {
                print("COLIDIUSZICUNPITU")
                // caboclo.removeActionForKey("run")
                //self.canRestart = true
                score+=10
                scoreLabelNode.text = String(score)
                
                print("\(contact.bodyA)")
                print("\(contact.bodyB)")
                
                contact.bodyB.node?.removeFromParent()
                
              //  pitus.remo
             //   pitus.removeChildrenInArray(pitus)
                //gameOver()
                //caboclo.removeAllActions()
                
                //resetScene()
               // moving.speed=0
            }

            
            
            
            if ( contact.bodyA.categoryBitMask & worldCategory ) == worldCategory || ( contact.bodyB.categoryBitMask & worldCategory ) == worldCategory  {
                
               // moving.speed = 0
                
                caboclo.physicsBody?.collisionBitMask = worldCategory
                //bird.runAction(  SKAction.rotateByAngle(CGFloat(M_PI) * CGFloat(bird.position.y) * 0.01, duration:1), completion:{self.bird.speed = 0 })
                if(jumps>0)
                    
                {
                    caboclo.setScale(2.0)
                    let birdTexture1 = SKTexture(imageNamed: "run1")
                    birdTexture1.filteringMode = .Nearest
                    let birdTexture2 = SKTexture(imageNamed: "run2")
                    birdTexture2.filteringMode = .Nearest
                    
                    let anim = SKAction.animateWithTextures([birdTexture1, birdTexture2], timePerFrame: 0.2)
                    let runCaboclorun = SKAction.repeatActionForever(anim)
                    
                    // caboclo
                    
                    caboclo.runAction(runCaboclorun, withKey: "run")

                }
                jumps = 0
               // caboclo.texture = SKTexture(imageNamed: "run1")
                
               // print("COLIDIUSZINUCHAO")

                // Flash background if contact is detected
                self.removeActionForKey("flash")
                /*self.runAction(SKAction.sequence([SKAction.repeatAction(SKAction.sequence([SKAction.runBlock({
                    self.backgroundColor = SKColor(red: 1, green: 0, blue: 0, alpha: 1.0)
                    }),SKAction.waitForDuration(NSTimeInterval(0.05)), SKAction.runBlock({
                        self.backgroundColor = self.skyColor
                        }), SKAction.waitForDuration(NSTimeInterval(0.05))]), count:4), SKAction.runBlock({
                            self.canRestart = true
                            })]), withKey: "flash")
*/
            }
        }
    }
}
