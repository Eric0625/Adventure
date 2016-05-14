//
//  KSteelSword.swift
//  Adventure
//
//  Created by 苑青 on 16/5/1.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KSteelSword: KSword {
    
    required init(){
        super.init()
        weight = 1500
        name = "铁剑"
        describe = "一柄普普通通的铁剑。"
        damage = 7
        value = 500
    }
    
    required init(k: KObject) {
        guard k is KSteelSword else {
            fatalError("Cloning KSteelSword with unkown object")
        }
        super.init(k: k)
    }
    
    override func clone() -> KObject {
        return KSteelSword(k: self)
    }
}