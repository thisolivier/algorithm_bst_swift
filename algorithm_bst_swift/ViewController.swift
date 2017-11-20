//
//  ViewController.swift
//  algorithm_bst_swift
//
//  Created by Olivier Butler on 20/11/2017.
//  Copyright © 2017 Olivier Butler. All rights reserved.
//

import UIKit
import SpriteKit

class BstViewController: UIViewController {
    @IBOutlet weak var SKViewController: SKView!
    let myTree:Bst = Bst()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 1...20{
            myTree.addNodeFromInt(Int(arc4random_uniform(100)))
        }
        makeNode()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func makeNode(){
        let shape = SKShapeNode()
        shape.path = UIBezierPath(roundedRect: CGRect(x: -20, y: -20, width: 40, height: 40), cornerRadius: 20).cgPath
        
        if let frame = SKViewController.scene?.frame {
            print("We have a frame")
            shape.position = CGPoint(x: frame.midX, y: frame.midY)
            shape.fillColor = UIColor.white
            shape.strokeColor = UIColor.black
            shape.lineWidth = 1
            // Now add a label
            let myLabel = SKLabelNode(fontNamed: "HelveticaNeue-CondensedBlack")
            myLabel.text = "231";
            myLabel.fontSize = 14;
            myLabel.verticalAlignmentMode = .center
            myLabel.fontColor = UIColor.black
            shape.addChild(myLabel)
            
            SKViewController.scene!.addChild(shape)
        }
    }
}
