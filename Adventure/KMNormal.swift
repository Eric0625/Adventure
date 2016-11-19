//
//  KMNormal.swift
//  Adventure
//
//  Created by Eric on 16/11/4.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

///一般材料，也就是只有名字和描述的区别，统一调用此类
class KMNormal: KItem {
    
    required init(k: KObject) {
        guard  k is KMNormal else {
            fatalError("Init KMNormal with unkown object")
        }
        super.init(k: k)
    }
    
    override init(name: String) {
        super.init(name: name)
        stackable = true
        weight = 1 //材料重1克
        describe = "制造材料"
    }
    
    override func clone() -> KObject{
        return  KMNormal(k: self)
    }
    
    override var name: String {
        set { super.name = newValue }
        get {
            if amount == 1 { return super.name }
            return super.name + "(\(amount))"
        }
    }
}
