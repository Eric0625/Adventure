//
//  KQiMeiGun.swift
//  Adventure
//
//  Created by 苑青 on 16/5/1.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KQiMeiGun: KLongStick {
    required init(){
        super.init()
        name = "齐眉棍"
        describe = "一根非常结实的齐眉棍。"
        damage = 15
        weight = 2.KG
        equipMessage = "$A挽了个棍花，将$W握在手中。\n"
        unequipMessage = "$A哼了一声，将齐眉棍别回腰间。\n"
        value = 1000
    }
    
    required init(k: KObject) {
        guard k is KQiMeiGun else {
            fatalError("Cloning KQiMeiGun with unkown object")
        }
        super.init(k: k)
    }
    
    override func clone() -> KObject {
        return KQiMeiGun(k: self)
    }
}
