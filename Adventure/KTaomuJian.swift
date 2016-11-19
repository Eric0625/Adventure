//
//  KTaomuJian.swift
//  Adventure
//
//  Created by Eric on 16/11/18.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation
class KTaomuJian: KSword {
    
    required init(){
        super.init()
        weight = 500
        name = "桃木剑"
        describe = "一把桃木制成的长剑，一般是用来写咒画符的。"
        damage = 4
        value = 200
    }
    
    required init(k: KObject) {
        guard k is KTaomuJian else {
            fatalError("Cloning KTaomuJian with unkown object")
        }
        super.init(k: k)
    }
    
    override func clone() -> KObject {
        return KTaomuJian(k: self)
    }
}
