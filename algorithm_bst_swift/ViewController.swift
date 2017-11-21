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
    
    // Links to storyboard/visual elements
    @IBOutlet weak var SKViewController: SKView!
    @IBAction func LemonButtonAction(_ sender: UIButton) {
        if let parent = parentNode{
            parent.position = CGPoint(x: (parent.position.x - 40), y: (parent.position.y - 10))
        }
    }
    @IBAction func JamButtonAction(_ sender: UIButton) {
    }
    @IBAction func WoodsButtonAction(_ sender: UIButton) {
    }
    @IBAction func LazerButtonAction(_ sender: UIButton) {
    }
    
    // Properties setup
    let myTree:Bst = Bst()
    var parentNode:SKShapeNode?
    var childNode:SKShapeNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 1...20{
            myTree.addNodeFromInt(Int(arc4random_uniform(100)))
        }
        makeNodesAndConnect()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func nodeGenWithLabel(_ labelValue:Int, offset:CGFloat = 0) -> SKShapeNode{
        let nodeShape = SKShapeNode()
        let nodeLabel = SKLabelNode(fontNamed: "HelveticaNeue-CondensedBlack")
        
        if let frame = SKViewController.scene?.frame {
            nodeShape.path = UIBezierPath(roundedRect: CGRect(x: -20, y: -20, width: 40, height: 40), cornerRadius: 20).cgPath
            nodeShape.position = CGPoint(x: frame.midX, y: (frame.height/2) - (100 + offset))
            nodeShape.fillColor = UIColor.white
            nodeShape.strokeColor = UIColor.black
            nodeShape.lineWidth = 1
            nodeShape.zPosition = 10
            // Now add a label
            
            nodeLabel.text = String(labelValue);
            nodeLabel.fontSize = 14;
            nodeLabel.verticalAlignmentMode = .center
            nodeLabel.fontColor = UIColor.black
            nodeLabel.zPosition = 20
            nodeShape.addChild(nodeLabel)
            SKViewController.scene!.addChild(nodeShape)
        }
        return nodeShape
    }
    
    func connectNodes(parent: SKShapeNode, child: SKShapeNode){
        let path = CGMutablePath()
        let lineShape = SKShapeNode()
        path.move(to: parent.position)
        path.addLine(to: child.position)
        lineShape.path = path
        lineShape.strokeColor = UIColor.black
        lineShape.lineWidth = 2
        lineShape.zPosition = 5
        SKViewController.scene!.addChild(lineShape)
    }
    
    func makeNodesAndConnect(){
        parentNode = nodeGenWithLabel(20)
        childNode = nodeGenWithLabel(42, offset: 100)
        connectNodes(parent: parentNode!, child: childNode!)
    }
}
