//
//  KCloth.swift
//  Adventure
//
//  Created by 苑青 on 16/5/1.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KCloth: KArmor {
    required init(k: KObject) {
        guard k is KCloth else {
            fatalError("Cloning KCloth with unkown object")
        }
        super.init(k: k)
    }
    
    required init(){
        super.init(name: "布衣")
        armor = 1
        describe = "一件普普通通的粗布衣服。\n"
        weight = 200 //单位是克
        equipType = .cloth
        definedEquipPosition = .body
        value = 1
    }
    
    override func clone() -> KObject {
        return KCloth(k: self)
    }
}
