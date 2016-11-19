//
//  KClothBoot1.swift
//  Adventure
//
//  Created by Eric on 16/11/3.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KClothBoot1: KArmor {
    required init(k: KObject) {
        guard k is KClothBoot1 else {
            fatalError("Cloning KClothBoot1 with unkown object")
        }
        super.init(k: k)
    }
    
    required init(){
        super.init(name: "简易布靴")
        armor = 1
        describe = "一件普普通通的粗布靴子。\n"
        weight = 400
        equipType = .cloth
        definedEquipPosition = .foot
        value = 1
    }
    
    override func clone() -> KObject {
        return KCloth(k: self)
    }
}
