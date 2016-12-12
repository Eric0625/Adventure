//
//  KGaoFarmer.swift
//  Adventure
//
//  Created by 苑青 on 2016/11/26.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KGaoFarmer: KHuman {
    
    required init(){
        super.init(name: "农夫")
        setSkill(inType: .unarmed, toLevel: 5)
        setSkill(inType: .dodge, toLevel: 1)
        setSkill(inType: .parry, toLevel: 1)
        chatMsg += [ name + "抬手擦了擦汗。",
                     name + "取下水壶，仰脖喝了几口。",
        ]
        combatChatMsg += [
            "农夫叫道：杀人哪！杀人哪！",
            "农夫叫道：有土匪哪！光天化日下打劫哪！"
        ]
        chatChance = 5
        combatChatChance = 30
        age = 20 + randomInt(40)
        gender = .男性
        combatExp = 150 + randomInt(800)
        money = 100 + randomInt(200)
    }
    
    required init(k: KObject) {
        assert(k is KGaoFarmer)
        super.init(k: k)
    }
    
    override func readyEquips() {
        let cloth = KCloth()
        cloth.moveTo(self)
        assert(equip(cloth))
    }
    
    override func clone() -> KObject {
        return KGaoFarmer(k: self)
    }
}
