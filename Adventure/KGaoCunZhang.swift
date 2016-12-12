//
//  KGaoCunZhang.swift
//  Adventure
//
//  Created by 苑青 on 2016/11/26.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KGaoCunZhang: KHuman {
    
    required init(){
        super.init(name: "吴文")
        setSkill(inType: .unarmed, toLevel: 15)
        setSkill(inType: .dodge, toLevel: 15)
        setSkill(inType: .parry, toLevel: 15)
        randomMoveChance = 5
        chatMsg += [ name+"上上下下打量了你几眼。",
                    ]
        chatChance = 5
        title = "村长"
        age = 46
        gender = .男性
        combatExp = 8000
        money = 100 + randomInt(1000)
    }
    
    required init(k: KObject) {
        assert(k is KGaoCunZhang)
        super.init(k: k)
    }
    
    override func readyEquips() {
        let cloth = KCloth()
        cloth.moveTo(self)
        assert(equip(cloth))
    }

    
    override func clone() -> KObject {
        return KGaoCunZhang(k: self)
    }
}
