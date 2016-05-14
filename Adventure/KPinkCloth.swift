//
//  KPinkCloth.swift
//  Adventure
//
//  Created by 苑青 on 16/5/1.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KPinkCloth: KArmor {
    
    required init(){
        super.init(name: KColors.PINK + "粉红绸衫" + KColors.NOR)
        armor = 1
        describe = "这件粉红色的绸衫上面绣着几只黄鹊，闻起来还有一股淡香。\n"
        weight = 200
        equipType = .Cloth
        value = 10000
    }
    
    required init(k: KObject) {
        guard k is KPinkCloth else {
            fatalError("Cloning KPinkCloth with unkown object")
        }
        super.init(k: k)
    }
    override func clone() -> KObject {
        return KPinkCloth(k: self)
    }
}