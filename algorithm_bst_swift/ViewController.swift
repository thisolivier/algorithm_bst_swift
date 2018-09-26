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
    
    @IBOutlet weak var SKViewController: SKView!
    
    var myTree:Bst = Bst()
    let nodeSize = CGSize(width: 40, height: 40)
    let drawingQueue: DispatchQueue = DispatchQueue(label: "DRAW_NODES")
    let dispatchGroup: DispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SKViewController.scene?.delegate = self
        self.buildTree()
    }
    
    @IBAction func LemonButtonAction(_ sender: UIButton) {
        self.clearTree()
        self.buildTree()
    }
    
    @IBAction func JamButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func WoodsButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func LazerButtonAction(_ sender: UIButton) {
    }
    
    func clearTree() {
        SKViewController.scene?.removeAllChildren()
        self.myTree = Bst()
    }
    
    func buildTree() {
        for _ in 1...20{
            self.myTree.addNodeFromInt(Int(arc4random_uniform(100)))
        }
        buildTreeVisual(node: self.myTree.root)
    }
    
    func nodeGenWithLabel(_ incomingNode:NodeStructFromInt, offset:[CGFloat] = [0,0]) -> SKShapeNode{
        let nodeShape = SKShapeNode()
        let nodeLabel = SKLabelNode(fontNamed: "HelveticaNeue-CondensedBlack")
        var color = UIColor.black
        var xOffset:CGFloat = 0
        if let orientation = incomingNode.cameFrom{
            switch orientation{
            case .left:
                color = UIColor.gray
                xOffset = -10
                break
            case .right:
                color = UIColor.orange
                xOffset = 10
                break
            }
        }
        
        if let frame = SKViewController.scene?.frame {
            let xVal = frame.midX + offset[1]
            let yVal = (frame.height/2) - (100 + (offset[0] * 60))
            nodeShape.path = UIBezierPath(roundedRect: CGRect(x: -20, y: -20, width: nodeSize.width, height: nodeSize.height), cornerRadius: 20).cgPath
            nodeShape.position = CGPoint(x: xVal, y: yVal)
            nodeShape.fillColor = UIColor.white
            nodeShape.strokeColor = color
            nodeShape.lineWidth = 1
            nodeShape.zPosition = 10
            nodeShape.physicsBody = SKPhysicsBody(circleOfRadius: nodeSize.width/2)
            // Now add a label
            
            nodeLabel.text = String(incomingNode.value);
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
        let lineSize = CGSize.init(width: 2, height: 90)
        lineShape.physicsBody = SKPhysicsBody(rectangleOf: lineSize)
        SKViewController.scene!.addChild(lineShape)
        return lineShape
    }
    
    func joinNodesWithPivot(parent: SKShapeNode, child: SKShapeNode){
        let physicalLine = drawConnectingLine(parent: parent, child: child)
        let pinJoint = SKPhysicsJointPin.joint(withBodyA: parent.physicsBody!, bodyB: physicalLine.physicsBody!, anchor: parent.position)
        let pinJoint2 = SKPhysicsJointPin.joint(withBodyA: child.physicsBody!, bodyB: physicalLine.physicsBody!, anchor: child.position)
        SKViewController.scene!.physicsWorld.add(pinJoint)
        SKViewController.scene!.addChild(child)
        SKViewController.scene!.physicsWorld.add(pinJoint2)
        self.drawingQueue.asyncAfter(deadline: .now() + 0.5) {
            self.dispatchGroup.leave()
        }
    }
    
    func buildTreeVisual(node:BstNode, offset:[CGFloat] = [0,0], parent:SKShapeNode? = nil){
        self.dispatchGroup.notify(queue: self.drawingQueue) {
            switch node{
            case .leaf:
                break
            case .BstNode(let bstNode):
                self.dispatchGroup.enter()
                // First, attach our new node
                bstNode.visualNode = self.nodeGenWithLabel(bstNode, offset: [offset[0], 0])
                if parent == nil{
                    bstNode.visualNode?.physicsBody!.isDynamic = false
                    self.SKViewController.scene!.addChild(bstNode.visualNode!)
                    self.dispatchGroup.leave()
                } else {
                    self.joinNodesWithPivot(parent: parent!, child: bstNode.visualNode!)
                }
                
                // Then build our children
                // TODO: Fix the timing of this, we need to push out from the current node (think an actual root), not stamp ontop of.
                let newOffset = [offset[0] + 1, offset[1]]
                for child in [bstNode.left, bstNode.right]{
                    self.buildTreeVisual(node: child, offset: newOffset, parent: bstNode.visualNode!)
                }
            }
        }
    }
    
//    func didSimulatePhysics(for scene: SKScene) {
//        lineShape?.removeFromParent()
//        lineShape = drawConnectingLine(parent: parentNode!, child: childNode!)
//    }
}
