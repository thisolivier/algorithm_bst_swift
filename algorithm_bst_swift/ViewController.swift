//
//  ViewController.swift
//  algorithm_bst_swift
//
//  Created by Olivier Butler on 20/11/2017.
//  Copyright © 2017 Olivier Butler. All rights reserved.
//

import UIKit
import SpriteKit

class BstViewController: UIViewController, SKSceneDelegate {
    
    // Links to storyboard/visual elements
    @IBOutlet weak var SKViewController: SKView!
    @IBAction func LemonButtonAction(_ sender: UIButton) {
        let treeClone = myTree
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SKViewController.scene!.delegate = self
        for _ in 1...20{
            myTree.addNodeFromInt(Int(arc4random_uniform(100)))
        }
        buildTreeVisual(node: myTree.root)
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
            nodeShape.physicsBody = SKPhysicsBody(circleOfRadius: nodeSize.width/2)
            // Now add a label
            
            nodeLabel.text = String(labelValue);
            nodeLabel.fontSize = 14;
            nodeLabel.verticalAlignmentMode = .center
            nodeLabel.fontColor = UIColor.black
            nodeLabel.zPosition = 20
            nodeShape.addChild(nodeLabel)
        }
        return nodeShape
    }
    
    func drawConnectingLine(parent: SKShapeNode, child: SKShapeNode) -> SKShapeNode{
        let path = CGMutablePath()
        let lineShape = SKShapeNode()
        path.move(to: parent.position)
        path.addLine(to: child.position)
        lineShape.path = path
        lineShape.strokeColor = UIColor.black
        lineShape.lineWidth = 2
        lineShape.zPosition = 5
        let lineSize = CGSize.init(width: 2, height: 60)
        lineShape.physicsBody = SKPhysicsBody(rectangleOf: lineSize)
        SKViewController.scene!.addChild(lineShape)
        return lineShape
    }
    
    func joinNodesWithSpring(parent: SKShapeNode, child: SKShapeNode){
        let physicalLine = drawConnectingLine(parent: parent, child: child)
        let pinJoint = SKPhysicsJointPin.joint(withBodyA: parent.physicsBody!, bodyB: physicalLine.physicsBody!, anchor: parent.position)
        let pinJoint2 = SKPhysicsJointPin.joint(withBodyA: child.physicsBody!, bodyB: physicalLine.physicsBody!, anchor: child.position)
        SKViewController.scene!.physicsWorld.add(pinJoint)
        SKViewController.scene!.addChild(child)
        SKViewController.scene!.physicsWorld.add(pinJoint2)
    }
    
    func buildTreeVisual(node:BstNode, tier:CGFloat = 0, parent:SKShapeNode? = nil){
        let newTier = tier + 1
        switch node{
        case .leaf:
            break
        case .BstNode(let bstNode):
            bstNode.visualNode = nodeGenWithLabel(bstNode.value, offset: (tier * 60))
            if parent == nil{
                bstNode.visualNode?.physicsBody!.isDynamic = false
                SKViewController.scene!.addChild(bstNode.visualNode!)
            } else {
                joinNodesWithSpring(parent: parent!, child: bstNode.visualNode!)
            }
            for child in [bstNode.left, bstNode.right]{
                buildTreeVisual(node: child, tier: newTier, parent: bstNode.visualNode!)
            }
        }
    }
    
//    func didSimulatePhysics(for scene: SKScene) {
//        lineShape?.removeFromParent()
//        lineShape = drawConnectingLine(parent: parentNode!, child: childNode!)
//    }
}
