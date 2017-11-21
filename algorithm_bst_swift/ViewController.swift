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
        let move = SKAction.moveBy(x: 20, y: 200, duration: 0.5)
        if let child = childNode{
            child.run(move)
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
    let nodeSize = CGSize(width: 40, height: 40)
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
            nodeShape.path = UIBezierPath(roundedRect: CGRect(x: -20, y: -20, width: nodeSize.width, height: nodeSize.height), cornerRadius: 20).cgPath
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
    
    func drawConnectingLine(parent: SKShapeNode, child: SKShapeNode){
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
    
    func joinNodesWithSpring(parent: SKShapeNode, child: SKShapeNode){
        parentNode!.physicsBody = SKPhysicsBody(circleOfRadius: nodeSize.width/2)
        parentNode!.physicsBody!.isDynamic = false
        childNode!.physicsBody = SKPhysicsBody(circleOfRadius: nodeSize.width/2)
        
        let spring = SKPhysicsJointSpring.joint(withBodyA: parentNode!.physicsBody!, bodyB: childNode!.physicsBody!, anchorA: parentNode!.position, anchorB: childNode!.position)
        spring.frequency = 0.9
        spring.damping = 0.2
        SKViewController.scene!.physicsWorld.add(spring)
    }
    
    func makeNodesAndConnect(){
        parentNode = nodeGenWithLabel(20)
        childNode = nodeGenWithLabel(42, offset: 20)
        drawConnectingLine(parent: parentNode!, child: childNode!)
        joinNodesWithSpring(parent: parentNode!, child: childNode!)
        
    }
    
    
}
