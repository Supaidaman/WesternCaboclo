//
//  GameOverViewController.swift
//  WesternCaboclo
//
//  Created by Student on 2/2/16.
//  Copyright © 2016 Fullstack.io. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {

    @IBAction func butao(sender: AnyObject) {
    }
    @IBOutlet weak var gameOverText: UILabel!
    override func viewDidLoad() {
               super.viewDidLoad()
        self.view.backgroundColor = UIColor.redColor()
        print("WUW")
//        gameOverText.text = "GAME OVER YEAAAAAAH"

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
