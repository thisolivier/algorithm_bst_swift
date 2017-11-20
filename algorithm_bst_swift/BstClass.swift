//
//  BstClass.swift
//  algorithm_bst_swift
//
//  Created by Olivier Butler on 20/11/2017.
//  Copyright © 2017 Olivier Butler. All rights reserved.
//

import Foundation
class Bst{
    var root = BstNode.leaf
    
    func addNodeFromInt(_ newValue:Int){
        let newNode = NodeStructFromInt(newValue)
        var currentNode = root
        
        switch root {
            case .leaf:
                root = .BstNode(newNode)
                return
            default:
                currentNode = root
        }
        
        var direction:Direction?
        while direction == nil {
            switch currentNode{
                case .BstNode(let nodeStruct):
                    print("We have a node")
                    var tempNode:BstNode?
                    switch newValue < nodeStruct.value{
                        case true:
                            direction = .left
                            tempNode = nodeStruct.left
                            break
                        case false:
                            direction = .right
                            tempNode = nodeStruct.right
                    }
                    print("We're going \(direction!)")
                    switch tempNode!{
                    case .leaf:
                        switch direction!{
                            case .left:
                                nodeStruct.left = .BstNode(newNode)
                                break
                            case .right:
                                nodeStruct.right = .BstNode(newNode)
                            }
                            print("We added a node the long way!")
                    case .BstNode(_):
                        direction = nil
                        currentNode = tempNode!
                    }
                    break
                case .leaf:
                    print("We ended up too far down the rabbit hole")
            }
        }
    }
}

class NodeStructFromInt {
    var value:Int
    var left = BstNode.leaf
    var right = BstNode.leaf
    init(_ nodeValue:Int){
        value = nodeValue
    }
}

enum BstNode{
    case leaf
    indirect case BstNode(NodeStructFromInt)
}

enum Direction:String{
    case left
    case right
}
